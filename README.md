# Hass.io addon for tingg.io.  
This AddOn sends states of selected Home Assistant entities to the tingg.io platform.

Go to your Hass.io Menu and add this AddOn thru pasting the URL.  
After that you have to build this AddOn locally with the respective buttons.  
Once the AddOn is ready to run, you can put your Thing-ID und Thing-Key from tingg.io into the config-area and also define there which elements state should be forwarded to tingg.io and how often. 

# Next steps
Soon there will be a pre-build container on Docker Hub for a much easier integration into Hass.io.

# Known issue
A HA update will not proceed because of a running task.  
Until we have fixed the bug, please stop the AddOn for a short time while the update process is running.
