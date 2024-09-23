#MTA-DayZ-Asia Gamemode


Installation Guide.

Copy [Mode] and paste into resource folder.
Copy ACL and MTAserver to deathmatch folder and your Done!

Alternatively. 
You can add this to your ACL if you wish to use your own ACL
     
    <object name="resource.webadmin"></object>
    <object name="resource.admin"></object>
    <object name="resource.acpanel"></object>
    <object name="resource.asia_admin"></object>
    <object name="resource.dayzepoch"></object>
    <object name="resource.asia_login"></object>
    <object name="resource.asia_modloader"></object>
    <object name="resource.asia_group"></object>
    <object name="user.2ndofIcarus"></object>1

Create a group in your ACL for staff, this is used for adding staff skin and previledge in your admin access. 

    <group name="Staff">
    <acl name="Staff"></acl>
    <object name="user.NameHere"></object>
    <object name="user.NameHere"></object>
    </group>

You also need to add them using your own mtaserver config.

    <resource src="admin" startup="1" protected="0" />
    <resource src="defaultstats" startup="1" protected="0" />
    <resource src="reload" startup="1" protected="0" />
    <resource src="webadmin" startup="1" protected="0" />
    <resource src="acpanel" startup="1" protected="0" />
   
    <resource src="dayzepoch" startup="1" protected="0" />
    <resource src="asia_particles" startup="1" protected="0" />
    <resource src="asia_admin" startup="1" protected="0" />
    <resource src="asia_antiglitch" startup="1" protected="0" />
    <resource src="asia_modloader" startup="1" protected="0" />
    <resource src="asia_dynamicsky" startup="1" protected="0" />
    <resource src="asia_login" startup="1" protected="0" />
    <resource src="asia_scoreboard" startup="1" protected="0" />
    <resource src="asia_shader" startup="1" protected="0" />
    <resource src="asia_radar" startup="1" protected="0" />
    <resource src="asia_shop" startup="1" protected="0" />
    <resource src="asia_animation" startup="1" protected="0" />
    <resource src="asia_gps" startup="1" protected="0" />
    <resource src="asia_group" startup="1" protected="0" />
    <resource src="asia_mission" startup="1" protected="0"/>
    <resource src="e_map" startup="1" protected="0" />
    <resource src="asia_finder" startup="1" protected="0" />
    <resource src="asia_loading" startup="1" protected="0" />
    <resource src="asia_worldmap" startup="1" protected="0" />
    <resource src="asia_lightsoff" startup="1" protected="0" />
    <resource src="asia_help" startup="1" protected="0"/>
    <resource src="asia_security" startup="1" protected="0" />
    <resource src="asia_attach" startup="1" protected="0" />
    <resource src="asia_compass" startup="1" protected="0" />
    
And you're all set.
