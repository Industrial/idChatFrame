local _G = _G
local TL, TC, TR = 'TOPLEFT', 'TOP', 'TOPRIGHT'
local ML, MC, MR = 'LEFT', 'CENTER', 'RIGHT'
local BL, BC, BR = 'BOTTOMLEFT', 'BOTTOM', 'BOTTOMRIGHT'

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
end

function addon:OnEnable()
end

function addon:OnDisable()
end


function on_event(frame, event, message, sender, language, channel_id, target, flags, unknown, channel_number, channel_name, unknown1, counter)
   local output = message
   add_message(output)
end

chat_frame = CreateFrame('ScrollingMessageFrame', 'idChatFrame', UIParent)
chat_frame.backdrop_texture = chat_frame:CreateTexture(nil, 'BACKGROUND')
chat_frame.backdrop_texture:SetAllPoints(chat_frame)
chat_frame.backdrop_texture:SetTexture(0, 0, 0, 0.5)

chat_frame:SetPoint(TL, UIParent, TL, 5, -5)
chat_frame:SetWidth(400)
chat_frame:SetHeight(400)

chat_frame:SetFont('Fonts\\ARIALN.TTF', 12)
chat_frame:SetJustifyH('LEFT')
chat_frame:SetFading(false)
chat_frame:SetMaxLines(chat_history_limit)

chat_frame:EnableMouseWheel(true)
chat_frame:SetScript('OnMouseWheel', scroll_chat)

chat_frame:SetScript('OnEvent', on_event)
chat_frame:RegisterEvent('CHAT_MSG_ACHIEVEMENT')
chat_frame:RegisterEvent('CHAT_MSG_SAY')

redisplay_all_messages()
