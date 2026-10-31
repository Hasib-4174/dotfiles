#!/usr/bin/env python3
# Workspace list for polybar (replaces internal/i3): same look, but the private
# space (lock workspace) is never shown. Click = go there, scroll = prev/next (no wrap).
import json, os, sys, subprocess, i3ipc

PRIVATE = "\U000f033e"
HERE = os.path.dirname(os.path.abspath(__file__))

def colors():
    try: return json.load(open(os.path.expanduser("~/.config/i3/colors.json")))
    except Exception: return {"bg": "#141414", "dim": "#808080", "accent": "#db8095", "urgent": "#ef6c7c"}

def visible(i3):
    ws = [w for w in i3.get_workspaces() if w.name != PRIVATE]
    return sorted(ws, key=lambda w: (w.num if w.num >= 0 else 999, w.name))

if len(sys.argv) > 1 and sys.argv[1] in ("next", "prev"):     # scrolling
    i3 = i3ipc.Connection(); ws = visible(i3)
    names = [w.name for w in ws]
    cur = next((w.name for w in ws if w.focused), None)
    if cur in names:
        i = names.index(cur) + (1 if sys.argv[1] == "next" else -1)
        if 0 <= i < len(names): i3.command(f'workspace "{names[i]}"')
    sys.exit()

def render(i3, *_):
    c = colors(); out = []
    for w in visible(i3):
        n = w.name.replace(":", "\\:")
        if w.focused:   txt = f"%{{B{c['accent']}}}%{{F{c['bg']}}} {w.name} %{{F-}}%{{B-}}"
        elif w.urgent:  txt = f"%{{B{c['urgent']}}}%{{F{c['bg']}}} {w.name} %{{F-}}%{{B-}}"
        elif w.visible: txt = f" {w.name} "
        else:           txt = f"%{{F{c['dim']}}} {w.name} %{{F-}}"
        out.append(f"%{{A1:i3-msg -q workspace \"{n}\":}}{txt}%{{A}}")
    me = os.path.join(HERE, "workspaces.py")
    print(f"%{{A4:{me} prev:}}%{{A5:{me} next:}}" + "".join(out) + "%{A}%{A}", flush=True)

i3 = i3ipc.Connection()
render(i3)
for ev in ("workspace", "window::urgent", "output"):
    i3.on(ev, render)
i3.main()
