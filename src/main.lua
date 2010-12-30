-- TODO: explore this idea later:   foxlit: think that's the right way to go?
-- say I have 20 FontStrings and I make them show 20 lines in a table at a
-- time, and just shove the content up and down.. could make every line
-- clickable etc

local _G = _G
local TL, TC, TR = 'TOPLEFT', 'TOP', 'TOPRIGHT'
local ML, MC, MR = 'LEFT', 'CENTER', 'RIGHT'
local BL, BC, BR = 'BOTTOMLEFT', 'BOTTOM', 'BOTTOMRIGHT'

local MAX_LINES = 500
local COLOR_GOLD = 'ffff00'
local COLOR_SILVER = 'aaaaaa'
local COLOR_COPPER = '993300'

local addon = LibStub('AceAddon-3.0'):NewAddon('idChatFrame', 'AceEvent-3.0')

function addon.scrollChat(frame, delta)
  if delta > 0 then
    if IsShiftKeyDown() then
      frame:ScrollToTop()
    else
      frame:ScrollUp()
    end
  elseif delta < 0 then
    if IsShiftKeyDown() then
      frame:ScrollToBottom()
    else
      frame:ScrollDown()
    end
  end
end

function addon:addMessage(message)
  table.insert(self.history, message)

  if #self.history >= MAX_LINES then
    table.remove(self.history, 1)
  end

  self:displayMessage(message)
end

function addon:displayMessage(message)
  self.frame:AddMessage(message)
end

function addon:redisplayAllMessages()
  for i,v in ipairs(self.history) do
    self:displayMessage(v)
  end
end

function addon:prependTimestamp(message)
  return ('%s | %s'):format(date('%X'), tostring(message))
end

function addon:OnInitialize()
  local defaults = {
    profile = {
      history = {}
    }
  }

  self.db = LibStub('AceDB-3.0'):New('idChatFrameDB', defaults, true)

  self.history = self.db.profile.history

  self.frame = CreateFrame('ScrollingMessageFrame', 'idChatFrame', UIParent)
  self.frame.background_texture = self.frame:CreateTexture(nil, 'BACKGROUND')

  local function nothing(...)
  end

  local function debug_message(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
    local output = ('event="%s", message="%s", sender="%s", language="%s", channel_id="%s", target="%s", flags="%s", unknown="%s", channel_number="%s", channel_name="%s", unknown1="%s", counter="%s"'):format(
      tostring(event),
      tostring(message),
      tostring(sender),
      tostring(language),
      tostring(channel_id),
      tostring(target),
      tostring(flags),
      tostring(unknown),
      tostring(channel_number),
      tostring(channel_name),
      tostring(unknown1),
      tostring(counter)
    )
    ChatFrame3:AddMessage(output)
  end

  self:RegisterEvent('CHAT_MSG_ACHIEVEMENT', debug_message)

  self:RegisterEvent('CHAT_MSG_AFK', debug_message)

  self:RegisterEvent('CHAT_MSG_BATTLEGROUND', function(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
    self:addMessage(self:prependTimestamp(('b %s: %s'):format(sender, message)))
  end)

  self:RegisterEvent('CHAT_MSG_BATTLEGROUND_LEADER', function(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
    self:addMessage(self:prependTimestamp(('B %s: %s'):format(sender, message)))
  end)

  self:RegisterEvent('CHAT_MSG_BG_SYSTEM_ALLIANCE', 'handleInformationalMessage')

  self:RegisterEvent('CHAT_MSG_BG_SYSTEM_HORDE', 'handleInformationalMessage')

  self:RegisterEvent('CHAT_MSG_BG_SYSTEM_NEUTRAL', 'handleInformationalMessage')

  self:RegisterEvent('CHAT_MSG_BN_CONVERSATION', debug_message)

  self:RegisterEvent('CHAT_MSG_BN_CONVERSATION_LIST', debug_message)

  self:RegisterEvent('CHAT_MSG_BN_CONVERSATION_NOTICE', debug_message)

  self:RegisterEvent('CHAT_MSG_BN_INLINE_TOAST_ALERT', debug_message)

  self:RegisterEvent('CHAT_MSG_BN_INLINE_TOAST_BROADCAST', debug_message)

  self:RegisterEvent('CHAT_MSG_BN_INLINE_TOAST_BROADCAST_INFORM', debug_message)

  self:RegisterEvent('CHAT_MSG_BN_INLINE_TOAST_CONVERSATION', debug_message)

  self:RegisterEvent('CHAT_MSG_BN_WHISPER', debug_message)

  self:RegisterEvent('CHAT_MSG_BN_WHISPER_INFORM', debug_message)

  self:RegisterEvent('CHAT_MSG_CHANNEL', function(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
    -- for now do nothing, I hate channels.
    --self:addMessage(self:prependTimestamp(('%s %s: %s'):format(channel_number, sender, message)))
  end)

  self:RegisterEvent('CHAT_MSG_CHANNEL_JOIN', 'handleInformationalMessage')

  self:RegisterEvent('CHAT_MSG_CHANNEL_LEAVE', 'handleInformationalMessage')

  self:RegisterEvent('CHAT_MSG_CHANNEL_LIST', 'handleInformationalMessage')

  self:RegisterEvent('CHAT_MSG_CHANNEL_NOTICE', 'handleInformationalMessage')

  self:RegisterEvent('CHAT_MSG_CHANNEL_NOTICE_USER', 'handleInformationalMessage')

  self:RegisterEvent('CHAT_MSG_COMBAT_FACTION_CHANGE', function(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
    local faction, amount = message:match('^Reputation with (.+) increased by (%d+).$')

    local output = ('+%s %s rep'):format(amount, faction)

    self:addMessage(self:prependTimestamp(output))
  end)

  self:RegisterEvent('CHAT_MSG_COMBAT_GUILD_XP_GAIN', function(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
    local xp = message:match('^You gain (%d+) guild experience.$')

    local output = ('+%sxp'):format(xp)

    self:addMessage(self:prependTimestamp(output))
  end)

  self:RegisterEvent('CHAT_MSG_COMBAT_HONOR_GAIN', debug_message)

  self:RegisterEvent('CHAT_MSG_COMBAT_MISC_INFO', 'handleInformationalMessage')

  self:RegisterEvent('CHAT_MSG_COMBAT_XP_GAIN', function(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
    local xp = tonumber(message:match('(%d+) experience.'))
    local rested = tonumber(message:match('+(%d+) exp') or 0)

    local output = ('+%sxp'):format(xp + rested)

    self:addMessage(self:prependTimestamp(output))
  end)

  self:RegisterEvent('CHAT_MSG_DND', debug_message)

  self:RegisterEvent('CHAT_MSG_EMOTE', debug_message)

  self:RegisterEvent('CHAT_MSG_FILTERED', debug_message)

  self:RegisterEvent('CHAT_MSG_GUILD', function(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
    self:addMessage(self:prependTimestamp(('g %s: %s'):format(sender, message)))
  end)

  self:RegisterEvent('CHAT_MSG_GUILD_ACHIEVEMENT', function(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
    local achievement = message:match('the achievement (.+)!$')
    self:addMessage(self:prependTimestamp(('%s %s'):format(sender, achievement)))
  end)

  self:RegisterEvent('CHAT_MSG_IGNORED', debug_message)

  self:RegisterEvent('CHAT_MSG_LOOT', 'handleInformationalMessage')

  self:RegisterEvent('CHAT_MSG_MONEY', function(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
    local gold   = tonumber(message:match('(%d+) Gold') or 0)
    local silver = tonumber(message:match('(%d+) Silver') or 0)
    local copper = tonumber(message:match('(%d+) Copper') or 0)

    local guild_gold   = tonumber(message:match('(%d+) Gold.+bank%)$') or 0)
    local guild_silver = tonumber(message:match('(%d+) Silver.+bank%)$') or 0)
    local guild_copper = tonumber(message:match('(%d+) Copper.+bank%)$') or 0)

    -- TODO: reimplement nicer?

    local output = '+'
    if gold > 0 then
      output = ('%s%s|cff%sg|r'):format(output, gold, COLOR_GOLD)
    end
    if silver > 0 then
      output = ('%s%s|cff%ss|r'):format(output, silver, COLOR_SILVER)
    end
    if copper > 0 then
      output = ('%s%s|cff%sc|r'):format(output, copper, COLOR_COPPER)
    end

    if guild_gold > 0 or guild_silver > 0 or guild_copper > 0 then
      output = output .. ' ('
      if guild_gold > 0 then
        output = ('%s%s|cff%sg|r'):format(output, guild_gold, COLOR_GOLD)
      end
      if guild_silver > 0 then
        output = ('%s%s|cff%ss|r'):format(output, guild_silver, COLOR_SILVER)
      end
      if guild_copper > 0 then
        output = ('%s%s|cff%sc|r'):format(output, guild_copper, COLOR_COPPER)
      end
      output = output .. ')'
    end

    self:addMessage(self:prependTimestamp(output))
  end)

  self:RegisterEvent('CHAT_MSG_MONSTER_EMOTE', debug_message)

  self:RegisterEvent('CHAT_MSG_MONSTER_PARTY', debug_message)

  self:RegisterEvent('CHAT_MSG_MONSTER_SAY', debug_message)

  self:RegisterEvent('CHAT_MSG_MONSTER_WHISPER', debug_message)

  self:RegisterEvent('CHAT_MSG_MONSTER_YELL', function(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
    self:addMessage(self:prependTimestamp(('y %s: %s'):format(sender, message)))
  end)

  self:RegisterEvent('CHAT_MSG_OFFICER', debug_message)

  self:RegisterEvent('CHAT_MSG_OPENING', nothing)

  self:RegisterEvent('CHAT_MSG_PARTY', debug_message)

  self:RegisterEvent('CHAT_MSG_PARTY_LEADER', debug_message)

  self:RegisterEvent('CHAT_MSG_PET_INFO', debug_message)

  self:RegisterEvent('CHAT_MSG_RAID', debug_message)

  self:RegisterEvent('CHAT_MSG_RAID_BOSS_EMOTE', debug_message)

  self:RegisterEvent('CHAT_MSG_RAID_BOSS_WHISPER', debug_message)

  self:RegisterEvent('CHAT_MSG_RAID_LEADER', debug_message)

  self:RegisterEvent('CHAT_MSG_RAID_WARNING', debug_message)

  self:RegisterEvent('CHAT_MSG_RESTRICTED', debug_message)

  self:RegisterEvent('CHAT_MSG_SAY', function(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
    self:addMessage(self:prependTimestamp(('s %s: %s'):format(sender, message)))
  end)

  self:RegisterEvent('CHAT_MSG_SKILL', 'handleInformationalMessage')

  self:RegisterEvent('CHAT_MSG_SYSTEM', 'handleInformationalMessage')

  self:RegisterEvent('CHAT_MSG_TARGETICONS', debug_message)

  self:RegisterEvent('CHAT_MSG_TEXT_EMOTE', debug_message)

  self:RegisterEvent('CHAT_MSG_TRADESKILLS', nothing)

  self:RegisterEvent('CHAT_MSG_WHISPER', debug_message)

  self:RegisterEvent('CHAT_MSG_WHISPER_INFORM', debug_message)

  self:RegisterEvent('CHAT_MSG_YELL', function(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
    self:addMessage(self:prependTimestamp(('y %s: %s'):format(sender, message)))
  end)

end

function addon:OnEnable()
  self.frame.background_texture:SetAllPoints(self.frame)
  self.frame.background_texture:SetTexture(0, 0, 0, 0.5)

  self.frame:SetPoint(TL, UIParent, TL, 5, -5)
  self.frame:SetWidth(400)
  self.frame:SetHeight(200)

  self.frame:SetFont('Fonts\\ARIALN.TTF', 14)
  self.frame:SetJustifyH('LEFT')
  self.frame:SetFading(false)
  self.frame:SetMaxLines(MAX_LINES)

  self.frame:EnableMouseWheel(true)
  self.frame:SetScript('OnMouseWheel', self.scrollChat)

  self:redisplayAllMessages()
end

function addon:OnDisable()
end

function addon:handleInformationalMessage(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
  self:addMessage(self:prependTimestamp(message))
end

function addon:handleUnknownMessage(event, ...)
  if DevTools_Dump then
    DevTools_Dump({event, ...})
  else
    print(event, ...)
  end
end

