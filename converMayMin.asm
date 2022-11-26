#Solicita un string al usuario y almacena en memoria un string igual al ingresado pero escrito unicamente en minusculas

.data
	string: .space 101
	prompt: .asciiz "Ingrese el string a convertir: "
	result: .asciiz "String convertido: "
	lineSkip: "\n"

.text
	#Se pide al usuario que ingrese el string a convertir
	la $a0, prompt
	li $v0, 4
	syscall
	la $a0, string
	li $a1, 100
	li $v0, 8
	syscall
	la $a0, lineSkip
	li $v0, 4
	syscall
	
	#Se empieza a convertir el string a minusculas
	la $t0, string
	#valor hexadecimal con el sexto bit menos significativo igual a 1 y todos los demas igual a 0
	li $t1, 0x00000020

loop:
	#Se carga en $t2 la letra obtenida en $t0
	lb $t2, ($t0)
	#Si el caracter encontrado es 0 se brinca al final
	beq $t2, 0x0000000a, end
	#Se almacena en $t2 el caracter transformado a minuscula
	or $t2, $t2, $t1
	#Se reemplaza el caracter en memoria por el caracter nuevo
	sb $t2, ($t0)
	#Se avanza en memoria
	addi $t0, $t0, 1
	j loop

end:
	la $a0, result
	li $v0, 4
	syscall
	la $a0, string
	syscall
		