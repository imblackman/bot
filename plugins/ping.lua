--start by @Tele_Sudo
local datebase = {
   "😐❤️ آنلاینم بی ناموس",
  "ریدی داش آنلاینم 😐❤️ ",
  "خفه شۅ عنچهره توهین نکن 😐❤️ ",
   "نزن لامصب انلاینم 😐❤️ ",
   "جاکش انلاینم دیه گاییدی 😐❤️ ",
   "افلاین نگاییدم 😐❤️ ",
  }
local function run(msg, matches) 
return datebase[math.random(#datebase)]
end
return {
  patterns = {
    "^(انلاینی)",
  },
  run = run
}

--end by @Tele_Sudo
--Channel @LuaError