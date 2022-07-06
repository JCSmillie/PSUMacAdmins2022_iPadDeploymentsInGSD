# !/bin/zsh
#
# Quick Example of CFGUTil script.  This would be launched from 
# the command line as so-> /usr/local/bin/cfgutil exec -a /Users/Shared/blah/<thisscript>.sh
#
# NOTE THIS SCRIPT WILL KEEP RUNNING OVER AND OVER AGAIN UNTIL YOU PRESS CONTROL X..  This is because
# the starter line you used is effectively telling cfgutil to go into loop mode and execute the script
# everytime an iPad is connected.

echo "The iPad connected has:"
echo "-------------------------"
echo "Type of iPad-> $Type"
echo "ECID-> $ECID"
echo "UDUD-> $UDID"
echo "Location-> $Location   <--This is the location of the device according to the USB tree."
echo "Name-> $deviceName   <--Name of the device currently."
echo "Build Version of iPadOS-> $buildVersion"

echo "All of the info in the variables is given weather you have trust or not..."

exit 0
