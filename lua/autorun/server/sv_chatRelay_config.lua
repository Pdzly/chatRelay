ROOKI = ROOKI or {}
ROOKI.chatSync = ROOKI.chatSync or {}

ROOKI.chatSync.config = {
    webHookUrl = "https://discord.com/api/webhooks/1033994912452063302/m-kPqC4oiURViS5Lba5zydXokI6SmjfJl__J8NAC5GPkXxNd7-KHDIotNwWeAX5R95lq",
    ignorePrefixes = {
        "/",
        "!",
        "."
    },
    checkText = function(ply, txt)
        return true, false, "Errormessageiffalse" -- 1. Should Relay, 2. Should Hide msg, 3. Errormessageif not relayed
    end, -- If you want to check the text with your own logic ( True = "accepted", False = "ignore")
    ignoreTeamChat = true,
    embed = true,
    embedOptions = {
        color = 5763719 -- examples see https://gist.github.com/thomasbnt/b6f455e2c7d743b796917fa3c205f812
    }
}