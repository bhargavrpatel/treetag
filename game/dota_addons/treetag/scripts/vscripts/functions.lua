--[[ removes all wearables of a given player ]]
function TreeTagGameMode:RemoveWearables(hero) 
	local wearables = {}

	-- Store all of the wearables into the wearables array
	local cur = hero:FirstMoveChild()
 	while cur ~= nil do
    cur = cur:NextMovePeer()
    if cur ~= nil and cur:GetClassname() ~= "" and cur:GetClassname() == "dota_item_wearable" then
      print(cur:GetClassname())  -- also can use cur:GetName()
      table.insert(wearables, cur)
    end
  end

    -- Remove all the wearables
  for i=1, #wearables do
  	UTIL_RemoveImmediate(wearables[i])
	end
end

-- function TreeTagGameMode:FurionItemBool(str)
--   if str == "attribute_bonus" or str == "furion_wrath_of_nature" or str == "furion_force_of_nature" or str == "furion_teleportation" or str == "furion_sprout" then
--     return false
--   else
--     return true
--   end
-- end