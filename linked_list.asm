# Trabalho 1 - SSC0902 � Organiza��o e Arquitetura de Computadores
# Prof. Sarita Mazzini Bruschi
#
# Alunos: Davi Fagundes Ferreira da Silva   NUSP: 12544013 
#         Murillo Moraes Martins                  12701599 
#         Rebeca Vieira Carvalho                  12543530

.data

.align 0
str_input: .asciiz "Digite o n�mero de n�s da lista (Pelo menos 5 n�s): "
str_id: .asciiz "ID: "
str_str_input: .asciiz "String: "
str_string: .asciiz " String: "
str_print: .asciiz "Imprimindo lista: \n"
jump_line: .asciiz "\n"

.align 2
# Ponteiro do inicio da lista
ptr_head: .word -1

.text
.globl main

main:
  ##### Leitura da quantidade de n�s da lista ####
  input:
    #imprimindo string input
        la   $a0, str_input
        li   $v0, 4
        syscall    
  
    li $v0, 5 # Le os n_nos
    syscall
    move $s0, $v0 # $s0 tem n_nos
    
    li $t1, 5
  blt $s0, $t1, input
  
  #### Cri��o da lista e inser��o din�mica dos n�s ####
  read_loop: beqz $s0 end_read_loop
    
    la $a0, ptr_head
    jal add_node # Chama funcao
    addi $s0, $s0, -1
    
    j read_loop
    
  end_read_loop:
  
  #### Impress�o da lista ligada ####
      la   $a0, str_print #imprimindo string print
      li   $v0, 4
      syscall 
  
  # Carrega o valor do ponteiro
  la $a0, ptr_head
  # Chama fun��o de imprimir lista
  jal print_list
  
  #### Fim da Execu��o ####
  li $v0, 10
  syscall
  
  


##### Fun��o de adi��o do n�s na lista (Params: ponteiro_head) #####
add_node:
  #### Inicializando vari�veis ####
  move $t6, $a0 # Coloca prox em t6
  
  li $t1, -1 # End = -1
  
  la $t5, ($t6) # Carrega o valor do ponteiro em t5
  lw $t2, 0($t5) # Last = ponteiro_head
  
  #### Encontra o fim da lista ####
  find_last_loop: # While prox != -1
    
    beq $t2, $t1, end_find_last_loop # if Last == -1 -> break
    
    addi $t2, $t2, 36 # Vai para a posicao do prox
    lw $t5, 0($t2) # Carrega o endereco do prox em Last
    
    beq $t5, $t1, end_find_last_loop # if prox == -1 -> break
    move $t2, $t5 # Else Last = prox
    
    j find_last_loop
  end_find_last_loop:
  
  #### Aloca 40 bytes ####
  li, $v0, 9
  addi $a0, $zero, 40
  syscall
  move $t4, $v0 # Endereco da posicao esta em $t4
    
  #### Leitura dos valores do n� ####
  #imprimindo string 'ID: '
      la   $a0, str_id
      li   $v0, 4
      syscall     
    
  # Le o int
  li $v0, 5 
  syscall
  move $t3, $v0 # ID esta em t3
  
  sw $t3, 0($t4) # Escreve ID na posicao
  addi $t4, $t4, 4 # Acrescenta 4 posicoes no endereco do n�
  
  #imprimindo string 'String: '
      la   $a0, str_str_input
      li   $v0, 4
      syscall 
  
  # Le a string
  li $v0, 8
  la $a0, 0($t4) # Coloca a posicao para escrita no a0 para leitura
  la $a1, 32
  syscall
  
  #### Retira o \n ####
  
    # Salvando na stack endere�o de retorno
    addi $sp, $sp -4
    sw $ra, 0($sp)
      la $a0, 0($t4)
      
      # Chama funcao de remove_n
      jal remove_n
      
      # Desempilhando
    lw $ra, 0($sp)
    addi $sp, $sp, 4
  
  #### Atualiza os valores da lista ####
  addi $t4, $t4, 32 # Atualiza o valor do ponteiro para a posicao do prox
  sw $t1, 0($t4) # Coloca prox no final
  addi $t4, $t4, -36 # Vai para o inicio do Espa�o alocado
  
  #### Verifica se lista est� vazia e atualiza ponteiro_head ####
  beq $t2, $t1, else # if last != -1
    sw $t4, 0($t2)
    j end_if
    
  else: #### Atualiza o last e o ponteiro (primeira ocorr�ncia) ####
    la $t5, ($t6) # Carrega o endere�o do ponteiro
    sw $t4, 0($t5) # Atualiza o ponteiro do inicio
  end_if:  

  jr $ra
  
##### Fun��o que remove o \n de uma string (Params: ptr_String) #####
remove_n:
  # Stackando registradores
    addi $sp, $sp -8
    sw $t0, 0($sp)
    sw $t1, 4($sp)

# Executando fun��o
    li $t0, '\n'   # armazenando \n
    lb $t1, 0($a0)  #1� byte da string
  loop_find_n:
      beq $t1, $t0, exit_find_n  #vendo se estamos em um \n
      beqz $t1, exit_find_n    #vendo se estamos em um \0
     addi $a0, $a0, 1      #avan�a na string
      lb $t1, 0($a0)        #salva o caractere
      j loop_find_n
  exit_find_n:
  sb $zero, 0($a0)  #substituindo �ltimo byte por \0
    
    # Desempilhando
  lw $t0, 0($sp)
  lw $t1, 4($sp)
    addi $sp, $sp, 8
    
    jr $ra


  
  
##### Impress�o da lista ligada (Params: ponteiro_head) #####
print_list:
    #### Inicializando registradores ####
    li   $t0, -1    #t0 = -1
    lw $t1, 0($a0)  #t1 = endere�o do head
    
    #### Loop da impress�o ####
    print_loop:
        beq $t1, $t0, end_print_loop
  
        #imprimindo ID
        la   $a0, str_id
        li   $v0, 4
        syscall      #imprimindo string 'ID: '
        
        lw   $a0, 0($t1)  #carregando ID do n�
        li   $v0, 1
        syscall      #imprimindo ID
        addi $t1, $t1, 4  #avan�ando ponteiro
    
        #imprimindo string
        la   $a0, str_string
        li   $v0, 4
        syscall      #imprimindo 'String: '
        
        la   $a0, 0($t1)    #carregando string do n�
        li   $v0, 4
        syscall      #imprimindo string
        
        #imprimindo string
        la   $a0, jump_line
        li   $v0, 4
        syscall      #imprimindo '\n'
        
        addi $t1, $t1, 32  #avan�ando ponteiro
    
        #pulando para pr�ximo endere�o
        lw   $t2, 0($t1)  #lendo pr�ximo
        move $t1, $t2    #carregando para o registrador que cont�m o endere�o
    
        j print_loop
    end_print_loop:
    
    jr $ra