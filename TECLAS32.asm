; Definici�n de constantes
CR	Equ 10
LF	Equ 13
DOS	Equ 21H
Bios	Equ 10H
TEsc	Equ 27 ; tecla Esc

;Segmento de datos
Datos Segment

Teclas	DB "A","C","F",0
Procs   DW ProcA,ProcC,ProcF

TeclaEsp Db ";","<","H","P",0
ProcsE	DW P_F1,P_F2,P_FArr,P_FAba
Rot_NoteclaEsp DB "Tecla especial <"
TeclaE	Db ?
	Db "> no encontrada",CR,LF,"$"

Letras	DW LetraA,LetraC,LetraF ; vector de direccs de rotulos

LetraA	Db "procesando letra A",CR,LF,"$"
LetraC	Db "procesando letra C",CR,LF,"$"
LetraF  Db "Nuevo proceso F",CR,LF,"$"
F1	Db "Tecla especial F1",CR,LF,"$"
F2	Db "Tecla especial F2",CR,LF,"$"
Arr	Db "Tecla especial Flecha Arriba",CR,LF,"$"
Aba	Db "Tecla especial Flecha Abajo",CR,LF,"$"

Rot1	Db "Digito la tecla >"
Tecla	DB ?,"< ",CR,LF,"$"
Datos EndS

Pila Segment Stack "Stack"
	DW 100 Dup (0)
Pila EndS

Codigo Segment
.486
Assume CS:Codigo, DS:Datos, SS:Pila

Princ:
	Mov Ax,Datos
	Mov DS,Ax

Otra:	
	Mov AH,07H 
	Int DOS
	
	Cmp Al, TEsc
	JE Salir
	Mov Tecla,Al
	; Escribir una hilera terminada en $
	Push Ax		;presevar la tecla le�da
	Mov ah,09h
	Mov DX, Offset Rot1
	Int DOS

	Pop Ax 	; Recuperar tecla le�da
	Call ProcTecla

	Jmp Otra
Salir:
	Mov Ah,4CH
	Int 21H

ProcTecla Proc
; Procesa la tecla contenida en AL y llama al procedimiento respectivo
	Push ESI
	Xor ESI,ESI
	Cmp AL,0	; Es tecla especial?
	JNE O2
	Call TeclaEspecial
	Jmp S1		; Devolverse
O2:
	Cmp Teclas[ESI],0
	JE S1		; Termin� de buscar en la tabla
	Cmp Teclas[ESI],AL
	JE procesa
	Inc ESI ; buscar siguiente
	Jmp O2
Procesa:
;Procesar las teclas, m�todo General
	; Escribir rotulo general
	Mov ah,09h	; Escribir rotulo especifico de la letra encontrada
	Mov DX, Letras[ESI*2]
	Int 21H

	Call Procs[ESI*2] ; procesar segun el proc correspondiente
S1:	
	Pop ESI
	Ret
ProCTecla EndP

TeclaEspecial Proc Near
	Mov AH,07H 
	Int 21H ; Lee tecla en AL posterior al 0 de tecla especial
	
	Mov TeclaE, Al ; guardarla por si no la encuntra poner mensaje
	
	Xor ESI,ESI	; en 0 para busqueda en el vector TeclaEsp
O3:
	Cmp TeclaEsp[ESI],0
	JE TE_S1		; Termin� de buscar en la tabla
	Cmp TeclaEsp[ESI],AL
	JE pro2
	Inc SI ; buscar siguiente
	Jmp O3
Pro2:
	Call ProcsE[ESI*2] ; procesar segun el proc correspondiente
	Jmp TE_Fin
TE_S1:
	; Escribir una hilera terminada en $
	Mov ah,09h
	Mov DX, Offset Rot_NoteclaEsp
	Int 21H
	
TE_Fin:
	Ret
TeclaEspecial EndP

ProcA Proc
	; Escribir una hilera teriminada en $
	Mov ah,09h
	Mov DX, Offset LetraA
	Int 21H
	
	Ret
ProcA EndP

ProcC Proc
	; Escribir una hilera teriminada en $


	Mov ah,09h
	Mov DX, Offset LetraC
	Int 21H
	
	Ret
ProcC EndP

ProcF Proc Near
	; Escribir una hilera teriminada en $
	Mov ah,09h
	Mov DX, Offset LetraF
	Int 21H
Ret
ProcF EndP

P_F1 Proc Near
	; Escribir una hilera teriminada en $
	Mov ah,09h
	Mov DX, Offset F1
	Int 21H
Ret
P_F1 EndP

P_F2 Proc Near
	; Escribir una hilera teriminada en $
	Mov ah,09h
	Mov DX, Offset F2
	Int 21H
Ret
P_F2 EndP

P_FArr Proc Near
	; Escribir una hilera teriminada en $
	Mov ah,09h
	Mov DX, Offset Arr
	Int 21H
Ret
P_FArr EndP

P_FAba Proc Near
	; Escribir una hilera teriminada en $

	Mov ah,09h
	Mov DX, Offset Aba
	Int 21H
Ret
P_FAba EndP

Codigo EndS

	End Princ