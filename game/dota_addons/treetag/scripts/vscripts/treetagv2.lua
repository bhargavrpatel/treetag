--===================================================
--[[                   GLOBALS                   ]]--
--===================================================
THINK_TIME = 0.01
DEBUG = true
PAUSED = false

-- Economy related
STARTING_GOLD = 20
STARTING_LUMBER = 40
GOLD_PER_TICK = 1
LUMBER_PER_TICK = 2

playerArray = {}
INNATE_ABILITIES = {}

--===================================================
--[[                GEN. GAMEMODE                ]]--
--===================================================
if TreeTagGameMode == nil then
	TreeTagGameMode = class({})

  -- Custom class to store player related information.
  PlayerClass = {}
  PlayerClass.__index = PlayerClass
end


--[[ Custom Class definition]]
function PlayerClass.create(pid)
  local ply = {}
  setmetatable(ply, PlayerClass)

  ply.pid = pid
  ply.player = nil
  ply.hero = nil
  ply.heroName = nil
  ply.score = 0
  ply.gold = STARTING_GOLD
  ply.lumber = STARTING_LUMBER
  ply.gold_inc = GOLD_PER_TICK
  ply.lumber_inc = LUMBER_PER_TICK

  ply.foodUsed = 0
  ply.foodTotal = 0

  ply.firstTime = true  -- flag var
  ply.isAlive = false
  ply.teamNum = 0

  ply.followerunit = nil

  print("Finished Player class instance")

  return ply
end


--===================================================
--[[                INIT GameMode                ]]--
--===================================================
function TreeTagGameMode:InitGameMode()
	TreeTagGameMode = self
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

	self.timers = {}

	GameRules:SetHeroSelectionTime( 0.0 )
	GameRules:SetPreGameTime( 0.0)
	
  -- Hook declarations
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(TreeTagGameMode, 'AutoAssignPlayer'), self)
  ListenToGameEvent('npc_spawned', Dynamic_Wrap(TreeTagGameMode, 'NPCSpawned'), self)

  -- Fill server with fake clients
  Convars:RegisterCommand('basic_tree', function(name, unitArrayIndex)
    local x = tonumber(unitArrayIndex)
    
    if x < 1 then
      x = 1
    elseif x > 9 then
      x = 9
    end

    if DEBUG then  
      ply = Convars:GetCommandClient()
      -- Check if the server ran it
      if ply then
        local randVec = RandomVector(20.0)
        local plyCoords = ply:GetAbsOrigin()

        local unitArray = {"npc_treetag_building_basic_tree", 
							"npc_treetag_building_armored_tree", 
							"npc_treetag_building_strong_tree", 
							"npc_treetag_building_big_tree", 
							"npc_treetag_building_giant_tree",
							"npc_treetag_building_resource_storage",
							"npc_treetag_building_sentry_tower",
							"npc_treetag_building_tree_barracks",
							"npc_treetag_building_tree_barracks_v2"
							}

        print("Creating: " .. unitArray[x]) 

        local unit = CreateUnitByName(unitArray[x], plyCoords+randVec, true, nil, nil, ply:GetTeam())
        unit:SetOwner(ply)
        unit:SetControllableByPlayer(ply:GetPlayerID(), true)
      end
    end
  end, 'Createss a unit', 0)

  -- Fill server with fake clients
  Convars:RegisterCommand('fake', function()
    -- Check if the server ran it
    if not Convars:GetCommandClient() or DEBUG then
      -- Create fake Players
      SendToServerConsole('dota_create_fake_clients')
      
      local fakes = {
        "npc_dota_hero_furion",
        "npc_dota_hero_furion",
        "npc_dota_hero_furion",
        "npc_dota_hero_furion",
        "npc_dota_hero_furion",
        "npc_dota_hero_furion",
        "npc_dota_hero_furion",
        "npc_dota_hero_furion",
        "npc_dota_hero_furion",
        "npc_dota_hero_furion",
        "npc_dota_hero_furion"
      }
        
      self:CreateTimer('assign_fakes', {
        endTime = Time(),
        callback = function(treetag, args)
          local userID = 20
          for i=0, 5 do
            userID = userID + 1
            -- Check if this player is a fake one
            if PlayerResource:IsFakeClient(i) then
              -- Grab player instance
              local ply = PlayerResource:GetPlayer(i)
              -- Make sure we actually found a player instance
              if ply then
                CreateHeroForPlayer(fakes[i], ply)
                ply:SetTeam(DOTA_TEAM_GOODGUYS)
                -- TreeTagGameMode:AutoAssignPlayer({
                --   index = ply:entindex()-1,
                --   splitscreenplayer = -1,
                --   userid = userID
                -- })
              end
            end
          end
          
          local ply = Convars:GetCommandClient()
          local plyID = ply:GetPlayerID()
          local hero = ply:GetAssignedHero()
          for k,v in pairs(HeroList:GetAllHeroes()) do
            if v ~= hero then
              --v:SetControllableByPlayer(plyID, true)
              --local dash = CreateItem("item_reflex_dash", v, v)
              --v:AddItem(dash)
              --local shooter = CreateItem("item_simple_shooter", v, v)
              --v:AddItem(shooter)
            end
          end
        end})
    end
  end, 'Connects and assigns fake Players.', 0)


end
