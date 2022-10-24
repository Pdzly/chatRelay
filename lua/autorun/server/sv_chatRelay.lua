require("reqwest")
ROOKI = ROOKI or {}
ROOKI.chatSync = ROOKI.chatSync or {}
ROOKI.chatSync.config = ROOKI.chatSync.config or {}

local function checkForIgnorePrefix(txt)
    for _, v in ipairs(ROOKI.chatSync.config.ignorePrefixes) do
        if string.StartWith(txt, v) then return true end
    end

    return false
end

local function unPackTable(tbl, indices, curr_ix)
    if curr_ix == nil then return unpack_indices(tbl, indices, 1) end
    if curr_ix > #indices then return end
    --Recursive call

    return tbl[indices[curr_ix]], unPackTable(tbl, indices, curr_ix + 1)
end

local function createEmbed(ply, txt)
    return {
        embeds = {
            {
                fields = {
                    {
                        name = "--------------",
                        value = txt
                    }
                },
                author = {
                    name = ply:Nick(),
                    url = "http://steamcommunity.com/profiles/" .. ply:SteamID64()
                },
                color = ROOKI.chatSync.config.embedOptions.color
            },
        }
    }
end

hook.Add("PlayerSay", "ROOKI.chatSync.Chat", function(ply, txt, tc)
    local shouldBlock, shouldHide, msg = ROOKI.chatSync.config.checkText(ply, txt)

    if shouldBlock then
        ply:ChatPrint("[Chat Relay] " .. msg)

        if shouldHide then
            return ""
        else
            return
        end
    end

    if ROOKI.chatSync.config.ignoreTeamChat and tc or checkForIgnorePrefix(txt) then return end

    local res = {
        username = ply:Nick() .. "[ " .. ply:SteamID64() .. " ]",
        content = txt,
    }

    if ROOKI.chatSync.config.embed then
        res = createEmbed(ply, txt)
    end

    reqwest({
        method = "POST",
        url = ROOKI.chatSync.config.webHookUrl,
        timeout = 30,
        body = util.TableToJSON(res),
        type = "application/json",
        headers = {
            ["User-Agent"] = "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0",
        },
        success = function(code, body)
            if code > 204 then
                print("Error: " .. code)
                print(body)
            end
        end,
        failed = function(err, errtxt)
            print("Chat Relay Error: ")
            print(err, errtxt)
        end
    })
end)