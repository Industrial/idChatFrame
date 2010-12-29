local _G = _G
local TL, TC, TR = 'TOPLEFT', 'TOP', 'TOPRIGHT'
local ML, MC, MR = 'LEFT', 'CENTER', 'RIGHT'
local BL, BC, BR = 'BOTTOMLEFT', 'BOTTOM', 'BOTTOMRIGHT'

local MAX_LINES = 500

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

  self:RegisterEvent('CHAT_MSG_ACHIEVEMENT', 'handleUnknownMessage')
  --self:RegisterEvent('CHAT_MSG_ADDON')
  self:RegisterEvent('CHAT_MSG_AFK', 'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_BATTLEGROUND', 'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_BATTLEGROUND_LEADER',              'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_BG_SYSTEM_ALLIANCE',               'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_BG_SYSTEM_HORDE',                  'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_BG_SYSTEM_NEUTRAL',                'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_BN_CONVERSATION',                  'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_BN_CONVERSATION_LIST',             'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_BN_CONVERSATION_NOTICE',           'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_BN_INLINE_TOAST_ALERT',            'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_BN_INLINE_TOAST_BROADCAST',        'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_BN_INLINE_TOAST_BROADCAST_INFORM', 'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_BN_INLINE_TOAST_CONVERSATION',     'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_BN_WHISPER',                       'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_BN_WHISPER_INFORM',                'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_CHANNEL',                          'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_CHANNEL_JOIN',                     'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_CHANNEL_LEAVE',                    'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_CHANNEL_LIST',                     'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_CHANNEL_NOTICE',                   'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_CHANNEL_NOTICE_USER',              'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_COMBAT_FACTION_CHANGE',            'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_COMBAT_GUILD_XP_GAIN',             'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_COMBAT_HONOR_GAIN',                'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_COMBAT_MISC_INFO',                 'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_COMBAT_XP_GAIN')
  self:RegisterEvent('CHAT_MSG_DND',                              'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_EMOTE',                            'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_FILTERED',                         'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_GUILD')
  self:RegisterEvent('CHAT_MSG_GUILD_ACHIEVEMENT',                'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_IGNORED',                          'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_LOOT',                             'handleInformationalMessage')
  self:RegisterEvent('CHAT_MSG_MONEY')
  self:RegisterEvent('CHAT_MSG_MONSTER_EMOTE',                    'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_MONSTER_PARTY',                    'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_MONSTER_SAY',                      'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_MONSTER_WHISPER',                  'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_MONSTER_YELL',                     'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_OFFICER',                          'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_OPENING',                          'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_PARTY',                            'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_PARTY_LEADER',                     'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_PET_INFO',                         'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_RAID',                             'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_RAID_BOSS_EMOTE',                  'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_RAID_BOSS_WHISPER',                'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_RAID_LEADER',                      'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_RAID_WARNING',                     'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_RESTRICTED',                       'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_SAY') --
  self:RegisterEvent('CHAT_MSG_SKILL',                            'handleInformationalMessage')
  self:RegisterEvent('CHAT_MSG_SYSTEM',                           'handleInformationalMessage')
  self:RegisterEvent('CHAT_MSG_TARGETICONS',                      'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_TEXT_EMOTE',                       'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_TRADESKILLS',                      'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_WHISPER',                          'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_WHISPER_INFORM',                   'handleUnknownMessage')
  self:RegisterEvent('CHAT_MSG_YELL') --
end

function addon:OnEnable()
  self.frame.background_texture:SetAllPoints(self.frame)
  self.frame.background_texture:SetTexture(0, 0, 0, 0.5)

  self.frame:SetPoint(TL, UIParent, TL, 5, -5)
  self.frame:SetWidth(400)
  self.frame:SetHeight(200)

  self.frame:SetFont('Fonts\\ARIALN.TTF', 12)
  self.frame:SetJustifyH('LEFT')
  self.frame:SetFading(false)
  self.frame:SetMaxLines(MAX_LINES)

  self.frame:EnableMouseWheel(true)
  self.frame:SetScript('OnMouseWheel', self.scrollChat)

  self:redisplayAllMessages()
end

function addon:OnDisable()
end

function addon:HandleMessage(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
  print(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)

  local output = ''

  if event == 'CHAT_MSG_ACHIEVEMENT' then
    output = message
  else
  end

  output = self:prependTimestamp(output)

  self:addMessage(output)
end

function addon:handleInformationalMessage(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
  self:addMessage(self:prependTimestamp(message))
end

function addon:handleUnknownMessage(event, ...)
  print(event, ...)
end

function addon:CHAT_MSG_SAY(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
  self:addMessage(self:prependTimestamp(('s %s: %s'):format(sender, message)))
end

function addon:CHAT_MSG_YELL(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
  self:addMessage(self:prependTimestamp(('y %s: %s'):format(sender, message)))
end

function addon:CHAT_MSG_GUILD(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
  self:addMessage(self:prependTimestamp(('g %s: %s'):format(sender, message)))
end

function addon:CHAT_MSG_COMBAT_XP_GAIN(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
  local xp = tonumber(message:match('(%d+) experience.'))
  local rested = tonumber(message:match('+(%d+) exp') or 0)

  local output = ('+%sxp'):format(xp + rested)

  self:addMessage(self:prependTimestamp(output))
end

function addon:CHAT_MSG_MONEY(event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
  local gold   = tonumber(message:match('(%d+) Gold') or 0)
  local silver = tonumber(message:match('(%d+) Silver') or 0)
  local copper = tonumber(message:match('(%d+) Copper') or 0)

  local guild_gold   = tonumber(message:match('(%d+) Gold.+bank%)$') or 0)
  local guild_silver = tonumber(message:match('(%d+) Silver.+bank%)$') or 0)
  local guild_copper = tonumber(message:match('(%d+) Copper.+bank%)$') or 0)

  -- TODO: reimplement nicer?

  local output = '+'
  if gold > 0 then
    output = output .. gold .. 'g'
  end
  if silver > 0 then
    output = output .. silver .. 's'
  end
  if copper > 0 then
    output = output .. copper .. 'c'
  end

  if guild_gold > 0 or guild_silver > 0 or guild_copper > 0 then
    output = output .. ' ('
    if guild_gold > 0 then
      output = output .. guild_gold .. 'g'
    end
    if guild_silver > 0 then
      output = output .. guild_silver .. 's'
    end
    if guild_copper > 0 then
      output = output .. guild_copper .. 'c'
    end
    output = output .. ')'
  end

  self:addMessage(self:prependTimestamp(output))
end

