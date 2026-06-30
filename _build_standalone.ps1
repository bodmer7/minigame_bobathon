
# Builds a fully standalone index.html in the root folder.
# Images are embedded as base64 data URIs; all CSS is inlined.
# Run from the workspace root: pwsh ./_build_standalone.ps1

$root = Split-Path $MyInvocation.MyCommand.Path

function ToDataUri($relPath) {
    $bytes = [System.IO.File]::ReadAllBytes((Join-Path $root $relPath))
    return "data:image/png;base64," + [Convert]::ToBase64String($bytes)
}

$penUri   = ToDataUri "assets/rewards/pen.png"
$bugsUri  = ToDataUri "assets/rewards/bugs-sticker.png"
$keepUri  = ToDataUri "assets/rewards/keep-calm-sticker.png"
$mugUri   = ToDataUri "assets/rewards/mug.png"
$tshirtUri = ToDataUri "assets/rewards/t-shirt.png"

$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>IBM Bob · Bobathon for UBS</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Saira+Condensed:wght@400;500;600;700;800&family=IBM+Plex+Sans:ital,wght@0,400;0,500;0,600;0,700;1,500&family=IBM+Plex+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
<script src="https://unpkg.com/react@18.3.1/umd/react.development.js" integrity="sha384-hD6/rw4ppMLGNu3tX5cjIb+uRZ7UkRJ6BPkLpg4hAu/6onKUg4lLsHAs9EBPT82L" crossorigin="anonymous"></script>
<script src="https://unpkg.com/react-dom@18.3.1/umd/react-dom.development.js" integrity="sha384-u6aeetuaXnQ38mYT8rp6sbXaQe3NL9t+IBXmnYxwkUI2Hw4bsp2Wvmx4yRQF1uAm" crossorigin="anonymous"></script>
<script src="https://unpkg.com/@babel/standalone@7.29.0/babel.min.js" integrity="sha384-m08KidiNqLdpJqLq95G/LEi8Qvjl/xUYll3QILypMoQ65QorJ9Lvtp2RXYGBFj1y" crossorigin="anonymous"></script>
<style>
:root {
  --ibm-blue:#0f62fe; --ibm-blue-hover:#2f7bff; --ibm-blue-press:#0a4fd1;
  --ibm-blue-soft:#0f62fe1f; --ibm-blue-glow:#0f62fe; --code-cyan:#54c8ff;
  --black:#04060b; --ink-900:#07090f; --ink-850:#0a0d15; --ink-800:#0d111b;
  --ink-700:#11151f; --ink-600:#161b28; --ink-500:#1d2434; --ink-400:#2a3346;
  --ink-300:#3b465c; --ink-200:#64718c; --ink-100:#9aa6bd; --ink-050:#ccd4e3;
  --white:#f4f7ff;
  --bg-app:var(--ink-900); --bg-panel:var(--ink-800);
  --surface-card:var(--ink-700); --surface-raised:var(--ink-600);
  --surface-hover:var(--ink-500); --surface-inset:var(--ink-850);
  --text-strong:var(--white); --text-body:var(--ink-050);
  --text-muted:var(--ink-100); --text-faint:var(--ink-200); --text-on-accent:#ffffff;
  --border-hair:rgba(255,255,255,0.07); --border-soft:rgba(255,255,255,0.11);
  --border-strong:rgba(255,255,255,0.18); --border-accent:var(--ibm-blue);
  --success:#34d17f; --warning:#ffb22e; --danger:#ff4d4d; --info:var(--code-cyan);
  --rar-standard-core:#4b69ff; --rar-standard-bright:#7e95ff;
  --rar-standard-deep:#1b2a6b; --rar-standard-glow:#4b69ff;
  --rar-rare-core:#8847ff; --rar-rare-bright:#b48bff;
  --rar-rare-deep:#341266; --rar-rare-glow:#8847ff;
  --rar-epic-core:#d32ce6; --rar-epic-bright:#f06bff;
  --rar-epic-deep:#5a0f63; --rar-epic-glow:#d32ce6;
  --rar-legendary-core:#eb4b4b; --rar-legendary-bright:#ff7b6b;
  --rar-legendary-deep:#631414; --rar-legendary-glow:#ff3b3b;
  --rar-exotic-core:#f5b32d; --rar-exotic-bright:#ffd86b;
  --rar-exotic-deep:#6b4a06; --rar-exotic-glow:#ffc73d;
  --finish-holo:linear-gradient(115deg,#ff5b9e 0%,#ffd86b 22%,#5bffc6 45%,#54c8ff 65%,#b48bff 85%,#ff5b9e 100%);
  --finish-foil:linear-gradient(150deg,#fff4c2 0%,#f5b32d 40%,#a9760a 60%,#ffe79e 100%);
  --scan-line:rgba(255,255,255,0.025); --grid-line:rgba(120,150,255,0.05);
  --font-display:"Saira Condensed","Arial Narrow",sans-serif;
  --font-ui:"IBM Plex Sans",system-ui,-apple-system,sans-serif;
  --font-mono:"IBM Plex Mono",ui-monospace,"SFMono-Regular",monospace;
  --w-regular:400; --w-medium:500; --w-semibold:600; --w-bold:700; --w-black:800;
  --fs-hero:clamp(48px,7vw,96px); --fs-display:clamp(34px,4.5vw,56px);
  --fs-title:28px; --fs-subtitle:21px; --fs-lg:18px; --fs-base:15px;
  --fs-sm:13px; --fs-xs:11px; --fs-2xs:10px;
  --lh-tight:0.92; --lh-snug:1.1; --lh-normal:1.45;
  --ls-display:0.005em; --ls-label:0.14em; --ls-wide:0.22em; --ls-mono:0.02em;
  --sp-0:0; --sp-1:4px; --sp-2:8px; --sp-3:12px; --sp-4:16px;
  --sp-5:20px; --sp-6:24px; --sp-8:32px; --sp-10:40px; --sp-12:48px;
  --sp-16:64px; --sp-20:80px;
  --r-xs:4px; --r-sm:7px; --r-md:10px; --r-lg:14px; --r-xl:20px; --r-pill:999px;
  --clip-cut:polygon(0 0,calc(100% - 14px) 0,100% 14px,100% 100%,14px 100%,0 calc(100% - 14px));
  --sh-1:0 1px 2px rgba(0,0,0,.5); --sh-2:0 4px 14px rgba(0,0,0,.5);
  --sh-3:0 12px 34px rgba(0,0,0,.55); --sh-4:0 24px 64px rgba(0,0,0,.6);
  --inset-top:inset 0 1px 0 rgba(255,255,255,.06);
  --inset-line:inset 0 0 0 1px var(--border-hair);
  --glow-sm:0 0 0 1px color-mix(in srgb,var(--rar-core,var(--ibm-blue)) 55%,transparent),
            0 0 16px -2px color-mix(in srgb,var(--rar-glow,var(--ibm-blue)) 70%,transparent);
  --glow-md:0 0 0 1px color-mix(in srgb,var(--rar-core,var(--ibm-blue)) 70%,transparent),
            0 0 28px -4px color-mix(in srgb,var(--rar-glow,var(--ibm-blue)) 85%,transparent),
            0 8px 30px rgba(0,0,0,.5);
  --glow-lg:0 0 0 1.5px var(--rar-core,var(--ibm-blue)),
            0 0 60px -6px color-mix(in srgb,var(--rar-glow,var(--ibm-blue)) 90%,transparent),
            0 0 120px -20px var(--rar-glow,var(--ibm-blue));
  --focus-ring:0 0 0 2px var(--bg-app),0 0 0 4px var(--ibm-blue);
  --ease-out:cubic-bezier(0.16,1,0.3,1); --ease-in:cubic-bezier(0.5,0,0.75,0);
  --ease-snap:cubic-bezier(0.34,1.56,0.64,1); --ease-reel:cubic-bezier(0.12,0.8,0.06,1);
  --dur-fast:120ms; --dur-base:220ms; --dur-slow:420ms; --dur-reel:6200ms;
  --z-base:1; --z-sticky:50; --z-overlay:100; --z-modal:200; --z-toast:300;
}
[data-rarity="standard"]  { --rar-core:var(--rar-standard-core);  --rar-bright:var(--rar-standard-bright);  --rar-deep:var(--rar-standard-deep);  --rar-glow:var(--rar-standard-glow); }
[data-rarity="rare"]      { --rar-core:var(--rar-rare-core);      --rar-bright:var(--rar-rare-bright);      --rar-deep:var(--rar-rare-deep);      --rar-glow:var(--rar-rare-glow); }
[data-rarity="epic"]      { --rar-core:var(--rar-epic-core);      --rar-bright:var(--rar-epic-bright);      --rar-deep:var(--rar-epic-deep);      --rar-glow:var(--rar-epic-glow); }
[data-rarity="legendary"] { --rar-core:var(--rar-legendary-core); --rar-bright:var(--rar-legendary-bright); --rar-deep:var(--rar-legendary-deep); --rar-glow:var(--rar-legendary-glow); }
[data-rarity="exotic"]    { --rar-core:var(--rar-exotic-core);    --rar-bright:var(--rar-exotic-bright);    --rar-deep:var(--rar-exotic-deep);    --rar-glow:var(--rar-exotic-glow); }
*{box-sizing:border-box}
html,body{margin:0;padding:0;height:100%;overflow:hidden}
body{background-color:var(--bg-app);
  background-image:radial-gradient(1200px 700px at 50% -10%,color-mix(in srgb,var(--ibm-blue) 12%,transparent),transparent 60%),linear-gradient(var(--grid-line) 1px,transparent 1px),linear-gradient(90deg,var(--grid-line) 1px,transparent 1px);
  background-size:auto,44px 44px,44px 44px;background-position:center top,center,center;
  color:var(--text-body);font-family:var(--font-ui);font-size:var(--fs-base);line-height:var(--lh-normal);
  -webkit-font-smoothing:antialiased;text-rendering:optimizeLegibility}
h1,h2,h3,h4{font-family:var(--font-display);color:var(--text-strong);text-transform:uppercase;letter-spacing:var(--ls-display);line-height:var(--lh-snug);margin:0}
a{color:var(--code-cyan);text-decoration:none}
::selection{background:var(--ibm-blue);color:#fff}
*{scrollbar-width:thin;scrollbar-color:var(--ink-400) transparent}
*::-webkit-scrollbar{width:10px;height:10px}
*::-webkit-scrollbar-thumb{background:var(--ink-400);border-radius:var(--r-pill);border:2px solid transparent;background-clip:padding-box}
*::-webkit-scrollbar-thumb:hover{background:var(--ink-300)}
.sticker-art{mix-blend-mode:lighten}
@media(prefers-reduced-motion:reduce){*{animation-duration:.001ms !important;transition-duration:.001ms !important}}
#root,.stage{position:fixed;inset:0}
.stage{display:grid;place-items:center;
  background:radial-gradient(900px 520px at 50% 8%,color-mix(in srgb,var(--ibm-blue) 14%,transparent),transparent 62%),radial-gradient(1200px 800px at 50% 120%,rgba(0,0,0,.7),transparent 60%)}
.sound-btn{position:absolute;top:22px;right:24px;z-index:var(--z-overlay);
  display:inline-flex;align-items:center;gap:9px;height:42px;padding:0 16px;
  background:rgba(255,255,255,.04);border:1px solid var(--border-soft);border-radius:var(--r-pill);
  color:var(--text-muted);font-family:var(--font-display);font-weight:700;font-size:13px;
  letter-spacing:.12em;text-transform:uppercase;cursor:pointer;backdrop-filter:blur(6px)}
.sound-btn:hover{color:var(--text-body);border-color:var(--border-strong)}
.idle{display:flex;flex-direction:column;align-items:center;text-align:center;gap:4px}
.eyebrow{font-family:var(--font-mono);font-size:13px;letter-spacing:.32em;text-transform:uppercase;color:var(--code-cyan)}
.title{font-family:var(--font-display);font-weight:800;font-style:italic;font-size:clamp(46px,8vw,104px);line-height:.88;color:var(--text-strong);margin:6px 0 0;text-shadow:0 6px 40px rgba(15,98,254,.4)}
.sub{font-family:var(--font-ui);font-size:17px;color:var(--text-muted);margin:8px 0 6px}
.cap-wrap{margin:10px 0 26px}
.odds{display:flex;gap:10px;margin-top:30px;flex-wrap:wrap;justify-content:center}
.odds-item{display:inline-flex;align-items:center;gap:8px;padding:7px 14px;border-radius:var(--r-pill);
  background:rgba(255,255,255,.03);border:1px solid color-mix(in srgb,var(--rar-core) 35%,transparent)}
.odds-dot{width:9px;height:9px;border-radius:50%;background:var(--rar-core);box-shadow:0 0 10px var(--rar-glow)}
.odds-label{font-family:var(--font-display);font-weight:700;font-size:12px;letter-spacing:.08em;text-transform:uppercase;color:var(--rar-bright)}
.odds-pct{font-family:var(--font-mono);font-size:12px;color:var(--text-faint);font-variant-numeric:tabular-nums}
.spin-layer{width:100%;display:grid;place-items:center}
.reel-vp{position:relative;width:100%;height:252px;overflow:hidden}
.strip{position:absolute;left:0;top:14px;display:flex;gap:18px;padding-left:24px;will-change:transform}
.marker{position:absolute;left:50%;top:0;bottom:0;width:3px;transform:translateX(-50%);z-index:6;
  background:linear-gradient(180deg,var(--rar-exotic-core),var(--code-cyan));
  box-shadow:0 0 18px 2px color-mix(in srgb,var(--code-cyan) 70%,transparent)}
.marker::before,.marker::after{content:"";position:absolute;left:50%;transform:translateX(-50%);border-left:10px solid transparent;border-right:10px solid transparent}
.marker::before{top:-2px;border-top:13px solid var(--rar-exotic-core)}
.marker::after{bottom:-2px;border-bottom:13px solid var(--rar-exotic-core)}
.reel-fade{position:absolute;top:0;bottom:0;width:22%;z-index:5;pointer-events:none}
.reel-fade-l{left:0;background:linear-gradient(90deg,var(--bg-app),transparent)}
.reel-fade-r{right:0;background:linear-gradient(270deg,var(--bg-app),transparent)}
.reveal{position:absolute;inset:0;z-index:var(--z-modal);display:grid;place-items:center;
  background:radial-gradient(1000px 700px at 50% 50%,rgba(4,6,11,.72),rgba(4,6,11,.94));
  backdrop-filter:blur(7px);animation:fade-in .35s var(--ease-out) both;overflow:hidden}
.reveal-inner{display:flex;flex-direction:column;align-items:center;text-align:center;gap:16px}
.reveal-eyebrow{font-family:var(--font-mono);font-size:13px;letter-spacing:.34em;text-transform:uppercase;color:var(--text-muted)}
.reveal-meta{display:flex;flex-direction:column;align-items:center;gap:8px}
.reveal-name{font-family:var(--font-display);font-weight:800;font-style:italic;font-size:clamp(30px,4.2vw,52px);text-transform:uppercase;color:var(--text-strong);line-height:.95;max-width:18ch}
.reveal-rarity{display:inline-flex;align-items:center;gap:10px;font-family:var(--font-display);font-weight:700;font-size:20px;letter-spacing:.18em;text-transform:uppercase;color:var(--rar-bright)}
.rar-dot{width:13px;height:13px;border-radius:50%;background:var(--rar-core);box-shadow:0 0 16px 2px var(--rar-glow)}
.finish-tag{font-family:var(--font-mono);font-size:11px;font-weight:700;letter-spacing:.14em;color:#0a0d15;padding:3px 8px;border-radius:var(--r-xs);background-image:var(--finish-foil)}
.handover{font-family:var(--font-ui);font-size:15px;color:var(--text-faint);margin-top:-2px}
.reveal-rays{position:absolute;inset:-40%;background:conic-gradient(from 0deg,transparent 0 8deg,color-mix(in srgb,var(--rar-glow) 22%,transparent) 8deg 16deg,transparent 16deg 24deg);animation:ray-spin 14s linear infinite;opacity:.5}
.confetti{position:absolute;inset:0;pointer-events:none;overflow:hidden}
.confetti span{position:absolute;top:-6%;border-radius:1px;animation-name:confetti-fall;animation-timing-function:cubic-bezier(.4,.2,.7,1);animation-iteration-count:1}
@keyframes confetti-fall{0%{transform:translateY(-10vh) translateX(0) rotate(0deg);opacity:1}100%{transform:translateY(108vh) translateX(var(--drift)) rotate(540deg);opacity:.9}}
@keyframes cap-float{0%,100%{transform:translateY(0)}50%{transform:translateY(-12px)}}
@keyframes cap-rattle{0%,100%{transform:translate(0,0) rotate(0)}25%{transform:translate(-3px,1px) rotate(-2deg)}75%{transform:translate(3px,-1px) rotate(2deg)}}
@keyframes cap-shine{0%{transform:translateX(-120%) rotate(8deg)}100%{transform:translateX(240%) rotate(8deg)}}
@keyframes reveal-pop{0%{transform:scale(.4);opacity:0}60%{transform:scale(1.06)}100%{transform:scale(1);opacity:1}}
@keyframes ray-spin{to{transform:rotate(360deg)}}
@keyframes fade-in{from{opacity:0}to{opacity:1}}
</style>
</head>
<body>
<div id="root"></div>
<script>
window._IMG = {
  "pen": "$penUri",
  "bugs-sticker": "$bugsUri",
  "keep-calm-sticker": "$keepUri",
  "mug": "$mugUri",
  "t-shirt": "$tshirtUri"
};
</script>
<script>
(function(){
  const RARITY = {
    standard:  { key:"standard",  label:"MIL-SPEC",      weight:70 },
    rare:      { key:"rare",      label:"RESTRICTED",    weight:15 },
    epic:      { key:"epic",      label:"CLASSIFIED",    weight:10 },
    legendary: { key:"legendary", label:"COVERT",        weight:5  },
    exotic:    { key:"exotic",    label:"BOB LEGENDARY", weight:0  },
  };
  const S = (id,name,tier,finish) => ({ id,name,tier,finish:finish||"none",img:window._IMG[id] });
  const STICKERS = [
    S("pen","Bob Pen","standard","none"),
    S("bugs-sticker","Bugs Sticker","rare","none"),
    S("keep-calm-sticker","Keep Calm Sticker","rare","none"),
    S("mug","Bob Mug","epic","none"),
    S("t-shirt","Bob T-Shirt","legendary","none"),
  ];
  const byTier = {};
  for (const k of Object.keys(RARITY)) byTier[k] = STICKERS.filter(s=>s.tier===k);
  const EQUAL_ODDS = true;
  function drawSticker() {
    if (EQUAL_ODDS) return STICKERS[Math.floor(Math.random()*STICKERS.length)];
    const total = Object.values(RARITY).reduce((a,r)=>a+r.weight,0);
    let roll = Math.random()*total, tier="standard";
    for (const k of Object.keys(RARITY)) { roll-=RARITY[k].weight; if(roll<=0){tier=k;break;} }
    const pool = byTier[tier].length?byTier[tier]:STICKERS;
    return pool[Math.floor(Math.random()*pool.length)];
  }
  function buildReel(winner,len,winIndex) {
    const fp=[].concat(byTier.standard,byTier.standard,byTier.rare,byTier.epic,byTier.legendary);
    const tiles=[];
    for(let i=0;i<len;i++){ if(i===winIndex){tiles.push(winner);continue;} tiles.push(fp[Math.floor(Math.random()*fp.length)]); }
    return tiles;
  }
  window.CAPSULE_DATA={ RARITY,STICKERS,byTier,drawSticker,buildReel,EQUAL_ODDS };
})();
</script>
<script type="text/babel">
const { useState, useRef, useEffect, useMemo } = React;
const D = window.CAPSULE_DATA;
const STRIDE = 188+18;

let _ac=null;
const ac=()=>(_ac=_ac||new(window.AudioContext||window.webkitAudioContext)());
let _noise=null;
function noiseBuf(){
  if(_noise)return _noise;
  const ctx=ac(),len=Math.floor(ctx.sampleRate*0.05);
  const buf=ctx.createBuffer(1,len,ctx.sampleRate),d=buf.getChannelData(0);
  for(let i=0;i<len;i++)d[i]=(Math.random()*2-1)*Math.pow(1-i/len,2.2);
  return(_noise=buf);
}
function tick(vol=0.22){
  const ctx=ac(),t=ctx.currentTime;
  const src=ctx.createBufferSource();src.buffer=noiseBuf();
  const bp=ctx.createBiquadFilter();bp.type="bandpass";
  bp.frequency.value=2400+Math.random()*700;bp.Q.value=1.4;
  const g=ctx.createGain();
  g.gain.setValueAtTime(vol,t);g.gain.exponentialRampToValueAtTime(0.0001,t+0.045);
  src.connect(bp);bp.connect(g);g.connect(ctx.destination);src.start(t);src.stop(t+0.06);
  const o=ctx.createOscillator(),og=ctx.createGain();
  o.type="square";o.frequency.setValueAtTime(820+Math.random()*120,t);
  o.frequency.exponentialRampToValueAtTime(360,t+0.03);
  og.gain.setValueAtTime(vol*0.5,t);og.gain.exponentialRampToValueAtTime(0.0001,t+0.04);
  o.connect(og);og.connect(ctx.destination);o.start(t);o.stop(t+0.05);
}
function winSound(tier){
  const ctx=ac(),t=ctx.currentTime;
  (()=>{
    const src=ctx.createBufferSource();src.buffer=noiseBuf();
    const lp=ctx.createBiquadFilter();lp.type="lowpass";
    lp.frequency.setValueAtTime(2600,t);lp.frequency.exponentialRampToValueAtTime(90,t+0.18);
    const g=ctx.createGain();g.gain.setValueAtTime(0.55,t);g.gain.exponentialRampToValueAtTime(0.0001,t+0.22);
    src.connect(lp);lp.connect(g);g.connect(ctx.destination);src.start(t);src.stop(t+0.25);
    const bo=ctx.createOscillator(),bg=ctx.createGain();bo.type="sine";
    bo.frequency.setValueAtTime(110,t);bo.frequency.exponentialRampToValueAtTime(44,t+0.22);
    bg.gain.setValueAtTime(0.4,t);bg.gain.exponentialRampToValueAtTime(0.0001,t+0.28);
    bo.connect(bg);bg.connect(ctx.destination);bo.start(t);bo.stop(t+0.32);
  })();
  const bell=(freq,delay,vol,dur)=>{
    [[freq,1],[freq*2.756,0.28]].forEach(([f,vMul])=>{
      const o=ctx.createOscillator(),g=ctx.createGain();
      o.type=f>2000?"sine":"triangle";o.frequency.value=f;
      g.gain.setValueAtTime(0.0001,t+delay);g.gain.linearRampToValueAtTime(vol*vMul,t+delay+0.018);
      g.gain.exponentialRampToValueAtTime(0.0001,t+delay+dur*vMul);
      o.connect(g);g.connect(ctx.destination);o.start(t+delay);o.stop(t+delay+dur+0.15);
    });
  };
  const schema={
    standard:[[880,.06,.20,1.3]],
    rare:[[880,.05,.22,1.6],[1175,.15,.14,1.2]],
    epic:[[880,.05,.24,1.9],[1175,.13,.16,1.5],[1760,.24,.11,1.2]],
    legendary:[[698,.04,.26,2.1],[880,.09,.24,1.9],[1175,.17,.17,1.6],[1760,.27,.13,1.3],[2349,.40,.09,1.0]],
    exotic:[[523,.03,.26,2.3],[698,.07,.24,2.1],[880,.13,.24,1.9],[1175,.20,.19,1.6],[1568,.29,.15,1.4],[2093,.40,.12,1.2],[2793,.53,.09,1.0]],
  };
  (schema[tier]||schema.standard).forEach(([f,d,v,dur])=>bell(f,d,v,dur));
  if(["epic","legendary","exotic"].includes(tier)){
    const len=Math.floor(ctx.sampleRate*0.12),buf2=ctx.createBuffer(1,len,ctx.sampleRate),d2=buf2.getChannelData(0);
    for(let i=0;i<len;i++)d2[i]=(Math.random()*2-1)*(i/len);
    const src2=ctx.createBufferSource();src2.buffer=buf2;
    const bp=ctx.createBiquadFilter();bp.type="bandpass";bp.Q.value=0.8;
    bp.frequency.setValueAtTime(280,t+0.04);bp.frequency.exponentialRampToValueAtTime(4800,t+0.36);
    const gw=ctx.createGain();gw.gain.setValueAtTime(0.0001,t+0.04);gw.gain.linearRampToValueAtTime(0.55,t+0.18);gw.gain.exponentialRampToValueAtTime(0.0001,t+0.44);
    src2.connect(bp);bp.connect(gw);gw.connect(ctx.destination);src2.start(t+0.04);src2.stop(t+0.5);
  }
  if(["legendary","exotic"].includes(tier)){
    const count=tier==="exotic"?34:18,topFreq=tier==="exotic"?3800:2200;
    for(let i=0;i<count;i++){
      const freq=900+Math.random()*topFreq,delay=0.18+Math.random()*0.9,dur=0.18+Math.random()*0.55;
      const o=ctx.createOscillator(),g=ctx.createGain();o.type="sine";o.frequency.value=freq;
      g.gain.setValueAtTime(0.0001,t+delay);g.gain.linearRampToValueAtTime(0.055,t+delay+0.012);g.gain.exponentialRampToValueAtTime(0.0001,t+delay+dur);
      o.connect(g);g.connect(ctx.destination);o.start(t+delay);o.stop(t+delay+dur+0.05);
    }
  }
}

function CapsuleObject({ size=300, spinning=false }){
  return(
    <div style={{position:"relative",width:size,height:size*1.15,display:"flex",flexDirection:"column",alignItems:"center"}}>
      <div style={{position:"relative",width:size,height:size,
        animation:spinning?"cap-rattle .35s ease-in-out infinite":"cap-float 4.5s var(--ease-out) infinite"}}>
        <div style={{position:"absolute",inset:"-18%",borderRadius:"50%",
          background:"radial-gradient(circle,color-mix(in srgb,var(--ibm-blue) 50%,transparent),transparent 60%)",
          filter:"blur(14px)",opacity:.65}}/>
        <div style={{position:"absolute",inset:"4% 8%",borderRadius:"42% 42% 50% 50% / 38% 38% 48% 48%",
          background:"linear-gradient(148deg,#5ea4ff 0%,#1a6eff 20%,var(--ibm-blue) 42%,#0a3da0 68%,#061e6b 88%,#040e3f 100%)",
          boxShadow:["inset 0 10px 28px rgba(255,255,255,.38)","inset 0 -30px 50px rgba(0,0,0,.50)","inset 4px 0 18px rgba(255,255,255,.10)","inset -8px 0 28px rgba(0,0,0,.25)","0 34px 80px -20px var(--ibm-blue-glow)","0 10px 30px -10px rgba(0,0,0,.7)"].join(", "),
          overflow:"hidden"}}>
          <div style={{position:"absolute",top:"5%",left:"8%",width:"52%",height:"42%",
            background:"radial-gradient(ellipse at 30% 30%,rgba(255,255,255,.62),rgba(255,255,255,.10) 52%,transparent 70%)",
            borderRadius:"50%",filter:"blur(4px)"}}/>
          <div style={{position:"absolute",bottom:"6%",right:"5%",width:"30%",height:"24%",
            background:"radial-gradient(ellipse,rgba(120,170,255,.32),transparent 70%)",
            borderRadius:"50%",filter:"blur(6px)"}}/>
          <div style={{position:"absolute",top:0,left:0,width:"42%",height:"100%",
            background:"linear-gradient(90deg,rgba(255,255,255,.42),transparent)",
            filter:"blur(8px)",animation:"cap-shine 4.5s var(--ease-out) infinite"}}/>
          <div style={{position:"absolute",top:"50%",left:0,right:0,height:14,
            background:"linear-gradient(180deg,rgba(0,0,0,.42) 0%,rgba(0,0,0,.18) 50%,rgba(255,255,255,.16) 100%)",
            boxShadow:"0 1px 0 rgba(255,255,255,.2),0 -1px 0 rgba(0,0,0,.4)"}}/>
          <div style={{position:"absolute",top:"14%",left:"6%",right:"6%",bottom:"44%",
            display:"flex",flexDirection:"column",alignItems:"center",justifyContent:"center",gap:5}}>
            <span style={{fontFamily:"var(--font-display)",fontWeight:800,fontStyle:"italic",
              fontSize:size*0.092,color:"#fff",textTransform:"uppercase",letterSpacing:"0.01em",
              lineHeight:1,textShadow:"0 2px 8px rgba(0,0,0,.55)"}}>Bobathon</span>
            <span style={{fontFamily:"var(--font-mono)",fontSize:size*0.044,
              color:"rgba(255,255,255,.65)",letterSpacing:"0.18em",textTransform:"lowercase"}}>for UBS</span>
            <div style={{marginTop:3,display:"flex",flexDirection:"column",alignItems:"center",gap:4}}>
              <svg width={size*0.23} height={size*0.12} viewBox="0 0 32 18" fill="none">
                {[0,13,26].map((x,i)=>(
                  <g key={i} transform={`translate(${x},0)`}>
                    <rect x={2.7} y={8.1} width={3.6} height={9.9} rx="0.8" fill="rgba(255,255,255,.92)"/>
                    <rect x={0} y={10.1} width={2.5} height={3.1} rx="0.6" fill="rgba(255,255,255,.92)"/>
                    <rect x={6.5} y={10.1} width={2.5} height={3.1} rx="0.6" fill="rgba(255,255,255,.92)"/>
                    <circle cx={4.5} cy={4.7} r={3.96} stroke="rgba(255,255,255,.92)" strokeWidth={1.98} fill="none"/>
                  </g>
                ))}
              </svg>
              <span style={{fontFamily:"var(--font-ui)",fontWeight:700,
                fontSize:size*0.065,letterSpacing:"0.12em",color:"rgba(255,255,255,.92)",lineHeight:1}}>UBS</span>
            </div>
          </div>
          <div style={{position:"absolute",bottom:"6%",left:"14%",right:"14%",height:"28%",
            background:"radial-gradient(circle at 50% 60%,color-mix(in srgb,var(--code-cyan) 50%,transparent),transparent 70%)",
            filter:"blur(3px)",opacity:.7}}/>
        </div>
        <div style={{position:"absolute",top:"2%",left:"18%",right:"18%",height:"12%",
          background:"linear-gradient(180deg,rgba(255,255,255,.18),rgba(255,255,255,.04))",
          borderRadius:"50%",filter:"blur(1px)"}}/>
        <div style={{position:"absolute",bottom:"-4%",left:"12%",right:"12%",height:"10%",
          background:"radial-gradient(ellipse,color-mix(in srgb,var(--ibm-blue) 55%,transparent),transparent 68%)",
          filter:"blur(9px)"}}/>
      </div>
    </div>
  );
}

function GameButton({children,variant="primary",size="lg",icon,onClick,disabled,style}){
  const sizes={md:{h:50,px:24,fs:16},lg:{h:66,px:40,fs:22},xl:{h:82,px:56,fs:28}};
  const s=sizes[size]||sizes.lg;
  const variants={
    primary:{background:"linear-gradient(180deg,var(--ibm-blue-hover),var(--ibm-blue))",color:"#fff",
      boxShadow:"0 0 0 1px color-mix(in srgb,var(--ibm-blue) 60%,transparent),0 10px 30px -8px var(--ibm-blue-glow),var(--inset-top)"},
    exotic:{background:"linear-gradient(180deg,var(--rar-exotic-bright),var(--rar-exotic-core))",color:"#3a2600",
      boxShadow:"0 0 0 1px var(--rar-exotic-core),0 12px 34px -8px var(--rar-exotic-glow),var(--inset-top)",textShadow:"0 1px 0 rgba(255,255,255,.25)"},
    ghost:{background:"rgba(255,255,255,.04)",color:"var(--text-muted)",border:"1px solid var(--border-soft)"},
  };
  return(
    <button onClick={onClick} disabled={disabled}
      style={{display:"inline-flex",alignItems:"center",justifyContent:"center",gap:12,
        height:s.h,padding:`0 ${s.px}px`,fontFamily:"var(--font-display)",fontWeight:800,fontStyle:"italic",
        fontSize:s.fs,letterSpacing:".04em",textTransform:"uppercase",border:"1px solid transparent",
        borderRadius:"var(--r-md)",cursor:disabled?"default":"pointer",opacity:disabled?.45:1,
        transition:"transform var(--dur-fast) var(--ease-snap),box-shadow var(--dur-fast)",whiteSpace:"nowrap",
        ...(variants[variant]||variants.primary),...style}}
      onMouseDown={e=>!disabled&&(e.currentTarget.style.transform="translateY(2px) scale(.985)")}
      onMouseUp={e=>(e.currentTarget.style.transform="")}
      onMouseLeave={e=>(e.currentTarget.style.transform="")}>
      {icon&&<span style={{fontSize:"1.05em"}}>{icon}</span>}{children}
    </button>
  );
}

const Mark=()=><span style={{fontFamily:"var(--font-mono)",fontWeight:700,letterSpacing:"-.05em"}}>{"</>"}</span>;

function ReelTile({sticker,w=188,dim=false}){
  return(
    <div data-rarity={sticker.tier} style={{flex:`0 0 ${w}px`,width:w,height:w*1.18,padding:3,borderRadius:"var(--r-lg)",
      background:"linear-gradient(180deg,color-mix(in srgb,var(--rar-core) 60%,transparent),color-mix(in srgb,var(--rar-deep) 55%,transparent))",
      boxShadow:dim?"none":"0 0 0 1px color-mix(in srgb,var(--rar-core) 45%,transparent),0 0 24px -6px var(--rar-glow)",
      opacity:dim?.4:1,transition:"opacity .3s"}}>
      <div style={{position:"relative",height:"100%",borderRadius:"calc(var(--r-lg) - 3px)",overflow:"hidden",
        background:"radial-gradient(120% 80% at 50% 12%,color-mix(in srgb,var(--rar-core) 28%,var(--ink-850)) 0%,var(--ink-900) 72%)"}}>
        <div style={{position:"absolute",inset:0,background:"radial-gradient(70% 45% at 50% 0%,color-mix(in srgb,var(--rar-glow) 40%,transparent),transparent 70%)"}}/>
        <div style={{position:"absolute",inset:0,display:"grid",placeItems:"center",padding:"6% 6% 22%"}}>
          <img src={sticker.img} alt="" className="sticker-art" style={{width:"94%",height:"94%",objectFit:"contain",filter:"drop-shadow(0 6px 14px rgba(0,0,0,.5))"}}/>
        </div>
        <div style={{position:"absolute",left:0,right:0,bottom:0,height:6,background:"var(--rar-core)",boxShadow:"0 0 12px var(--rar-glow)"}}/>
      </div>
    </div>
  );
}

const PAL={epic:["#d32ce6","#f06bff","#54c8ff"],legendary:["#eb4b4b","#ff7b6b","#ffd86b"],exotic:["#f5b32d","#ffd86b","#fff4c2","#54c8ff"]};
function Confetti({tier}){
  const colors=PAL[tier];
  const bits=useMemo(()=>Array.from({length:140},()=>({
    left:Math.random()*100,delay:Math.random()*.6,dur:1.5+Math.random()*1.4,
    color:colors[Math.floor(Math.random()*colors.length)],rot:Math.random()*360,
    w:6+Math.random()*9,drift:(Math.random()*2-1)*80,
  })),[tier]);
  if(!colors)return null;
  return(
    <div className="confetti">
      {bits.map((b,i)=>(
        <span key={i} style={{left:b.left+"%",animationDelay:b.delay+"s",animationDuration:b.dur+"s",
          background:b.color,width:b.w,height:b.w*.45,"--drift":b.drift+"px",transform:`rotate(${b.rot}deg)`}}/>
      ))}
    </div>
  );
}

function RevealCard({sticker}){
  const finish=sticker.finish!=="none"
    ?sticker.finish==="holo"
      ?{backgroundImage:"var(--finish-holo)",mixBlendMode:"color-dodge",opacity:0.5}
      :{backgroundImage:"var(--finish-foil)",mixBlendMode:"overlay",opacity:0.42}
    :null;
  return(
    <div data-rarity={sticker.tier} style={{width:"min(34vw,360px)",padding:4,borderRadius:"var(--r-xl)",
      background:"linear-gradient(180deg,var(--rar-core),var(--rar-deep))",
      boxShadow:"0 0 0 2px var(--rar-core),0 0 90px -8px var(--rar-glow),0 0 180px -30px var(--rar-glow)",
      animation:"reveal-pop .55s var(--ease-snap) both"}}>
      <div style={{position:"relative",borderRadius:"calc(var(--r-xl) - 4px)",overflow:"hidden",aspectRatio:"1/1",
        background:"radial-gradient(120% 90% at 50% 12%,color-mix(in srgb,var(--rar-core) 32%,var(--ink-850)),var(--ink-900) 72%)"}}>
        <div style={{position:"absolute",inset:0,background:"radial-gradient(70% 50% at 50% 0%,color-mix(in srgb,var(--rar-glow) 45%,transparent),transparent 70%)"}}/>
        <div className="reveal-rays"/>
        <div style={{position:"absolute",inset:0,display:"grid",placeItems:"center",padding:"7%"}}>
          <img src={sticker.img} alt={sticker.name} className="sticker-art"
            style={{width:"92%",height:"92%",objectFit:"contain",filter:"drop-shadow(0 10px 24px rgba(0,0,0,.55))"}}/>
          {finish&&<div style={{position:"absolute",inset:0,pointerEvents:"none",...finish}}/>}
        </div>
      </div>
    </div>
  );
}

function OddsLegend(){
  const order=["standard","rare","epic","legendary","exotic"];
  if(D.EQUAL_ODDS)return(
    <div className="odds">
      <div className="odds-item" data-rarity="exotic" style={{borderColor:"color-mix(in srgb,var(--code-cyan) 45%,transparent)"}}>
        <span className="odds-dot" style={{background:"var(--code-cyan)",boxShadow:"0 0 10px var(--code-cyan)"}}/>
        <span className="odds-label" style={{color:"var(--code-cyan)"}}>Test Mode</span>
        <span className="odds-pct">All {D.STICKERS.length} items · equal chance</span>
      </div>
    </div>
  );
  return(
    <div className="odds">
      {order.map(k=>(
        <div key={k} className="odds-item" data-rarity={k}>
          <span className="odds-dot"/>
          <span className="odds-label">{D.RARITY[k].label}</span>
          <span className="odds-pct">{D.RARITY[k].weight}%</span>
        </div>
      ))}
    </div>
  );
}

function App(){
  const [phase,setPhase]=useState("idle");
  const [reel,setReel]=useState([]);
  const [winner,setWinner]=useState(null);
  const [winIndex,setWinIndex]=useState(0);
  const [sound,setSound]=useState(true);
  const stripRef=useRef(null);
  const vpRef=useRef(null);
  const soundRef=useRef(true);
  useEffect(()=>{soundRef.current=sound;},[sound]);

  function open(){
    if(soundRef.current)ac().resume();
    const w=D.drawSticker();
    const LEN=64,WIN=57;
    setWinner(w);setReel(D.buildReel(w,LEN,WIN));setWinIndex(WIN);setPhase("spinning");
  }
  function again(){setPhase("idle");setReel([]);setWinner(null);}

  useEffect(()=>{
    if(phase!=="spinning"||!reel.length)return;
    const strip=stripRef.current,vp=vpRef.current.clientWidth;
    const PAD=24,jitter=(Math.random()*.5-.25)*150;
    const finalX=-(winIndex*STRIDE+PAD+188/2-vp/2)+jitter;
    const DUR=6200;
    const ease=x=>1-Math.pow(1-x,3.6);
    const t0=performance.now();let raf,lastIdx=null;
    const frame=now=>{
      const p=Math.min(1,(now-t0)/DUR);
      const x=finalX*ease(p);
      strip.style.transform=`translateX(${x}px)`;
      const idxUnder=Math.round((vp/2-x-PAD-188/2)/STRIDE);
      if(idxUnder!==lastIdx){lastIdx=idxUnder;if(soundRef.current&&p<0.997)tick(0.07+0.18*(1-p));}
      if(p<1){raf=requestAnimationFrame(frame);return;}
      strip.style.transform=`translateX(${finalX}px)`;
      setPhase("reveal");if(soundRef.current)winSound(winner.tier);
    };
    raf=requestAnimationFrame(frame);
    return()=>cancelAnimationFrame(raf);
  },[phase,reel]);

  const rare=winner&&["epic","legendary","exotic"].includes(winner.tier);
  return(
    <div className="stage">
      <button className="sound-btn" onClick={()=>setSound(s=>!s)}>
        <span style={{fontSize:18}}>{sound?"🔊":"🔇"}</span>
        <span>SOUND {sound?"ON":"OFF"}</span>
      </button>

      {phase==="idle"&&(
        <div className="idle" key="idle">
          <div className="eyebrow">IBM&nbsp;BOB&nbsp;·&nbsp;HACKATHON&nbsp;DROP</div>
          <h1 className="title">Sticker&nbsp;Capsule</h1>
          <p className="sub">Open the capsule and draw your <Mark/>&nbsp;Bob.</p>
          <div className="cap-wrap"><CapsuleObject size={300}/></div>
          <GameButton variant="exotic" size="xl" icon={<Mark/>} onClick={open}>Open</GameButton>
          <OddsLegend/>
        </div>
      )}

      {(phase==="spinning"||phase==="reveal")&&(
        <div className="spin-layer" key="spin">
          <div className="reel-vp" ref={vpRef}>
            <div className="marker"/>
            <div className="reel-fade reel-fade-l"/>
            <div className="reel-fade reel-fade-r"/>
            <div className="strip" ref={stripRef}>
              {reel.map((s,i)=>(
                <ReelTile key={i} sticker={s} w={188} dim={phase==="reveal"&&i!==winIndex}/>
              ))}
            </div>
          </div>
        </div>
      )}

      {phase==="reveal"&&winner&&(
        <div className="reveal" key="reveal">
          {rare&&<Confetti tier={winner.tier}/>}
          <div className="reveal-inner">
            <div className="reveal-eyebrow">You drew</div>
            <RevealCard sticker={winner}/>
            <div data-rarity={winner.tier} className="reveal-meta">
              <div className="reveal-name">{winner.name}</div>
              <div className="reveal-rarity">
                <span className="rar-dot"/>
                {D.RARITY[winner.tier].label}
                {winner.finish!=="none"&&<span className="finish-tag">{winner.finish==="holo"?"HOLO":"FOIL"}</span>}
              </div>
            </div>
            <div className="handover">Please collect at the booth</div>
            <GameButton variant="primary" size="lg" onClick={again}>Open again</GameButton>
          </div>
        </div>
      )}
    </div>
  );
}

ReactDOM.createRoot(document.getElementById("root")).render(<App/>);
</script>
</body>
</html>
"@

[System.IO.File]::WriteAllText((Join-Path $root "index.html"), $html, [System.Text.Encoding]::UTF8)
$size = (Get-Item (Join-Path $root "index.html")).Length
Write-Host "index.html written. Size: $size bytes ($([math]::Round($size/1MB,2)) MB)"
