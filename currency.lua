local CurrentFrame
local Initialize

local function MoneyString()
    local money = GetMoney()
    return ("%dg %ds %dc"):format(money / 10000, (money / 100) % 100, money % 100)
end

local function MakeFrame()
    local displays = {}
    local currencies = {}

    local frame = CreateFrame("Frame", "CurrencyFrame", UIParent)
    frame:SetPoint("BOTTOMRIGHT", -30, 5)
    frame:SetWidth(200)
    frame:SetHeight(100)
    frame:Show()

    -- Create gold display
    local icon_tex = frame:CreateTexture()
    icon_tex:SetTexture("Interface\\Icons\\inv_misc_coin_01")
    icon_tex:SetPoint("BOTTOMLEFT", 0, 0)
    icon_tex:SetWidth(20)
    icon_tex:SetHeight(20)
    icon_tex:Show()

    local num = frame:CreateFontString()
    num:SetFont("Fonts\\FRIZQT__.TTF", 12)
    num:SetPoint("BOTTOMLEFT", 25, 3)
    num:SetShadowColor(0, 0, 0, 1)
    num:SetShadowOffset(1, -1)
    num:SetText(MoneyString())

    displays[0] = {
        icon_tex = icon_tex,
        num = num
    }

    -- Create currency displays
    for i = 1, GetNumWatchedTokens() do
        local name, amount, icon, id = GetBackpackCurrencyInfo(i)

        local icon_tex = frame:CreateTexture()
        icon_tex:SetTexture(icon)
        icon_tex:SetPoint("BOTTOMLEFT", 0, i * 25)
        icon_tex:SetWidth(20)
        icon_tex:SetHeight(20)
        icon_tex:Show()

        local label = frame:CreateFontString()
        label:SetFont("Fonts\\FRIZQT__.TTF", 12)
        label:SetPoint("BOTTOMLEFT", 25, i * 25 + 3)
        label:SetShadowColor(0, 0, 0, 1)
        label:SetShadowOffset(1, -1)
        label:SetText(name)
        label:Show()

        local num = frame:CreateFontString()
        num:SetFont("Fonts\\FRIZQT__.TTF", 12)
        num:SetPoint("LEFT", label, "RIGHT", 5, 0)
        num:SetShadowColor(0, 0, 0, 1)
        num:SetShadowOffset(1, -1)
        num:SetText(tostring(amount))

        table.insert(currencies, id)
        displays[id] = {
            icon_tex = icon_tex,
            label = label,
            num = num
        }
    end

    frame:SetScript("OnEvent", function (self, event, ...)
        if event == "CURRENCY_DISPLAY_UPDATE" then
            Initialize()
            return
        end

        displays[0].num:SetText(MoneyString())
        
        for i, currency in ipairs(currencies) do
            local _, amount = GetCurrencyInfo(currency)
            displays[currency].num:SetText(tostring(amount))
        end
    end)
    
    frame:RegisterEvent("PLAYER_MONEY")
    frame:RegisterEvent("CHAT_MSG_CURRENCY")
    frame:RegisterEvent("BAG_UPDATE")
    frame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")

    return frame
end

Initialize = function()
    if CurrentFrame then
        CurrencyFrame:SetScript("OnEvent", nil)
        CurrentFrame:Hide()
    end
    CurrentFrame = MakeFrame()
end

Initialize()
