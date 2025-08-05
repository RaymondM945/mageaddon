local enableaddon = true
local enabletarget = true

local box = CreateFrame("Frame", "MyBlackBox", UIParent)
box:SetSize(25, 25)
box:SetPoint("CENTER")

box.texture = box:CreateTexture(nil, "BACKGROUND")
box.texture:SetAllPoints()
box.texture:SetColorTexture(0, 0, 0, 1)

local checkbox = CreateFrame("CheckButton", "MyAddonCheckbox", UIParent, "UICheckButtonTemplate")
checkbox:SetSize(24, 24)
checkbox:SetPoint("TOP", 0, -25)
checkbox.text = checkbox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
checkbox.text:SetPoint("LEFT", checkbox, "RIGHT", 4, 0)
checkbox.text:SetText("Enable Addon")
checkbox:SetChecked(enableaddon)
checkbox:SetScript("OnClick", function(self)
	if self:GetChecked() then
		print("Checkbox checked")
		enableaddon = true
	else
		print("Checkbox unchecked")
		enableaddon = false
	end
end)

-- local checkbox2 = CreateFrame("CheckButton", "MyAddonCheckbox2", UIParent, "UICheckButtonTemplate")
-- checkbox2:SetSize(24, 24)
-- checkbox2:SetPoint("TOP", checkbox, "BOTTOM", 0, -5) -- Position under the first checkbox with a 5px gap
-- checkbox2.text = checkbox2:CreateFontString(nil, "OVERLAY", "GameFontNormal")
-- checkbox2.text:SetPoint("LEFT", checkbox2, "RIGHT", 4, 0)
-- checkbox2.text:SetText("Enable Target")
-- checkbox2:SetChecked(enabletarget)
-- checkbox2:SetScript("OnClick", function(self)
-- 	if self:GetChecked() then
-- 		print("Second checkbox checked")
-- 		enabletarget = true
-- 	else
-- 		print("Second checkbox unchecked")
-- 		enabletarget = false
-- 	end
-- end)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addonName)
	if addonName == "MyAddon" then
	end
end)

local loopFrame = CreateFrame("Frame")

loopFrame:SetScript("OnUpdate", function(self, elapsed)
	box.texture:SetColorTexture(0, 0, 0, 1)

	if enableaddon then
		local drinkBuffName = GetSpellInfo(430)
		local drinkname = AuraUtil.FindAuraByName(drinkBuffName, "player", "HELPFUL")

		if IsInGroup() then
			if UnitAffectingCombat("party1") and not drinkname then
				box.texture:SetColorTexture(1, 1, 0, 1)
				if UnitExists("party1target") and UnitIsVisible("party1target") and not UnitIsDead("party1target") then
					local currentHP = UnitHealth("party1target")
					local maxHP = UnitHealthMax("party1target")

					local hpPercent = (currentHP / maxHP) * 100

					if hpPercent < 95 then
						local spellName = "Frostbolt"
						local castspell = UnitCastingInfo("player")
						local usable, noMana = IsUsableSpell(spellName)
						local channelspell = UnitChannelInfo("player")

						if channelspell then
							print("You are currently channeling " .. channelspell .. ".")
						else if castingSpell == "Polymorph" then
							print("You are currently casting " .. castingSpell .. ".")
						else
							if castspell ~= "Frostbolt" and usable then
								print("You can cast " .. spellName .. " on your target.")
								box.texture:SetColorTexture(0, 1, 0, 1)
							elseif not IsAutoRepeatSpell("Shoot") then
								box.texture:SetColorTexture(1, 0, 0, 1)
							end
						end
			
					end
				end
			else
				print("Party member is not in combat.")
				box.texture:SetColorTexture(0, 0, 0, 1)
			end
		end
	end
end)

-- if UnitExists("party1target") and UnitIsVisible("party1target") then
-- 	if not UnitIsUnit("target", "party1target") and enabletarget then
-- 		print("You are NOT targeting the same target as party1.")
-- 		box.texture:SetColorTexture(1, 1, 1, 1)
-- 	else
-- 		if UnitExists("target") and not UnitIsDead("target") then
-- 			local currentHP = UnitHealth("target")
-- 			local maxHP = UnitHealthMax("target")

-- 			local hpPercent = (currentHP / maxHP) * 100

-- 			if hpPercent < 95 then
-- 				local spellName = "Frostbolt"
-- 				local castspell = UnitCastingInfo("player")
-- 				local usable, noMana = IsUsableSpell(spellName)
-- 				local channelspell = UnitChannelInfo("player")

-- 				if channelspell then
-- 					print("You are currently channeling " .. channelspell .. ".")
-- 				else
-- 					if castspell ~= "Frostbolt" and usable then
-- 						print("You can cast " .. spellName .. " on your target.")
-- 						box.texture:SetColorTexture(0, 1, 0, 1)
-- 					elseif not IsAutoRepeatSpell("Shoot") then
-- 						box.texture:SetColorTexture(1, 0, 0, 1)
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
-- else
-- 	print("Party member's target is not visible or does not exist.")
-- end
