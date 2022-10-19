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
	
	add $s0, $v0, 0

	add $a0, $v0, 0
	jal fact
	
	move $s3, $v0
	
	
	li $v0, 4
	la $a0, string2
	syscall
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	li $v0, 4
	la $a0, string3
	syscall
	
	li $v0, 1
	move $a0, $s3
	syscall
	
	li $v0, 10
	syscall
		
 fact:
 	addi $sp, $sp, -8 # abrindo espaço pra stackar 2 coisas
 	sw $ra, 4($sp)
 	sw $a0, 0($sp)
 	
 	slti $t0, $a0, 1
 	beq $t0, $zero, L1
 	
 	addi $v0, $zero, 1 
 	addi $sp, $sp, 8
 	jr $ra
 	
 L1:
 	addi $a0, $a0, -1
 	jal fact
 	lw $a0, 0($sp)
 	lw $ra, 4($sp)
 	addi $sp, $sp, 8
 	
 	mul $v0, $a0, $v0
 	jr $ra
 	
 
 