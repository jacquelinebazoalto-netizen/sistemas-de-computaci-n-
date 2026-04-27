set pagination off
set debuginfod enabled off

# ─── PUNTO 1: justo en el call (xmm0 ya cargado, retaddr aún NO en stack) ──
break *0x400643

# ─── PUNTO 2: primera instrucción de convertir_gini (retaddr YA en stack) ──
break convertir_gini

# Solo la primera iteración
ignore 1 0
ignore 2 0

run < test_input.txt

# ════════════════════════════════════════════════════════════════════════════
echo \n╔══════════════════════════════════════════════════════════════════╗\n
echo   PUNTO 1 — ANTES del call a convertir_gini\n
echo   xmm0 tiene el float (42.4), la retaddr NO está en el stack aún\n
echo ╚══════════════════════════════════════════════════════════════════╝\n

echo --- RSP / RBP ---\n
info registers rsp rbp

echo --- xmm0: argumento float (bits como int32 en v4_float[0]) ---\n
p/f (float)$xmm0.v4_float[0]

echo --- Stack (8 quadwords desde RSP) ---\n
x/8xg $rsp

echo --- Instrucciones a punto de ejecutarse (call incluido) ---\n
x/3i $rip

continue

# ════════════════════════════════════════════════════════════════════════════
echo \n╔══════════════════════════════════════════════════════════════════╗\n
echo   PUNTO 2 — DURANTE: primera instrucción de convertir_gini\n
echo   El call empujó la retaddr: RSP decrementó 8 bytes\n
echo ╚══════════════════════════════════════════════════════════════════╝\n

echo --- RSP / RBP (RSP debe ser PUNTO1_RSP - 8) ---\n
info registers rsp rbp

echo --- xmm0 intacto con el argumento ---\n
p/f (float)$xmm0.v4_float[0]

echo --- Stack: [RSP] es la dirección de retorno ---\n
x/8xg $rsp

echo --- Disassembly completo de convertir_gini ---\n
disassemble convertir_gini

# ── instrucción 1: cvtss2si eax, xmm0 ──────────────────────────────────────
stepi
echo \n--- Tras cvtss2si eax,xmm0: float truncado en eax ---\n
info registers rax
p (int)$eax

# ── instrucción 2: add eax, 1 ───────────────────────────────────────────────
stepi
echo \n--- Tras add eax,1: resultado final (truncado + 1) ---\n
info registers rax
p (int)$eax

# ── instrucción 3: ret ──────────────────────────────────────────────────────
stepi

# ════════════════════════════════════════════════════════════════════════════
echo \n╔══════════════════════════════════════════════════════════════════╗\n
echo   PUNTO 3 — DESPUÉS del ret: de vuelta en main\n
echo   RSP restaurado (= RSP de PUNTO 1); resultado en eax/rax\n
echo ╚══════════════════════════════════════════════════════════════════╝\n

echo --- RSP / RBP restaurados ---\n
info registers rsp rbp

echo --- eax: valor devuelto por convertir_gini ---\n
info registers rax
p (int)$eax

echo --- Stack restaurado (igual que en PUNTO 1) ---\n
x/8xg $rsp

quit
