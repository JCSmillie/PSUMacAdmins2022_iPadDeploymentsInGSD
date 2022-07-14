# PSUMacAdmins2022_iPadDeploymentsInGSD
 PSU MacAdmins 2022 Presentation on iPad Deployments in GSD using Mosyle

Slides and example scripts from presentation given for Penn State MacAdmins 2022 Camp Fire sessions about how we deploy our iPads with Mosyle and various custom scripts, things we do in the classroom to help our students better understand how to take care of the iPad, and our future endevors with the Jr Gator IT Help Desk.

This presentation was originally given on July 7th, 2022 virtually for PSU MacAdmins.

The slides from the Keynote will be posted AFTER the presentation (same day.)  This is because there are a few things we tweaked right up to the minute before we presented!

Link to MOSBasic Repo-> https://github.com/JCSmillie/MOSBasic \
***The Public version of Shake N' Bake can also be found in this repo in the extras folder.***


Link to Misc Mosyle API Reference Script Repo-> https://github.com/JCSmillie/GSDMosyleAPI_Scripts \
***This area should be considered more reference then anything else as things have changed a little since then***

Other files:.
 - cfgutil_exec_example.sh  <-Quick and dirty example script to run with cfgutil exec -a 
 - Better_cfgutil.sh  <-Based on the same principals just goes a little further....

While I did do a live demo of Shake N' Bake during the camp fire session I do have another video of ShakeNBake doing its thing which can be found on my Google Drive.  It was too big to through on a Github in a nice mannor.  
https://drive.google.com/file/d/1-28_WREDVW3hPTM1vc5fkik0eSBsJJjx

The video of Mosyle Limbo based iPads deploying can also be found in my Google Drive:
https://drive.google.com/file/d/1BkoAv1usf331B6X8Hkz1GSzZFoqZSprc


Links to Jennifer Czyzewski Student presentations:
 - [iPad Care for Students](https://docs.google.com/presentation/d/e/2PACX-1vQAo8L1LcXpNiYIlQL4Bjil3ySryHtVBzEvqwdVPG69TQ65ZipjtHswd1nwd9LOYhQvtvwoDvLpl6VR/pub?start=true&loop=false&delayms=3000)
 - [Internet Safety for Middle School Students](https://www.canva.com/design/DAFDhLifaK0/LOBcVvJxLocYxqfmtw2cCQ/view?utm_content=DAFDhLifaK0&utm_campaign=designshare&utm_medium=link&utm_source=publishpresent)
 
 
## POST PRESENTATION NOTES/UPDATES:
  - I use **autoload is-at-least** in ShakeNBake to do compares on what Apple says a device should use and what the device has.  When cfgutil executes ShakeNBake though it doesn't call the Autoload command... It doesn't know what it is.  I know this has something to do with how cfgutil loads scripts and their support files but haven't put my finger on a good fix.  In the short term when launching ShakeNBake use this line instead-> `cfgutil exec -a 'zsh -c "/Users/Shared/ShakeNBake/ShakeNBake_V3.sh"'`  This will insure that all the shell files get loaded.
 - There is something weird with Ventura Beta (as of 7/14/22) and multiple iPads (more than 4) on a single bus.  I've seen this with my Thundersync unit.  Needs more testing and I'll report it.  For now run only in Monterey if you can.
