#!/bin/bash

root=`pwd`
export root
host=`hostname | awk -F. {'print $1'}`
arch=`gcc -march=native -Q --help=target | grep march | awk '{print $2}'`

date +"%d/%m/%Y %H:%M:%S"
printf "\t Running on $arch@$host \n\n"

date +"%d/%m/%Y %H:%M:%S"

source env.sh
./compile.sh &> /tmp/time.make
sed 's/^/\t/' /tmp/time.make
printf "\n"

rm -rf $SCRATCH/bin/
cp -r $root/bin/ $SCRATCH/

cd /tmp

while true; do
	step=`ls $root/output/ | grep $host | tail -1 | awk -F. {'print $2'}`
	if [ -z "$step" ]; then
		step=0
	fi
	
	doe=$root/DoE/$host.csv
	if [ -f "$doe" ]; then
	    printf "\t Using old $doe\n"
	else 
	    $root/DoE.sh
	    step=$((step+1))
	fi
	log=$root/log/$host.$step.log
	output=$root/output/$host.$step.csv

	unset -v KMP_AFFINITY
	unset -v GOMP_CPU_AFFINITY
	unset -v OMP_NUM_THREADS
	unset -v OMP_SCHEDULE
	unset -v PAPI_EVENT
	unset -v LD_PRELOAD

	date +"%d/%m/%Y %H:%M:%S"
	printf "\t Warm-up\n"
	stress-ng --cpu 100 -t 5 &> /tmp/time.stress
	sed 's/^/\t/' /tmp/time.stress
	printf "\n"

	printf "\t Step: $step \n\n"

	while IFS=\; read -r app version size; do			
		date +"%d/%m/%Y %H:%M:%S"
		printf "\t Application: $app \n"
		printf "\t Version: $version \n"
		printf "\t Size: $size \n\n"
		
		exec=$SCRATCH/bin/$app.$version.$host.x

		if [[ $version == *"OpenACC-GPU"* ]]; then
			unset -v ACC_NUM_CORES
			export ACC_DEVICE_TYPE=nvidia
	  		$exec TTI $size $size $size 16 12.5 12.5 12.5 0.001 0.1 > /tmp/fletcher.out 2> /tmp/fletcher.err
	  		export ACC_DEVICE_TYPE=host
			export ACC_NUM_CORES=`lscpu | grep "^CPU(s):" | awk {'print $2'}`
		else
			$exec TTI $size $size $size 16 12.5 12.5 12.5 0.001 0.1 > /tmp/fletcher.out 2> /tmp/fletcher.err
		fi

		SAMPLES=`cat /tmp/fletcher.out | grep Samples | awk {'print $2'}`
		TIME=`cat /tmp/fletcher.out | grep "Execution time (s) is" | awk {'print $5'}`

		cat /tmp/fletcher.out >> $log
		cat /tmp/fletcher.err >> $log

		echo $host,$arch,$app,$version,$size,"samples",$SAMPLES,"M" >> $output
		echo $host,$arch,$app,$version,$size,"time",$TIME,"s" >> $output

		sed -i '1d' $doe
                find $DOE -size 0 -delete
	done < $doe

	date +"%d/%m/%Y %H:%M:%S"
	printf "\t done - $output \n\n"

	rm -f $doe
done
