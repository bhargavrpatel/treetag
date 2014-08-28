function showBuildMenu(keys)
	print("***** SHOW BUILD MENU *****")
	PrintTable(keys)
	print("***************************")

	-- Get the caster entIndex, and convert it to NPC instance
	local caster_entIndex = keys.caster_entindex        
	local caster = EntIndexToHScript(caster_entIndex)   


	if caster:IsHero() then
		-- Get player instance from NPC instance ten player ID to FireEvent
		local ply = caster:GetPlayerOwner()
		if ply then														-- The IF statements here are probably not needed, but its a good practice
			local plyid = ply:GetPlayerID()
			if plyid ~= -1 then
				FireGameEvent("treetag_toggle_build_menu", {pid=plyid,showBool=1})
			end
		end   
	end

end

function hideBuildMenu(keys)
	print("***** HIDE BUILD MENU *****")
	PrintTable(keys)
	print("***************************")

	-- Get the caster entIndex, and convert it to NPC instance
	local caster_entIndex = keys.caster_entindex        
	local caster = EntIndexToHScript(caster_entIndex)   

	if caster:IsHero() then
		-- Get player instance from NPC instance ten player ID to FireEvent
		local ply = caster:GetPlayerOwner()
		if ply then														-- The IF statements here are probably not needed, but its a good practice
			local plyid = ply:GetPlayerID()
			if plyid ~= -1 then
				FireGameEvent("treetag_toggle_build_menu", {pid=plyid,showBool=0})
			end
		end   
	end
end


-- ***** SHOW BUILD MENU *****
-- Function: showBuildMenu
-- ScriptFile: scripts/vscripts/runnable_scripts/build_menu.lua
-- Target: CASTER
-- ability:
-- 		__self: userdata: 0x2d001ee0
-- caster:
-- 		__self: userdata: 0x2d0017a8
-- caster_entindex: 57
-- target_entities:
-- 		1: table: 0x2d001768
-- target_points:
-- 		1: Vector 0BA1DAE0 [2336.000000 -192.000000 0.000061]
-- ***************************

-- ***** HIDE BUILD MENU *****
-- Function: hideBuildMenu
-- ScriptFile: scripts/vscripts/runnable_scripts/build_menu.lua
-- Target: CASTER
-- ability:
-- 		__self: userdata: 0x2d001ee0
-- caster:
-- 		__self: userdata: 0x2d0017a8
-- caster_entindex: 57
-- target_entities:
-- 		1: table: 0x2d001768
-- target_points:
-- 		1: Vector 2D002BE8 [2336.000000 -192.000000 0.000061]
-- ***************************


-- function nuke(keys)
--   print("********* UPGRADE CHANNEL FUNCTION *********")
--   PrintTable(keys)
--   print("********************************************")

--   -- Figure out the center of the aoe
--   targetPoints = table.remove(keys.target_points, 1)
--   -- PrintTable(targetPoints) 


--   -- Create a invisible dummy unit at the center of that aoe, assign the reference to local variable unit
--   local unit = CreateUnitByName("npc_pyra_nuke_dummy", targetPoints, false, nil, nil, DOTA_TEAM_BADGUYS)
--   unit:AddAbility("treetag_pyra_nuclear_dummy_unit")

--   -- Find the ability of the unit, and set the level to 1 (The leveling might not be needed by CastAbility)
--   local ability = unit:FindAbilityByName("treetag_pyra_nuclear_dummy_unit")
--   ability:SetLevel(1)

--   -- unit:CastAbilityNoTarget(ability, 0)
--   unit:CastAbilityImmediately(ability, 0)  
--   -- unit:CastAbilityImmediately(ability, -1) 

--   unit:ForceKill(false) 

-- end