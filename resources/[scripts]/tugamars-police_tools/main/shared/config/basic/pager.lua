Config.Pager = {
    Item = {
        RequireToReceive=false,
        RequireToSend=false,
        Name="pager",
    },
    Command={
        Name="pager",
        Enabled=true
    },
    Channels = {
        ["cirt"] = {
            Title="Critical Incident Response Team",
            BroadcastPerms={ -- Who should be able to page this channel
                Ace={
                    "pager_cirt_broadcast",
                }, -- set to nil to not check
                Jobs=nil, -- set to nil to not check
            },
            SubscribePerms={ -- Who should be able to receive messages from this channel / subscribe to it?
                Ace={
                    "pager_swat_subscribe",
                },
                Jobs=nil,
            },
            SubscribeType="manual", -- auto = onlogin based on perms; manual = person needs to use pager/command
        }
    }
};