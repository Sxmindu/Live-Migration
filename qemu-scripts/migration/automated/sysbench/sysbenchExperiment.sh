#!/bin/bash

CORE="$1"
ITR="$2"

STATUS=""
METHODS=("tcp" "pp" "tp")
RAM="8192"

log() {
	echo $1 >> experiment_${RAM}_${CORE}.txt
}

while [[ $RAM -ge 1024 ]]
do

	touch experiment_${RAM}_${CORE}.txt
	
	log ">>> RAM: $RAM"
	log ""

	for method in "${METHODS[@]}" 
	do
		if [ "$method" = "tcp" ]
		then
			log "---------------- Precopy Experiments ----------------"
		elif [ "$method" = "pp" ]
		then
			log "---------------- Postcopy Experiments ----------------"
		elif [ "$method" = "tp" ]
		then
			log "---------------- Hybrid Experiments ----------------"
		fi	

		log ""

		for i in {1..$ITR}
		do	
			log "Experiment No: $i"
			bash sysbenchAuto.sh sysbench_disk tap0 $RAM $CORE $method
			sleep 60

			STATUS=$?

			echo "Status: $STATUS"

			if [[ $STATUS -eq -1 ]]
			then
				log "Error In Experiment No: $i"
				log ""
				((i--))
				continue
			fi
		done

		log "------------------------------------------------------"
		log ""
	done

	log "-----------------------------------"
	log ""

	((RAM-=1024))
done
