-- Copyright (c) 2015 &yet <https://andyet.com>
-- https://github.com/otalk/mod_muc_allowners/blob/9a86266a25ed32ade150742cc79f5a1669765a8f/mod_muc_allowners.lua
--
-- Used under the terms of the MIT License
-- https://github.com/otalk/mod_muc_allowners/blob/9a86266a25ed32ade150742cc79f5a1669765a8f/LICENSE

local muc_service = module:depends("muc")
local room_mt = muc_service.room_mt

module:depends("c2s")
local sessions = module:shared("c2s/sessions")

local muc_util = module:require "muc/util"
local valid_affiliations = muc_util.valid_affiliations

local jid_bare = require "util.jid".bare

room_mt.get_affiliation = function(room, jid)
    local bare_jid = jid_bare(jid)
    local affiliation = "participant"

    -- TODO: don't allow earlier sessions to override affiliation claim from later ones
    for conn, session in ipairs(sessions) do
        if jid_bare(session.full_jid) == bare_jid then
            if valid_affiliations[session.jitsi_meet_room_affiliation] ~= nil then
                affiliation = session.jitsi_meet_room_affiliation
            end
        end
    end

    return affiliation
end
