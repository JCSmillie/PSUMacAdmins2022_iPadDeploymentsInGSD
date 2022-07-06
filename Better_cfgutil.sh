# !/bin/zsh
#
# JCS - 5/5/2022
#
# Quick Example of CFGUTil script.  This would be launched from 
# the command line as so-> /usr/local/bin/cfgutil exec -a /Users/Shared/blah/<thisscript>.sh
# to filter out all the junk.
# 
# This scripts job would be to get an iPad into Restored state, drop a wifi profile on it,
# and then pass the iPad to DEP for the finish.
#
# NOTE THIS SCRIPT WILL KEEP RUNNING OVER AND OVER AGAIN UNTIL YOU PRESS CONTROL X..  This is because
# the starter line you used is effectively telling cfgutil to go into loop mode and execute the script
# everytime an iPad is connected.
# 
# 

#Profile to get iPad onto a temporary provisioning network.  DO NOT USE YOUR MAIN NETWORK.
#This profile can be exported from your MDM or created using Apple Configurator2 before hand.
TEMPORARYWIFIPROFILE="/Users/Shared/ShakeNBake/Profiles/AppleStoreWifi7Days.mobileconfig"

echo "The iPad connected has:"
echo "-------------------------"
echo "Type of iPad-> $Type"
echo "ECID-> $ECID"
echo "UDUD-> $UDID"
echo "Name-> $deviceName           <--Name of the device currently."
echo "Device Type-> $deviceType"
echo "Build Version of iPadOS-> $buildVersion"

echo "All of the info in the variables is given weather you have trust or not..."
echo " "

#Use CFGUTIL and $ECID to query iPad about variables bootedState, isPaired, & activationState  Drop to file.
#There are a lot more things you can gather using the get command if we have trust, but for now lets 
#focus on these things.
GetDeviceState=$(/usr/local/bin/cfgutil --ecid "$ECID" get bootedState isPaired activationState 2>/dev/null )

#Take our data we colleced and fill variables.
Devicebootstate=$(echo "$GetDeviceState" | grep -a1 bootedState: | tail -1)
Devicepairingstate=$(echo "$GetDeviceState" | grep -a1 isPaired: | tail -1)
RWeActivated=$(echo "$GetDeviceState" | grep -a1 activationState: | tail -1)

#Function to perform final setup.  Because we are calling this twice I
#made a function to reference so we don't have to make changes to it twice.
FinalSeteup() {
	echo "$ECID / ($UDID) is waiting for setup..  Doing it."
	
	#Install Wifi Profile to get device on the network.
	bash -c "/usr/local/bin/cfgutil --ecid "$ECID" install-profile $TEMPORARYWIFIPROFILE" 2>/dev/null
	
	#Tell iPad to start prep and go to DEP for finishing instructions.
	bash -c "/usr/local/bin/cfgutil --ecid "$ECID" prepare --dep --skip-language --skip-region"  2>/dev/null
	exit 0
}


#Check if iPad is unactivated.  This would mean its booted, but hasn't
#made it past the hello screens.  Its probably been wiped or its new 
#out of the box.
if [ "$RWeActivated" = "Unactivated" ]; then
	#Call Final Setup Function
	FinalSeteup

	
#Check if iPad is in DFU/Recovery Mode
elif  [ "$Devicebootstate" = "Recovery" ]; then
	echo "$ECID / ($UDID) device in DFU mode.  Jumping right to restore attempt."
	#Run RESTORE against the iPad
	bash -c "/usr/local/bin/cfgutil --ecid "$ECID" restore"  2>/dev/null 
	
	#When an iPad is in DFU mode and we do a RESTORE it does not reboot... so we
	#should not exit just yet...  When the upper command finishes we can jump 
	#to final setup.

	#Give iPad a chance to boot back up.
	sleep 15
	
	#Call Final Setup routine.
	FinalSeteup


#Check if iPad is booted and paired.  We can only PAIR if we have Trust.
elif [ "$Devicebootstate" = "Booted" ] && [ "$Devicepairingstate" = "yes" ]; then
	echo "$ECID / ($UDID) device has Trust and Booted.  We can ERASE."
	#Device is booted and we have trust
	bash -c "/usr/local/bin/cfgutil --ecid "$ECID" erase"  2>/dev/null
	
	#When an iPad does an ERASE the iPad restarts and CFGUTIL will see it again.
	#This is why we EXIT with status 0.
	exit 0

else
	#We got no trust.  We can't do anything else, Boo...
	echo "No Trust.  Restart iPad in DFU Mode and try again."
	exit 1
fi

