set -e #-x
DATE=`date +%H:%M:%S_%d/%m/%Y`

ENV="P"
PLAN_PATH=tf_plan.tfplan

echo ""
echo "##################################################"
echo "Executed at: 		$DATE"
echo "Plan path:   		$PLAN_PATH"
echo "##################################################"
echo ""

terraform init

terraform "$@" plan -out=$PLAN_PATH

read -p "Do you want to apply the plan located at $PLAN_PATH? [y/n]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    time terraform "$@" apply -state=$STATE_PATH $PLAN_PATH

	#Check exit status
	rc=$?; if [[ $rc -ne 0 ]]; then echo "------ ERROR DURING THE EXECUTION OF TERRAFORM -----"; exit $rc; fi
	
	rm -rf tf_plan.tfplan

fi
