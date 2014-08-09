--[[ Generate the GameMode ]]
if TreeTagGameMode == nil then
	TreeTagGameMode = class({})
end

--[[ Called from Active() ]]
function TreeTagGameMode:InitGameMode()
	TreeTagGameMode = self
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )


	GameRules:SetHeroSelectionTime( 0.0 )
	GameRules:SetPreGameTime( 0.0)
	-- Hook declarations
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(TreeTagGameMode, 'AutoAssignPlayer'), self)
end

--[[ Main Think ]]
function TreeTagGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

--==================================================
--[[  Hook implementation: player_connect_full  ]]--
--==================================================
function TreeTagGameMode:AutoAssignPlayer(keys)
	print("############################################")
	print("             player_connect_full            ")
	print("############################################")
	PrintTable(keys)
	-- [   VScript              ]: index: 0
	-- [   VScript              ]: splitscreenplayer: -1
	-- [   VScript              ]: userid: 1
	print("############################################")

	local entIndex = keys.index+1
	-- The Player entity of the joining user
	local ply = EntIndexToHScript(entIndex)
	  
	-- The Player ID of the joining player
	local playerID = ply:GetPlayerID()

	-- Good guys
	-- ply:SetTeam(DOTA_TEAM_GOODGUYS)
	-- local plyHero = CreateHeroForPlayer('npc_dota_hero_furion', ply)


	-- BAD guys
	ply:SetTeam(DOTA_TEAM_BADGUYS)
	local plyHero = CreateHeroForPlayer('npc_dota_hero_warlock', ply)
	
	TreeTagGameMode:RemoveWearables(plyHero)
end