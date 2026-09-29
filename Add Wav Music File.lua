--By March 7th, And ask deepseek for help
local MP3_URL    = "https://s78-ious.freeconvert.com/task/6abb647e68d781fb6b1104fb/M5000044TOLQ2N8Klc.wav"   --Remember, put the URL of the wav file here.You can replace the URL with the URL of your personal wav file.(记住,这里填入wav文件的URL.URL可以替换成你个人wav文件的URL)
local TMP_NAME   = "ce_tmp_audio.wav"
local TABLE_NAME = "music.wav"
local function getTempDir()
    local d = os.getenv("TEMP") or os.getenv("TMP")
    if not d or d == "" then d = getTempFolder() end
    if not d or d == "" then d = "." end
    return d
end
local function downloadToFile(url, path)
    local int = getInternet()
    if not int then return false, "Failed to access the network!" end
    local ok, data = pcall(function() return int.getURL(url) end)
    int.destroy()
    if not ok or not data or #data == 0 then
        return false, "Download failed !"
    end
    local f = io.open(path, "wb")
    if not f then return false, "Unable to write to file: " .. path end
    f:write(data)
    f:close()
    return true, #data
end
local function removeFile(path)
    pcall(function() deleteFile(path) end)
    pcall(function() os.remove(path) end)
end
-- 1. Download this file to a TMP folder(下载到临时文件夹)
local path = getTempDir() .. "\\" .. TMP_NAME
local ok, info = downloadToFile(MP3_URL, path)
if not ok then
    print("Download failed: " .. tostring(info))
    return
end
-- 2. Load the wav file to Cheat Table (加载wav文件到CT表单中)
local old = findTableFile(TABLE_NAME)
if old ~= nil then old.delete() end
local embedOk, tf = pcall(function()
    return createTableFile(TABLE_NAME, path)
end)
if not embedOk or tf == nil then
    print("Load failed: " .. tostring(tf))
    removeFile(path)
    return
end
-- 3. Delete this wav file from the TMP folder(删本地文件)
removeFile(path)
-- 4. Play music(播放音乐)
playSound(findTableFile(TABLE_NAME))