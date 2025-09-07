# EasyNotifications

**EasyNotifications** is a lightweight and customizable notification system for Roblox.  
It allows you to display styled notifications with different themes, animations, shapes, and positions.  
Fully configurable with support for custom fonts, colors, transparency profiles, and UI strokes.

---

## Features

- **Themes**: Customize the look of notifications
  - DarkOne, RosePine, Neon, Light, Gray
- **Transparency Profiles**: Control background/text transparency
  - Solid, Soft, Ghosty
- **Animations**: Various appearing/disappearing animations
  - Fade, SlideUp, SlideLeft, Pop, SlideRightWipe
- **Shapes**: Choose between rounded or blocky notifications
  - Rounded, Blocky
- **UI Stroke**: Add outline stroke for better visibility
- **Font**: Custom font support (`Enum.Font`)
- **Position**: Define where notifications appear on screen
  - TopLeft, TopRight, BottomLeft, BottomRight, Center, TopCenter
- **Notification Types**: Predefined colors for Info, Success, Warning, Error

---
[Watch Preview1.mkv](./Preview1.mkv)
---

## Configuration

| Property | Description |
|----------|-------------|
| `Notification.Config.Duration` | Time (in seconds) the notification stays on screen |
| `Notification.Config.TweenTime` | Duration of the animation Tween |
| `Notification.Config.MaxNotifications` | Maximum number of notifications on screen |
| `Notification.Config.Theme` | Default theme |
| `Notification.Config.TransparencyProfile` | Default transparency profile |
| `Notification.Config.Animation` | Default animation |
| `Notification.Config.Shape` | Default shape |
| `Notification.Config.UseUIStroke` | Enable/disable UIStroke |
| `Notification.Config.CustomTextColor` | Optional custom text color |
| `Notification.Config.Font` | Text font |
| `Notification.Config.Position` | Default position |

---

## Usage Examples

```lua
-- Set a theme
Notification:SetTheme("Neon")

-- Set transparency
Notification:SetTransparency("Soft")

-- Set an animation
Notification:SetAnimation("SlideUp")

-- Set the notification shape
Notification:SetShape("Rounded")

-- Enable UI Stroke
Notification:EnableUIStroke(true)

-- Set a custom font
Notification:SetFont(Enum.Font.GothamBold)

-- Set notification position
Notification:SetPosition("TopCenter")

-- Display a notification
Notification:Notify("This is an info notification", "Info")
Notification:Notify("Operation successful", "Success")
Notification:Notify("Be careful!", "Warning")
Notification:Notify("An error occurred", "Error")
