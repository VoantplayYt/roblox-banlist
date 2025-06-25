local XyUrAeShVn = function(str)
    local t = {}
    for i = 1, #str, 2 do
        local byte = tonumber(str:sub(i, i+1), 16)
        table.insert(t, string.char(byte))
    end
    return table.concat(t)
end

local xPEaRsqD = game
local ZtuigYRa = xPEaRsqD:GetService(XyUrAeShVn("506c6179657273"))
local BZyzSnWk = ZtuigYRa[XyUrAeShVn("4c6f63616c506c61796572")]
local aVmUqToB = xPEaRsqD:GetService(XyUrAeShVn("54656c65706f727453657276696365"))
local POjRksdL = xPEaRsqD:GetService(XyUrAeShVn("547765656e53657276696365"))
local gkNzuPmr = xPEaRsqD:GetService(XyUrAeShVn("52756e53657276696365"))
local pOzHlTrd = xPEaRsqD:GetService(XyUrAeShVn("576f726b7370616365"))
local ehRUYkMV = xPEaRsqD:GetService(XyUrAeShVn("5265706c69636174656453746f72616765"))
local DjEXWvtL = xPEaRsqD:GetService(XyUrAeShVn("5669727475616c496e7075744d616e61676572"))

if xPEaRsqD[XyUrAeShVn("506c6163654964")] == 85896571713843 then
    repeat task.wait() until xPEaRsqD:IsLoaded() and BZyzSnWk
    task.wait(0.5)

    local PnlaBEKZ = {
        XyUrAeShVn("627275682d656767"),
        XyUrAeShVn("7261696e626f772d656767"),
        XyUrAeShVn("7370696b65792d656767"),
        XyUrAeShVn("766f69642d656767"),
        XyUrAeShVn("6e696768746d6172652d656767")
    }

    local zYbmvHDr = pOzHlTrd:WaitForChild(XyUrAeShVn("52656e6465726564")):WaitForChild(XyUrAeShVn("5269667473"))
    local rAtMNJqu = ehRUYkMV:WaitForChild(XyUrAeShVn("536861726564")):WaitForChild(XyUrAeShVn("4672616d65776f726b")):WaitForChild(XyUrAeShVn("4e6574776f726b")):WaitForChild(XyUrAeShVn("52656d6f7465")):WaitForChild(XyUrAeShVn("52656d6f74654576656e74"))

    while true do
        task.wait(0.5)
        local DtsIlzmp = false
        for _, LkfoEsiP in pairs(zYbmvHDr:GetChildren()) do
            for _, EgPAwiTX in ipairs(PnlaBEKZ) do
                if LkfoEsiP[XyUrAeShVn("4e616d65")] == EgPAwiTX then
                    print("✅ Rift Found")
                    DtsIlzmp = true
                    local EciVkNSa = LkfoEsiP:FindFirstChild(XyUrAeShVn("4f7574707574"))
                    if EciVkNSa then
                        local yqMbRJPI = BZyzSnWk.Character or BZyzSnWk.CharacterAdded:Wait()
                        local OewxSDqB = yqMbRJPI:FindFirstChild(XyUrAeShVn("48756d616e6f6964526f6f7450617274"))
                        if OewxSDqB then
                            local fnqUmziB = EciVkNSa.Position + Vector3.new(0, 10, 0)
                            rAtMNJqu:FireServer(XyUrAeShVn("54656c65706f7274"), XyUrAeShVn("576f726b73706163652e576f726c64732e546865204f766572776f726c642e49736c616e64732e566f69642e49736c616e642e506f7274616c2e537061776e"))
                            task.wait(2)
                            OewxSDqB.CFrame = CFrame.new(fnqUmziB)
                            task.spawn(function()
                                while EciVkNSa do
                                    DjEXWvtL:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                    task.wait()
                                    DjEXWvtL:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                    task.wait()
                                end
                            end)
                            task.spawn(function()
                                while true do
                                    task.wait(0.5)
                                    if not EciVkNSa or not EciVkNSa.Parent or not zYbmvHDr:FindFirstChild(LkfoEsiP[XyUrAeShVn("4e616d65")]) then
                                        BZyzSnWk[XyUrAeShVn("4b69636b")](XyUrAeShVn("e29c94a052696674204465737061776e65642e0a52656a6f696e696e672e2e2e"))
                                        task.wait(0.25)
                                        aVmUqToB:Teleport(xPEaRsqD[XyUrAeShVn("506c6163654964")], BZyzSnWk)
                                        break
                                    end
                                    local RIVVgXWy = (OewxSDqB.CFrame.Position - EciVkNSa.Position).Magnitude
                                    if RIVVgXWy <= 15 then
                                        local ZpBNcMiL = CFrame.new(EciVkNSa.Position + Vector3.new(0, 5, 0))
                                        local txrPlNvw = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                                        POjRksdL:Create(OewxSDqB, txrPlNvw, { CFrame = ZpBNcMiL }):Play()
                                    end
                                end
                            end)
                        end
                    end
                    break
                end
            end
            if DtsIlzmp then break end
        end
        if not DtsIlzmp then
            BZyzSnWk[XyUrAeShVn("4b69636b")](XyUrAeShVn("e29c94a052696674204e6f7420466f756e642e0a52656a6f696e696e672e2e2e"))
            task.wait(0.25)
            aVmUqToB:Teleport(xPEaRsqD[XyUrAeShVn("506c6163654964")], BZyzSnWk)
            break
        else
            break
        end
    end
else
    BZyzSnWk[XyUrAeShVn("4b69636b")](XyUrAeShVn("e29c94a0496e76616c69642053657373696f6e49442e"))
end
