# Herdr Flash

Minimal letter-hint target picker for Herdr 0.7.4 or newer using native popup panes.

The plugin action opens a 56x14 session-modal popup, loads tabs from the workspace in
which it was invoked, assigns stable hints using home-row-first letters, and
focuses the matching tab. Press `Esc` to cancel and `Backspace` to clear a
partial two-letter hint. Press `Tab` to cycle through tab, workspace, and agent
selection. Selecting a workspace or agent focuses it and closes the picker.

## Local installation

```sh
herdr plugin link ~/.config/herdr/plugins/herdr-flash
```

Example keybinding:

```toml
[[keys.command]]
key = "prefix+f"
type = "plugin_action"
command = "local.herdr-flash.open"
description = "Jump to tab by letter hint"
```
