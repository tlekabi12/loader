-- loader.lua : เช็ก PlaceId แล้วรันสคริปต์ของแมพนั้น
-- loader.lua : เช็ก PlaceId แล้วรันสคริปต์ของแมพนั้น
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(2)

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

-- ดึงสคริปต์ ลองใหม่สูงสุด 3 ครั้ง
local src, lastErr
for attempt = 1, 3 do
    local ok, res = pcall(function() return game:HttpGet(finalUrl) end)
    if ok and type(res) == "string" and #res > 100 then
        src = res
        break
    end
    lastErr = ok and ("ได้ข้อมูลสั้นผิดปกติ (" .. tostring(res and #res) .. " ตัวอักษร)") or res
    warn(("ดึงสคริปต์ไม่สำเร็จ (ครั้งที่ %d/3): %s"):format(attempt, tostring(lastErr)))
    task.wait(2)
end
if not src then return end

local fn, cerr = loadstring(src)
if not fn then
    warn("คอมไพล์สคริปต์ไม่ผ่าน: " .. tostring(cerr))
    return
end

local ok, err = pcall(fn)
if not ok then
    warn("รันสคริปต์ไม่สำเร็จ: " .. tostring(err))
end
