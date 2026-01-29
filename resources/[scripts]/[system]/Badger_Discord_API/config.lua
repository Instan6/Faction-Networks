Config = {
	Guild_ID = '1335097499672641558', -- Set to the ID of your guild (or your Primary guild if using Multiguild)
	Multiguild = false, -- Set to true if you want to use multiple guilds
	Guilds = {
		["Laneway Roleplay"] = "1335097499672641558", -- Replace this with a name, like "main"
	},
	Bot_Token = 'MTQ2MzQ5NTk3NDc4MDY3MDAxNQ.GvBKx8.ZBfqLWppYT2-rvncf1VKWOw4Fd87nNRZN7fI_4',
	RoleList = {

		['director'] = '1335815945108717598', -- Director
		['manager'] = '1400754336983679037', -- Manager
		['developer'] = '1335815489183678495', -- Developer
		['staff'] = '1335815682885156896', -- Staff
		['government'] = '1337727432479735809', -- Government
		['vip'] = '1465015097066918123', -- VIP Dealership

	},
	DebugScript = false,
	CacheDiscordRoles = true, -- true to cache player roles, false to make a new Discord Request every time
	CacheDiscordRolesTime = 60, -- if CacheDiscordRoles is true, how long to cache roles before clearing (in seconds)
}

Config.Splash = {
	Header_IMG = 'https://forum.cfx.re/uploads/default/original/3X/a/6/a6ad03c9fb60fa7888424e7c9389402846107c7e.png',
	Enabled = false,
	Wait = 10, -- How many seconds should splash page be shown for? (Max is 12)
	Heading1 = "Welcome to [ServerName]",
	Heading2 = "Make sure to join our Discord and check out our website!",
	Discord_Link = 'https://discord.gg',
	Website_Link = 'https://badger.store',
}