--====================================================
--[[               REMOVE COSMETICS               ]]--
--====================================================
function TreeTagGameMode:RemoveWearables(hero) 
	local wearables = {}

	-- Store all of the wearables into the wearables array
	local cur = hero:FirstMoveChild()
 	while cur ~= nil do
    cur = cur:NextMovePeer()
    if cur ~= nil and cur:GetClassname() ~= "" and cur:GetClassname() == "dota_item_wearable" then
      --print(cur:GetClassname())  -- also can use cur:GetName()
      table.insert(wearables, cur)
    end
  end

    -- Remove all the wearables
  for i=1, #wearables do
  	UTIL_RemoveImmediate(wearables[i])
	end
end



--=====================================================
--[[           PRELEVEL INNATE ABILITIES           ]]--
--=====================================================
function TreeTagGameMode:PreLevelInnateAbilities(unit, innateAbilitiesArr) 
  for i, ability in ipairs(innateAbilitiesArr) do
    if unit:HasAbility(ability) then
      local a = unit:FindAbilityByName(ability)
      a:SetLevel(1)
    end
  end
end
