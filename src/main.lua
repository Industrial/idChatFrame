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

   self:displayMessage(message)
end

function addon:displayMessage(message)
  chat_frame:AddMessage(message)
end

function addon:redisplayAllMessages()
  for i,v in ipairs(self.history) do
    self:displayMessage(v)
  end
end

function addon:OnInitialize()
  self.db = LibStub('AceDB-3.0'):New('idChatFrameDB')
  self.history = self.db.profile.history
  self.frame = CreateFrame('ScrollingMessageFrame', 'idChatFrame', UIParent)
  self.frame.background_texture = self.frame:CreateTexture(nil, 'BACKGROUND')
end

function addon:OnEnable()
  self.frame.background_texture:SetAllPoints(chat_frame)
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

  self:RegisterEvent('CHAT_MSG_ACHIEVEMENT', 'HandleMessage')
  self:RegisterEvent('CHAT_MSG_SAY', 'HandleMessage')

  self:redisplayAllMessages()
end

function addon:OnDisable()
end

function addon:HandleMessage(frame, event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
   local output = message
   add_message(output)
end

