#!/usr/bin/env bash
# Post-layout gate-level simulation (GLS)
# Runs all 5 programs on (1) the RTL and (2) the FINAL post-layout netlist
# from OpenLane, and checks that both produce identical results.
# Usage (from the asic/gls folder):  bash run_gls.sh  [optional: path to a RUN_ folder]
set -e
cd "$(dirname "$0")"

RUN="${1:-$(ls -d ../openlane/runs/RUN_* | tail -1)}"
NL="$RUN/final/nl/riscv_core.nl.v"
[ -f "$NL" ] || { echo "Netlist not found: $NL"; exit 1; }

MODELS="${MODELS:-$(dirname "$(find ~/.volare -path '*sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v' 2>/dev/null | head -1)")}"
[ -f "$MODELS/sky130_fd_sc_hd.v" ] || { echo "sky130 cell models not found under ~/.volare"; exit 1; }

echo "Netlist : $NL"
echo "Models  : $MODELS"
command -v iverilog >/dev/null || { echo "Install first:  sudo apt install -y iverilog"; exit 1; }

mkdir -p logs
iverilog -g2005 -o logs/rtl.vvp tb_gls.v ../openlane/riscv_core.v
iverilog -g2005 -DFUNCTIONAL -DUNIT_DELAY=#1 -o logs/gl.vvp \
  tb_gls.v "$NL" "$MODELS/primitives.v" "$MODELS/sky130_fd_sc_hd.v" 2> logs/compile_gl.txt \
  || { echo "Gate-level compile failed, see logs/compile_gl.txt"; tail -20 logs/compile_gl.txt; exit 1; }

pass=0
for p in fibonacci bubble_sort find_max grades grades_acc; do
  vvp -n logs/rtl.vvp +prog=programs/$p.mem | grep -vE "readmemh|finish called" > logs/$p.rtl.log
  vvp -n logs/gl.vvp  +prog=programs/$p.mem | grep -vE "readmemh|finish called" > logs/$p.gl.log
  if diff -q logs/$p.rtl.log logs/$p.gl.log >/dev/null; then
    echo "PASS  $p   ($(grep END logs/$p.gl.log | sed 's/END *//'))"; pass=$((pass+1))
  else
    echo "FAIL  $p   (compare logs/$p.rtl.log and logs/$p.gl.log)"
  fi
done
echo "----------------------------------------------"
echo "$pass / 5 programs: post-layout netlist == RTL"
echo "Final data memory per program is in logs/<program>.gl.log"
