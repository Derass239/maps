Citizen.CreateThread(function()
    SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0) -- Level 0
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0) -- Level 1
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0) -- Level 2
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0) -- Level 3
    SetMapZoomDataLevel(4, 24.3, 0.9, 0.08, 0.0, 0.0) -- Level 4
    SetMapZoomDataLevel(5, 55.0, 0.0, 0.1, 2.0, 1.0) -- ZOOM_LEVEL_GOLF_COURSE
    SetMapZoomDataLevel(6, 450.0, 0.0, 0.1, 1.0, 1.0) -- ZOOM_LEVEL_INTERIOR
    SetMapZoomDataLevel(7, 4.5, 0.0, 0.0, 0.0, 0.0) -- ZOOM_LEVEL_GALLERY
    SetMapZoomDataLevel(8, 11.0, 0.0, 0.0, 2.0, 3.0) -- ZOOM_LEVEL_GALLERY_MAXIMIZE
end)

local isPedOnFoot = false
local isPedInVehicle = false

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1)
		if isPedOnFoot or isPedInVehicle then
			SetRadarZoom(1100)
		end
    end
end)

Citizen.CreateThread(function()
    while(true) do
        isPedOnFoot = IsPedOnFoot(PlayerPedId())
        isPedInVehicle = IsPedInAnyVehicle(PlayerPedId(), true)
        Citizen.Wait(3000)
    end
end)

local isPostalActive = false

local postal = {
    ["postal_0_0"] = "minimap_0_0",
    ["postal_0_1"] = "minimap_0_1",
    ["postal_1_0"] = "minimap_1_0",
    ["postal_1_1"] = "minimap_1_1",
    ["postal_2_0"] = "minimap_2_0",
    ["postal_2_1"] = "minimap_2_1",
    ["postal_lod_128"] = "minimap_lod_128",
    ["postal_sea_0_0"] = "minimap_sea_0_0",
    ["postal_sea_0_1"] = "minimap_sea_0_1",
    ["postal_sea_1_0"] = "minimap_sea_1_0",
    ["postal_sea_1_1"] = "minimap_sea_1_1",
    ["postal_sea_2_0"] = "minimap_sea_2_0",
    ["postal_sea_2_1"] = "minimap_sea_2_1"
}

local normal = {
    ["minimap_0_0"] = "minimap_0_0",
    ["minimap_0_1"] = "minimap_0_1",
    ["minimap_1_0"] = "minimap_1_0",
    ["minimap_1_1"] = "minimap_1_1",
    ["minimap_2_0"] = "minimap_2_0",
    ["minimap_2_1"] = "minimap_2_1",
    ["minimap_lod_128"] = "minimap_lod_128",
    ["minimap_sea_0_0"] = "minimap_sea_0_0",
    ["minimap_sea_0_1"] = "minimap_sea_0_1",
    ["minimap_sea_1_0"] = "minimap_sea_1_0",
    ["minimap_sea_1_1"] = "minimap_sea_1_1",
    ["minimap_sea_2_0"] = "minimap_sea_2_0",
    ["minimap_sea_2_1"] = "minimap_sea_2_1"
}

RegisterCommand("postal", function()
    print(isPostalActive)
    if isPostalActive then
        isPostalActive = false
        for k, v in pairs(normal) do
            RequestStreamedTextureDict(k, false)
            while not HasStreamedTextureDictLoaded(k) do
                Wait(1)
            end
            local postalKey = string.gsub(k, "minimap_", "postal_")
            AddReplaceTexture(postal[postalKey], v, k, v)
        end
    else
        isPostalActive = true
        for k, v in pairs(postal) do
            RequestStreamedTextureDict(k, false)
            while not HasStreamedTextureDictLoaded(k) do
                Wait(1)
            end
            local normalKey = string.gsub(k, "postal_", "minimap_")
            AddReplaceTexture(normal[normalKey], v, k, v)
        end
    end
end, false)