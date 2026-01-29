Config.Camera = {
    HudResource="tugamars_hud",
    FovMax=50.0,
    FovMin=1.0, -- max zoom (less = more zoom)
    ZoomSpeed=1.5, -- camera zoom speed
    SpeedHorizontal= 2.0, -- Speed rot camera horizontal
    SpeedVertical=2.0, -- Speed rot camera vertically
    Webhook="#", --Valid discord webhook, for fivemanage URLs make sure the URL has ?apiKey=YOUR_API_TOKEN | https://api.fivemanage.com/api/image?apiKey=yourtoken
    WebhookSystem="discord", -- discord or fivemanage
    ItemName={
        ["sdcard"]="sdcard",
    }
};
