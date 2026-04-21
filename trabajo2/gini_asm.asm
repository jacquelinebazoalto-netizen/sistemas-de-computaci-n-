section .text
global convertir_gini

; int convertir_gini(float valor)
; Parametro: valor GINI como float en xmm0 (System V AMD64 ABI)
; Retorno:   entero en eax (truncado + 1)
convertir_gini:
    cvtss2si eax, xmm0      ; float → int (redondeo hacia cero)
    add      eax, 1
    ret
