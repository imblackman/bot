local function modadd(msg)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_admin(msg) then
        return 'شما مدیر ربات نیستید❗️🚷'
    end
    local data = load_data(_config.moderation.data)
  if data[tostring(msg.chat_id_)] then
   return '💎گروه قبلا به لیست پشتبان ربات اضافه شد بود🛡'
  end
        -- create data array in moderation.json
      data[tostring(msg.chat_id_)] = {
              owners = {},
      mods ={},
      banned ={},
      is_silent_users ={},
      settings = {
          lock_link = 'yes',
          lock_tag = 'yes',
          lock_spam = 'yes',
          lock_webpage = 'no',
          lock_markdown = 'no',
          flood = 'yes',
          lock_bots = 'yes'
          },
   mutes = {
                  mute_fwd = 'no',
                  mute_audio = 'no',
                  mute_video = 'no',
                  mute_contact = 'no',
                  mute_text = 'no',
                  mute_photos = 'no',
                  mute_gif = 'no',
                  mute_loc = 'no',
                  mute_doc = 'no',
                  mute_sticker = 'no',
                  mute_voice = 'no',
                   mute_all = 'no'
          }
      }
  save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.chat_id_)] = msg.chat_id_
      save_data(_config.moderation.data, data)
  return '💎گروه به لیست پشتبان ربات اضافه شد🛡'
end

local function modrem(msg)
    -- superuser and admins only (because sudo are always has privilege)
      if not is_admin(msg) then
        return 'شما مدیر ربات نیستید❗️🚷'
    end
    local data = load_data(_config.moderation.data)
    local receiver = msg.chat_id_
  if not data[tostring(msg.chat_id_)] then
    return 'این گروه در لیست پشتیبانی نیست❌📜'
  end

  data[tostring(msg.chat_id_)] = nil
  save_data(_config.moderation.data, data)
     local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end data[tostring(groups)][tostring(msg.chat_id_)] = nil
      save_data(_config.moderation.data, data)
  return 'گروه از لیست پشتبانی ربات حذف شد❌🗑'
end

local function modlist(msg)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.chat_id_)] then
    return "این گروه در لیست پشتیبانی نیست❌📜"
  end
  -- determine if table is empty
  if next(data[tostring(msg.chat_id_)]['mods']) == nil then --fix way
    return "در این گروه هیچ کسی مدیر ربات نیست👤🤖"
  end
  local message = '*List of moderators :*\n'
  for k,v in pairs(data[tostring(msg.chat_id_)]['mods']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function ownerlist(msg)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.chat_id_)] then
    return "این گروه در لیست پشتیبانی نیست❌📜"
  end
  -- determine if table is empty
  if next(data[tostring(msg.chat_id_)]['owners']) == nil then --fix way
    return "هیچ معاونی در این گروه نیست👤❗️"
  end
  local message = '*List of group owners :*\n'
  for k,v in pairs(data[tostring(msg.chat_id_)]['owners']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function action_by_reply(arg, data)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
if not tonumber(data.sender_user_id_) then return false end
  if not administration[tostring(data.chat_id_)] then
    return tdcli.sendMessage(data.chat_id_, "", 0, "این گروه در لیست پشتیبانی نیست❌📜", 0, "md")
  end
if cmd == "setowner" then
local function owner_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."این کاربر قبلا مدیر ربات شد است👤🤖", 0, "md")
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."کاربر مدیر ربات شد 👤🤖", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "promote" then
local function promote_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."این کاربر قبلا معاون شده است🤖👤", 0, "md")
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."کاربر معاون ربات شد✅🤖", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, promote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
     if cmd == "remowner" then
local function rem_owner_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."هیچ مدیری در این گروه برای ربات نیست❌🤖", 0, "md")
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."هیچ مدیری در این گروه برای ربات نیست❌🤖", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, rem_owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "demote" then
local function demote_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."هیچ معاونی در این گروه برای ربات نیست❌🤖", 0, "md")
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."تنزل مقام انجام شد✅📛", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, demote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "id" then
local function id_cb(arg, data)
    return tdcli.sendMessage(arg.chat_id, "", 0, "*"..data.id_.."*", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, id_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
end

local function action_by_username(arg, data)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
  if not administration[tostring(arg.chat_id)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "این گروه در لیست پشتیبانی نیست❌📜", 0, "md")
  end
if data.type_.user_.username_ and not data.type_.user_.username_:match("_") then
user_name = '@'..data.type_.user_.username_
else
user_name = data.title_
end
if not arg.username then return false end
if cmd == "setowner" then
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."این کاربر قبلا مدیر ربات شد است👤🤖", 0, "md")
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."کاربر مدیر ربات شد 👤🤖", 0, "md")
  end
  if cmd == "promote" then
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."این کاربر قبلا معاون شده است🤖👤", 0, "md")
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."کاربر معاون ربات شد✅🤖", 0, "md")
end
   if cmd == "remowner" then
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."در این گروه هیچ کسی مدیر ربات نیست👤🤖", 0, "md")
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."در این گروه هیچ کسی مدیر ربات نیست👤🤖", 0, "md")
end
   if cmd == "demote" then
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."هیچ معاونی در این گروه نیست👤❗️", 0, "md")
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."تنزل مقام انجام شد✅📛", 0, "md")
end
   if cmd == "id" then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*"..data.id_.."*", 0, "md")
end
    if cmd == "res" then
    local text = "Result for [ ".. data.type_.user_.username_ .." ] :\n"
    .. "".. data.title_ .."\n"
    .. " [".. data.id_ .."]"
       return tdcli.sendMessage(arg.chat_id, 0, 1, text, 1)
   end
end

local function action_by_id(arg, data)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
  if not administration[tostring(arg.chat_id)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "این گروه در لیست پشتیبانی نیست❌📜", 0, "md")
  end
if not tonumber(arg.user_id) then return false end
if data.first_name_ then
if data.username_ and not data.username_:match("_") then
user_name = '@'..data.username_
else
user_name = data.first_name_
end
if cmd == "setowner" then
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."این کاربر قبلا مدیر ربات شد است👤🤖", 0, "md")
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."کاربر مدیر ربات شد 👤🤖", 0, "md")
  end
  if cmd == "promote" then
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."این کاربر قبلا معاون شده است🤖👤", 0, "md")
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."کاربر معاون ربات شد✅🤖", 0, "md")
end
   if cmd == "remowner" then
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."هیچ مدیری در این گروه برای ربات نیست❌🤖", 0, "md")
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."هیچ مدیری در این گروه برای ربات نیست❌🤖", 0, "md")
end
   if cmd == "demote" then
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."هیچ معاونی در این گروه برای ربات نیست❌🤖", 0, "md")
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."تنزل مقام انجام شد✅📛", 0, "md")
end
    if cmd == "whois" then
if data.username_ then
username = '@'..data.username_
else
username = 'not found'
end
       return tdcli.sendMessage(arg.chat_id, 0, 1, 'Info for [ '..data.id_..' ] :\nUserName : '..username..'\nName : '..data.first_name_, 1)
   end
 else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User not founded_", 0, "md")
  end
end


---------------Lock Link-------------------
local function lock_link(msg, data, target) 
if not is_mod(msg) then
 return "شما مدیر ربات نیستید❗️🚷"
end

local lock_link = data[tostring(target)]["settings"]["lock_link"] 
if lock_link == "yes" then
 return "🔒قفل #لینک از قبل فعال بوده است"
else
 data[tostring(target)]["settings"]["lock_link"] = "yes"
save_data(_config.moderation.data, data) 
 return 
"🔒قفل #لینک  فعال شد"
end
end

local function unlock_link(msg, data, target)
 if not is_mod(msg) then
return "شما مدیر ربات نیستید❗️🚷"
end 
local lock_link = data[tostring(target)]["settings"]["lock_link"]
 if lock_link == "no" then
return "🔒قفل #لینک فعال نیست" 
else 
data[tostring(target)]["settings"]["lock_link"] = "no" save_data(_config.moderation.data, data) 
return "🔒قفل #لینک غیر فعال شد" 
end
end

---------------Lock Tag-------------------
local function lock_tag(msg, data, target) 
if not is_mod(msg) then
 return "شما مدیر ربات نیستید❗️🚷"
end

local lock_tag = data[tostring(target)]["settings"]["lock_tag"] 
if lock_tag == "yes" then
 return "🔒قفل #هشتگ از قبل فعال بوده است"
else
 data[tostring(target)]["settings"]["lock_tag"] = "yes"
save_data(_config.moderation.data, data) 
 return 
"🔒قفل #هشتگ  فعال شد"
end
end

local function unlock_tag(msg, data, target)
 if not is_mod(msg) then
return "شما مدیر ربات نیستید❗️🚷"
end 
local lock_tag = data[tostring(target)]["settings"]["lock_tag"]
 if lock_tag == "no" then
return "🔒قفل #هشتگ فعال نیست" 
else 
data[tostring(target)]["settings"]["lock_tag"] = "no" save_data(_config.moderation.data, data) 
return "🔒قفل #هشتگ غیر فعال شد" 
end
end

---------------Lock Mention-------------------
local function lock_mention(msg, data, target) 
if not is_mod(msg) then
 return "شما مدیر ربات نیستید❗️🚷"
end

local lock_mention = data[tostring(target)]["settings"]["lock_mention"] 
if lock_mention == "yes" then
 return "🔒قفل #یوزرنیم (@)  از قبل فعال بوده است"
else
 data[tostring(target)]["settings"]["lock_mention"] = "yes"
save_data(_config.moderation.data, data) 
 return 
"🔒قفل #یوزرنیم (@) فعال شد"
end
end

local function unlock_mention(msg, data, target)
 if not is_mod(msg) then
return "شما مدیر ربات نیستید❗️🚷"
end 
local lock_mention = data[tostring(target)]["settings"]["lock_mention"]
 if lock_mention == "no" then
return "🔒قفل #یوزرنیم (@)  فعال نیست" 
else 
data[tostring(target)]["settings"]["lock_mention"] = "no" save_data(_config.moderation.data, data) 
return "🔒قفل #یوزرنیم (@) غیر فعال شد" 
end
end

---------------Lock Edit-------------------
local function lock_edit(msg, data, target) 
if not is_mod(msg) then
 return "شما مدیر ربات نیستید❗️🚷"
end

local lock_edit = data[tostring(target)]["settings"]["lock_edit"] 
if lock_edit == "yes" then
 return "🔒قفل #ادیت  از قبل فعال بوده است"
else
 data[tostring(target)]["settings"]["lock_edit"] = "yes"
save_data(_config.moderation.data, data) 
 return 
"🔒قفل #ادیت فعال شد"
end
end

local function unlock_edit(msg, data, target)
 if not is_mod(msg) then
return "شما مدیر ربات نیستید❗️🚷"
end 
local lock_edit = data[tostring(target)]["settings"]["lock_edit"]
 if lock_edit == "no" then
return "🔒قفل #ادیت  فعال نیست" 
else 
data[tostring(target)]["settings"]["lock_edit"] = "no" save_data(_config.moderation.data, data) 
return "🔒قفل #ادیت غیر فعال شد" 
end
end

---------------Lock spam-------------------
local function lock_spam(msg, data, target) 
if not is_mod(msg) then
 return "شما مدیر ربات نیستید❗️🚷"
end

local lock_spam = data[tostring(target)]["settings"]["lock_spam"] 
if lock_spam == "yes" then
 return "🔒قفل #اسپم  از قبل فعال بوده است"
else
 data[tostring(target)]["settings"]["lock_spam"] = "yes"
save_data(_config.moderation.data, data) 
 return 
"🔒قفل #اسپم  فعال شد"
end
end

local function unlock_spam(msg, data, target)
 if not is_mod(msg) then
return "شما مدیر ربات نیستید❗️🚷"
end 
local lock_spam = data[tostring(target)]["settings"]["lock_spam"]
 if lock_spam == "no" then
return "🔒قفل #اسپم فعال نیست" 
else 
data[tostring(target)]["settings"]["lock_spam"] = "no" save_data(_config.moderation.data, data) 
return "🔒قفل #اسپم  غیر فعال  شد" 
end
end

---------------Lock Flood-------------------
local function lock_flood(msg, data, target) 
if not is_mod(msg) then
 return "شما مدیر ربات نیستید❗️🚷"
end

local lock_flood = data[tostring(target)]["settings"]["flood"] 
if lock_flood == "yes" then
 return "🔒قفل #فلود  از قبل فعال بوده است"
else
 data[tostring(target)]["settings"]["flood"] = "yes"
save_data(_config.moderation.data, data) 
 return 
"🔒قفل #فلود  فعال شد"
end
end

local function unlock_flood(msg, data, target)
 if not is_mod(msg) then
return "شما مدیر ربات نیستید❗️🚷"
end 
local lock_flood = data[tostring(target)]["settings"]["flood"]
 if lock_flood == "no" then
return "🔒قفل #فلود  فعال نیست" 
else 
data[tostring(target)]["settings"]["flood"] = "no" save_data(_config.moderation.data, data) 
return "🔒قفل #فلود  غیر فعال شد" 
end
end

---------------Lock Bots-------------------
local function lock_bots(msg, data, target) 
if not is_mod(msg) then
 return "شما مدیر ربات نیستید❗️🚷"
end

local lock_bots = data[tostring(target)]["settings"]["lock_bots"] 
if lock_bots == "yes" then
 return "🔒قفل #ورود ربات های مخرب  از قبل فعال بوده است"
else
 data[tostring(target)]["settings"]["lock_bots"] = "yes"
save_data(_config.moderation.data, data) 
 return 
"🔒قفل #ورود ربات های مخرب  فعال شد"
end
end

local function unlock_bots(msg, data, target)
 if not is_mod(msg) then
return "شما مدیر ربات نیستید❗️🚷"
end 
local lock_bots = data[tostring(target)]["settings"]["lock_bots"]
 if lock_bots == "no" then
return "🔒قفل #ورود ربات های مخرب فعال نیست" 
else 
data[tostring(target)]["settings"]["lock_bots"] = "no" save_data(_config.moderation.data, data) 
return "🔒قفل #ورود ربات های مخرب  غیر فعال شد"
end
end

---------------Lock Markdown-------------------
local function lock_markdown(msg, data, target) 
if not is_mod(msg) then
 return ""
end

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"] 
if lock_markdown == "yes" then
 return "*Markdown* _Posting Is Already Locked_"
else
 data[tostring(target)]["settings"]["lock_markdown"] = "yes"
save_data(_config.moderation.data, data) 
 return 
"*Markdown* _Posting Has Been Locked_"
end
end

local function unlock_markdown(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"]
 if lock_markdown == "no" then
return "*Markdown* _Posting Is Not Locked_" 
else 
data[tostring(target)]["settings"]["lock_markdown"] = "no" save_data(_config.moderation.data, data) 
return "*Markdown* _Posting Has Been Unlocked_" 
end
end

---------------Lock Webpage-------------------
local function lock_webpage(msg, data, target) 
if not is_mod(msg) then
 return "شما مدیر ربات نیستید❗️🚷"
end

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"] 
if lock_webpage == "yes" then
 return "🔒قفل #صفحات وب از قبل فعال بوده است"
else
 data[tostring(target)]["settings"]["lock_webpage"] = "yes"
save_data(_config.moderation.data, data) 
 return 
"🔒قفل #صفحات وب فعال شد"
end
end

local function unlock_webpage(msg, data, target)
 if not is_mod(msg) then
return "شما مدیر ربات نیستید❗️🚷"
end 
local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"]
 if lock_webpage == "no" then
return "🔒قفل #صفحات وب فعال نیست" 
else 
data[tostring(target)]["settings"]["lock_webpage"] = "no"
save_data(_config.moderation.data, data) 
return "🔒قفل #صفحات وب غیر فعال شد" 
end
end

function group_settings(msg, target)  
if not is_mod(msg) then
  return "شما مدیر ربات نیستید❗️🚷"  
end
local data = load_data(_config.moderation.data)
local target = msg.chat_id_ 
if data[tostring(target)] then  
if data[tostring(target)]["settings"]["num_msg_max"] then   
NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['num_msg_max'])
  print('custom'..NUM_MSG_MAX)  
else  
NUM_MSG_MAX = 5
end
end

if data[tostring(target)]["settings"] then    
if not data[tostring(target)]["settings"]["lock_link"] then     
data[tostring(target)]["settings"]["lock_link"] = "yes"   
end
end

if data[tostring(target)]["settings"] then    
if not data[tostring(target)]["settings"]["lock_tag"] then      
data[tostring(target)]["settings"]["lock_tag"] = "yes"    
end
end

if data[tostring(target)]["settings"] then    
if not data[tostring(target)]["settings"]["lock_mention"] then      
data[tostring(target)]["settings"]["lock_mention"] = "no"   
end
end

if data[tostring(target)]["settings"] then    
if not data[tostring(target)]["settings"]["lock_edit"] then     
data[tostring(target)]["settings"]["lock_edit"] = "no"    
end
end

if data[tostring(target)]["settings"] then    
if not data[tostring(target)]["settings"]["lock_spam"] then     
data[tostring(target)]["settings"]["lock_spam"] = "yes"   
end
end

if data[tostring(target)]["settings"] then    
if not data[tostring(target)]["settings"]["lock_flood"] then      
data[tostring(target)]["settings"]["lock_flood"] = "yes"    
end
end

if data[tostring(target)]["settings"] then    
if not data[tostring(target)]["settings"]["lock_bots"] then     
data[tostring(target)]["settings"]["lock_bots"] = "yes"   
end
end

if data[tostring(target)]["settings"] then    
if not data[tostring(target)]["settings"]["lock_markdown"] then     
data[tostring(target)]["settings"]["lock_markdown"] = "no"    
end
end

if data[tostring(target)]["settings"] then    
if not data[tostring(target)]["settings"]["lock_webpage"] then      
data[tostring(target)]["settings"]["lock_webpage"] = "no"   
end
end

local settings = data[tostring(target)]["settings"] 
local text = "⚙تنظیمات قفلی گروه⛓:\n🔐 #قفل پین: *"..settings.lock_edit.."*\n🔐 #قفل لینک: *"..settings.lock_link.."*\n🔐 #قفل هشتگ: *"..settings.lock_tag.."*\n🔐 #قفل فلود: *"..settings.flood.."*\n🔐 #قفل اسپم: *"..settings.lock_spam.."*\n🔐 #قفل یوزرنیم: *"..settings.lock_mention.."*\n🔐 #قفل صفحات وب: *"..settings.lock_webpage.."*\n🔐 #قفل مارک داون: *"..settings.lock_markdown.."*\n🔐 #قفل ربات های مخرب: *"..settings.lock_bots.."*\n 🔐 #میزان حساسیت فلود: *"..NUM_MSG_MAX.."*\n👤🛠سودو و برنامه نویس @sudoradmhr021 "
text = string.gsub(text, "yes", "بله✅")
 text =  string.gsub(text, "no", "خیر⛔️")
return text
end
--------Mutes---------
--------Mute all--------------------------
local function mute_all(msg, data, target) 
if not is_mod(msg) then
 return "شما مدیر ربات نیستید❗️🚷"
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "yes" then
 return "#سکوت گروه از قبل فعال شده است✅"
else
 data[tostring(target)]["mutes"]["mute_all"] = "yes" 
save_data(_config.moderation.data, data) 
 return 
"#سکوت گروه فعال شده ✅"
end
end

local function unmute_all(msg, data, target)
 if not is_mod(msg) then
return "شما مدیر ربات نیستید❗️🚷"
end 
local mute_all = data[tostring(target)]["mutes"]["mute_all"]
 if mute_all == "no" then
return "#سکوت گروه قبلا  غیر فعال شده است✅" 
else 
data[tostring(target)]["mutes"]["mute_all"] = "no"
 save_data(_config.moderation.data, data) 
return "#سکوت گروه غیر  فعال شده ✅" 
end
end
---------------Mute Gif-------------------
local function mute_gif(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end

local mute_gif = data[tostring(target)]["mutes"]["mute_gif"] 
if mute_gif == "yes" then
 return "🔒موت #گیف از قبل فعال بوده است✅"
else
 data[tostring(target)]["mutes"]["mute_gif"] = "yes" 
save_data(_config.moderation.data, data) 
 return "🔒موت #گیف  فعال شد✅"
end
end

local function unmute_gif(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_gif = data[tostring(target)]["mutes"]["mute_gif"]
 if mute_gif == "no" then
return "🔒موت #گیف  فعال نیست✅" 
else 
data[tostring(target)]["mutes"]["mute_gif"] = "no"
 save_data(_config.moderation.data, data) 
return "🔒موت #گیف  غیر فعال شد✅" 
end
end
---------------Mute Game-------------------
local function mute_game(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end

local mute_game = data[tostring(target)]["mutes"]["mute_game"] 
if mute_game == "yes" then
 return "🔒موت #بازی  از قبل فعال بوده است✅"
else
 data[tostring(target)]["mutes"]["mute_game"] = "yes" 
save_data(_config.moderation.data, data) 
 return "🔒موت #بازی  فعال شد✅"
end
end

local function unmute_game(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_game = data[tostring(target)]["mutes"]["mute_game"]
 if mute_game == "no" then
return "🔒موت #بازی فعال نیست✅" 
else 
data[tostring(target)]["mutes"]["mute_game"] = "no"
 save_data(_config.moderation.data, data) 
return "🔒موت #بازی غیر فعال شد✅" 
end
end
---------------Mute Inline-------------------
local function mute_inline(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end

local mute_inline = data[tostring(target)]["mutes"]["mute_inline"] 
if mute_inline == "yes" then
 return "🔒موت #لینک شیشه ای از قبل فعال بوده است✅"
else
 data[tostring(target)]["mutes"]["mute_inline"] = "yes" 
save_data(_config.moderation.data, data) 
 return "🔒موت #لینک شیشه ای فعال شد✅"
end
end

local function unmute_inline(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_inline = data[tostring(target)]["mutes"]["mute_inline"]
 if mute_inline == "no" then
return "🔒موت #لینک شیشه ای فعال نیست✅" 
else 
data[tostring(target)]["mutes"]["mute_inline"] = "no"
 save_data(_config.moderation.data, data) 
return "🔒موت #لینک شیشه ای غیر فعال شد✅" 
end
end
---------------Mute Text-------------------
local function mute_text(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end

local mute_text = data[tostring(target)]["mutes"]["mute_text"] 
if mute_text == "yes" then
 return "🔒موت #متن از قبل فعال بوده است✅"
else
 data[tostring(target)]["mutes"]["mute_text"] = "yes" 
save_data(_config.moderation.data, data) 
 return "🔒موت #متن  فعال شد✅"
end
end

local function unmute_text(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_text = data[tostring(target)]["mutes"]["mute_text"]
 if mute_text == "no" then
return "🔒موت #متن  فعال نیست✅" 
else 
data[tostring(target)]["mutes"]["mute_text"] = "no"
 save_data(_config.moderation.data, data) 
return "🔒موت #متن غیر فعال شد✅" 
end
end
---------------Mute photo-------------------
local function mute_photo(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end

local mute_photo = data[tostring(target)]["mutes"]["mute_photo"] 
if mute_photo == "yes" then
 return "🔒موت #عکس از قبل فعال بوده است✅"
else
 data[tostring(target)]["mutes"]["mute_photo"] = "yes" 
save_data(_config.moderation.data, data) 
 return "🔒موت #عکس  فعال شد✅"
end
end

local function unmute_photo(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"]
 if mute_photo == "no" then
return "🔒موت #عکس  فعال نیست✅" 
else 
data[tostring(target)]["mutes"]["mute_photo"] = "no"
 save_data(_config.moderation.data, data) 
return "🔒موت #عکس  غیر فعال شد✅" 
end
end
---------------Mute Video-------------------
local function mute_video(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end

local mute_video = data[tostring(target)]["mutes"]["mute_video"] 
if mute_video == "yes" then
 return "🔒موت #ویدیو از قبل فعال شد است✅"
else
 data[tostring(target)]["mutes"]["mute_video"] = "yes" 
save_data(_config.moderation.data, data) 
 return "🔒موت #ویدیو  فعال شد✅"
end
end

local function unmute_video(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_video = data[tostring(target)]["mutes"]["mute_video"]
 if mute_video == "no" then
return "🔒موت #ویدیو غیر فعال شد ✅" 
else 
data[tostring(target)]["mutes"]["mute_video"] = "no"
 save_data(_config.moderation.data, data) 
return "🔒موت #ویدیو  فعال نیست✅" 
end
end
---------------Mute Audio-------------------
local function mute_audio(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end

local mute_audio = data[tostring(target)]["mutes"]["mute_audio"] 
if mute_audio == "yes" then
 return "🔒موت #اهنگ از قبل فعال شد است✅"
else
 data[tostring(target)]["mutes"]["mute_audio"] = "yes" 
save_data(_config.moderation.data, data) 
 return "🔒موت #اهنگ  فعال شد ✅"
end
end

local function unmute_video(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_audio = data[tostring(target)]["mutes"]["mute_audio"]
 if mute_audio == "no" then
return "🔒موت #اهنگ فعال نیست✅" 
else 
data[tostring(target)]["mutes"]["mute_audio"] = "no"
 save_data(_config.moderation.data, data) 
return "🔒موت #اهنگ غیر  فعال شد ✅" 
end
end
---------------Mute Voice-------------------
local function mute_voice(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end

local mute_voice = data[tostring(target)]["mutes"]["mute_voice"] 
if mute_voice == "yes" then
 return "🔒موت #وویس از قبل فعال شد است✅"
else
 data[tostring(target)]["mutes"]["mute_voice"] = "yes" 
save_data(_config.moderation.data, data) 
 return "🔒موت #وویس فعال شد ✅"
end
end

local function unmute_voice(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_voice = data[tostring(target)]["mutes"]["mute_voice"]
 if mute_voice == "no" then
return "🔒موت #وویس  فعال نیست ✅" 
else 
data[tostring(target)]["mutes"]["mute_voice"] = "no"
 save_data(_config.moderation.data, data) 
return "🔒موت #وویس غیر فعال شد ✅" 
end
end
---------------Mute Sticker-------------------
local function mute_sticker(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end

local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"] 
if mute_sticker == "yes" then
 return "🔒موت #استیکر از قبل فعال شد است✅"
else
 data[tostring(target)]["mutes"]["mute_sticker"] = "yes" 
save_data(_config.moderation.data, data) 
 return "🔒موت #استیکر  فعال شد✅"
end
end

local function unmute_sticker(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"]
 if mute_sticker == "no" then
return "🔒موت #استیکر  فعال نیست ✅" 
else 
data[tostring(target)]["mutes"]["mute_sticker"] = "no"
 save_data(_config.moderation.data, data) 
return "🔒موت #استیکر  غیر فعال شد✅" 
end
end
---------------Mute Contact-------------------
local function mute_contact(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end

local mute_contact = data[tostring(target)]["mutes"]["mute_contact"] 
if mute_contact == "yes" then
 return "🔒موت #ارسال مخاطب از قبل فعال شد است✅"
else
 data[tostring(target)]["mutes"]["mute_contact"] = "yes" 
save_data(_config.moderation.data, data) 
 return "🔒موت #ارسال مخاطب  فعال شد✅"
end
end

local function unmute_contact(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_contact = data[tostring(target)]["mutes"]["mute_contact"]
 if mute_contact == "no" then
return "🔒موت #ارسال مخاطب   فعال نیست✅" 
else 
data[tostring(target)]["mutes"]["mute_contact"] = "no"
 save_data(_config.moderation.data, data) 
return "🔒موت #ارسال مخاطب غیر  فعال شد✅" 
end
end
---------------Mute Forward-------------------
local function mute_forward(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end

local mute_forward = data[tostring(target)]["mutes"]["mute_forward"] 
if mute_forward == "yes" then
 return "🔒موت #فوروارد  از قبل فعال شد است✅"
else
 data[tostring(target)]["mutes"]["mute_forward"] = "yes" 
save_data(_config.moderation.data, data) 
 return "🔒موت #فوروارد فعال شد ✅"
end
end

local function unmute_forward(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_forward = data[tostring(target)]["mutes"]["mute_forward"]
 if mute_forward == "no" then
return "🔒موت #فوروارد فعال نیست✅" 
else 
data[tostring(target)]["mutes"]["mute_forward"] = "no"
 save_data(_config.moderation.data, data) 
return "🔒موت #فوروارد غیر فعال شده است✅" 
end
end
---------------Mute Location-------------------
local function mute_location(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end

local mute_location = data[tostring(target)]["mutes"]["mute_location"] 
if mute_location == "yes" then
 return "🔒موت #ارسال مکان  از قبل فعال شد است✅"
else
 data[tostring(target)]["mutes"]["mute_location"] = "yes" 
save_data(_config.moderation.data, data) 
 return "🔒موت #ارسال مکان   فعال شد✅"
end
end

local function unmute_location(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_location = data[tostring(target)]["mutes"]["mute_location"]
 if mute_location == "no" then
return "🔒موت #ارسال مکان فعال نیست✅" 
else 
data[tostring(target)]["mutes"]["mute_location"] = "no"
 save_data(_config.moderation.data, data) 
return "🔒موت #ارسال مکان غیر  فعال شد✅" 
end
end
---------------Mute Document-------------------
local function mute_document(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end

local mute_document = data[tostring(target)]["mutes"]["mute_document"] 
if mute_document == "yes" then
 return "🔒موت #ارسال فایل  از قبل فعال شد است✅"
else
 data[tostring(target)]["mutes"]["mute_document"] = "yes" 
save_data(_config.moderation.data, data) 
 return "🔒موت #ارسال فایل  فعال شد است✅"
end
end

local function unmute_document(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_document = data[tostring(target)]["mutes"]["mute_document"]
 if mute_document == "no" then
return "🔒موت #ارسال فایل  فعال نیست✅" 
else 
data[tostring(target)]["mutes"]["mute_document"] = "no"
 save_data(_config.moderation.data, data) 
return "🔒موت #ارسال فایل غیر فعال شد✅" 
end
end
---------------Mute TgService-------------------
local function mute_tgservice(msg, data, target) 
if not is_mod(msg) then
 return "_You're Not_ *Moderator*"
end

local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"] 
if mute_tgservice == "yes" then
 return "🔒موت #پیام ورود و خروج  از قبل فعال شد است✅"
else
 data[tostring(target)]["mutes"]["mute_tgservice"] = "yes" 
save_data(_config.moderation.data, data) 
 return "🔒موت #پیام ورود و خروج  فعال شد✅"
end
end

local function unmute_tgservice(msg, data, target)
 if not is_mod(msg) then
return "_You're Not_ *Moderator*"
end 
local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"]
 if mute_tgservice == "no" then
return "🔒موت #پیام ورود و خروج   فعال نیست✅" 
else 
data[tostring(target)]["mutes"]["mute_tgservice"] = "no"
 save_data(_config.moderation.data, data) 
return "🔒موت #پیام ورود و خروج  غیر فعال شد✅" 
end
end
----------MuteList---------
local function mutes(msg, target)   
if not is_mod(msg) then
  return "You're Not Moderator" 
end
local data = load_data(_config.moderation.data)
local target = msg.chat_id_ 
if data[tostring(target)]["mutes"] then   
if not data[tostring(target)]["mutes"]["mute_all"] then     
data[tostring(target)]["mutes"]["mute_all"] = "no"    
end
end
if data[tostring(target)]["mutes"] then   
if not data[tostring(target)]["mutes"]["mute_gif"] then     
data[tostring(target)]["mutes"]["mute_gif"] = "no"    
end
end
if data[tostring(target)]["mutes"] then   
if not data[tostring(target)]["mutes"]["mute_text"] then      
data[tostring(target)]["mutes"]["mute_text"] = "no"   
end
end
if data[tostring(target)]["mutes"] then   
if not data[tostring(target)]["mutes"]["mute_photo"] then     
data[tostring(target)]["mutes"]["mute_photo"] = "no"    
end
end
if data[tostring(target)]["mutes"] then   
if not data[tostring(target)]["mutes"]["mute_video"] then     
data[tostring(target)]["mutes"]["mute_video"] = "no"    
end
end
if data[tostring(target)]["mutes"] then   
if not data[tostring(target)]["mutes"]["mute_audio"] then     
data[tostring(target)]["mutes"]["mute_audio"] = "no"    
end
end
if data[tostring(target)]["mutes"] then   
if not data[tostring(target)]["mutes"]["mute_voice"] then     
data[tostring(target)]["mutes"]["mute_voice"] = "no"    
end
end
if data[tostring(target)]["mutes"] then   
if not data[tostring(target)]["mutes"]["mute_sticker"] then     
data[tostring(target)]["mutes"]["mute_sticker"] = "no"    
end
end
if data[tostring(target)]["mutes"] then   
if not data[tostring(target)]["mutes"]["mute_contact"] then     
data[tostring(target)]["mutes"]["mute_contact"] = "no"    
end
end
if data[tostring(target)]["mutes"] then   
if not data[tostring(target)]["mutes"]["mute_forward"] then     
data[tostring(target)]["mutes"]["mute_forward"] = "no"    
end
end
if data[tostring(target)]["mutes"] then   
if not data[tostring(target)]["mutes"]["mute_location"] then      
data[tostring(target)]["mutes"]["mute_location"] = "no"   
end
end
if data[tostring(target)]["mutes"] then   
if not data[tostring(target)]["mutes"]["mute_document"] then      
data[tostring(target)]["mutes"]["mute_document"] = "no"   
end
end
if data[tostring(target)]["mutes"] then   
if not data[tostring(target)]["mutes"]["mute_tgservice"] then     
data[tostring(target)]["mutes"]["mute_tgservice"] = "no"    
end
end
if data[tostring(target)]["mutes"] then   
if not data[tostring(target)]["mutes"]["mute_inline"] then      
data[tostring(target)]["mutes"]["mute_inline"] = "no"   
end
end
if data[tostring(target)]["mutes"] then   
if not data[tostring(target)]["mutes"]["mute_game"] then      
data[tostring(target)]["mutes"]["mute_game"] = "no"   
end
end
local mutes = data[tostring(target)]["mutes"] 
local text = "🛡*titanbot*💎 \n ⛓تنظیمات موت گروه⚙ : \n🔐 #موت همه : *"..mutes.mute_all.."*\n🔐 #موت گیف : *"..mutes.mute_gif.."*\n🔐 #موت متن : *"..mutes.mute_text.."*\n🔐 #موت لینک شیشه ای : *"..mutes.mute_inline.."*\n🔐 #موت بازی : *"..mutes.mute_game.."*\n🔐 #موت عکس : *"..mutes.mute_photo.."*\n🔐 #موت ویدیو : *"..mutes.mute_video.."*\n🔐 #موت اهنگ : *"..mutes.mute_audio.."*\n🔐 #موت وویس : *"..mutes.mute_voice.."*\n🔐 #موت استیکر: *"..mutes.mute_sticker.."*\n🔐 #موت مخاطب : *"..mutes.mute_contact.."*\n🔐 #موت فوروارد : *"..mutes.mute_forward.."*\n🔐 #موت ارسال مکان : *"..mutes.mute_location.."*\n🔐 #موت ارسال فایل : *"..mutes.mute_document.."*\n🔐 #موت ورود و خروج : *"..mutes.mute_tgservice.."*\n👤💎*سودو و برنامه نویس* : @sudoradmhr021"
text = string.gsub(text, "yes", "بله✅")
 text =  string.gsub(text, "no", "خیر⛔️")
return text
end
local function run(msg, matches)
    local data = load_data(_config.moderation.data)
   local chat = msg.chat_id_
   local user = msg.sender_user_id_
if matches[1] == "ایدی" then
if not matches[2] and tonumber(msg.reply_to_message_id_) == 0 then
return "*👥ایدی گروه :* _"..chat.."_\n*👤ایدی :* _"..user.."_\n _برنامه نویس_ : @sudoradmhr021"
end
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="ایدی"})
  end
if matches[2] and tonumber(msg.reply_to_message_id_) == 0 then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="ایدی"})
      end
   end
if matches[1] == "پین" and is_owner(msg) then
tdcli.pinChannelMessage(msg.chat_id_, msg.reply_to_message_id_, 1)
return "پیام مورد نظر پین شد??"
end
if matches[1] == 'انپین' and is_mod(msg) then
tdcli.unpinChannelMessage(msg.chat_id_)
return "پین  غیر فعال شد🔗"
end
if matches[1] == "نصب" then
return modadd(msg)
end
if matches[1] == "حذف" then
return modrem(msg)
end
if matches[1] == "مدیر" and is_admin(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="setowner"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="setowner"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="setowner"})
      end
   end
if matches[1] == "تنزل مدیر" and is_admin(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="remowner"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="remowner"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="remowner"})
      end
   end
if matches[1] == "معاون" and is_owner(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="promote"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="promote"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="promote"})
      end
   end
if matches[1] == "تنزل" and is_owner(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="demote"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="demote"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="demote"})
      end
   end

if matches[1] == "قفل" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "لینک" then
return lock_link(msg, data, target)
end
if matches[2] == "هشتگ" then
return lock_tag(msg, data, target)
end
if matches[2] == "یوزرنیم" then
return lock_mention(msg, data, target)
end
if matches[2] == "ادیت" then
return lock_edit(msg, data, target)
end
if matches[2] == "اسپم" then
return lock_spam(msg, data, target)
end
if matches[2] == "فلود" then
return lock_flood(msg, data, target)
end
if matches[2] == "ربات" then
return lock_bots(msg, data, target)
end
if matches[2] == "مارک داون" then
return lock_markdown(msg, data, target)
end
if matches[2] == "صفحات وب" then
return lock_webpage(msg, data, target)
end
end

if matches[1] == "بازکردن" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "لینک" then
return unlock_link(msg, data, target)
end
if matches[2] == "هشتگ" then
return unlock_tag(msg, data, target)
end
if matches[2] == "یوزرنیم" then
return unlock_mention(msg, data, target)
end
if matches[2] == "ادیت" then
return unlock_edit(msg, data, target)
end
if matches[2] == "اسپم" then
return unlock_spam(msg, data, target)
end
if matches[2] == "فلود" then
return unlock_flood(msg, data, target)
end
if matches[2] == "ربات" then
return unlock_bots(msg, data, target)
end
if matches[2] == "مارک داون" then
return unlock_markdown(msg, data, target)
end
if matches[2] == "صفحات وب" then
return unlock_webpage(msg, data, target)
end
end
if matches[1] == "موت" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "همه" then
return mute_all(msg, data, target)
end
if matches[2] == "گیف" then
return mute_gif(msg ,data, target)
end
if matches[2] == "متن" then
return mute_text(msg ,data, target)
end
if matches[2] == "عکس" then
return mute_photo(msg ,data, target)
end
if matches[2] == "ویدیو" then
return mute_video(msg ,data, target)
end
if matches[2] == "اهنگ" then
return mute_audio(msg ,data, target)
end
if matches[2] == "وویس" then
return mute_voice(msg ,data, target)
end
if matches[2] == "استیکر" then
return mute_sticker(msg ,data, target)
end
if matches[2] == "مخاطب" then
return mute_contact(msg ,data, target)
end
if matches[2] == "فوروارد" then
return mute_forward(msg ,data, target)
end
if matches[2] == "ارسال مکان" then
return mute_location(msg ,data, target)
end
if matches[2] == "ارسال فایل" then
return mute_document(msg ,data, target)
end
if matches[2] == "ورود و خروج" then
return mute_tgservice(msg ,data, target)
end
if matches[2] == "لینک شیشه ای" then
return mute_inline(msg ,data, target)
end
if matches[2] == "بازی" then
return mute_game(msg ,data, target)
end
end

if matches[1] == "انموت" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "همه" then
return unmute_all(msg, data, target)
end
if matches[2] == "گیف" then
return unmute_gif(msg, data, target)
end
if matches[2] == "متن" then
return unmute_text(msg, data, target)
end
if matches[2] == "عکس" then
return unmute_photo(msg ,data, target)
end
if matches[2] == "اهنگ" then
return unmute_video(msg ,data, target)
end
if matches[2] == "ویدیو" then
return unmute_audio(msg ,data, target)
end
if matches[2] == "وویس" then
return unmute_voice(msg ,data, target)
end
if matches[2] == "استیکر" then
return unmute_sticker(msg ,data, target)
end
if matches[2] == "مخاطب" then
return unmute_contact(msg ,data, target)
end
if matches[2] == "فوروارد" then
return unmute_forward(msg ,data, target)
end
if matches[2] == "ارسال مکان" then
return unmute_location(msg ,data, target)
end
if matches[2] == "ارسال فایل" then
return unmute_document(msg ,data, target)
end
if matches[2] == "ورود و خروج" then
return unmute_tgservice(msg ,data, target)
end
if matches[2] == "لینک شیشه ای" then
return unmute_inline(msg ,data, target)
end
if matches[2] == "بازی" then
return unmute_game(msg ,data, target)
end
end
if matches[1] == "اطلاعات گروه" and gp_type(msg.chat_id_) == "channel" then
local function group_info(arg, data)
local text = "👥*اطلاعات گروه🎇 :*\n_ادمین ها :_ *"..data.administrator_count_.."*\n_تعدادممبر ها :_ *"..data.member_count_.."*\n_اخراج شده ها :_ *"..data.kicked_count_.."*\n_ایدی گروه :_ *"..data.channel_.id_.."*"
print(serpent.block(data))
        tdcli.sendMessage(arg.chat_id, arg.msg_id, 1, text, 1, 'md')
end
 tdcli.getChannelFull(msg.chat_id_, group_info, {chat_id=msg.chat_id_,msg_id=msg.id_})
end
    if matches[1] == 'تنظیم لینک' and is_owner(msg) then
      data[tostring(chat)]['settings']['linkgp'] = 'waiting'
      save_data(_config.moderation.data, data)
      return '✅لطفا لینک گروه خود را ارسال کنید '
    end

    if msg.content_.text_ then
   local is_link = msg.content_.text_:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.content_.text_:match("^([https?://w]*.?t.me/joinchat/%S+)$")
      if is_link and data[tostring(chat)]['settings']['linkgp'] == 'waiting' and is_owner(msg) then
        data[tostring(chat)]['settings']['linkgp'] = msg.content_.text_
        save_data(_config.moderation.data, data)
        return "لینک ثبت شد✅"
      end
    end
    if matches[1] == 'لینک' and is_mod(msg) then
      local linkgp = data[tostring(chat)]['settings']['linkgp']
      if not linkgp then
        return "ابتدا لینک گروه خود را با دستور تنظیم لینک ثبت کنید"
      end
      local text = "<b>Group Link :</b>\n"..linkgp
        return tdcli.sendMessage(chat, msg.id_, 1, text, 1, 'html')
    end
  if matches[1] == "تنظیم قوانین" and matches[2] and is_mod(msg) then
    data[tostring(chat)]['rules'] = matches[2]
    save_data(_config.moderation.data, data)
    return "قوانین گروه تبت شد"
  end
  if matches[1] == "قوانین" then
 if not data[tostring(chat)]['rules'] then
     rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban.\nsudo @sudoradmhr021"
        else
     rules = "*Group Rules :*\n"..data[tostring(chat)]['rules']
      end
    return rules
  end
if matches[1] == "اطلاعات یوزرنیم" and matches[2] and is_mod(msg) then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="res"})
  end
if matches[1] == "اطلاعات یوزر" and matches[2] and is_mod(msg) then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="whois"})
  end
  if matches[1] == 'تنظیم حساسیت اسپم' and is_mod(msg) then
      if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 50 then
        return "عدد وارد شده باید بین 1-50 باشد"
        end
      local flood_max = matches[2]
      data[tostring(chat)]['settings']['num_msg_max'] = flood_max
      save_data(_config.moderation.data, data)
    return "_حساسیت اسپم گروه تغییر کرد به:_ *[ "..matches[2].." ]*"
       end
    if matches[1]:lower() == 'پاک کردن' and is_owner(msg) then
      if matches[2] == 'مدیر ها' then
        if next(data[tostring(chat)]['mods']) == nil then
          return "هیچ مدیری در گروه نیست"
        end
        for k,v in pairs(data[tostring(chat)]['mods']) do
          data[tostring(chat)]['mods'][tostring(k)] = nil
          save_data(_config.moderation.data, data)
        end
        return "تمام مدیر ها تنزل مقام پیدا کردند"
      end
      if matches[2] == 'قوانین' then
        if not data[tostring(chat)]['rules'] then
          return "قوانینی تنظیم نشده است"
        end
          data[tostring(chat)]['rules'] = nil
          save_data(_config.moderation.data, data)
        return "_قوانین گروه پاک شد_"
      end
      if matches[2] == 'درباره' then
        if gp_type(chat) == "chat" then
        if not data[tostring(chat)]['about'] then
          return "چیزی تنظیم نشده است"
        end
          data[tostring(chat)]['about'] = nil
          save_data(_config.moderation.data, data)
        elseif gp_type(chat) == "channel" then
   tdcli.changeChannelAbout(chat, "", dl_cb, nil)
             end
        return "درباره گروه پاک شد"
        end
        end
    if matches[1]:lower() == 'پاک کردن' and is_admin(msg) then
      if matches[2] == 'معاون ها' then
        if next(data[tostring(chat)]['owners']) == nil then
          return "هیچ معاونی در گروه نیست"
        end
        for k,v in pairs(data[tostring(chat)]['owners']) do
          data[tostring(chat)]['owners'][tostring(k)] = nil
          save_data(_config.moderation.data, data)
        end
        return "_تمام معاون ها تنزل پیدا کردند_"
      end
     end
if matches[1] == "تنظیم نام" and matches[2] and is_mod(msg) then
local gp_name = string.gsub(matches[2], "_","")
tdcli.changeChatTitle(chat, gp_name, dl_cb, nil)
end
  if matches[1] == "تنظیم درباره" and matches[2] and is_mod(msg) then
     if gp_type(chat) == "channel" then
   tdcli.changeChannelAbout(chat, matches[2], dl_cb, nil)
    elseif gp_type(chat) == "chat" then
    data[tostring(chat)]['about'] = matches[2]
    save_data(_config.moderation.data, data)
     end
    return "_مشخصات گروه تنظیم شد_" 
  end
  if matches[1] == "درباره" and gp_type(chat) == "chat" then
 if not data[tostring(chat)]['about'] then
     about = "_مشخصاتی وجود ندارد_"
        else
     about = "*Group Description :*\n"..data[tostring(chat)]['about']
      end
    return about
  end
if matches[1] == "تنظیمات" then
return group_settings(msg, target)
end
if matches[1] == "موت لیست" then
return mutes(msg, target)
end
if matches[1] == "لیست معاون ها" then
return modlist(msg)
end
if matches[1] == "لیست مدیران" and is_owner(msg) then
return ownerlist(msg)
end

if matches[1] == "راهنما" and is_mod(msg) then
text = [[
*⛓🔰راهنمای ربات TelBots🔰⚙*

!bot on  : ♻️✅ربات روشن 
!bot off : ♨️📛ربات خاموش 

👤👥راهنمای مدیر و سودو:

⬅️ مدیر [یوزرنیم ، ایدی ، ریپلای]
تنطیم مدیر گروه برای ربات با قرار دادن یکی از اطلاعات بالا جلوی دستور🌀
➖➖➖➖➖➖➖➖➖➖➖
⬅️تنزل مدیر [یوزرنیم ، ایدی ، ریپلای]
کاهش مقام مدیر توسط سودو➿
➖➖➖➖➖➖➖➖➖➖➖
⬅️معاون [یوزرنیم ، ایدی ، ریپلای]
تایین فرد به عنوان معاون ربات با قرار دادن یکی از اطلاعات بالا جلوی دستور🌐
➖➖➖➖➖➖➖➖➖➖➖
⬅️تنزل [یوزرنیم ، ایدی ، ریپلای]
تنزل مقام معاون با قرار دادن یکی از اطلاعات بالا جلوی اسم💠
➖➖➖➖➖➖➖➖➖➖➖
⬅️تنطیم حساسیت اسپم [1-50]
درصورت تعداد پیام مشخص  فرد حذف شود✅
➖➖➖➖➖➖➖➖➖➖➖
⬅️قفل [ لینک ، هشتگ ، ادیت ، صفحات وب ، ربات ، اسپم ، فلود ، یوزرنیم ]
در صورت ارسال پیامی که حاوی این موارد باشد ربات ان را پاک میکند🏧
➖➖➖➖➖➖➖➖➖➖➖
⬅️بازکردن قفل [ لینک ، هشتگ ، ادیت ، صفحات وب ، ربات ، اسپم ، فلود ، یوزرنیم ]
قفل پیام ها باز میشود و ربات ان را پاک نمیکند 🛃
➖➖➖➖➖➖➖➖➖➖➖
⬅️موت [ گیف، عکس ،  ارسال فایل ، استیکر ، ویدیو ، متن ، فوروارد ، ارسال مکان ، اهنگ ، وویس ، مخاطب ، همه , لینک شیشه ای , بازی , ورود و خروج ]
پاک کردن پیام های حاوی یکی از موارد بالا توسط ربات 🤖
➖➖➖➖➖➖➖➖➖➖➖
⬅️انموت [ گیف، عکس ،  ارسال فایل ، استیکر ، ویدیو ، متن ، فوروارد ، ارسال مکان ، اهنگ ، وویس ، مخاطب ، همه , لینک شیشه ای , بازی , ورود و خروج ]
پاک نکردن قسمت موت شده 😸
➖➖➖➖➖➖➖➖➖➖➖
⬅️تنظیم [قوانین ، نام ، عکس گروه ، درباره]
تنظیم یکی از اطلاعات بالا برای گروه توسط ربات⚙⛓
➖➖➖➖➖➖➖➖➖➖➖
⬅️پاک کردن [ قوانین ، درباره]🔩
➖➖➖➖➖➖➖➖➖➖➖
⬅️پین
پین کردن پیام در گروه🖇📎
➖➖➖➖➖➖➖➖➖➖➖
⬅️انپین 
بستن پین در گروه🖇✂️
➖➖➖➖➖➖➖➖➖➖➖
⬅️تنظیمات
نمایش تنظیمات قفلی گروه⚙
➖➖➖➖➖➖➖➖➖➖➖
⬅️موت لیست
نمایش تنظیمات موت گروه 🛠
➖➖➖➖➖➖➖➖➖➖➖
⬅️لیست مدیران
نمایش لیست مدیران گروه👥
➖➖➖➖➖➖➖➖➖➖➖
⬅️لیست معاون ها
نمایش لیست معاون ها در گروه🗣
➖➖➖➖➖➖➖➖➖➖➖
⬅️تاریخ انقضا 
نشان دادن تاریخ انقضای گروه🔕

⬅️تنظیم تاریخ انقضا [عدد]
تنظیم تاریخ انقضا و مدت زمان خرید ربات به روز💵
➖➖➖➖➖➖➖➖➖➖➖
⬅️!فیلتر [کلمه]
درصورت نوشتن کلمه پاک میشود(قفل فحش)🚷

⬅️!ازاد [کلمه]
ازاد کردن کلمه از بخش فیلتر

⬅️!لیست فیلتر
نمایش کلمات فیلتر شده به صورت لیست

⬅️!پاک کردن لیست فیلتر
پاک کردن لیست کلمات فیلتر شده
➖➖➖➖➖➖➖➖➖➖➖
بخش دستورات انگلیسی :👐🏿

➡️!silent [یوزرنیم ، ایدی ، ریپلای]
ساکت کردن فرد مورد نظر و پاک شدن پیامش👾
➡️!unsilent [یوزرنیم ، ایدی ، ریپلای]
 خارج شدن فرد از حالت ساکت🗣
➡️!mt [عدد ساعت  عدد دقیقه]
تنظیم موت گروه به صورت تایم داره عدد اول میزان ساعت و عدد دوم میزان دقیقه است
➖➖➖➖➖➖➖➖➖➖➖
➡️!kick 
اخراج شدن از گروه❌
➡️!ban
تحریم و اخراج (دیگر اجازه ورود به گروه را ندارد🚷🚯
➡️!unban
خارج شدن از حالت بان
➖➖➖➖➖➖➖➖➖➖➖
➡️!clean [bans , bots , silentlist]
پاک کردن لیست بان ها ربات ها و ساکت ها
➡️!banlist 
نشان دادن لیست بان ها
➡️!del [عدد]
پاک کردن تعداد پیام های مورد نظر گروه  
عدد بین 1 و 100 رو وارد کنید❗️
➖➖➖➖➖➖➖➖➖➖➖
راهنمای عمومی ربات برای همه کاربر ها:🎮

⬅️قوانین
نمایش قوانین گروه 🚷

⬅️درباره
نمایش اطلاعات تنظیم شده در باره گروه🆎

⬅️اطلاعات من
نمایش اطلاعات شما👤

⬅️اطلاعات گروه
نمایش اطلاعاتی درباره گروه💮

⬅️لینک
دریافت لینک گروه که قبلا تنظیم شده است🆔

⬅️اطلاعات یوزرنیم[یوزرنیم]
نشان دادن اطلاعات یوزرنیم با قرار دادن یوزرنیم جلوی دستور☢

⬅️ایدی [ریپلای ، ارسال]
نشان دادن ایدی عددیه فرد مورد نظر با ریپلای و ارسال تنهای ان نشان دادن اطلاعات یوزر🌋

⬅️اطلاعات یوزر[ایدی عددی]
نشان دادن اطلاعات فرد با قرار دادن ایدی عددیه ان جلوی دستور🏁

⬅️نرخ 
مشاهده نرخ خرید ربات برای گروه

⬅️انلاینی
اطمینال از انلاین بودن ربات به صورت فان😄

⬅️عکس من
فرستادن عکس پروفایل شما

❗️❗️شما عزیزان میتوانید از علامت های [ / و #] در شروع دستوراتی که با [!]اغاز میشود نیز استفاده کنید

💻برنامه نویسی توسط 
@sudoradmhr021
👥🗣کانال ما:
@DJteamm
]]
return text
end
end
return {
patterns ={
"^(ایدی)$",
"^(ایدی) (.*)$",
"^(پین)$",
"^(انپین)$",
"^(اطلاعات گروه)$",
"^(test)$",
"^(نصب)$",
"^(حذف)$",
"^(مدیر)$",
"^(مدیر) (.*)$",
"^(تنزل مدیر)$",
"^(تنزل مدیر) (.*)$",
"^(معاون)$",
"^(معاون) (.*)$",
"^(تنزل)$",
"^(تنزل) (.*)$",
"^(لیست مدیران)$",
"^(لیست معاون ها)$",
"^(قفل) (.*)$",
"^(بازکردن) (.*)$",
"^(تنظیمات)$",
"^(موت لیست)$",
"^(موت) (.*)$",
"^(انموت) (.*)$",
"^(لینک)$",
"^(تنظیم لینک)$",
"^(قوانین)$",
"^(تنظیم قوانین) (.*)$",
"^(درباره)$",
"^(تنظیم درباره) (.*)$",
"^(تنظیم نام) (.*)$",
"^(پاک کردن) (.*)$",
"^(تنظیم حساسیت اسپم) (%d+)$",
"^(اطلاعات یوزرنیم) (.*)$",
"^(اطلاعات یوزر) (%d+)$",
"^(راهنما)$",
"^([https?://w]*.?t.me/joinchat/%S+)$",
"^([https?://w]*.?telegram.me/joinchat/%S+)$",

},
run=run
}
--end groupmanager.lua mohammadrezajiji
