.data
	mlines: .space 4
	nCells: .space 4
	p: .space 4
	x: .space 4
	y: .space 4
	i: .space 4
	j: .space 4

	k: .space 4

	mat: .zero 1600 #initializeaza cu zero spatiul din memorie

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

	push $y
	push $formatScanf
	call scanf
	addl $8, %esp 

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

et_cont:

	movl $0, i

	movl mlines, %eax
	add $2, %eax
	movl %eax, mlines #pt afisarea bordarii

	movl nCells, %eax
	add $2, %eax
	movl %eax, nCells #pt afisarea bordarii

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
	mull nCells
	addl j, %eax

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
