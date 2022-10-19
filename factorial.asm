.data 
.align 0
string1: .asciiz "Digite o N para calcular o fatorial "
string2: .asciiz "O fatorial de "
string3: .asciiz " eh "

.text 
.globl main

main: 
	li $v0, 4 #Printando a primeira string
	la $a0, string1
	syscall
	
	li $v0, 5 #Lendo o Input do usuário 
	syscall 

	move $t3, $v0 #Passando o valor de v0 para t3
	
	li $t4, 1 # Onde vai ficar o fatorial
	
	move $t5, $t3 #t5 é o contador e t3 é o n
	
	li $t6, 1 # Condição de Parada
	
loopfat:
	ble $t5, $t6, sailoop #se t5 < t6, vai pra sailoop
	mul $t4, $t4, $t5
	add $t5, $t5, -1
	j loopfat
	
sailoop:
	li $v0, 4
	la $a0, string2
	syscall 
	
	li $v0, 1
	move $a0, $t3
	syscall
	
	li $v0, 4
	la $a0, string3
	syscall 
	
	li $v0, 1
	move $a0, $t4
	syscall 
	
	li $v0, 10
	syscall
	