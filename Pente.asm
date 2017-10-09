;Definición de contantes
CR Equ 10 ;Ir a inicio de línea
LF Equ 13 ;Cambio de línea
DOS Equ 21H ;Interrupción de Input
Bios Equ 10H ;No se

SegVideo Equ 0B800H ;Inicio de segnmento de video
AnchoP Equ 80 ;Ancho de pantalla en caracteres
LargoLin Equ AnchoP*2 ;Ancho de pantall en bytes

;Segmento de Datos
N Equ 5 ;Tamaño del tablero N * N
ColorBase Equ 7fH ;Color base negro

Datos Segment

Tablero Db 0,0,0,0,0
	Db 0,0,0,0,0
	Db 0,0,0,0,0
	Db 0,0,0,0,0
	Db 0,0,0,0,0
	Db 100 dup (0) ;En 0 el resto

Jug1 db 13 dup (?) ;Jugador puede tener maximo 10 caracters
Jug2 db 13 dup (?) ;Jugador puede tener maximo 10 caracters
	
Datos EndS

Pila Segment Stack "Stack"
	DW 100 Dup (0)
Pila EndS

Codigo Segment
.486
Assume CS:Codigo, DS:Datos, SS:Pila

;Include Tablero.inc
;Include Partida.inc
;Include Teclas.inc
Include ImpFila.inc

Init:
	mov Ax,Datos
	mov DS,Ax
	mov Ax,SegVideo
	mov ES,Ax

Main:
	;call SelecNom
	
	;mov Dx, Offset Jug1
	;mov Ah,09H
	;Int DOS
	
	;mov Dx, Offset Jug2
	;mov Ah,09H
	;Int DOS
	
	Mov EBX, Offset Tablero
	Mov ESI,LargoLin*3+ 20 ; posicion en pantalla 
	Call ImpTablero
	
	Salir:
		Mov Ah,4CH
		Int 21H

		
SelecNom Proc
	;Trabaja sobre el Jugador que está guardado en el registro Dx
	mov Cx, 10 ;Para poder realizar el loop
	EscogerNom1:
	;Permite que el usuario seleccione un nombre
	;tamaño máximo es 10
		mov Bx,10
		sub Bx,Cx
		
		mov Ah,07H
		Int DOS
		
		cmp Al,LF ;Ve si el Usuario le dio enter
		je FinNom1 ;Salta a FinNom si le dio ENTER
		
		mov Jug1[Bx],Al ;Guarda la tecla escogida en el luga que le corresponde
	loop EscogerNom1
	
	FinNom1:
		mov Jug1[Bx],CR
		inc Bx
		mov Jug1[Bx],LF
		inc Bx
		mov Jug1[Bx],"$"
		
		
	mov Cx, 10 ;Para poder realizar el loop
	EscogerNom2:
	;Permite que el usuario seleccione un nombre
	;tamaño máximo es 10
		mov Bx,10
		sub Bx,Cx
		
		mov Ah,07H
		Int DOS
		
		cmp Al,LF ;Ve si el Usuario le dio enter
		je FinNom2 ;Salta a FinNom si le dio ENTER
		
		mov Jug2[Bx],Al ;Guarda la tecla escogida en el luga que le corresponde
	loop EscogerNom2
	
	FinNom2:
		mov Jug2[Bx],CR
		inc Bx
		mov Jug2[Bx],LF
		inc Bx
		mov Jug2[Bx],"$"
		
	ret
	
SelecNom EndP


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
		mov Al,"s"
		Int DOS
		
		Add ESI, LargoLin
	Loop OtraLinea

	Ret
ImpTablero EndP

	Codigo EndS

End Main