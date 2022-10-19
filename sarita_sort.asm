	.data
	.align 2
num: .word 7, 5, 2, 1, 1, 3, 4
	.align 0
string: .asciiz "Vetor ordenado: "
	.text
	.globl main
main:
	li $t0, 7 #t0 = MAX = 7
	li $t1, 0 #t1 = i = 0
	la $s0, num # carrega o endereço do 1 byte do vetor

loop_i:
	 bge $t1, $t0, sai_loop_i # i >= MAX
	 addi $t2, $t0, -1
loop_j:
	ble $t2, $t1, sai_loop_j #j <= i sai
	sll $t6, $t2, 2 # j*4
	add $t6, $t6, $s0 # Endereça a posição num[j]
	lw $t4, 0($t6) # t4 = num[j]
	lw $t5, -4($t6) # t5 = num[j-1]
	
	ble $t5, $t4, nao_troca
	# swap num[j-1] e num[j]
	sw $t4, -4($t6)
	sw $t5, 0($t6) 

nao_troca:
	addi $t2, $t2, -1
	j loop_j

sai_loop_j:
	addi $t1, $t1, 1
	j loop_i
	 
sai_loop_i: 
	li $v0, 4
	la $a0, string
	syscall
	
	li $v0, 1
	la $t0, num
	li, $t1, 7

imprime:
	beqz $t1, sai_imprime
	lw $a0, 0($t0)
	syscall
	addi $t0, $t0, 4
	addi $t1, $t1, -1
	j imprime
	
sai_imprime:
	li, $v0, 10
	syscall