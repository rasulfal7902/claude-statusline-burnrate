#!/usr/bin/env python3
"""ANSI SGR -> HTML spans. Reads stdin, writes span-wrapped HTML lines."""
import sys, re, html

def xterm256(n):
    if n < 16:
        base = ['#000000','#cd3131','#0dbc79','#e5e510','#2472c8','#bc3fbc','#11a8cd','#e5e5e5',
                '#666666','#f14c4c','#23d18b','#f5f543','#3b8eea','#d670d6','#29b8db','#ffffff']
        return base[n]
    if n < 232:
        n -= 16
        steps = [0,95,135,175,215,255]
        r, g, b = steps[n//36], steps[(n//6)%6], steps[n%6]
        return f'#{r:02x}{g:02x}{b:02x}'
    v = 8 + (n-232)*10
    return f'#{v:02x}{v:02x}{v:02x}'

BASIC = {31:'#f85149', 32:'#3fb950', 33:'#d4c11f', 34:'#409bf0', 35:'#d670d6', 36:'#4dd0e1', 37:'#e6edf3'}
SGR = re.compile(r'\x1b\[([0-9;]*)m')

def convert(text):
    out, pos = [], 0
    color, dim = None, False
    def open_span():
        style = []
        if color: style.append(f'color:{color}')
        if dim: style.append('color:#767f8b') if not color else style.append('opacity:.62')
        return f'<span style="{";".join(style)}">' if style else '<span>'
    for m in SGR.finditer(text):
        if m.start() > pos:
            out.append(open_span() + html.escape(text[pos:m.start()]) + '</span>')
        pos = m.end()
        params = [int(p) for p in m.group(1).split(';') if p != ''] or [0]
        i = 0
        while i < len(params):
            p = params[i]
            if p == 0: color, dim = None, False
            elif p == 2: dim = True
            elif p in BASIC: color = BASIC[p]
            elif p == 38 and i+2 < len(params) and params[i+1] == 5:
                color = xterm256(params[i+2]); i += 2
            i += 1
    if pos < len(text):
        out.append(open_span() + html.escape(text[pos:]) + '</span>')
    return ''.join(out)

for line in sys.stdin.read().split('\n'):
    print(f'<div class="row">{convert(line)}</div>' if line.strip() else '<div class="gap"></div>')
