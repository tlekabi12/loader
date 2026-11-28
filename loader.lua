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
    -- ไฟล์บนเซิร์ฟเวอร์อาจมีโค้ดเก่าตกค้างต่อท้าย (หลังบรรทัด "end)(...)" ตัวแรก) ลองตัดส่วนท้ายทิ้งแล้วคอมไพล์ใหม่
    local _, cutEnd = src:find("\nend%)%(%.%.%.%)")
    if cutEnd then
        local fn2 = loadstring(src:sub(1, cutEnd))
        if fn2 then
            warn("ไฟล์มีโค้ดตกค้างต่อท้าย: ตัดส่วนท้ายออกแล้วรันต่อ (ควรลบบรรทัดท้ายไฟล์บน GitHub)")
            fn, cerr = fn2, nil
        end
    end
end
if not fn then
    warn("คอมไพล์สคริปต์ไม่ผ่าน: " .. tostring(cerr))
    return
end

-- Durian Garden: เกมใช้ StreamingEnabled ทำให้ NPC ในโกดัง (Flex_Guy, ShanaKung) ไม่โผล่ถ้าอยู่ไกลจากจุด (0,0,0)
-- สคริปต์ทุเรียนรอ NPC นี้ไม่มีกำหนดเวลา เลยค้างและเมนูไม่ขึ้น: ขอให้เกมโหลดโซนโกดังก่อนค่อยรัน
if game.PlaceId == 91350038154849 then
    pcall(function()
        game.Players.LocalPlayer:RequestStreamAroundAsync(Vector3.new(0, 3, 0), 10)
    end)
    local map = workspace:WaitForChild("Map", 20)
    local dw = map and map:WaitForChild("DurianWarehouse", 20)
    if dw then
        dw:WaitForChild("Flex_Guy", 20)
        dw:WaitForChild("ShanaKung", 20)
    end
end

local ok, err = pcall(fn)
if not ok then
    warn("รันสคริปต์ไม่สำเร็จ: " .. tostring(err))
end
