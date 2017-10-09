; Definición de constantes
CR	Equ 10
LF	Equ 13
DOS	Equ 21H
Bios	Equ 10H

SegVideo	Equ 0B800h
AnchoP		Equ 80 ; ancho pantalla en caracteres
LargoLin	Equ AnchoP*2 ; Largo en bytes de una linea en pantalla

;Segmento de datos

N Equ 5 ; tam tablero N X N
ColorBase Equ 7fH ; Amarillo?

Datos Segment
Tablero Db 0,0,0,0,0
	Db 0,0,0,0,0
	Db 0,0,0,0,0
	DB 0,0,0,0,0
	Db 0,0,0,0,0
	db 100 dup (0) ; el resto

Datos EndS

Pila Segment Stack "Stack"
	DW 100 Dup (0)
Pila EndS

Codigo Segment
.486
Assume CS:Codigo, DS:Datos, SS:Pila

Include ImpFila.inc
cosa	Proc Near

	Ret
Cosa	EndP

ImpTablero Proc
; Imprime un tablero (EBX) en pantalla de dimensiones NXN
; N   es global y debe estar definido con anterioridad
; EBX está la dirección inical del tablero NXN
; ESI tiene el offset inicial en pantalla
; EDI tiene el indice al tablero apuntado por EBX. Interno.
	Mov ECX, N ;N Filas
	Xor EDI, EDI ; Posicion inicial en 0
OtraLinea:
	Call ImprimeFila ; preserva ESI
	Int 3
	; Cambiar de linea
	Add ESI, LargoLin
  Loop OtraLinea

	Ret
ImpTablero EndP


Princ:
	Mov Ax,Datos
	Mov DS,Ax
	Mov Ax, SegVideo
	Mov ES, Ax ; ES= Mem Video
	
	Mov EBX, Offset Tablero
	Mov ESI,LargoLin*3+ 20 ; posicion en pantalla 
	Call ImpTablero

	Mov Ah,4CH
	Int 21H
Codigo EndS

	End Princ