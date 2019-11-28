#!/bin/bash

###################################################################
#Script Name	:   CreateSnapshot.sh
#Description	:   This script iterates through all VMs in the provides subscription
#Author       	:   Stephan Graber | GrabX Solutions
#Email         	:   stephan@grabx.ch
###################################################################

#Ask for Azure supscription name

echo "In which resourceGroup should the snapshot be saved?"
read regSnapshot
#regSnapshot="p-reg-snapshot"

echo "I will create a snapshot for each vm in the provided subscription, which would that be?"
read subscription
#subscription="p-sub-production"

az account set --subscription $subscription

#variables
vms=$(az vm list --query [].name --output tsv)
vmids=$(az vm list --query [].id --output tsv)
rg=$(az vm list --query [].resourceGroup --output tsv)
i=0
j=1
declare -a vmarray


for vm in $vms;
do
    ((i=i+1))
    vmarray[$i]=$(echo $vms | awk -v a=$i '{ print $a }')
done
#echo ${#vmarray[@]}


for vmid in $vmids; do
    osDiskId=$(az vm show --ids $vmid --query "storageProfile.osDisk.managedDisk.id" -o tsv)
    #echo $osDiskId
    #echo ${vmarray[$j]}
    az snapshot create -g $regSnapshot --source $osDiskId --name "osdisk"${vmarray[$j]}
    ((j=j+1))
done


#osDiskId=$(az vm show -g $reg -n $vm --query "storageProfile.osDisk.managedDisk.id" -o tsv)
