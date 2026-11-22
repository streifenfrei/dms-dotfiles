# dms-dotfiles

My personal [Dux Modular Shell](https://duxlabs.dev/docs/dms/cli-setup) (dms) and Hyprland settings.

Managed as a **bare git repository**: git dir at `~/.dotfiles.git`, worktree at `~/.config` — so this README lives at `~/.config/README.md` and the tracked files *are* the live files. DMS edits them in place and they show up directly in `git status`.

Only files that store **my own** settings are tracked. Everything DMS generates on its own (`~/.config/hypr/dms/{colors,outputs,layout,cursor,input,binds,windowrules}.lua`, `firefox.css`, …) is deliberately left out and recreated with `dms setup`.

## Contents

| File | What it is | Who writes it |
|---|---|---|
| `dms/settings.json` | DMS settings (bars, dock, launcher, keybindings, …) | DMS (my settings) |
| `dms/themes/autumnLeafs/autumn_leafs.json` | My custom "Autumn" theme | me |
| `dms/plugins.lock.json` | Installed plugins and their exact revisions (audioFx) | `dms plugins lock` |
| `hypr/hyprland.lua` | Hyprland entry config: DMS startup block + requires | `dms setup` writes it initially, won't clobber it |
| `hypr/dms/user.lua` | My custom Hyprland settings (layout, animations, window rules) | me — DMS never touches it |
| `hypr/dms/binds-user.lua` | My keybind overrides | me / DMS keybind editor |

`.dotfiles-exclude` is the track-exactly list, wired in via `core.excludesFile` (see below).

## Day-to-day use

```zsh
alias dotfiles='git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME/.config'

dotfiles status                     # what changed in the live files
dotfiles add dms/settings.json      # stage (or: dotfiles add -u)
dotfiles commit -m "..."
dotfiles push                       # after adding a remote
```

Untracked noise from the rest of `~/.config` is hidden (`status.showUntrackedFiles no`) and excluded from `git add` by `.dotfiles-exclude`.

## Fresh install

```sh
git clone --bare <remote-url> ~/.dotfiles.git
git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME/.config config core.excludesFile $HOME/.config/.dotfiles-exclude
git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME/.config config status.showUntrackedFiles no
git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME/.config checkout main -- .
dms setup            # (re)creates the generated dms/*.lua fragments
dms plugins restore  # reinstalls audioFx at the pinned revision
hyprctl reload && hyprctl configerrors
```

## Notes

- `dms/settings.json` hardcodes my home directory in the theme path — adjust it if you install elsewhere.
- **Load order:** `user.lua` is required *before* the DMS-managed modules, so DMS settings (gaps, rounding, keyboard layouts) win on conflicts. Move the `require("dms.user")` line to the end of `hyprland.lua` to make my values win instead.
- If a DMS update ever rewrites `hyprland.lua`, re-add the `require("dms.user")` line (a backup lands in `~/.config/hypr/.dms-backups/`).
- Saving in the DMS keybind editor rewrites `binds-user.lua` keeping only `hl.bind`/`hl.unbind` lines — so it only manages binds, never `user.lua`.
- GNU stow doesn't work here: DMS saves `settings.json` atomically (temp file + rename), which replaces a symlink with a plain file and silently desyncs the repo.
