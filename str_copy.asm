	.data 
	.align 0
string_src: .asciiz "Barulho quero silêncio"
string_dst: .space 100  
	.align 2 # align para word
ptr_string_dst: .word #din alloc

	.text
	.globl main
main: 
	#percorrer a src pra encontrar o tamanho
	#percorrer a src pra ler os bytes e copiar em string_dst
	#endereço do 1º byte de string_src
	la $t0, string_src
	lb $t1, 0($t0) #ler o primeiro byte
	li $t2, 0  #tamanho string

loop_tam:
	beqz $t1, sai_loop_tam
	addi $t2, $t2, 1
	addi $t0, $t0, 1
	lb $t1, 0($t0) #lê o prox byte
	j loop_tam
	# ou beq $zero tlgd?
	
sai_loop_tam:
	addi $t2, $t2, 1 #\0 ne vida
	
	li $v0, 9
	add $a0, $zero, $t2
	syscall
	
	la $s0, ptr_string_dst
	sw $v0, 0($s0)
	#pra economizar uma instrução, é só começar o t2 como 1, pq string sempre tem /0
	la $t0, string_src
	move $t6, $v0
	#la $t6, string_dst
	#espaço para condição de parada

loop_copy: beqz $t2, sai_loop_copy
	lb $t1, 0($t0) #lê o byte
	sb $t1, 0($t6) #escreve o byte
	addi $t0, $t0, 1 #avança na src
	addi $t6, $t6, 1 #avança na dst
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
	