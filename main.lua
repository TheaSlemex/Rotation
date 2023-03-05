if Main["Online Header"] then
    config = request("GET", Main["Header Script"])
    load(config)()
end

worlds = {}
pohon = {}
waktu = {}
fossil = {}
tileBreak = {}
rekapWaktu = ""
WorldOwner = Main.WorldOwner
slot = Main.Bot[getBot().name:upper()].slot
worldss = Main.Bot[getBot().name:upper()].listWorld
doorId = Main.Bot[getBot().name:upper()].doorFarm
totalWorld = #Main.Bot[getBot().name:upper()].listWorld
upgradeBp = Main.Bot[getBot().name:upper()].upgradeBackpack
posX = Main.Bot[getBot().name:upper()].posisiX
posY = Main.Bot[getBot().name:upper()].posisiY
startFrom = Main.Bot[getBot().name:upper()].worldStart
editWebhook = Main.Bot[getBot().name:upper()].editWebhook
messageId = Main.Bot[getBot().name:upper()].messageId
webhook = Main.Bot[getBot().name:upper()].webhookLink
showlistNow = 1
loop = 0
kuntul = 0
waktuHidup = os.time()
sleep_time = Plugin["Rest"].Time["Delay"] * 60000
blockId = seedid - 1
farmable = {seedid,blockId}

if not webhookOffline:find("https://discord.com/api/webhooks/") then
    webhookOffline = webhook
end

for _, item in pairs(farmable) do
    table.insert(dontTrash,item)
end

for _, pack in pairs(idPack) do
    table.insert(dontTrash,pack)
end

for i = startFrom, totalWorld do
    table.insert(worlds,worldss[i])
end

if looping then
    for i = 1,startFrom-1 do
        table.insert(worlds,worldss[i])
    end
end

if (showList-1) >= totalWorld then
    customShow = false
end

for i = math.floor(tilePnb/2),1,-1 do
    i = i * -1
    table.insert(tileBreak,i)
end

for i = 0, math.ceil(tilePnb/2) - 1 do
    table.insert(tileBreak,i)
end

function tilePunch1(x,y)
    for _,num in pairs(tileBreak) do
        if getTile(x - 1,y + num).fg ~= 0 or getTile(x - 1,y + num).bg ~= 0 then
            return true
        end
    end
    return false
end

function tilePlace1(x,y)
    for _,num in pairs(tileBreak) do
        if getTile(x - 1,y + num).fg == 0 and getTile(x - 1,y + num).bg == 0 then
            return true
        end
    end
    return false
end

function tilePunch2(x,y)
    for _,num in pairs(tileBreak) do
        if getTile(x + 1,y + num).fg ~= 0 or getTile(x + 1,y + num).bg ~= 0 then
            return true
        end
    end
    return false
end

function tilePlace2(x,y)
    for _,num in pairs(tileBreak) do
        if getTile(x + 1,y + num).fg == 0 and getTile(x - 1,y + num).bg == 0 then
            return true
        end
    end
    return false
end

function cekItem(table,item)
    for _, name in pairs(table) do
        if name == item then
            return true
        end
    end
    return false
end

if editWebhook == "true" then
    webhookUrl = webhook.."/messages/"..messageId
else
    webhookUrl = webhook
end

function countworlds()
    totalworld = 0
    progres = 0
    for O, Y in pairs(worlds) do
        if Y ~= nil then
            totalworld = totalworld + 1
		      end
    end		  
    for O, S in pairs(worlds) do
        if S ~= nil then
			        progres = progres + 1
		      end
	       if S:upper() == (getBot()).world:upper() then
			         break
		      end
	   end
    worldnumber = progres .. "/" .. totalworld
end

function worldTime()
    rekapWaktu = ""
    if customShow then
        for i = showList,1,-1 do
            newList = showlistNow - i
            if newList <= 0 then
                newList = newList + totalWorld
            end
            if getBot().world:upper() == worlds[newList]:upper() then
                rekapWaktu = rekapWaktu.."\n"..newList..". "..worlds[newList]:upper().." ( "..(waktu[worlds[newList]] or "FARMING").." )"
            else
                rekapWaktu = rekapWaktu.."\n"..newList..". "..worlds[newList]:upper().." ( "..(waktu[worlds[newList]] or "NO DATA").." )"
            end
        end
    else
        for i,world in pairs(worlds) do
            if getBot().world == world then
                rekapWaktu = rekapWaktu.."\n"..i..". "..world:upper().." ( "..(waktu[world] or "FARMING").." )"
            else
                rekapWaktu = rekapWaktu.."\n"..i..". "..world:upper().." ( "..(waktu[world] or "NO DATA").." )"
            end
        end
    end
end

function getCaptcha()
    local res = "Failed"
    if getBot().captcha:find("Solved") then
        res = "Solved"
    else
        res = "Failed"
    end
    return res
end

function getJammer()
    local res = "Not Active"
    for _, tile in pairs(getTiles()) do
        if tile.fg == 226 then
            if tile.data == 1 then
                res = "Active"
            else
                res = "Not Active"
            end
        end
    end
    return res
end

function powershell(o)
    local getPlr = #getPlayers()+1
    countworlds()
    sleep(100)
    waktuSc = os.time() - waktuHidup
    worldTime()
    sleep(100)
    local script = [[
        $webHookUrl = "]]..webhookUrl..[["
        $titleObj = "Rotation Information"
        $desc = '<:megaphone:1055467413463896144> **Bot Information**
]]..o..[['
        $cpu = (Get-WmiObject win32_processor | Measure-Object -property LoadPercentage -Average | Select Average).Average
        $CompObject =  Get-WmiObject -Class WIN32_OperatingSystem
        $Memory = ((($CompObject.TotalVisibleMemorySize - $CompObject.FreePhysicalMemory)*100)/ $CompObject.TotalVisibleMemorySize)
        $ram = [math]::Round($Memory, 0)
        $footerObj = [PSCustomObject]@{
            text = '! PIKEHOOK#0716
]]..os.date("%a %d %b, %Y at %H:%M %p")..[['
        }
        $fieldArray = @(
            @{
                name = "<:player:1007595580253536257> Name"
                value = "<a:arrowyellow:983237528037498940> ]]..getBot().name..[[ - (Slot ]]..slot..[[)"
                inline = "true"
            }
            @{
                name = "<:emoji_76:1018295410072244296> World (]]..loop..[[ Loop)"
                value = "<a:arrowyellow:983237528037498940> ]]..getBot().world:upper()..[[ - (]]..worldnumber..[[)"
                inline = "true"
            }
            @{
                name = "<:jammers:1081192465308069960> Jammer"
                value = "<a:arrow:1065851091008356434> ]]..getJammer()..[[ - (]]..getPlr..[[ Players)"
                inline = "true"
            }
            @{
                name = "<:status:1007595490600288326> Status"
                value = "<a:arrowyellow:983237528037498940> ]]..getBot().status..[[ - (]]..getCaptcha()..[[)"
                inline = "true"
            }
            @{
                name = "<:100gems:1007595715838607401> Gems"
                value = "<a:arrowyellow:983237528037498940> ]]..findItem(112)..[["
                inline = "true"
            }
            @{
                name = "<:small_seed_pack:1055465835164082237> Pack"
                value = "<a:arrowyellow:983237528037498940> ]]..kuntul..[[ ]]..displayPack..[["
                inline = "true"
            }
            @{
                name = "<:scrolll:1055465858044022865> World List"
                value = "**]]..rekapWaktu..[[**"
                inline = "false"
            }
            @{
                name = "<:growtopia_clock:1011929976628596746> Uptime"
                value = "<a:arrowyellow:983237528037498940> ]]..math.floor(waktuSc/86400)..[[ Days ]]..math.floor(waktuSc%86400/3600)..[[ Hours ]]..math.floor(waktuSc%86400%3600/60)..[[ Minutes ]]..math.floor(waktuSc%60)..[[ Seconds"
                inline = "false"
            }
        )
        $embedObject = @{
            title = $titleObj
            description = $desc
            color = "16746496"
            fields = $fieldArray
            footer = $footerObj
        }
        $embedArray = @($embedObject)
        $payload = @{
            embeds = $embedArray
        }
        $edit = "]]..editWebhook..[["
        if ($edit -match "true") {
            $Method = "Patch"
        } else {
            $Method = "Post"
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method $Method -ContentType 'application/json'
    ]]
    local pipe = io.popen("powershell -command -", "w")
    pipe:write(script)
    pipe:close()
end

function packInfo(link,id,desc)
    local text = [[
        $webHookUrl = "]]..link..[[/messages/]]..id..[["
        $thumbnailObject = @{
            url = "https://media.discordapp.net/attachments/1067061580237381702/1081195145283772476/20230205_110111.png"
        }
        $footerObject = @{
            text = '! PIKEHOOK#0716
]]..os.date("%a %d %b, %Y at %H:%M %p")..[['
        }
        $fieldArray = @(
            @{
                name = "<:player:1055465879929901136> Name"
                value = "]]..getBot().name..[["
                inline = "false"
            }
            @{
                name = "<:growscan:1055466125334413362> Items"
                value = "]]..desc..[["
                inline = "false"
            }
        )
        $embedObject = @{
            title = "<:megaphone:1055467413463896144> **Storage Information**"
            color = "16746496"
            thumbnail = $thumbnailObject
            footer = $footerObject
            fields = $fieldArray
        }
        $embedArray = @($embedObject)
        $payload = @{
            embeds = $embedArray
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Patch -ContentType 'application/json'
    ]]
    local file = io.popen("powershell -command -", "w")
    file:write(text)
    file:close()
end

function seedInfo(link,id,desc)
    local text = [[
        $webHookUrl = "]]..link..[[/messages/]]..id..[["
        $thumbnailObject = @{
            url = "https://media.discordapp.net/attachments/1067061580237381702/1081195145283772476/20230205_110111.png"
        }
        $footerObject = @{
            text = '! PIKEHOOK#0716
]]..os.date("%a %d %b, %Y at %H:%M %p")..[['
        }
        $fieldArray = @(
            @{
                name = "<:player:1055465879929901136> Name"
                value = "]]..getBot().name..[["
                inline = "false"
            }
            @{
                name = "<:growscan:1055466125334413362> Items"
                value = "]]..desc..[["
                inline = "false"
            }
        )
        $embedObject = @{
            title = "<:megaphone:1055467413463896144> **Storage Information**"
            color = "16746496"
            thumbnail = $thumbnailObject
            footer = $footerObject
            fields = $fieldArray
        }
        $embedArray = @($embedObject)
        $payload = @{
            embeds = $embedArray
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Patch -ContentType 'application/json'
    ]]
    local file = io.popen("powershell -command -", "w")
    file:write(text)
    file:close()
end

function loginInfo()
    local script = [[
        $webHookUrl = "]]..webhookOffline..[["
        $titleObj = "Login Information"
        $footerObj = [PSCustomObject]@{
            text = '! PIKEHOOK#0716
]]..os.date("%a %d %b, %Y at %H:%M %p")..[['
        }
        $fieldArray = @(
            @{
                name = "<:player:1055465879929901136> Name"
                value = "]]..getBot().name..[[ - (Slot ]]..slot..[[)"
                inline = "true"
            }
            @{
                name = "<:status:1055465801097957446> Status"
                value = "<:arrow:1041677730044989500> ]]..getBot().status..[[ - (]]..getCaptcha()..[[)"
                inline = "false"
            }
        )
        $embedObject = @{
            title = $titleObj
            color = "16746496"
            fields = $fieldArray
            footer = $footerObj
        }
        $embedArray = @($embedObject)
        $payload = @{
            embeds = $embedArray
            content = "@everyone"
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Post -ContentType 'application/json'
    ]]
    local pipe = io.popen("powershell -command -", "w")
    pipe:write(script)
    pipe:close()
end

function restInfo(txt)
    local script = [[
        $webHookUrl = "]]..webhookOffline..[["
        $titleObj = "Rest Information"
        $txt = "]]..txt..[["
        $footerObj = [PSCustomObject]@{
            text = '! PIKEHOOK#0716
]]..os.date("%a %d %b, %Y at %H:%M %p")..[['
        }
        $fieldArray = @(
            @{
                name = "<:player:1055465879929901136> Name"
                value = "]]..getBot().name..[[ - (Slot ]]..slot..[[)"
                inline = "true"
            }
            @{
                name = "<:status:1055465801097957446> Status"
                value = "<:arrow:1041677730044989500> ]]..getBot().status..[[ - (]]..getCaptcha()..[[)"
                inline = "false"
            }
        )
        $embedObject = @{
            title = $titleObj
            color = "16746496"
            description = $txt
            fields = $fieldArray
            footer = $footerObj
        }
        $embedArray = @($embedObject)
        $payload = @{
            embeds = $embedArray
            content = "@everyone"
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Post -ContentType 'application/json'
    ]]
    local pipe = io.popen("powershell -command -", "w")
    pipe:write(script)
    pipe:close()
end

function cekWorld(world)
    fossil[world] = 0
    for _, til in pairs(getTiles()) do
        if til.fg == 3918 then
            fossil[world] = fossil[world] + 1
        end
    end
end
        
function relogin(world,id,x,y)
    while getBot().captcha:find("Couldn't") or getBot().captcha:find("Wrong") do
        disconnect()
        sleep(3000)
        break
    end

    if getBot().status ~= "online" then
        powershell("Reconnecting")
        sleep(100)
        loginInfo()
        sleep(100)
        while true do
            connect()
            sleep(3000)
            if getBot().status == "online" then
                break
            end
        end
        powershell("Succes reconnect")
        sleep(100)
        loginInfo()
        sleep(100)

        if Plugin["Active"] and Plugin["Rest"].Time["Active"] then
            checktime()
        end
                
        if getBot().status == "online" and getBot().world ~= world:upper() then
            while getBot().status == "online" and getBot().world ~= world:upper() do
                sendPacket(3,"action|join_request\nname|".. world:upper().. "|"..id:upper().."\ninvitedWorld|0")
                sleep(6000)
            end
        end
        if getBot().status == "online" and getBot().world == world:upper() then
            while getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 do
                sendPacket(3,"action|join_request\nname|".. world:upper().. "|".. id:upper().. "\ninvitedWorld|0")
                sleep(5000)
            end
        end
        if x and y and getBot().status == "online" and getBot().world == world:upper() then
            while math.floor(getBot().x / 32) ~= x and math.floor(getBot().y / 32) ~= y do
                findPath(x,y)
                sleep(100)
            end
        end
    end
end

function checktime()
	current_time = os["time"]()
	time_1 = tonumber(os["date"]("!%H")) - 5
	time_2 = os["date"]("!%M", current_time)
	time_3 = string["format"]("%02d:%02d", time_1, time_2)
	for _, B in pairs(Plugin["Rest"].Time["Offline"]) do
		if time_3 == B then
			setBool("Auto Reconnect", false)
			if (getBot())["status"] == "online" then
				setBool("Auto Reconnect", false)
				sleep(1000)
				disconnect()
				restInfo("Bot disconnected for " .. Plugin["Rest"].Time["Delay"] .. " minutes")
			end
			sleep(sleep_time)
			setBool("Auto Reconnect", true)
			connect()
			sleep(5000)
			break
		end
	end
end

function RandomVariable(e)
	local B = function(e)
		local m, C = e[#e], ""
		for B = 1, #m, 1 do
			C = C .. m[e[B]]
		end
		return C
	end
	local C = function(e)
		local m = ""
		for C = 1, #e / 2, 1 do
			m = m .. e[#e / 2 + e[C]]
		end
		return m
	end
	local m = ""
	for e = 1, e, 1 do
		m = m .. string["char"](math["random"](97, 122))
	end
	return m
end

function randomworld()
	if Plugin["Random World"].World > 0 then
		for C = Plugin["Random World"].World, 1, -1 do
			sendPacket(3, "action|join_request\nname|" .. RandomVariable(5) .. "\ninvitedWorld|0")
            sleep(Plugin["Random World"].Delay)
		end
	end
end

function trashSampah() 
    for _, item in pairs(getInventory()) do
        if not cekItem(dontTrash,item.id) then
            sendPacket(2, "action|trash\n|itemID|"..item.id)
            sendPacket(2, "action|dialog_return\ndialog_name|trash_item\nitemID|"..item.id.."|\ncount|"..item.count)
            sleep(200)
        end
    end
end
        
function pindah(world,id)
    n = 0
    nuke = false
    while getBot().status == "online" and getBot().world ~= world:upper() do
        sendPacket(3,"action|join_request\nname|".. world:upper().."|"..id:upper().."\ninvitedWorld|0")
        sleep(6000)
        if n == 20 then
            nuke = true
            break
        else
            n = n + 1
        end
    end
    
    if not nuke then
        while getBot().status == "online" and getTile(math.floor(getBot().x / 32), math.floor(getBot().y / 32)).fg == 6 do
            sendPacket(3,"action|join_request\nname|".. world:upper().. "|".. id:upper().. "\ninvitedWorld|0")
            sleep(5000)
        end
    end
end
    
function round(n)
    return n % 1 > 0.5 and math.ceil(n) or math.floor(n)
end

function take(id)
    for _, item in pairs(getObjects()) do
        if item.id == id then
            local x = math.floor((item.x+10)/32)
            local y = math.floor((item.y+10)/32)
            findPath(x, y)
            sleep(1000)
            collect(3)
            sleep(1000)
            while findItem(id) > 1 do
                move(-1,0)
                sleep(1000)
                sendPacket(2,"action|drop\nitemID|" .. id)
                sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|" .. id .. "|\ncount|" .. findItem(id)-1)
                sleep(1000)
            end
            if findClothes(98) == false then
                wear(98)
                sleep(100)
            end
            if findItem(98) > 0 then
                break
            end
        end
    end
end
        
function dropPack(x,y,jumlah)
    local count = 0
    local stak = 0
    for _, obj in pairs(getObjects()) do
        if round(obj.x / 32) == x and math.floor(obj.y / 32) == y then
            count = count + obj.count
            stak = stak + 1
        end
    end
    if stak < 20 and count <= (4000 - jumlah) then
        return true
    end
    return false
end
        
function dropSeed(x,y,jumlah)
    local count = 0
    for _,obj in pairs(getObjects()) do
        if round(obj.x / 32) == x and math.floor(obj.y / 32) == y then
            count = count + obj.count
        end
    end
    if count <= (4000 - jumlah) then
        return true
    end
    return false
end

function itemInfo(ids)
    local result = {name = "null", id = ids, emote = "null"}
    for _,item in pairs(emotes) do
        if item.id == ids then
            result.name = item.name
            result.emote = item.emote
            return result
        end
    end
    return result
end

function infoPack()
    local store = {}
    for _,obj in pairs(getObjects()) do
        if store[obj.id] then
            store[obj.id].count = store[obj.id].count + obj.count
        else
            store[obj.id] = {id = obj.id, count = obj.count}
        end
    end
    local str = ""
    for _,object in pairs(store) do
        str = str.."\n"..itemInfo(object.id).emote.." "..itemInfo(object.id).name.." > "..object.count
    end
    return str
end

function narohPack(world)
    for _, pack in pairs(idPack) do
        for _, til in pairs(getTiles()) do
            if til.fg == patokanPack or til.bg == patokanPack then
                if dropPack(til.x,til.y,findItem(pack)) then
                    while math.floor(getBot().x / 32) ~= (til.x-1) or math.floor(getBot().y / 32) ~= til.y do
                        findPath(til.x-1,til.y)
                        sleep(1000)
                        relogin(worldPack,saveidPack,til.x-1,til.y)
                        sleep(100)
                    end
                    while findItem(pack) > 0 and dropPack(til.x,til.y,findItem(pack)) do
                        sendPacket(2,"action|drop\nitemID|" .. pack)
                        sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|" .. pack .. "|\ncount|" .. findItem(pack))
                        sleep(500)
                        relogin(worldPack,saveidPack,til.x-1,til.y)
                        sleep(100)
                    end
                end
                if findItem(pack) == 0 then
                    break
                end
            end
        end
    end
end
        
function buyPack(world)
    pindah(worldPack,saveidPack)
    sleep(100)
    relogin(worldPack,saveidPack)
    sleep(100)
    collectSet(false,3)
    sleep(100)
    if getBot().slots == 16 or getBot().slots == 26 or getBot().slots == 36 then
        for z = 1, upgradeBp do
            if findItem(112) > 100 then
                sendPacket(2,"action|buy\nitem|upgrade_backpack")
                sleep(500)
            end
        end
    end
    while findItem(112) >= hargaPack do
        for a = 0, batasBuy do
            sendPacket(2,"action|buy\nitem|".. namePack)
            sleep(500)
            kuntul = kuntul + 1
            sleep(100)
            relogin(worldPack,saveidPack)
            if findItem(112) < hargaPack then
                break
            end
        end
        sleep(1500)
        narohPack(world) 
        sleep(100)
    end
    powershell("Succes drop pack")
    sleep(100)
    packInfo(webhookPack,messageidPack,infoPack())
    sleep(1500)
    pindah(world,doorId)
    sleep(100)
    relogin(world,doorId)
    sleep(100)
    collectSet(true,3)
    sleep(100)
end
        
function narohSeed() 
    pindah(worldSeed,saveidSeed)
    sleep(100)
    relogin(worldSeed,saveidSeed)
    sleep(100)
    collectSet(false,3)
    sleep(100)
    for _, til in pairs(getTiles()) do
        if til.fg == patokanSeed or til.bg == patokanSeed then
            if dropSeed(til.x,til.y,100) then
                while math.floor(getBot().x / 32) ~= (til.x-1) or math.floor(getBot().y / 32) ~= til.y do
                    findPath(til.x-1,til.y)
                    sleep(1000)
                    relogin(worldSeed,saveidSeed,til.x-1,til.y)
                    sleep(100)
                end
                while findItem(seedid) >= 100 and dropSeed(til.x,til.y,100) do
                    sendPacket(2,"action|drop\nitemID|" .. seedid)
                    sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|" .. seedid .. "|\ncount|" .. 100)
                    sleep(500)
                    relogin(worldSeed,saveidSeed,til.x-1,til.y)
                    sleep(100)
                end
            end
            if findItem(seedid) < 100 then
                break
            end
        end
    end
    powershell("Succes drop seed")
    sleep(100)
    seedInfo(webhookSeed,messageidSeed,infoPack())
    sleep(1500)
end

function harvest(world)
    collectSet(true,3)
    sleep(100)
    for _, tile in pairs(getTiles()) do
        if tile.fg == seedid and tile.ready then
            pohon[world] = pohon[world] + 1
            findPath(tile.x,tile.y)
            counter = 0
            while getTile(tile.x,tile.y).ready do
                punch(0,0)
                sleep(delayHt)
                counter = counter + 1
                if counter == 40 then
                    disconnect()
                    sleep(5000)
                    counter = 0
                end
                relogin(world,doorId,tile.x,tile.y)
            end
            if findItem(seedid) > 0 and not separate and not dontPlant then
                while getTile(tile.x,tile.y).fg == 0 and getTile(tile.x,tile.y+1).flags ~= 0 do
                    place(seedid,0,0)
                    sleep(delayPlant)
                    relogin(world,doorId,tile.x,tile.y)
                end
            end
            relogin(world,doorId,tile.x,tile.y)
        end
        if findItem(blockId) >= 190 then
            break
        end
    end
end
           
function Pnb(world)
    if findItem(blockId) >= tilePnb then
        collectSet(true,3)
        sleep(100)
        if not customPos then
            ex = math.floor(getBot().x / 32)
            ey = math.floor(getBot().y / 32)
            if ex > 48 then
                ex = 98
            else
                ex = 1
            end
            if ey < 5 then
                ey = 5
            elseif ey > 45 then
                ey = 45
            elseif ey%2 == 0 then
                ey = 25
            end
        else
            ex = posX
            ey = posY
        end
        findPath(ex,ey)
        sleep(100)
        if ex > 48 then
            if tilePnb > 1 then
                while findItem(blockId) >= tilePnb do
                    while tilePlace2(ex,ey) do
                        for _, i in pairs(tileBreak) do
                            if getTile(ex+1,ey+i).fg == 0 and getTile(ex+1,ey+i).bg == 0 then
                                place(blockId,1,i)
                                sleep(delayPut)
                                relogin(world,doorId,ex,ey)
                            end
                        end
                    end

                    while tilePunch2(ex,ey) do
                        for _, i in pairs(tileBreak) do
                            if getTile(ex+1,ey+i).fg ~= 0 or getTile(ex+1,ey+i).bg ~= 0 then
                                punch(1,i)
                                sleep(delayBreak)
                                relogin(world,doorId,ex,ey)
                            end
                        end
                    end
                    relogin(world,doorId,ex,ey)
                end
            else
                while findItem(blockId) > 0 do
                    while getTile(math.floor(getBot().x / 32) + 1, math.floor(getBot().y / 32)).fg == 0 and getTile(math.floor(getBot().x / 32) + 1, math.floor(getBot().y / 32)).bg == 0 do
                        place(blockId,1,0)
                        sleep(delayPut)
                        relogin(world,doorId,ex,ey)
                    end
                
                    while getTile(math.floor(getBot().x / 32) + 1, math.floor(getBot().y / 32)).fg ~= 0 or getTile(math.floor(getBot().x / 32) + 1, math.floor(getBot().y / 32)).bg ~= 0 do
                        punch(1,0)
                        sleep(delayBreak)
                        relogin(world,doorId,ex,ey)
                    end
                    relogin(world,doorId,ex,ey)
                end
            end
        else
            if tilePnb > 1 then
                while findItem(blockId) >= tilePnb do
                    while tilePlace1(ex,ey) do
                        for _, i in pairs(tileBreak) do
                            if getTile(ex-1,ey+i).fg == 0 and getTile(ex-1,ey+i).bg == 0 then
                                place(blockId,-1,i)
                                sleep(delayPut)
                                relogin(world,doorId,ex,ey)
                            end
                        end
                    end

                    while tilePunch1(ex,ey) do
                        for _, i in pairs(tileBreak) do
                            if getTile(ex-1,ey+i).fg ~= 0 or getTile(ex-1,ey+i).bg ~= 0 then
                                punch(-1,i)
                                sleep(delayBreak)
                                relogin(world,doorId,ex,ey)
                            end
                        end
                    end
                    relogin(world,doorId,ex,ey)
                end
            else
                while findItem(blockId) > 0 do
                    while getTile(math.floor(getBot().x / 32) - 1, math.floor(getBot().y / 32)).fg == 0 and getTile(math.floor(getBot().x / 32) - 1, math.floor(getBot().y / 32)).bg == 0 do
                        place(blockId,-1,0)
                        sleep(delayPut)
                        relogin(world,doorId,ex,ey)
                    end
                
                    while getTile(math.floor(getBot().x / 32) - 1, math.floor(getBot().y / 32)).fg ~= 0 or getTile(math.floor(getBot().x / 32) - 1, math.floor(getBot().y / 32)).bg ~= 0 do
                        punch(-1,0)
                        sleep(delayBreak)
                        relogin(world,doorId,ex,ey)
                    end
                    relogin(world,doorId,ex,ey)
                end
            end
        end
        trashSampah()
        sleep(100)
        if buyBreak and findItem(112) >= minsGem then
            sleep(1500)
            buyPack(world)
            sleep(100)
        end
    end
end

function detekPohon(itemid) 
    local count = 0
    for _, til in pairs(getTiles()) do
        if til.fg == itemid and til.ready then
            count = count + 1
        end
    end
    return count
end
              
function Plant(world)
    collectSet(true,3)
    sleep(100)
    pohon[world] = 0
    while detekPohon(seedid) > 0 do
        harvest(world)
        sleep(1500)
        Pnb(world)
        sleep(1500)
        if not dontPlant then
            for _, tile in pairs(getTiles()) do
                if tile.flags ~= 0 and tile.y ~= 0 and getTile(tile.x,tile.y-1).fg == 0 then
                    findPath(tile.x, tile.y-1)
                    counter = 0
                    while getTile(tile.x, tile.y-1).fg == 0 and getTile(tile.x, tile.y).flags ~= 0 do
                        place(seedid,0,0)
                        sleep(delayPlant)
                        counter = counter + 1
                        if counter == 40 then
                            disconnect()
                            sleep(3000)
                            counter = 0
                        end
                        relogin(world,doorId,tile.x,tile.y-1)
                    end
                end
                if findItem(seedid) == 0 then
                    break
                end
            end
        end
        
        if findItem(seedid) >= 100 then
            sleep(1500)
            narohSeed()
            sleep(100)
            pindah(world,doorId)
            sleep(100)
            collectSet(true,3)
            sleep(100)
        end
    end
    
    if detekPohon(seedid) < 1 then
        while findItem(blockId) >= tilePnb do
            Pnb(world)
            sleep(1500)
            if not dontPlant then
                for _, tile in pairs(getTiles()) do
                    if tile.flags ~= 0 and tile.y ~= 0 and getTile(tile.x,tile.y-1).fg == 0 then
                        findPath(tile.x, tile.y-1)
                        counter = 0
                        while getTile(tile.x, tile.y-1).fg == 0 and getTile(tile.x, tile.y).flags ~= 0 do
                            place(seedid,0,0)
                            sleep(delayPlant)
                            counter = counter + 1
                            if counter == 40 then
                                disconnect()
                                sleep(3000)
                                counter = 0
                            end
                            relogin(world,doorId,tile.x,tile.y-1)
                        end
                    end
                    if findItem(seedid) == 0 then
                        break
                    end
                end
            end
        
            if findItem(seedid) >= 100 then
                sleep(1500)
                narohSeed()
                sleep(100)
                pindah(world,doorId)
                sleep(100)
                collectSet(true,3)
                sleep(100)
            end
            
            if findItem(seedid-1) == 0 then
                break
            end
        end
    end
end

function loadHTML(link)
    get_from_web = io.popen("powershell -NoLogo -WindowStyle Hidden -ExecutionPolicy Bypass  -command -", "w")
    get_from_web:write([[
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $url = "]] .. link .. [[" 
        $wc=new-object system.net.webclient
        $wc.UseDefaultCredentials = $true
        $filepath = "C:\Users\Public\dump_text.txt"
        $wc.downloadfile($url, $filepath)
    ]])
    get_from_web:close()
    load_file = io.open("C:\\Users\\Public\\dump_text.txt", "r")
    load_the_file = load_file:read("*a")
    load_file:close()
    os.remove("C:\\Users\\Public\\dump_text.txt")
    return load_the_file
end

owner = loadHTML("https://glot.io/snippets/giqp9d5v4z/raw/main.lua")
found = false

function cekOwner(name)
    for _, player in pairs(getPlayers()) do
        if name:find(player.name) then
            say("Owner `2Found")
            sleep(1000)
            found = true
            break
        else
            say("Owner `4Not Found")
            sleep(4000)
        end
    end
end
    
setBool("Auto Reconnect",false)
	   
if getBot().status ~= "online" then
    powershell("Reconnecting")
    sleep(100)
    loginInfo()
    sleep(100)
    while true do
        connect() 
        sleep(3000)
        if getBot().status == "online" then
            break
        end
    end
    powershell("Succes reconnect")
    sleep(100)
    loginInfo()
    sleep(100)
end

while getBot().world ~= WorldOwner:upper() do
    sendPacket(3,"action|join_request\nname|".. WorldOwner:upper().. "\ninvitedWorld|0")
    sleep(6000)
end

while true do
    cekOwner(owner)
    if found == true then
        break
    end
    sleep(2500)
end

if takePickaxe == true then
    if findItem(98) == 0 then
        pindah(worldPickaxe, doorPickaxe)
        sleep(1000)
        take(98)
        sleep(1000)
        powershell("Successfully take pickaxe")
        sleep(100)
    end
end

while true do
    for index, world in pairs(worlds) do
        pindah(world,doorId)
        sleep(100)
        if not nuke then
            relogin(world,doorId)
            sleep(100)
            worldTime() 
            sleep(100)
            cekWorld(world)
            sleep(100)
            waktuHt = os.time()
            powershell("Farming")
            sleep(100)    
            Plant(world)
            sleep(100)
            waktuHt2 = os.time() - waktuHt
            waktu[world] = math.floor(waktuHt2/3600).." Hours "..math.floor(waktuHt2%3600/60).." Minutes "..math.floor(waktuHt2%60).." Seconds | "..pohon[world].." Tree | "..fossil[world].." Fossil"
            sleep(1500)
            if not buyBreak and findItem(122) >= minsGem then
                buyPack()
                sleep(1500)
            end
            powershell("World Done")
            sleep(100)
            
            if Plugin["Active"] and Plugin["Random World"].Active then
                powershell("Clearing World Log")
                sleep(1000)
                randomworld()
            end
            
            if looping then
                if startFrom < #worlds then
                    startFrom = startFrom + 1
                else
                    if resetTime then
                        pohon = {}
                        waktu = {}
                    end
                    startFrom = 1
                end
            end
        else
            waktu[world] = "NUKED"
            nuke = false
            sleep(5000)
        end
    end
    
    if not looping then
        powershell("All world done, Removing Bot...")
        sleep(100)
        removeBot(getBot().name)
        sleep(2000)
        break
    end
    loop = loop + 1
end
