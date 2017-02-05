--Start By edit @mohammadrezajijji

function run(msg, matches)
local url , res = http.request('http://api.gpmod.ir/time/')
if res ~= 200 then return "❌❕اتصال بر قرار نیست با شبکه" end
local jdat = json:decode(url)
local text = '*📆تاریخ شمسی:* _'..jdat.FAdate..'_\n🔰🔰🔰🔰🔰🔰🔰🔰🔰🔰🔰\n*📆تاریخ میلادی:* _'..jdat.ENdate.. '_'
  tdcli.sendMessage(msg.chat_id_, 0, 1, text, 1, 'md')
end
return {
  patterns = {"^ساعت$"}, 
run = run 
}
--End By @mohammadrezajiji
--Channel 
