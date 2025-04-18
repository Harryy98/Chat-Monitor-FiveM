# 🚨  Chat Moderation Logger

A  **chat moderation system** for FiveM servers that automatically detects and logs offensive messages and unauthorized Discord invites. It logs them to a Discord webhook, takes automated action like kicking, and broadcasts moderation alerts to the server.

---

## 📌 Features

- 🔞 **Offensive Language Detection**  
  Detects racial and homophobic slurs (including spaced versions) and automatically kicks the player.

- 📩 **Unauthorized Discord Link Blocking**  
  Blocks Discord and dsc.gg invite links unless they match your approved code (e.g., `discord.gg/server`).

- ⚠️ **Live Alerts to Discord**  
  Sends clean, embedded moderation alerts to your server’s moderation Discord channel.

- 🦺 **Automatic Player Warnings and Kicks**  
  Violations can trigger an in-game warning or auto-kick with a ticket appeal link.

---

## 📄 File Overview

- `server.lua` – Main file for handling chat message events, link detection, and webhook logging.

---

## ⚙️ Setup Instructions

1. **Place the Script in Your Server Resources**  
   Drop the folder into your `resources/` directory.

2. **Configure `server.cfg`**  
   Add this to your server config:
   ```cfg
   ensure Chat-Monitor-FiveM
   ```

3. **Edit Webhook and Invite Code**  
   Open `server.lua` and configure the following at the top:
   ```lua
   local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/your_webhook_here"
   local WHITELISTED_INVITE = "yourdiscord" -- Just the invite code, not the full URL
   ```

---

## 🔐 How to Add Permissions (Bypass Invite Filter)

To allow trusted staff to post Discord invites without being warned, grant them the `staff-p` ACE permission.

1. Open your `server.cfg` and add:
   ```cfg
   add_ace identifier.discord:YOUR_DISCORD_ID_HERE staff-p allow
   ```

2. Replace `YOUR_DISCORD_ID_HERE` with their full Discord identifier, like:
   ```cfg
   add_ace identifier.discord:123456789012345678 staff-p allow
   ```

---

## 📝 Example Discord Message

```md
**Moderation**
Name: `Player`  
Message: `join discord.gg/boostmeuplol`

Action: Player attempted to post unauthorized Discord invite link.
```

---

## 🛠️ Customization

- **Add/Remove Banned Words**  
  Modify the `offensiveWords` list in `monitor.lua` to update what gets flagged.

- **Adjust Actions (Kick/Warn)**  
  Inside `handleViolation()`, control whether to `DropPlayer()` or just `TriggerClientEvent()` a warning.

- **Change Webhook Embed Appearance**  
  Change color, title, or format inside the `sendToDiscord()` function.

---

## 📢 Ticket Link Customization

The auto-kick message includes a link for players to appeal via Discord. This link auto-adjusts based on `WHITELISTED_INVITE`.

> Example: If your invite code is `server`, the kick message will say:
>  
> `"If this is a mistake, please make a ticket at https://discord.gg/server"`
