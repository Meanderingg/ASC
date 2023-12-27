.data
	mlines: .space 4
	nCells: .space 4
	p: .space 4
	x: .space 4
	y: .space 4
	i: .space 4
	j: .space 4

	k: .space 4
	nriter: .space 4

	mat: .zero 1600 #initializeaza cu zero spatiul din memorie
	mat2: .zero 1600

	formatScanf: .asciz "%d"
	formatPrintf: .asciz "%d "
	endl: .asciz "\n"
.text
.global main

main:
	push $mlines
	push $formatScanf
	call scanf
	addl $8, %esp

	push $nCells
	push $formatScanf
	call scanf
	addl $8, %esp 

	push $p
	push $formatScanf
	call scanf
	addl $8, %esp 

	movl $0, %ecx
	movl $mat, %edi

et_p:
	cmp p, %ecx
	je main_continue

	push %ecx

	push $x
	push $formatScanf
	call scanf
	addl $8, %esp 

	movl mlines, %eax
	cmp x, %eax
	jle et_exit # verificarea datelor de intrare	

	push $y
	push $formatScanf
	call scanf
	addl $8, %esp 

	movl nCells, %eax
	cmp y, %eax
	jle et_exit # verificarea datelor de intrare	

	pop %ecx
	
	mov x, %eax
	inc %eax #adaugam 1 pt bordarea matricei
	
	movl nCells, %ebx
	add $2, %ebx #adaugam 2 la nr de coloane pt bordare
	mull %ebx

	add y, %eax
	inc %eax #incrementeaza cu o coloana pentru a executa bordarea

	movl $1, (%edi, %eax, 4)
	incl %ecx
	jmp et_p
	
main_continue:

	push $k
	push $formatScanf
	call scanf
	addl $8, %esp #citirea lui k

	mov mlines, %eax
	mull nCells
	movl %eax, nriter #numarul de iteratii pt parcurgerea matricei	
	xor %ecx, %ecx

parcurgere_celule:

	cmp k , %ecx
	je et_cont #sa fac asta de k ori, mutarea matricei 
		
	movl $0, i
	push %ecx #pt a retine nr generatiei curente
for_parcurgere_linii:
	movl i, %ecx
	cmp mlines, %ecx
	je parcurgere_celule_cont

	movl $0, j
for_parcurgere_coloane:
	movl j, %ecx
	cmp nCells, %ecx
	je for_parcurgere_linii_cont	
	
	mov i, %eax
	inc %eax #pt a sari peste linia de bordare

	mov nCells, %ebx
	add $2, %ebx
	mull %ebx #se adauga 2 pt cele 2 coloane de bordare
	
	addl j, %eax
	inc %eax #pt a doua coloana de bordare

	movl (%edi, %eax, 4), %ebx 
	xorl %edx, %edx
	cmp %ebx, %edx
	je caz_zero

caz_unu:
	
numararea_vecinilor:
	xorl %ebx, %ebx #tinem nr de vecini vii in ebx
	add (%edi, %eax, 4), %ebx	
	incl j
	jmp for_parcurgere_coloane
caz_zero:

	incl j
	jmp for_parcurgere_coloane
for_parcurgere_linii_cont:
	incl i
	jmp for_parcurgere_linii	
	
parcurgere_celule_cont:	
	pop %ecx
	incl %ecx
	jmp parcurgere_celule
et_cont:

	movl $0, i


for_lines:
	movl i, %ecx
	cmp mlines, %ecx	
	je exit	
	movl $0, j
for_columns:
	movl j, %ecx
	cmp nCells, %ecx
	je for_lines_cont
	
	mov i, %eax
	inc %eax #pt a sari peste linia de bordare

	mov nCells, %ebx
	add $2, %ebx
	mull %ebx #se adauga 2 pt cele 2 coloane de bordare
	
	addl j, %eax
	inc %eax #pt a doua coloana de bordare

	movl (%edi, %eax, 4), %ebx 
	push %ebx
	push $formatPrintf
	call printf
	addl $8, %esp

	incl j
	jmp for_columns

for_lines_cont:

	push $endl
	call printf
	add $4, %esp
	incl i
	jmp for_lines

et_exit:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
