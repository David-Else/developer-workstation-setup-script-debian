-- ~/.config/mpv/scripts/disable-nightlight-gnome.lua
-- GNOME version of night light control using gsettings
-- Disables Night Light on video start if enabled, restores on pause/end

local utils = require 'mp.utils'

-- Global variables to store state
local night_light_was_enabled = false
local was_paused = false

-- Execute shell command and return trimmed output
local function exec(cmd)
    local res = utils.subprocess({
        args = cmd,
        playback_only = false
    })
    if res.status == 0 then
        return res.stdout:match("^%s*(.-)%s*$")  -- trim whitespace
    else
        mp.msg.warn("Command failed: " .. table.concat(cmd, " "))
        return nil
    end
end

-- Check if GNOME Night Light is currently enabled
local function is_night_light_enabled()
    local output = exec({"gsettings", "get", "org.gnome.settings-daemon.plugins.color", "night-light-enabled"})
    return output == "true"
end

-- Set Night Light state: true/false
local function set_night_light(enabled)
    local value = enabled and "true" or "false"
    exec({"gsettings", "set", "org.gnome.settings-daemon.plugins.color", "night-light-enabled", value})
end

-- Toggle Night Light (optional, but we'll use direct set for clarity)
local function toggle_night_light()
    set_night_light(not is_night_light_enabled())
end

-- Check if current file is audio-only
local function is_audio_file()
    local track_list = mp.get_property_native("track-list")
    for _, track in ipairs(track_list) do
        if track.type == "video" and not track.albumart and (track["demux-fps"] or 2) > 1 then
            return false  -- It's a real video
        end
    end
    return true  -- No video track found → treat as audio
end

-- On file load: disable night light if needed
local function handle_night_light_on_start()
    if is_audio_file() then
        mp.osd_message("🎵 Audio file detected; Night Light unchanged")
        return
    end

    if is_night_light_enabled() then
        night_light_was_enabled = true
        set_night_light(false)
        mp.osd_message("🌙 Night Light disabled for video playback")
    else
        night_light_was_enabled = false
        mp.msg.info("Night Light already off")
    end
end

-- Restore Night Light if it was originally on
local function restore_night_light()
    if night_light_was_enabled and not is_night_light_enabled() then
        set_night_light(true)
        mp.osd_message("🌙 Night Light restored")
    end
end

-- Handle pause/resume
local function handle_pause_change(_, paused)
    if paused then
        was_paused = true
        restore_night_light()
    elseif not paused and not is_audio_file() then
        if was_paused and night_light_was_enabled then
            set_night_light(false)
            mp.osd_message("🌙 Night Light disabled on video resume")
            was_paused = false
        end
    end
end

-- Register events
mp.register_event("file-loaded", handle_night_light_on_start)
mp.observe_property("pause", "bool", handle_pause_change)
mp.register_event("end-file", restore_night_light)
mp.register_event("close-window", restore_night_light)
mp.register_event("shutdown", restore_night_light)  -- Ensure restore on MPV quit
