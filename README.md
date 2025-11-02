Perfect — here’s a **complete, professional `README.md`** for your widget project **“ZenCount”**, structured to look great on GitHub and ready to drop into your repo folder:

---

# 🕒 ZenCount – Minimal Countdown Widget for KDE Plasma

**ZenCount** is a modern and minimalist KDE Plasma widget designed to help you track events, goals, and milestones with elegance.
It allows you to **add, edit, delete, and manage multiple countdown timers** — all in a clean, intuitive interface that integrates beautifully with your desktop.

---

## 🌟 Features

* 🧘 **Minimal & Elegant UI** – Designed to feel native to KDE Plasma.
* ⏳ **Multiple Countdown Timers** – Track multiple goals or events.
* 🎨 **Dynamic Color Themes** – Each timer gets its own color accent.
* ⚡ **Real-Time Updates** – Auto-refresh every minute.
* 💾 **Persistent Data** – Timers are saved and restored automatically.
* 🖱️ **Interactive Controls** – Add, edit, or delete timers with one click.
* 🧩 **Compact & Full Views** – Seamlessly switch between panel and popup views.

---

## 📸 Preview

*(You can add screenshots later here)*

```text
Compact View → shows remaining days/hours  
Full View → displays all active countdowns with edit & delete options
```

---

## 📂 Folder Structure

```
org.chatgpt.zencount/
├── metadata.desktop
├── contents/
│   ├── ui/
│   │   └── main.qml
│   └── config/
│       ├── main.xml
│       └── config.qml
└── LICENSE
└── README.md
```

---

## ⚙️ Installation

### 🧩 Manual Install (Recommended for Development)

1. Create widget folder:

   ```bash
   mkdir -p ~/.local/share/plasma/plasmoids/org.chatgpt.zencount
   ```
2. Copy all project files into that folder.
3. Run:

   ```bash
   plasmapkg2 -t plasmoid -i ~/.local/share/plasma/plasmoids/org.chatgpt.zencount
   ```
4. If updating:

   ```bash
   plasmapkg2 -t plasmoid -u ~/.local/share/plasma/plasmoids/org.chatgpt.zencount
   ```
5. Add it to your desktop or panel from **"Add Widgets" → ZenCount**.

---

## 🧠 Usage

* **Left Click** → Open or close full view.
* **Add Timer** → Create new countdown with name & date.
* **Edit** → Modify existing timers easily.
* **Delete** → Remove completed or unnecessary timers.
* **Compact Mode** → Displays active countdown text (Days/Hours/Minutes left).

---

## 🛠️ Configuration Files

| File               | Purpose                                  |
| ------------------ | ---------------------------------------- |
| `main.qml`         | Core logic & UI layout for the widget    |
| `main.xml`         | Defines config keys for saving timers    |
| `config.qml`       | Links configuration with Plasma settings |
| `metadata.desktop` | Identifies the widget to Plasma          |

---

## 🔧 Troubleshooting

If the widget doesn’t appear:

```bash
plasmapkg2 -t plasmoid -r org.chatgpt.zencount
plasmapkg2 -t plasmoid -i ~/.local/share/plasma/plasmoids/org.chatgpt.zencount
kquitapp5 plasmashell && kstart5 plasmashell
```

**Common issues:**

* ❌ *Expected token numeric literal*: Check for extra characters before `import QtQuick` in `main.qml`.
* 🧩 Widget not listed: Ensure `metadata.desktop` is valid and uses correct `X-KDE-PluginInfo-Name`.

---

## 🧑‍💻 Developer Notes

ZenCount is built with:

* **QML / QtQuick 2.15**
* **Plasma Components 3.0**
* **PlasmaCore**
* **Declarative Applet Scripting**

Goal: Keep it **lightweight**, **aesthetic**, and **hackable**.

---

## 📜 License

Released under the **GPL-3.0 License**.
You’re free to modify and redistribute with credit.

---

## ❤️ Contribute

Pull requests are welcome!
If you find bugs or have feature ideas, open an [issue](../../issues) or submit a PR.

---

Would you like me to generate a **`metadata.desktop`** that perfectly matches this new project name (`ZenCount`) and avoids errors like the previous “Expected token numeric literal”?
