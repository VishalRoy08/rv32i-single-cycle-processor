#!/usr/bin/env bash
# Prints the sign-off results of the latest OpenLane run as a short table.
# Usage (from the project folder):  bash signoff_summary.sh  [optional RUN_ folder]
cd "$(dirname "$0")"
RUN="${1:-$(ls -d runs/RUN_* | tail -1)}"
python3 - "$RUN/final/metrics.json" <<'PY'
import json, sys
m = json.load(open(sys.argv[1]))
def g(k, d="n/a"): return m.get(k, d)
period = None
try:
    import re
    cfg = json.load(open(sys.argv[1].replace("final/metrics.json", "resolved.json")))
    period = float(cfg.get("CLOCK_PERIOD"))
except Exception: pass
rows = [
 ("Die area (um^2)",                 g("design__die__area")),
 ("Cell instances",                  g("design__instance__count")),
 ("Std-cell utilization",            g("design__instance__utilization")),
 ("Total power (W)",                 g("power__total")),
 ("Wire length (um)",                g("route__wirelength")),
 ("Setup WNS, all corners (ns)",     g("timing__setup__ws")),
 ("Setup WNS, typical tt (ns)",      g("timing__setup__ws__corner:nom_tt_025C_1v80")),
 ("Hold WNS, all corners (ns)",      g("timing__hold__ws")),
 ("Routing DRC errors",              g("route__drc_errors")),
 ("Magic DRC errors",                g("magic__drc_error__count")),
 ("KLayout DRC errors",              g("klayout__drc_error__count")),
 ("LVS errors",                      g("design__lvs_error__count")),
 ("Antenna violating nets",          g("antenna__violating__nets")),
 ("Max slew violations",             g("design__max_slew_violation__count")),
 ("Max cap violations",              g("design__max_cap_violation__count")),
 ("Max fanout violations",           g("design__max_fanout_violation__count")),
]
print(f"Run: {sys.argv[1].split('/final')[0]}")
if period: print(f"Clock period: {period} ns ({1000/period:.1f} MHz)")
print("-"*52)
for k,v in rows:
    if isinstance(v,float): v = round(v,4)
    print(f"{k:34s}{v}")
ws = g("timing__setup__ws", None)
if period and isinstance(ws,(int,float)):
    print("-"*52); print(f"Estimated all-corner Fmax: {1000/(period-ws):.1f} MHz")
PY
