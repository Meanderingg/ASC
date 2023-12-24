.data
	mlines: .space 4
	nCells: .space 4
	p: .space 4
	x: .space 4
	y: .space 4
	i: .space 4
	j: .space 4

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
	je et_cont

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
	mull nCells
	add y, %eax

	movl $1, (%edi, %eax, 4)
	incl %ecx
	jmp et_p
	
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
