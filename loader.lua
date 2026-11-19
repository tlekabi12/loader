-- loader.lua : เช็ก PlaceId แล้วรันสคริปต์ของแมพนั้น
local Scripts = {
    [91350038154849]  = "https://raw.githubusercontent.com/tlekabi12/durian-script/main/Tscriptdurian.lua", -- Durian Garden
    [142823291]       = "https://gist.githubusercontent.com/tlekabi12/5653c951f32de94508104ed2ae94199c/raw/mm2", -- Murder Mystery 2
    [104549080643413] = "https://raw.githubusercontent.com/tlekabi12/Mhnk-script/main/mhnk.luau", -- MAHANAKHON 
}

local url = Scripts[game.PlaceId]
if not url then
    warn("ยังไม่รองรับแมพนี้ PlaceId = " .. tostring(game.PlaceId))
    return
end

-- ตรวจสอบว่าลิงก์เดิมมีเครื่องหมาย ? หรือยัง เพื่อเลือกใช้ ?t= หรือ &t= สำหรับข้ามแคช
local separator = url:find("%?") and "&" or "?"
local finalUrl = url .. separator .. "t=" .. os.time()

local ok, err = pcall(function()
    loadstring(game:HttpGet(finalUrl))()
end)

if not ok then 
    warn("โหลดสคริปต์ไม่สำเร็จ: " .. tostring(err)) 
end
