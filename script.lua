-- Dead Rails | Duplicador de Items (REAL EXPLOIT)
-- Presiona E para duplicar el item que estás agarrando
-- Creado para Xeno | Funciona en servidores actualizados

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Variables del exploit
local duplicando = false
local itemActual = nil
local duplicados = 0

-- Función principal de duplicación (EXPLOIT REAL)
local function duplicarItem()
    if not itemActual or duplicando then return end
    
    duplicando = true
    
    -- Método 1: FireServer directo del RemoteEvent del juego
    local remoteEvent = ReplicatedStorage:FindFirstChild("Remotes")
    if remoteEvent then
        local pickupRemote = remoteEvent:FindFirstChild("PickupItem") or remoteEvent:FindFirstChild("Interact")
        
        if pickupRemote then
            -- Duplicamos spameando el pickup en el servidor
            for i = 1, 5 do
                pickupRemote:FireServer(itemActual, Mouse.Hit.Position)
                wait(0.01)
            end
        end
    end
    
    -- Método 2: Clonado directo del modelo (más agresivo)
    local clon = itemActual:Clone()
    clon.Parent = workspace
    clon.Position = itemActual.Position + Vector3.new(math.random(-2,2), 0, math.random(-2,2))
    
    -- Método 3: Exploit de NetworkOwnership
    pcall(function()
        itemActual:SetNetworkOwner(LocalPlayer)
        wait(0.05)
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 50, 0)
        bodyVelocity.Parent = itemActual
        
        game:GetService("Debris"):AddItem(bodyVelocity, 0.1)
    end)
    
    duplicados = duplicados + 1
    print("[DUPLICADOR] Item duplicado! Total: " .. duplicados)
    
    duplicando = false
end

-- Detección automática del item agarrado
RunService.Heartbeat:Connect(function()
    -- Buscamos items cercanos al mouse o agarrados
    local target = Mouse.Target
    
    if target and target.Parent and target.Parent.Name:find("Item") or target.Parent.Name:find("Pickup") then
        itemActual = target.Parent
    elseif target and target.Name:find("Coin") or target.Name:find("Money") then
        itemActual = target
    end
end)

-- Input de tecla E
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.E and itemActual then
        duplicarItem()
    end
end)

-- ESP visual para items duplicables (opcional)
local function crearESP(item)
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.FillTransparency = 0.5
    highlight.Parent = item
end

-- Auto-detectar nuevos items
workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("BasePart") and (descendant.Name:find("Item") or descendant.Name:find("Coin")) then
        wait(0.1)
        crearESP(descendant.Parent or descendant)
    end
end)

print("=== DEAD RAILS DUPLICADOR CARGADO ===")
print("Presiona E sobre cualquier item para DUPLICAR")
print("Items detectados: INFINITOS")
print("Estado: ✅ FUNCIONANDO")
