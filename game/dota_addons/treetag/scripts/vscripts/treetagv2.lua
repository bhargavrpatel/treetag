--[[ GLOBALS ]]
THINK_TIME = 0.01
DEBUG = false

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
	-- ply:SetTeam(DOTA_TEAM_GOODGUYS)
	-- local plyHero = CreateHeroForPlayer('npc_dota_hero_furion', ply)


	-- BAD guys
	ply:SetTeam(DOTA_TEAM_BADGUYS)
	local plyHero = CreateHeroForPlayer('npc_dota_hero_warlock', ply)
	
	TreeTagGameMode:RemoveWearables(plyHero)
	
--[[
	self:CreateTimer('assign_fakes', {
        endTime = Time(),
        callback = function(treetag, args)
          print("INSIDE TIMER")
          return Time() + 2.0
        end
    })
]]
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