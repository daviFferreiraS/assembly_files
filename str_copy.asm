	.data 
	.align 0
string_src: .asciiz "Barulho quero sil�ncio"
string_dst: .space 100  
	.align 2 # align para word
ptr_string_dst: .word #din alloc

	.text
	.globl main
main: 
	#percorrer a src pra encontrar o tamanho
	#percorrer a src pra ler os bytes e copiar em string_dst
	#endere�o do 1� byte de string_src
	la $t0, string_src
	lb $t1, 0($t0) #ler o primeiro byte
	li $t2, 0  #tamanho string

loop_tam:
	beqz $t1, sai_loop_tam
	addi $t2, $t2, 1
	addi $t0, $t0, 1
	lb $t1, 0($t0) #l� o prox byte
	j loop_tam
	# ou beq $zero tlgd?
	
sai_loop_tam:
	addi $t2, $t2, 1 #\0 ne vida
	
	li $v0, 9
	add $a0, $zero, $t2
	syscall
	
	la $s0, ptr_string_dst
	sw $v0, 0($s0)
	#pra economizar uma instru��o, � s� come�ar o t2 como 1, pq string sempre tem /0
	la $t0, string_src
	move $t6, $v0
	#la $t6, string_dst
	#espa�o para condi��o de parada

loop_copy: beqz $t2, sai_loop_copy
	lb $t1, 0($t0) #l� o byte
	sb $t1, 0($t6) #escreve o byte
	addi $t0, $t0, 1 #avan�a na src
	addi $t6, $t6, 1 #avan�a na dst
	addi $t2, $t2, -1
	j loop_copy
	
sai_loop_copy:
	li $v0, 4
	#la $a0, string_dst
	
	la $s1, ptr_string_dst
	lw $a0 0($s1)
	syscall
	li $v0, 10
	syscall
	