# Proyecto 1, Organizacion del computador CI3815
# Integrantes:
# 	Daniel Robayo, 18-11086
# 	Santiago Finamore, 18-10125
#
# Descripciond el problema:
# 	Dado un string ingresado por el usuaio, se desea mostrar en pantalla el mismo
#	string escrito usando matriz dot display.
#
# Algunas limitaciones:
#	El string de entrada no puede superar los 100 caracteres.
#	Al mostrar el resultado en pantalla se debe limitar a maximo 20 caracteres por 
#	por linea, es decir, de darse el caso se imprimiran varias lineas


.data
	string: .space 101		# espacio reservado para el input
	segment: .space 20 		# espacion reservado para guardar los segmentos del string
	prompt: .asciiz "Ingrese el string (max 100 char): "
	lineSkip: .asciiz "\n"
	zeroStr: .asciiz "\0"
	asterisk: .asciiz "*"
	blankSpace: .asciiz " "
	
	# se carga en memoria las letras usando arrays de 5 bytes
	A: .byte 0x10, 0x18, 0x14, 0x1e, 0x11
	B: .byte 0x1c, 0x12, 0x1c, 0x12, 0x1f
	C: .byte 0x1e, 0x10, 0x10, 0x10, 0x1f
	D: .byte 0x1c, 0x12, 0x11, 0x11, 0x1f
	E: .byte 0x1c, 0x10, 0x1e, 0x10, 0x1f
	F: .byte 0x1f, 0x10, 0x1c, 0x10, 0x10
	G: .byte 0x1f, 0x10, 0x17, 0x1d, 0x01
	H: .byte 0x11, 0x11, 0x0e, 0x11, 0x11
	I: .byte 0x1e, 0x04, 0x04, 0x04, 0x0f
	J: .byte 0x1f, 0x01, 0x01, 0x09, 0x0f
	K: .byte 0x12, 0x14, 0x1c, 0x12, 0x11 
	L: .byte 0x01, 0x02, 0x04, 0x08, 0x1f
	M: .byte 0x10, 0x1b, 0x15, 0x11, 0x11
	N: .byte 0x10, 0x19, 0x15, 0x13, 0x11
	O: .byte 0x0e, 0x11, 0x11, 0x11, 0x0e
	P: .byte 0x1e, 0x19, 0x1e, 0x10, 0x10
	Q: .byte 0x0c, 0x12, 0x16, 0x0e, 0x01
	R: .byte 0x18, 0x14, 0x18, 0x14, 0x13
	S: .byte 0x1c, 0x10, 0x1f, 0x01, 0x07
	T: .byte 0x1f, 0x15, 0x04, 0x04, 0x04
	U: .byte 0x10, 0x11, 0x11, 0x11, 0x1f
	V: .byte 0x11, 0x09, 0x05, 0x03, 0x01
	W: .byte 0x11, 0x11, 0x15, 0x15, 0x1f
	X: .byte 0x1d, 0x06, 0x04, 0x0c, 0x17
	Y: .byte 0x11, 0x0a, 0x04, 0x08, 0x10
	Z: .byte 0x1f, 0x02, 0x0e, 0x08, 0x1f
main: 
.text
	la 	$a0, prompt
	li 	$v0, 4
	syscall
	la 	$a0, string
	li 	$a1, 100		# Se pide el input al usuario
	li 	$v0, 8
	syscall
	
	la 	$t0, string		 
	jal 	toLowerCase		# Llamada a la funcion toLowerCase
	
	la 	$t0, string		# $t0 tiene la direccion al string
	jal 	matrixDotDisplay	# Llamada a la funcion divideString
	j endMain


# Input: Se recibe la direccion de un string que puede o no tener mayusculas. 
# 	 Se espera que el string este cargado en $t0
# Output: Se devuelve el mismo string pero con todas las letras en minusculas
#	  No se devuelven registro		 
toLowerCase: 
	li 	$t1, 0x00000020
loopToLowerCase:
	lb 	$t2 ($t0) 					# se carga en $t2 la letra en $t0
	beq 	$t2, 0x0000000a, endLoopToLowerCase		# Condicion de parada del ciclo
	or 	$t2, $t2, $t1 					# Se transforma a minusculas el caracter en $t0
	sb 	$t2, ($t0) 					# reemplazamos el caracter
	addi 	$t0, $t0, 1					# avanzamos en la memoria
	
	j	loopToLowerCase
endLoopToLowerCase:
	jr 	$ra
	
# Input: Recibe la direccion de un string
# 	 Se espera que el string este en $t0
# Output: Muestra en pantalla secciones de 20 caracteres del string
matrixDotDisplay:
	li 	$t1, 0					# contador de letras
	la 	$t2, segment				# cargamos la direccion de segment
loopMatrixDotDisplay:
	lb 	$t3, ($t0)				# $t3 es un registro auxilar
	beq 	$t3, $zero, endLoopMatrixDotDisplay

	sb 	$t3, ($t2)				# cargamos la palabra en el 
	addi 	$t2, $t2, 1
	lb 	$t3, zeroStr				
	sb 	$t3, ($t2)				# se carga un \0 para terminar el string
	
	addi 	$t0, $t0, 1
	addi 	$t1, $t1, 1
	
	li 	$t3, 20
	div 	$t1, $t3				# verificamos el resto de dividir entre 20
	mfhi 	$t3
	beqz 	$t3, endIfLoopMatrixDotDisplay 
ifLoopMatrixDotDisplay:
	j 	loopMatrixDotDisplay
endIfLoopMatrixDotDisplay:
	addi	$sp, $sp, -4 				
	sw 	$ra, 0($sp)				# Empilamos la $ra actual	 
	jal 	printSegment				# Llamada a printSegment, $t2 = segment	
	lw 	$ra, 0($sp)				# desempilamos $ra de la pila
	addi 	$sp, $sp, 4		
	
	la 	$t2, segment 				# reseteamos el apuntador del del segemto
	j 	loopMatrixDotDisplay	
	
endLoopMatrixDotDisplay:
	addi 	$sp, $sp, -4
	sw 	$ra, 0($sp)				# empilamos $ra a la pila					
	jal 	printSegment				# llamada
	lw	$ra, 0($sp)				# desempilamos
	addi	$sp, $sp, 4 

	jr $ra
	
# Input: Un segmento de caracteres
# Output: Se muestra en pantalla en formato matrixDotDisplay la frase que contenga el string
printSegment:
	la	$a0, segment
	li	$v0, 4
	syscall
	
	la 	$a0, lineSkip
	syscall
	jr	$ra
	
	
endMain:
	li $t0, 1

