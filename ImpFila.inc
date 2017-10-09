ImprimeFila	Proc Near
; ESI apunta al offset de pantalla donde se debe imprimir. Se preserva
; EDI apunta al offset de la posición a imprimir
; EBX El tablero
	Push ESI
	Push ECX ;preservar contador anterior

	Mov Ah, ColorBase

; Repetir N veces (tamano de la linea)
	Mov ECX, N
OtroCar:
;  Tomar caracter de tablero
	Mov Al, [EBX+EDI]
	Add Ah,Al ; sumar al colorbase el numero para cambiar colores

	
Normal:
;  Pasarlo a ASCII (texto)
	Mov Al,"X"
Escribir:
;  Imprimirlo en pantalla
	Mov ES:[ESI],AX ; caracter
;  Incrementar indice Tablero
	Inc EDI
;  Incrementar indice Pantalla
	Inc ESI
	Inc ESI
   Loop OtroCar

	Pop ECX
	Pop ESI
	Ret
ImprimeFila	EndP

