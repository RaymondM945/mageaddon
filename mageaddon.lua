local enableaddon = true

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
		if IsInGroup() then
			if UnitAffectingCombat("party1") then
				box.texture:SetColorTexture(1, 1, 0, 1)
				if UnitExists("party1target") and UnitIsVisible("party1target") then
					if not UnitIsUnit("target", "party1target") then
						print("You are NOT targeting the same target as party1.")
						box.texture:SetColorTexture(1, 1, 1, 1)
					else
						if UnitExists("target") and not UnitIsDead("target") then
							local currentHP = UnitHealth("target")
							local maxHP = UnitHealthMax("target")

							local hpPercent = (currentHP / maxHP) * 100

							if hpPercent < 95 then
								local spellName = "Frostbolt"
								local castspell = UnitCastingInfo("player")
								local usable, noMana = IsUsableSpell(spellName)
								local channelspell = UnitChannelInfo("player")

								if channelspell then
									print("You are currently channeling " .. channelspell .. ".")
								else
									if castspell ~= "Frostbolt" and usable then
										print("You can cast " .. spellName .. " on your target.")
										box.texture:SetColorTexture(0, 1, 0, 1)
									else
										box.texture:SetColorTexture(1, 1, 0, 1)
									end
								end
							end
						end
					end
				else
					print("Party member's target is not visible or does not exist.")
				end
			else
				print("Party member is not in combat.")
				box.texture:SetColorTexture(0, 0, 0, 1)
			end
		end
	end
end)
