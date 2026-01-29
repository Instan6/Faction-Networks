-- Webhook for instapic posts, recommended to be a public channel
INSTAPIC_WEBHOOK = "https://discord.com/api/webhooks/1460658885827236082/F8nHXMGsECcQWHzvZFwuZopa0ZhGJrzEUzHSQb3fO9UWO0maStjwfOy70CGgxVuaAkqO"
-- Webhook for birdy posts, recommended to be a public channel
BIRDY_WEBHOOK = "https://discord.com/api/webhooks/1460658683972161783/EGbgoaz-C4fg-GkjeBYFpUjW7RKqOCq6mrfKxRuY4hD-YdjXOhPIrUKV-t1g59HqCiWJ"

-- Discord webhook or API key for server logs
-- We recommend https://fivemanage.com/ for logs. Use code "LBLOGS" for 20% off the Logs Pro plan
LOGS = {
    Default = "https://discord.com/api/webhooks/1460658519450587292/y52fGZLJENwSLtJrPmeyDabSENbyUSuyCf6aAm82h4AIAfac30Ph3NjuQaTQohmqkF_j", -- set to false to disable
    Calls = "https://discord.com/api/webhooks/1460658519450587292/y52fGZLJENwSLtJrPmeyDabSENbyUSuyCf6aAm82h4AIAfac30Ph3NjuQaTQohmqkF_j",
    Messages = "https://discord.com/api/webhooks/1460658519450587292/y52fGZLJENwSLtJrPmeyDabSENbyUSuyCf6aAm82h4AIAfac30Ph3NjuQaTQohmqkF_j",
    InstaPic = "https://discord.com/api/webhooks/1460658519450587292/y52fGZLJENwSLtJrPmeyDabSENbyUSuyCf6aAm82h4AIAfac30Ph3NjuQaTQohmqkF_j",
    Birdy = "https://discord.com/api/webhooks/1460658519450587292/y52fGZLJENwSLtJrPmeyDabSENbyUSuyCf6aAm82h4AIAfac30Ph3NjuQaTQohmqkF_j",
    YellowPages = "https://discord.com/api/webhooks/1460658519450587292/y52fGZLJENwSLtJrPmeyDabSENbyUSuyCf6aAm82h4AIAfac30Ph3NjuQaTQohmqkF_j",
    Marketplace = "https://discord.com/api/webhooks/1460658519450587292/y52fGZLJENwSLtJrPmeyDabSENbyUSuyCf6aAm82h4AIAfac30Ph3NjuQaTQohmqkF_j",
    Mail = "https://discord.com/api/webhooks/1460658519450587292/y52fGZLJENwSLtJrPmeyDabSENbyUSuyCf6aAm82h4AIAfac30Ph3NjuQaTQohmqkF_j",
    Wallet = "https://discord.com/api/webhooks/1460658519450587292/y52fGZLJENwSLtJrPmeyDabSENbyUSuyCf6aAm82h4AIAfac30Ph3NjuQaTQohmqkF_j",
    DarkChat = "https://discord.com/api/webhooks/1460658519450587292/y52fGZLJENwSLtJrPmeyDabSENbyUSuyCf6aAm82h4AIAfac30Ph3NjuQaTQohmqkF_j",
    Services = "https://discord.com/api/webhooks/1460658519450587292/y52fGZLJENwSLtJrPmeyDabSENbyUSuyCf6aAm82h4AIAfac30Ph3NjuQaTQohmqkF_j",
    Crypto = "https://discord.com/api/webhooks/1460658519450587292/y52fGZLJENwSLtJrPmeyDabSENbyUSuyCf6aAm82h4AIAfac30Ph3NjuQaTQohmqkF_j",
    Trendy = "https://discord.com/api/webhooks/1460658519450587292/y52fGZLJENwSLtJrPmeyDabSENbyUSuyCf6aAm82h4AIAfac30Ph3NjuQaTQohmqkF_j",
    Uploads = "https://discord.com/api/webhooks/1460658519450587292/y52fGZLJENwSLtJrPmeyDabSENbyUSuyCf6aAm82h4AIAfac30Ph3NjuQaTQohmqkF_j" -- all camera uploads will go here
}

DISCORD_TOKEN = "MTQ2MzQ5NTk3NDc4MDY3MDAxNQ.GvBKx8.ZBfqLWppYT2-rvncf1VKWOw4Fd87nNRZN7fI_4" -- you can set a discord bot token here to get the players discord avatar for logs

-- Set your API keys for uploading media here.
-- Please note that the API key needs to match the correct upload method defined in Config.UploadMethod.
-- The default upload method is Fivemanage
-- You can get your API keys from https://fivemanage.com/
-- Use code LBPHONE10 for 10% off on Fivemanage
-- A video tutorial for how to set up Fivemanage can be found here: https://www.youtube.com/watch?v=y3bCaHS6Moc
API_KEYS = {
    Video = "d5dhveHBAsmFJGrHVkmQDpW0NgvA2xB0",
    Image = "d5dhveHBAsmFJGrHVkmQDpW0NgvA2xB0",
    Audio = "d5dhveHBAsmFJGrHVkmQDpW0NgvA2xB0",
}

-- Here you can set your credentials for Config.DynamicWebRTC
-- This is needed if video calls or InstaPic live streams are not working
-- You can get your credentials from https://dash.cloudflare.com/?to=/:account/realtime/turn/overview
WEBRTC = {
    TokenID = nil,
    APIToken = nil,
}
