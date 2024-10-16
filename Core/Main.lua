-------------------------------------------------------------------------------
-- InterFace Frame {{{
-------------------------------------------------------------------------------

MBR = CreateFrame("Frame", "MoronBoxRepair", UIParent)

-------------------------------------------------------------------------------
-- The Stored Variables {{{
-------------------------------------------------------------------------------

MBR.DefaultOptions = {
    VendorSettings = {
        AutoOpenInteraction = true,
        AutoRepair = true,
        AutoSellGrey = true
    },
    VendorItems = {
        WhiteListed = {},
        BlackListed = {}
    }
}

-------------------------------------------------------------------------------
-- Local Variables {{{
-------------------------------------------------------------------------------

MBR.Session = {
    PossibleVendorItems = {
        WhiteListed = {},
        BlackListed = {}
    }
}

-------------------------------------------------------------------------------
-- Core Event Code {{{
-------------------------------------------------------------------------------

MBR:RegisterEvent("ADDON_LOADED")
MBR:RegisterEvent("MERCHANT_SHOW")
MBR:RegisterEvent("MERCHANT_CLOSE")
MBR:RegisterEvent("GOSSIP_SHOW")
MBR:RegisterEvent("GOSSIP_CLOSED")

function MBR:OnEvent(event)
    if event == "ADDON_LOADED" and arg1 == self:GetName() then
        self:SetupSavedVariables()
    elseif event == "MERCHANT_SHOW" then
        self:SellGreyItems()
        self:RepairItems()
    elseif event == "MERCHANT_CLOSE" or event == "GOSSIP_CLOSED" then
        self:ResetPossibleVendorItems()       
    elseif event == "GOSSIP_SHOW" then
        self:OpenVendorOrBank()
    end
end

MBR:SetScript("OnEvent", MBR.OnEvent)

function MBR:SetupSavedVariables()
    if not MoronBoxRepair_Settings then
        MoronBoxRepair_Settings = {}
    end

    for k, v in ipairs(self.DefaultOptions) do
        if MoronBoxRepair_Settings[k] == nil then
            MoronBoxRepair_Settings[k] = v
        end
    end
end

function MBR:ResetToDefaults()
    MoronBoxRepair_Settings = self.DefaultOptions
    self:ResetPossibleVendorItems()
    ReloadUI()
end

-------------------------------------------------------------------------------
-- Core Action Code {{{
-------------------------------------------------------------------------------

function MBR:RepairItems()

    if not MoronBoxRepair_Settings.VendorSettings.AutoRepair or CanMerchantRepair() ~= 1 then 
        return 
    end

    local repairAllCost, canRepair = GetRepairAllCost()

    if repairAllCost > 0 then
        if canRepair == 1 then
            RepairAllItems()
            MBC:Print("Your items have been repaired for: "..GetCoinTextureString(repairAllCost))
            return
        end

        MBC:Print("You don't have enough money for repairs!")
    end
end

function MBR:SellGreyItems()

    if not MoronBoxRepair_Settings.VendorSettings.AutoSellGrey then 
        return 
    end

    local totalPrice, amountSold, itemsSold = 0, 0, 0

    for i = 0, 4 do
        for y = 1, GetContainerNumSlots(i) do
            local currentItemLink = GetContainerItemLink(i, y)

            if currentItemLink then
                -- Get item info
                local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(currentItemLink)
                local _, itemCount = GetContainerItemInfo(i, y)

                -- Identify items to skip
                local isGreyItem = itemRarity == 0
                local isWhiteItem = itemRarity == 1
                local isTradeGoods = itemType == "Trade Goods"
                local isConsumable = itemType == "Consumable"
                local isQuestItem = itemType == "Quest"
                local isHearthStone =  itemName == "Hearthstone"
                local isPotion = isConsumable and itemSubType == "Potion"
                local isHerb = isTradeGoods and itemSubType == "Herb"
                local isLeather = isTradeGoods and itemSubType == "Leather"
                local isCloth = isTradeGoods and itemSubType == "Cloth"
                local isFood = isConsumable and (itemSubType == "Food" or itemSubType == "Drink" or itemSubType == "Food & Drink")
                local isSpecialWeapon = itemType == "Weapon" and itemSubType == "Miscellaneous"

                -- Skip items that should not be sold
                if not (isQuestItem or isHearthStone or isPotion or isHerb or isLeather or isCloth or isFood or isSpecialWeapon) then

                    -- Sell gray items
                    if isGreyItem and itemSellPrice > 0 then

                        totalPrice = totalPrice + (itemSellPrice * itemCount)
                        amountSold = amountSold + itemCount
                        itemsSold = itemsSold + 1
                        UseContainerItem(i, y)

                    elseif isWhiteItem and itemSellPrice > 0 then

                        if self:ItemIsWhitelist({ Link = itemLink }) then

                            totalPrice = totalPrice + (itemSellPrice * itemCount)
                            amountSold = amountSold + itemCount
                            itemsSold = itemsSold + 1
                            UseContainerItem(i, y)
    
                        elseif not self:ItemIsBlacklist({ Link = itemLink }) 
                            and not self:ItemIsWhitelist({ Link = itemLink }) 
                            and not self:ItemExistsInPossibleVendorItems({ Link = itemLink }) then
  
                            table.insert(self.Session.PossibleVendorItems.WhiteListed, {
                                Name = itemName,
                                Link = itemLink,
                                Icon = itemTexture
                            })
                        end
                    end
                end
            end
        end
    end

    if self:HasVendorItems() then
        self:CreateSellOverview()
    end

    if itemsSold > 0 then
        MBC:Print("Total items sold: "..itemsSold.." ("..amountSold.." in total) for a combined price of "..GetCoinTextureString(totalPrice))
    end
end

function MBR:OpenVendorOrBank()
    if MoronBoxRepair_Settings.VendorSettings.AutoOpenInteraction then
        for i = 1, GetNumGossipOptions() do
            local GossipText, GossipType = GetGossipOptions(i)

            if GossipType == "vendor" or GossipType == "banker" or 
                (GossipText and (GossipText:find("I want to browse") or GossipText:find("I would like to check"))) then
                SelectGossipOption(i)
                MBC:Print("Opening "..CapitalizeFirstLetter(GossipType).."!")
                break
            end
        end
    end
end