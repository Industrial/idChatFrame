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
   message = ('%s %s'):format(date('%X'), message)

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

  self:RegisterEvent('CHAT_MSG_ACHIEVEMENT', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_SAY', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_ACHIEVEMENT', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_ADDON', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_AFK', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_BATTLEGROUND', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_BATTLEGROUND_LEADER', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_BG_SYSTEM_ALLIANCE', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_BG_SYSTEM_HORDE', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_BG_SYSTEM_NEUTRAL', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_BN_CONVERSATION', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_BN_CONVERSATION_LIST', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_BN_CONVERSATION_NOTICE', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_BN_INLINE_TOAST_ALERT', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_BN_INLINE_TOAST_BROADCAST', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_BN_INLINE_TOAST_BROADCAST_INFORM', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_BN_INLINE_TOAST_CONVERSATION', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_BN_WHISPER', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_BN_WHISPER_INFORM', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_CHANNEL', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_CHANNEL_JOIN', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_CHANNEL_LEAVE', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_CHANNEL_LIST', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_CHANNEL_NOTICE', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_CHANNEL_NOTICE_USER', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_COMBAT_FACTION_CHANGE', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_COMBAT_GUILD_XP_GAIN', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_COMBAT_HONOR_GAIN', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_COMBAT_MISC_INFO', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_COMBAT_XP_GAIN', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_DND', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_EMOTE', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_FILTERED', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_GUILD', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_GUILD_ACHIEVEMENT', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_IGNORED', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_LOOT', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_MONEY', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_MONSTER_EMOTE', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_MONSTER_PARTY', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_MONSTER_SAY', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_MONSTER_WHISPER', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_MONSTER_YELL', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_OFFICER', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_OPENING', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_PARTY', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_PARTY_LEADER', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_PET_INFO', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_RAID', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_RAID_BOSS_EMOTE', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_RAID_BOSS_WHISPER', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_RAID_LEADER', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_RAID_WARNING', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_RESTRICTED', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_SAY', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_SKILL', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_SYSTEM', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_TARGETICONS', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_TEXT_EMOTE', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_TRADESKILLS', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_WHISPER', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_WHISPER_INFORM', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_YELL', 'HandleMessage')
end

function addon:OnEnable()
  self.frame.background_texture:SetAllPoints(self.frame)
  self.frame.background_texture:SetTexture(0, 0, 0, 0.5)

  self.frame:SetPoint(TL, UIParent, TL, 5, -5)
  self.frame:SetWidth(400)
  self.frame:SetHeight(400)

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
  self:addMessage(message)
end

