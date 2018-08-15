#!/bin/bash
cd $(dirname $0)
echo -e "local me,ns = ...\n" >wowhead.lua
date +"ns.wowhead_update=%s" >>wowhead.lua
../wowhelpers/OCArtifacts.php >>wowhead.lua
../wowhelpers/OCEquipment.php >>wowhead.lua
../wowhelpers/OCRep.php >>wowhead.lua
#../wowhelpers/GCGearTokens.php >>wowhead.lua
