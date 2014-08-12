--[[ GLOBALS ]]
THINK_TIME = 0.01
DEBUG = true

--[[ Generate the GameMode ]]
if TreeTagGameMode == nil then
	TreeTagGameMode = class({})
end

--[[ Called from Active() ]]
function TreeTagGameMode:InitGameMode()
	TreeTagGameMode = self
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

	self.timers = {}

	GameRules:SetHeroSelectionTime( 0.0 )
	GameRules:SetPreGameTime( 0.0)
	
  -- Hook declarations
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(TreeTagGameMode, 'AutoAssignPlayer'), self)


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

--==================================================
--[[  Hook implementation: player_connect_full  ]]--
--==================================================
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
  GameRules:SendCustomMessage("Creators: <font color='#6BF97E'>MAXGT (Coder)</font>", ply:GetTeam(), playerID)
  GameRules:SendCustomMessage("Creators: <font color='#6BF97E'>Azarak (Mapper)</font>", ply:GetTeam(), playerID)
  
end



---------------------------------------------------------------------
--                               BMD TIMERS BELOW
---------------------------------------------------------------------
--[[ Main Think ]]
function TreeTagGameMode:OnThink()
  --[[print("THINK")
  print(TreeTagGameMode.timers)
  print(3)
  PrintTable(TreeTagGameMode.timers)
  print(4)
  print("---------------")]]
  -- If the game's over, it's over.
  if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
    return
  end

  -- Track game time, since the dt passed in to think is actually wall-clock time not simulation time.
  local now = GameRules:GetGameTime()
  --print("now: " .. now)
  if TreeTagGameMode.t0 == nil then
    TreeTagGameMode.t0 = now
  end
  local dt = now - TreeTagGameMode.t0
  TreeTagGameMode.t0 = now

  --TreeTagGameMode:thinkState( dt )

  -- Process timers
  for k,v in pairs(TreeTagGameMode.timers) do
    --print ("EXEC timer: " .. tostring(k))
    local bUseGameTime = false
    local bFixResolution = true
    if v.dontFixResolution and v.dontFixResolution == true then
      bFixResolution = false
    end

    if v.useGameTime and v.useGameTime == true then
      bUseGameTime = true;
    end

    local now = GameRules:GetGameTime()
    if not bUseGameTime then
      now = Time()
    end
    -- Check if the timer has finished
    if now >= v.endTime then
      -- Remove from timers list
      TreeTagGameMode.timers[k] = nil

      -- Run the callback
      local status, nextCall = pcall(v.callback, TreeTagGameMode, v)

      -- Make sure it worked
      if status then
        -- Check if it needs to loop
        if nextCall then
          -- Change it's end time
          if bFixResolution then
            v.endTime = v.endTime + nextCall - now
          else
            v.endTime = nextCall
          end
          TreeTagGameMode.timers[k] = v
        end
      end
    end
  end

  return THINK_TIME
end


function TreeTagGameMode:CreateTimer(name, args)
  --[[
  args: {
  endTime = Time you want this timer to end: Time() + 30 (for 30 seconds from now),
  useGameTime = use Game Time instead of Time()
  callback = function(frota, args) to run when this timer expires,
  dontFixResolution = false
  }

  If you want your timer to loop, simply return the time of the next callback inside of your callback, for example:

  callback = function()
  return Time() + 30 -- Will fire again in 30 seconds
  end
  ]]

  if not args.endTime or not args.callback then
    print("Invalid timer created: "..name)
    return
  end

  -- Store the timer
  TreeTagGameMode.timers[name] = args
end

function TreeTagGameMode:RemoveTimer(name)
  -- Remove this timer
  TreeTagGameMode.timers[name] = nil
end

function TreeTagGameMode:RemoveTimers(killAll)
  local timers2 = {}

  -- If we shouldn't kill all timers
  if not killAll then
    -- Loop over all timers
    for k,v in pairs(TreeTagGameMode.timers) do
      -- Check if it is persistant
      if v.persist then
        -- Add it to our new timer list
        timers2[k] = v
      end
    end
  end

  -- Store the new batch of timers
  TreeTagGameMode.timers = timers2
end