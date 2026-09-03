#!/usr/bin/env python3
"""Rebuild the vdots-listen catalog + per-session article pages.

Reads $VDOTS_LISTEN_DIR, one session per subdirectory (meta.json + cues.json +
readability.json). Self-contained HTML (no external assets) so it opens straight
from Google Drive on any device. Each article page shows the audio player, a
readability report, and the verbatim transcript that follows along with playback.
"""
import html
import json
import os
import sys

ROOT = os.environ.get("VDOTS_LISTEN_DIR") or os.path.expanduser("~/ai/outbox/listen")


def load_json(path):
    try:
        with open(path) as fh:
            return json.load(fh)
    except (OSError, ValueError):
        return None


def sessions(root):
    out = []
    for name in sorted(os.listdir(root)):
        d = load_json(os.path.join(root, name, "meta.json"))
        if not d:
            continue
        d["_dir"] = name
        d["_read"] = load_json(os.path.join(root, name, d.get("readability", "") or "x")) or {}
        out.append(d)
    out.sort(key=lambda d: d.get("iso", ""), reverse=True)
    return out


def dur(s):
    try:
        s = int(float(s))
    except (TypeError, ValueError):
        return ""
    return f"{s // 60}m {s % 60:02d}s"


PALETTE = """
:root{color-scheme:light dark;--fg:#1a1a1a;--bg:#fafafa;--card:#fff;--muted:#666;--line:#e3e3e3;--accent:#3b6ea5;--hl:#fff3c4}
@media(prefers-color-scheme:dark){:root{--fg:#e8e8e8;--bg:#16161a;--card:#1f1f24;--muted:#9a9a9a;--line:#33333a;--accent:#7fb0dd;--hl:#3a3620}}
*{box-sizing:border-box}
body{margin:0;font:16px/1.6 -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif;color:var(--fg);background:var(--bg)}
.wrap{max-width:760px;margin:0 auto;padding:2rem 1.25rem 4rem}
a{color:var(--accent)}
h1{font-size:1.5rem;margin:0 0 .25rem}
.sub{color:var(--muted);margin:0 0 1.5rem;font-size:.9rem}
"""

CATALOG_CSS = PALETTE + """
article{background:var(--card);border:1px solid var(--line);border-radius:12px;padding:1rem 1.15rem;margin:0 0 1rem}
article h2{font-size:1.12rem;margin:0 0 .3rem}
article h2 a{color:var(--fg);text-decoration:none}
article h2 a:hover{color:var(--accent)}
.meta{color:var(--muted);font-size:.83rem;margin:0 0 .7rem}
audio{width:100%;height:38px}
.empty{color:var(--muted);text-align:center;padding:3rem 0}
footer{color:var(--muted);font-size:.8rem;text-align:center;margin-top:2rem}
"""

ARTICLE_CSS = PALETTE + """
.back{font-size:.85rem;margin:0 0 1rem}
audio{width:100%;margin:0 0 1rem}
.report{background:var(--card);border:1px solid var(--line);border-radius:10px;padding:.8rem 1rem;margin:0 0 1.5rem;font-size:.9rem}
.report b{font-weight:600}
.report .grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(130px,1fr));gap:.4rem .9rem;margin-top:.5rem;color:var(--muted)}
#t p,#t h2,#t li,#t blockquote{margin:.5rem 0;padding:.15rem .4rem;border-radius:5px;cursor:pointer;transition:background .15s}
#t h2{font-size:1.15rem;margin-top:1.4rem}
#t blockquote{border-left:3px solid var(--line);color:var(--muted)}
#t .active{background:var(--hl)}
#t .code{font-family:ui-monospace,Menlo,monospace;color:var(--muted);font-size:.9rem}
.toc{background:var(--card);border:1px solid var(--line);border-radius:10px;padding:.6rem 1rem;margin:0 0 1rem;font-size:.9rem}
.toc ol{margin:.4rem 0 0;padding-left:1.3rem}
.toc a{text-decoration:none}
"""


def esc(s):
    return html.escape(str(s or ""))


def build_catalog(items, machine):
    p = [
        "<!doctype html><html lang=en><head><meta charset=utf-8>",
        '<meta name=viewport content="width=device-width,initial-scale=1">',
        "<title>Listen</title><style>", CATALOG_CSS, "</style></head><body><div class=wrap>",
        "<h1>🎧 Listen</h1>",
        f'<p class="sub">{len(items)} read-through{"" if len(items)==1 else "s"} · synced from {esc(machine)}'
        ' · <a href="index.md">on Google Drive open index.md</a> (the player below only works in a real browser)</p>',
    ]
    if not items:
        p.append('<p class="empty">Nothing published yet. Run <code>vdots-listen publish FILE.md</code>.</p>')
    for s in items:
        d = esc(s["_dir"])
        r = s["_read"]
        nch = len(s.get("chapters") or [])
        meta = " · ".join(x for x in (
            esc(s.get("date")), dur(s.get("duration")),
            esc(s.get("voice")) if s.get("voice") not in (None, "auto") else "",
            (f'grade {r["flesch_kincaid_grade"]}' if r.get("flesch_kincaid_grade") is not None else ""),
            (r.get("reading_ease_band") or ""),
            (f"{nch} chapters" if nch else ""),
        ) if x)
        rich = s.get("audio_rich")
        rich_l = (f' · <a href="{d}/{esc(rich)}">m4a</a>'
                  if rich and rich != s.get("audio") else "")
        p += [
            "<article>",
            f'<h2><a href="{d}/{esc(s.get("article"))}">{esc(s.get("title", s["_dir"]))}</a></h2>',
            f'<p class="meta">{meta}</p>',
            f'<audio controls preload=none src="{d}/{esc(s.get("audio"))}"></audio>',
            f'<p class="meta"><a href="{d}/{esc(s.get("audio"))}">audio</a>{rich_l} · '
            f'<a href="{d}/{esc(s.get("report", s.get("doc")))}">report</a> · '
            f'<a href="{d}/{esc(s.get("transcript", ""))}">transcript</a></p>',
            "</article>",
        ]
    p += ["<footer>generated by vdots-listen</footer>", "</div></body></html>"]
    return "\n".join(p)


ARTICLE_JS = """
(function(){
  var a=document.getElementById('player'), t=document.getElementById('t');
  if(!a) return;
  [].forEach.call(document.querySelectorAll('[data-seek]'), function(el){
    el.addEventListener('click', function(ev){
      ev.preventDefault();
      a.currentTime=parseFloat(el.dataset.seek)||0; a.play();
    });
  });
  if(!t) return;
  // flatten one level of ul/ol so list-item cues are tracked too
  var nodes=[], cur=-1;
  [].forEach.call(t.children, function(c){
    if(c.tagName==='UL'||c.tagName==='OL'){ [].forEach.call(c.children, function(li){ nodes.push(li); }); }
    else nodes.push(c);
  });
  nodes.forEach(function(n,i){ n.addEventListener('click',function(){
    var s=parseFloat(n.dataset.start); if(!isNaN(s)){ a.currentTime=s; a.play(); }
  });});
  a.addEventListener('timeupdate',function(){
    var ct=a.currentTime, hit=-1;
    for(var i=0;i<nodes.length;i++){
      var s=parseFloat(nodes[i].dataset.start), e=parseFloat(nodes[i].dataset.stop);
      if(ct>=s && ct<e){ hit=i; break; }
      if(ct>=s) hit=i;
    }
    if(hit!==cur){
      if(cur>=0) nodes[cur].classList.remove('active');
      if(hit>=0){ nodes[hit].classList.add('active');
        nodes[hit].scrollIntoView({block:'center',behavior:'smooth'}); }
      cur=hit;
    }
  });
})();
"""


def build_article(s, sdir):
    cues = load_json(os.path.join(sdir, s.get("cues", "") or "x")) or []
    r = s["_read"]
    title = esc(s.get("title", s["_dir"]))

    body = []
    open_ul = False
    for c in cues:
        kind = c.get("kind", "para")
        txt = esc(c.get("text", ""))
        attrs = f'data-start="{c.get("start",0):.2f}" data-stop="{c.get("stop",0):.2f}"'
        if kind != "list" and open_ul:
            body.append("</ul>"); open_ul = False
        if kind == "heading":
            body.append(f"<h2 {attrs}>{txt}</h2>")
        elif kind == "list":
            if not open_ul:
                body.append("<ul>"); open_ul = True
            body.append(f"<li {attrs}>{txt}</li>")
        elif kind == "quote":
            body.append(f"<blockquote {attrs}>{txt}</blockquote>")
        elif kind == "code":
            body.append(f'<p class="code" {attrs}>{txt}</p>')
        else:
            body.append(f"<p {attrs}>{txt}</p>")
    if open_ul:
        body.append("</ul>")

    report = ""
    if r:
        exp = s.get("spoken_minutes")
        last = (
            f"<span>expected ~{exp} min</span>"
            if exp not in (None, "", "None")
            else f'<span>{r.get("polysyllabic_words","?")} long words</span>'
        )
        report = (
            '<div class="report">'
            f'<b>Readability</b> — grade {r.get("flesch_kincaid_grade","?")} · '
            f'{esc(r.get("reading_ease_band",""))} '
            f'(Flesch {r.get("flesch_reading_ease","?")})'
            '<div class="grid">'
            f'<span>{r.get("words","?")} words</span>'
            f'<span>{r.get("sentences","?")} sentences</span>'
            f'<span>{r.get("avg_words_per_sentence","?")} words/sentence</span>'
            f'<span>~{r.get("listening_time_min","?")} min listen</span>'
            f'<span>~{r.get("reading_time_min","?")} min read</span>'
            f'{last}'
            "</div></div>"
        )

    chapters = s.get("chapters") or []
    toc = ""
    if chapters:
        links = "".join(
            f'<li><a href="#" data-seek="{c.get("start",0):.2f}">{esc(c.get("title",""))}</a></li>'
            for c in chapters
        )
        toc = f'<nav class="toc"><b>Chapters</b><ol>{links}</ol></nav>'

    src = s.get("source_url")
    src_link = f' · <a href="{esc(src)}">source</a>' if src not in (None, "", "None") else ""

    rich = s.get("audio_rich")
    rich_link = (f' · <a href="{esc(rich)}">m4a&nbsp;(chapters)</a>'
                 if rich and rich != s.get("audio") else "")
    vid_link = f' · <a href="{esc(s["video"])}">read-along&nbsp;video</a>' if s.get("video") else ""
    guide_link = f' · <a href="{esc(s["guide"])}">guide&nbsp;PDF</a>' if s.get("guide") else ""
    brief_link = f' · <a href="{esc(s["brief"])}">analysis&nbsp;brief</a>' if s.get("brief") else ""
    mani_link = f' · <a href="{esc(s["manifest"])}">research&nbsp;manifest</a>' if s.get("manifest") else ""

    return "\n".join([
        "<!doctype html><html lang=en><head><meta charset=utf-8>",
        '<meta name=viewport content="width=device-width,initial-scale=1">',
        f"<title>{title}</title><style>", ARTICLE_CSS, "</style></head><body><div class=wrap>",
        '<p class="back"><a href="../index.html">&larr; Listen</a></p>',
        f"<h1>{title}</h1>",
        f'<p class="sub">{esc(s.get("date"))} · {dur(s.get("duration"))} · '
        f'{esc(s.get("voice"))} · <a href="{esc(s.get("doc"))}">document</a> · '
        f'<a href="{esc(s.get("report", s.get("doc")))}">report</a> · '
        f'<a href="{esc(s.get("vtt"))}">captions</a>{vid_link}{guide_link}{brief_link}{mani_link}{rich_link}{src_link}</p>',
        f'<audio id="player" controls preload="none" src="{esc(s.get("audio"))}"></audio>',
        f'<p class="sub"><a href="{esc(s.get("audio"))}">open the audio directly</a>'
        ' if the player above is blank'
        + (f', or watch the <a href="{esc(s["video"])}">read-along video</a>' if s.get("video") else "")
        + ' (Google Drive preview blocks the player above)</p>',
        toc,
        report,
        '<div id="t">', *body, "</div>",
        f"<script>{ARTICLE_JS}</script>",
        "</div></body></html>",
    ])


def build_md(items):
    # The Google Drive surface: Drive renders this on a phone and the links are
    # tappable — tap the audio to play it, tap the report to read along.
    out = ["# 🎧 Listen", ""]
    if not items:
        return "# 🎧 Listen\n\n_Nothing published yet._\n"
    for s in items:
        d = s["_dir"]
        r = s["_read"]
        nch = len(s.get("chapters") or [])
        meta = " · ".join(x for x in (
            s.get("date", ""), dur(s.get("duration")),
            (f'grade {r["flesch_kincaid_grade"]} ({r.get("reading_ease_band","")})'
             if r.get("flesch_kincaid_grade") is not None else ""),
            (f"{nch} chapters" if nch else ""),
        ) if x)
        rich = s.get("audio_rich")
        links = [f'▶ [Play]({d}/{s.get("audio","")})',
                 ]
        if s.get("video"):
            links.append(f'🎬 [Read-along video]({d}/{s["video"]})')
        links += [f'[Report]({d}/{s.get("report", s.get("doc",""))})',
                  f'[Transcript]({d}/{s.get("transcript","")})']
        if s.get("guide"):
            links.append(f'[Guide PDF]({d}/{s["guide"]})')
        if s.get("brief"):
            links.append(f'[Analysis brief]({d}/{s["brief"]})')
        if s.get("manifest"):
            links.append(f'[Research manifest]({d}/{s["manifest"]})')
        if rich and rich != s.get("audio"):
            links.append(f'[Chaptered m4a]({d}/{rich})')
        out += [f'## {s.get("title", d)}', "", meta, "", " · ".join(links), ""]
        chapters = s.get("chapters") or []
        if chapters:
            marks = " · ".join(
                f'{int(c.get("start",0))//60}:{int(c.get("start",0))%60:02d} {c.get("title","")}'
                for c in chapters)
            out += [f"**Chapters:** {marks}", ""]
    return "\n".join(out).rstrip() + "\n"


def main():
    os.makedirs(ROOT, exist_ok=True)
    items = sessions(ROOT)
    machine = os.uname().nodename.split(".")[0]
    for s in items:
        sdir = os.path.join(ROOT, s["_dir"])
        with open(os.path.join(sdir, s.get("article", "article.html")), "w") as fh:
            fh.write(build_article(s, sdir))
    with open(os.path.join(ROOT, "index.html"), "w") as fh:
        fh.write(build_catalog(items, machine))
    with open(os.path.join(ROOT, "index.md"), "w") as fh:
        fh.write(build_md(items))
    return 0


if __name__ == "__main__":
    sys.exit(main())
