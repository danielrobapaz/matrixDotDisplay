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
	prompt: .asciiz "Ingrese el string (max 100 char): "
	lineSkip: .asciiz "\n"
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
	jal 	divideString		# Llamada a la funcion divideString
	j endMain


# Input: Se recibe la direccion de un string que puede o no tener mayusculas. $t0
# Output: Se devuelve el mismo string pero con todas las letras en minusculas
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
	jr $ra
	
# Input: Recibe la direccion de un string
# Output: Muestra en pantalla secciones de 20 caracteres del string
divideString:
	li $t1, 0				# apuntador de la letra
loopDivideString:
	add $t2, $t0, $t1			# $t2 es la direccion al bit a imprimir
	lb $t3, ($t2)
	beq $t3, $zero, endLoopDivideString
	
	lb $a0, ($t2)				# imprimimos el caracter string[$t2]
	li $v0, 11
	syscall
	
	addi $t1, $t1, 1
	
	li $t3, 20
	div $t1, $t3				# verificamos el resto de dividir entre 20
	mfhi $t3
	beqz $t3, endIfLoopDivideString 
ifLoopDivideString:
	j loopDivideString
endIfLoopDivideString:	
	lb $a0, lineSkip
	li $v0, 11
	syscall
	
	j loopDivideString	
	
endLoopDivideString:
	jr $ra
endMain:
	li $t0, 1