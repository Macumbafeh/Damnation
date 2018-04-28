DamnationSave = nil -- saved tank item - {name, itemSlot1, itemSlot2}   - itemSlot2 can be nil

-- get the client's names for the spells
local GREATER_BLESSING_OF_SALVATION = (GetSpellInfo(25895))
local BLESSING_OF_SALVATION         = (GetSpellInfo(1038))

----------------------------------------------------------------------------------------------------
-- handling new aura events
----------------------------------------------------------------------------------------------------
-- if wearing the assigned tank item, then cancel salvation buffs
local function CancelSalvation()
	local link
	local isTanking

	-- first slot
	link = GetInventoryItemLink("player", DamnationSave[2])
	if link and link:match("%[(.-)]") == DamnationSave[1] then
		isTanking = true
	end
	-- second slot if the item can have one
	if not isTanking and DamnationSave[3] then
		link = GetInventoryItemLink("player", DamnationSave[3])
		if link and link:match("%[(.-)]") == DamnationSave[1] then
			isTanking = true
		end
	end

	if isTanking then
		CancelPlayerBuff(GREATER_BLESSING_OF_SALVATION)
		CancelPlayerBuff(BLESSING_OF_SALVATION)
	end
end

-- react to new buffs
local eventFrame = CreateFrame("frame")
eventFrame:SetScript("OnEvent", function() if DamnationSave then CancelSalvation() end end)
eventFrame:RegisterEvent("PLAYER_AURAS_CHANGED")

----------------------------------------------------------------------------------------------------
-- slash command
----------------------------------------------------------------------------------------------------
_G.SLASH_DAMNATION1 = "/damnation"
function SlashCmdList.DAMNATION(input)
	input = input and input:lower() or ""

	if input == "off" or input == "none" then
		DamnationSave = nil
	else
		-- get the item name and which slot(s) it can be in
		local slotID1, slotID2
		local name, _, _, _, _, _, _, _, slotType = GetItemInfo(input)

		-- convert the slot type to slot IDs
		if slotType then
			if     slotType == "INVTYPE_2HWEAPON"       then slotID1 = 16; slotID2 = nil;
			elseif slotType == "INVTYPE_AMMO"           then slotID1 =  0; slotID2 = nil;
			elseif slotType == "INVTYPE_BODY"           then slotID1 =  4; slotID2 = nil;
			elseif slotType == "INVTYPE_CHEST"          then slotID1 =  5; slotID2 = nil;
			elseif slotType == "INVTYPE_CLOAK"          then slotID1 = 15; slotID2 = nil;
			elseif slotType == "INVTYPE_FEET"           then slotID1 =  8; slotID2 = nil;
			elseif slotType == "INVTYPE_FINGER"         then slotID1 = 11; slotID2 =  12;
			elseif slotType == "INVTYPE_HAND"           then slotID1 = 10; slotID2 = nil;
			elseif slotType == "INVTYPE_HEAD"           then slotID1 =  1; slotID2 = nil;
			elseif slotType == "INVTYPE_HOLDABLE"       then slotID1 = 17; slotID2 = nil;
			elseif slotType == "INVTYPE_LEGS"           then slotID1 =  7; slotID2 = nil;
			elseif slotType == "INVTYPE_NECK"           then slotID1 =  2; slotID2 = nil;
			elseif slotType == "INVTYPE_RANGED"         then slotID1 = 18; slotID2 = nil;
			elseif slotType == "INVTYPE_RANGEDRIGHT"    then slotID1 = 18; slotID2 = nil;
			elseif slotType == "INVTYPE_RELIC"          then slotID1 = 18; slotID2 = nil;
			elseif slotType == "INVTYPE_ROBE"           then slotID1 =  5; slotID2 = nil;
			elseif slotType == "INVTYPE_SHIELD"         then slotID1 = 17; slotID2 = nil;
			elseif slotType == "INVTYPE_SHOULDER"       then slotID1 =  3; slotID2 = nil;
			elseif slotType == "INVTYPE_TABARD"         then slotID1 = 19; slotID2 = nil;
			elseif slotType == "INVTYPE_THROWN"         then slotID1 = 18; slotID2 = nil;
			elseif slotType == "INVTYPE_TRINKET"        then slotID1 = 13; slotID2 =  14;
			elseif slotType == "INVTYPE_WAIST"          then slotID1 =  6; slotID2 = nil;
			elseif slotType == "INVTYPE_WEAPON"         then slotID1 = 16; slotID2 =  17;
			elseif slotType == "INVTYPE_WEAPONMAINHAND" then slotID1 = 16; slotID2 = nil;
			elseif slotType == "INVTYPE_WEAPONOFFHAND"  then slotID1 = 17; slotID2 = nil;
			elseif slotType == "INVTYPE_WRIST"          then slotID1 =  9; slotID2 = nil;
			else
				DEFAULT_CHAT_FRAME:AddMessage("The tanking item must be wearable equipment.")
				return
			end
		end

		if name and slotID1 then
			DamnationSave = {name, slotID1, slotID2}
			CancelSalvation()
		else
			DEFAULT_CHAT_FRAME:AddMessage("Damnation commands:", 1, 1, 0)
			DEFAULT_CHAT_FRAME:AddMessage("/damnation <tank-only item link>")
			DEFAULT_CHAT_FRAME:AddMessage("/damnation off")
			DEFAULT_CHAT_FRAME:AddMessage(" ")
		end
	end

	if DamnationSave then
		DEFAULT_CHAT_FRAME:AddMessage("You will cancel salvation if wearing " .. DamnationSave[1] .. ".")
	else
		DEFAULT_CHAT_FRAME:AddMessage("You will never automatically cancel salvation.")
	end
end
