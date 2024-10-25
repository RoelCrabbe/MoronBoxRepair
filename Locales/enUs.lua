-------------------------------------------------------------------------------
-- Localization English {{{
-------------------------------------------------------------------------------

function MBR:Localization_enUS()

    self.L = {}

    self.L["Moron Box Repair"] = ""

    self.L["Intro"] = 
        MBC:ApplyTextColor("MoronBoxRepair", MBC.COLORS.Highlight)..
        MBC:ApplyTextColor(" is a lightweight bag cleaner addon that automatically repairs gear when needed.", MBC.COLORS.Text)

    self.L["Icon Explanation"] = 
        "|TInterface\\AddOns\\MoronBoxCore\\Media\\Icons\\RedMinus.tga:22:22:0:0:64:64:4:60:4:60|t" ..
        MBC:ApplyTextColor(" : Auto Vendor   |   ", MBC.COLORS.Text) ..
        "|TInterface\\AddOns\\MoronBoxCore\\Media\\Icons\\GreenPlus.tga:22:22:0:0:64:64:4:60:4:60|t" ..
        MBC:ApplyTextColor(" : Never Vendor", MBC.COLORS.Text)

    self.L["New Items Found"] =
        MBC:ApplyTextColor("These items haven't been sold before. Review them carefully and choose which ones should be auto-sold in the future.\n", MBC.COLORS.Text)..
        MBC:ApplyTextColor("Your selections will be saved, and those items will ", MBC.COLORS.Text)..
        MBC:ApplyTextColor("always", MBC.COLORS.Highlight)..
        MBC:ApplyTextColor(" be kept from auto-selling.\n\n", MBC.COLORS.Text)..
        MBC:ApplyTextColor("Certain items, like ", MBC.COLORS.Text)..
        MBC:ApplyTextColor("cloth", MBC.COLORS.Highlight).. 
        MBC:ApplyTextColor(", ", MBC.COLORS.Text)..
        MBC:ApplyTextColor("leather", MBC.COLORS.Highlight)..
        MBC:ApplyTextColor(", ", MBC.COLORS.Text)..
        MBC:ApplyTextColor("potions", MBC.COLORS.Highlight)..
        MBC:ApplyTextColor(", and ", MBC.COLORS.Text)..
        MBC:ApplyTextColor("quest items", MBC.COLORS.Highlight)..
        MBC:ApplyTextColor(", will always be excluded from auto-selling.\n\n", MBC.COLORS.Text)

    self.L["Reset Settings"] =
        MBC:ApplyTextColor("Are you sure", MBC.COLORS.Highlight)..
        MBC:ApplyTextColor(" you want to proceed and ", MBC.COLORS.Text)..
        MBC:ApplyTextColor("reset settings", MBC.COLORS.Highlight)..
        MBC:ApplyTextColor("?", MBC.COLORS.Text)

    self.L["Auto Open Vendor Label"] =
        MBC:ApplyTextColor("Enable Auto Open Vendor & Bankers", MBC.COLORS.Text)

    self.L["Auto Repair Label"] =
        MBC:ApplyTextColor("Enable Auto Repair", MBC.COLORS.Text)

    self.L["Auto Sell Grey Label"] =
        MBC:ApplyTextColor("Enable Auto Sell Grey & White Items", MBC.COLORS.Text)

    self.L["Auto Black List Mats Label"] =
        MBC:ApplyTextColor("Auto Mats & Food & Drink Blacklisting", MBC.COLORS.Text)

    self.L["Items Repaired"] = "Your items have been repaired for: "
    self.L["No Repair"] = "You don't have enough money for repairs!"
    self.L["Total Items Sold"] = "Total items sold: %s (%s in total) for a combined price of %s"
    self.L["Opening"] = "Opening "
    self.L["Vendor"] = "Vendor"
    self.L["Banker"] = "Banker"
    self.L["Browse"] = "I want to browse"
    self.L["Check"] = "I would like to check"

    self.L["WhiteListed Single"] = "There has been 1 item added to the vendor list."
    self.L["WhiteListed Multiple"] = "There have been %s items added to the vendor list."
    self.L["BlackListed Single"] = "There is 1 item that won't be vendored from now on."
    self.L["BlackListed Multiple"] = "There have been %s items that won't be vendored from now on."
end