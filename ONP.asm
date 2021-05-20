.data
pytanie1: .asciiz "\n Dej miy akcje do roboty kamracie | 0 - wprowadzenie | 1 - wykonanie operacje | 2 - wynik |"
pytanie2: .asciiz "\n Co chcesz porachowac kamracie? |0 - dodawanie| 1 - odyjmowanie| 2 - mnozynie | 3 - tajlowanie |"
informacja_o_bledzie: .asciiz "\n Ajjj podales zlo cyfra"
informacja_o_koniecznoœci_wprowadzenia_wartosci_liczbowej: .asciiz "\n Wprowadz wartosc cyfrowa kamracie"
aktualny_stos: "\n Terozny twoj sztapel kamracie prezyntuje sie nastepujaco: "
spacja: .asciiz " "
wyœwietlenie_wyniku: .asciiz  "\n Jo zech porachowa³ kamracie: "
informacja_o_niemo¿liwoœci_wykonania: .asciiz "\n Potrzebujesz wiecej numerow by wykonac ta operacje"
informacja_o_pustym_stosie: .asciiz "\n Kamracie niy mosz ju¿ czego zdjac ze sztapla :("
informacja_o_za_wielkiej_ilosci_elementow: .asciiz "\n Na sztaplu musi byc ino jedyn elymynt!"
b³¹d_dzielenia: .asciiz  "\n Chopie(abo dzioucho) co przez 0 tajlujesz?"

.macro get_input(%register)            
li $v0,5                
syscall                   
move %register,$v0            
.end_macro

.macro printInt(%value)              
move $a0,%value                
li $v0,1                
syscall                 
.end_macro 

.macro printString(%value)              
li $v0,4                
la $a0,%value
syscall                 
.end_macro 

.macro push(%value)              
addi $sp,$sp,-4
sw %value,($sp)
.end_macro

.macro pop(%value)              
lw %value,($sp)
addi $sp,$sp,4
.end_macro

.macro empty()              
beq $sp,2147479548,stos_pusty
.end_macro

.text

.macro one_element()              
bne $sp,2147479544,za_du¿o
.end_macro

.text

main:

printString(pytanie1)

get_input($t0)
   
beq $t0,0,Dodawanie_liczby_na_stos
beq $t0,1,Wykonanie_operacji_znakowej 
beq $t0,2,Zakonczenie_programu_cz1

printString(informacja_o_bledzie)
b main

Dodawanie_liczby_na_stos:
printString(informacja_o_koniecznoœci_wprowadzenia_wartosci_liczbowej)
get_input($t1)
push($t1)
jal drukowanie_stosu_cz1
j main

Wykonanie_operacji_znakowej:
printString(pytanie2)
get_input($t2)
empty()
empty()
pop($t3)
pop($t5)
beq $t2,0,dodawanie
beq $t2,1,odejmowanie
beq $t2,2,mnozenie
beq $t2,3,dzielenie
printString(informacja_o_bledzie)
b main

dodawanie:
add $t4,$t5,$t3
push($t4)
jal drukowanie_stosu_cz1
j main

odejmowanie:
sub $t4,$t5,$t3
push($t4)
jal drukowanie_stosu_cz1
j main

mnozenie:
mul $t4,$t5,$t3
push($t4)
jal drukowanie_stosu_cz1
j main

dzielenie:
beq $t5,0,przez_zero
div $t3,$t5
mflo $t4
push($t4)
jal drukowanie_stosu_cz1
j main

stos_pusty:
printString(informacja_o_pustym_stosie)
b Zakonczenie_programu_cz2
Zakonczenie_programu_cz1:
one_element()
printString(wyœwietlenie_wyniku)
lw $t6,0($sp)
printInt($t6)

Zakonczenie_programu_cz2:
li $v0, 10
syscall
 
drukowanie_stosu_cz1: 
printString(aktualny_stos)
move $t7 $sp

drukowanie_stosu_cz2:
beq $sp,2147479548,drukowanie_stosu_koniec
lw $t6,0($sp)
printInt($t6)
printString(spacja)
addi $sp,$sp 4
b drukowanie_stosu_cz2

drukowanie_stosu_koniec:
move $sp $t7
jr $ra

za_du¿o:
printString(informacja_o_za_wielkiej_ilosci_elementow)
j main
przez_zero:
printString(b³¹d_dzielenia)
b Zakonczenie_programu_cz2