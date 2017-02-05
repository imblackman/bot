
local function run(msg, matches)
	if matches[1]:lower() == 'اطلاعات من' then
		function get_id(arg, data)
			local username
			if data.first_name_ then
				if data.username_ then
					username = '@'..data.username_
				else
					username = 'یوزرنیم وجود ندارد❌❗️'
				end
				local telNum
				if data.phone_number_ then
					telNum = '+'..data.phone_number_
				else
					telNum = '----'
				end
				local lastName
				if data.last_name_ then
					lastName = data.last_name_
				else
					lastName = '----'
				end
				local rank
				if is_sudo(msg) then
					rank = 'سودو👤'
				elseif is_owner(msg) then
					rank = 'مدیر👤'
				elseif is_admin(msg) then
					rank = 'ادمین👤'
				elseif is_mod(msg) then
					rank = 'معاون👤'
				else
					rank = 'عضو عادی👤'
				end
				local text = '👤📄❄️اطلاعات شما:\n1⃣اسم اول:: '..data.first_name_..'\n2⃣اسم دوم: '..lastName..'\n🛂یوزرنیم: '..username..'\n👤ایدی: '..data.id_..'\nℹ️ایدی گروه: '..arg.chat_id..'\n📱شماره تلفن: '..telNum..' \n👥مقام: '..rank..'\n🈁لینک شما : telegram.me/'..data.username_
				tdcli.sendMessage(arg.chat_id, msg.id_, 1, text, 0, 'html')
			end
		end
		tdcli_function({ ID = 'GetUser', user_id_ = msg.sender_user_id_, }, get_id, {chat_id=msg.chat_id_, user_id=msg.sendr_user_id_})
	end
end

return { patterns = { "^اطلاعات من$" }, run = run }

-- END
-- By @To0fan
-- CHANNEL: @LuaError
-- We Are The Best :-)