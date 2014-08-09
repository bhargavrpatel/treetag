require('util')
require('treetagv2')
require('functions')

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	PrecacheUnitByNameSync("npc_dota_hero_furion", context)
	PrecacheUnitByNameSync("npc_dota_hero_warlock", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = TreeTagGameMode()
	GameRules.AddonTemplate:InitGameMode()
end