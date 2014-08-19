require('util')
require('timers')
require('treetagv2')
require('functions')
require('hooks')

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
	PrecacheUnitByNameSync("npc_dota_hero_doom_bringer", context)
	PrecacheUnitByNameSync("npc_dota_hero_night_stalker", context)
	PrecacheUnitByNameSync("npc_dota_hero_treant_protector", context)

	-- Treant Protector as the various trees, requires the base model and all submodels tobe precached this way.
	PrecacheModel("models/heroes/treant_protector/treant_protector.vmdl", context)
		PrecacheModel("models/heroes/treant_protector/head.vmdl", context)
			PrecacheModel("models/heroes/treant_protector/foliage.vmdl", context)
				PrecacheModel("models/heroes/treant_protector/hands.vmdl", context)
					PrecacheModel("models/heroes/treant_protector/legs.vmdl", context)
					
	-- Precache Building models
	PrecacheModel("models/props_structures/good_statue008.vmdl", context)
	PrecacheModel("models/props_structures/tower_good.vmdl", context)
	PrecacheModel("models/props_structures/good_barracks_melee001.vmdl", context)
	PrecacheModel("models/props_structures/good_barracks_melee002.vmdl", context)	
	
	
	
end

-- Create the game mode when we activate
function Activate()
    GameRules.AddonTemplate = TreeTagGameMode()
    GameRules.AddonTemplate:InitGameMode()
end
