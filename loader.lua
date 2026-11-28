-- loader.lua : เช็ก PlaceId แล้วรันสคริปต์ของแมพนั้น
local Scripts = {
    [91350038154849]  = "https://raw.githubusercontent.com/tlekabi12/durian-script/refs/heads/main/Tscriptdurian.lua", -- Durian Garden
    [142823291]       = "https://gist.githubusercontent.com/tlekabi12/5653c951f32de94508104ed2ae94199c/raw/mm2", -- Murder Mystery 2
    [104549080643413] = "https://raw.githubusercontent.com/tlekabi12/Mhnk-script/main/mhnk.luau", -- MAHANAKHON
    [92700843475315]  = "https://raw.githubusercontent.com/tlekabi12/RiverHunter/refs/heads/main/RiverHunter.lua", -- River Hunter
    [116750055341696] = "https://raw.githubusercontent.com/tlekabi12/Buddha/refs/heads/main/AmuletRoad.lua", -- Amulet Road (ถนนพระเครื่อง)
   
}

local url = Scripts[game.PlaceId]
if not url then
    warn("ยังไม่รองรับแมพนี้ PlaceId = " .. tostring(game.PlaceId))
    return
end

-- ใส่ ?t=เวลา ต่อท้ายลิงก์ทุกครั้ง เพื่อข้ามแคชและดึงเวอร์ชันล่าสุดเสมอ
-- (ถ้าลิงก์มี ? อยู่แล้วจะใช้ &t= แทน)
local separator = url:find("%?") and "&" or "?"
local finalUrl = url .. separator .. "t=" .. os.time()

local ok, err = pcall(function()
    loadstring(game:HttpGet(finalUrl))()
end)

if not ok then
    warn("โหลดสคริปต์ไม่สำเร็จ: " .. tostring(err))
end
