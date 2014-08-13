--=====================================================
--[[              player_connect_full              ]]--
--=====================================================
function TreeTagGameMode:AutoAssignPlayer(keys)
	if DEBUG then
		print("############################################")
		print("             player_connect_full            ")
		print("############################################")
		PrintTable(keys)
		-- [   VScript              ]: index: 0
		-- [   VScript              ]: splitscreenplayer: -1
		-- [   VScript              ]: userid: 1
		print("############################################")
	end

	local entIndex = keys.index+1
	-- The Player entity of the joining user
	local ply = EntIndexToHScript(entIndex)
	  
	-- The Player ID of the joining player
	local playerID = ply:GetPlayerID()

	-- Good guys
	ply:SetTeam(DOTA_TEAM_GOODGUYS)
	local plyHero = CreateHeroForPlayer('npc_dota_hero_furion', ply)


	-- BAD guys
	-- ply:SetTeam(DOTA_TEAM_BADGUYS)
	-- local plyHero = CreateHeroForPlayer('npc_dota_hero_warlock', ply)
	
	local heroName = plyHero:GetUnitName() 
  TreeTagGameMode:RemoveWearables(plyHero)

  if heroName == "npc_dota_hero_furion" then
    plyHero:ReduceMana(0.0)
  end
	

  GameRules:SendCustomMessage("Welcome to <font color='#6BA6F9'>Treetag!</font>", ply:GetTeam(), playerID)
  GameRules:SendCustomMessage("Creators: <font color='#6BF97E'>Morphined (Coder)</font>", ply:GetTeam(), playerID)
  GameRules:SendCustomMessage("Creators: <font color='#6BF97E'>MaskGT (Coder)</font>", ply:GetTeam(), playerID)
  GameRules:SendCustomMessage("Creators: <font color='#6BF97E'>Azarak (Mapper)</font>", ply:GetTeam(), playerID)
  
end

--=====================================================
--[[                  npc_spawned                  ]]--
--=====================================================
function TreeTagGameMode:NPCSpawned(keys)
  if DEBUG then
    print("####################################")
    print("             npc_spawned            ")
    print("####################################")
    PrintTable(keys)
    print("####################################")
  end

  local spawnedUnit = EntIndexToHScript(keys.entindex)    -- Hscript
  local PID = spawnedUnit:GetPlayerOwnerID()   -- PID

  if PID ~= -1 and spawnedUnit:IsHero() then
    if DEBUG then
      print(tostring(spawnedUnit:GetUnitName()) .. "\'s PID isn\'t -1")
    end

    -- If playerArray instance is null, create a new player instance
    if playerArray[PID] == null then
      playerArray[PID] = PlayerClass.create(PID)
    end

    -- Player instance was newly added to the array, disable the flag and set initial values
    if playerArray[PID].firstTime then
      playerArray[PID].firstTime = false
      playerArray[PID].hero = spawnedUnit
      playerArray[PID].heroName = spawnedUnit:GetUnitName()
      playerArray[PID].teamNum = spawnedUnit:GetTeamNumber()


      -- Set starting gold
      spawnedUnit:SetGold(0, true)
      spawnedUnit:SetGold(0, false)
      spawnedUnit:SetGold(STARTING_GOLD, true)

      -- Pre-level all innate abilities
      TreeTagGameMode:PreLevelInnateAbilities(spawnedUnit, INNATE_ABILITIES)
    end
    
    -- Change death status to alive and fire an event
    playerArray[PID].isAlive = true -- FireGameEvent("", {}})   Add this in later
  else
    if DEBUG then
      print(tostring(spawnedUnit:GetUnitName()) .. "\'s PID isn\'t -1")
    end
  end
end