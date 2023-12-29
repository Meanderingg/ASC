.data
	mlines: .space 4
	nCells: .space 4
	p: .space 4
	x: .space 4
	y: .space 4
	i: .space 4
	j: .space 4

	k: .space 4
	kiter: .space 4
	nrvecini: .space 4

	mat: .zero 1600 #initializeaza cu zero spatiul din memorie
	mat2: .zero 1600

	formatScanf: .asciz "%d"
	formatPrintf: .asciz "%d "
	endl: .asciz "\n"
.text
.global main
unu:
	push %ebp
	movl %esp, %ebp

	movl 8(%ebp), %eax
	
	push %ebx
	movl nrvecini, %ebx
subpop:
	cmp $2, %ebx
	jge cont_cel
	
	movl $0 , (%esi, %eax, 4) #punem in mat2 0
	jmp unu_exit
cont_cel:	
	cmp $3, %ebx
	jg ultrapop

	movl $1, (%esi, %eax, 4) #punem in mat2 1
	jmp unu_exit

ultrapop:
	movl $0, (%esi, %eax, 4) #punem 0 in mat2

unu_exit:
	pop %ebx
	pop %ebp
	ret

zero:
	push %ebp
	mov %esp, %ebp

	movl 8(%ebp), %eax #indicele emelmentului

	push %ebx
	movl nrvecini, %ebx
creare:
	cmp $3, %ebx
	jne cont_cel_m

	movl $1, (%esi, %eax, 4) #punem in mat2 1
	jmp zero_exit
cont_cel_m:
	movl $0, (%esi, %eax, 4)
zero_exit:
	pop %ebx
	pop %ebp
	ret

numvecini:
	
	push %ebp
	mov %esp, %ebp

	push %ebx
	xor %ebx, %ebx
	
	movl 8(%ebp), %eax #punem in %eax indicele elem
		
	decl %eax #elem din stanga
	addl (%edi, %eax, 4), %ebx

	addl $2, %eax #elem din dreapta
	addl (%edi, %eax, 4), %ebx

	dec %eax
	subl nCells, %eax
	subl $2, %eax #elementul de deasupra
	addl (%edi, %eax, 4), %ebx

	dec %eax #elem din st-sus
	addl (%edi, %eax, 4), %ebx

	addl $2, %eax #elem din dr-sus
	addl (%edi, %eax, 4), %ebx

	dec %eax
	addl nCells, %eax
	addl nCells, %eax
	addl $4, %eax #elem de dedesubt
	addl (%edi, %eax, 4), %ebx

	dec %eax #elem st-jos
	addl (%edi, %eax, 4), %ebx

	addl $2, %eax #elem din dr-jos
	addl (%edi, %eax, 4), %ebx

	movl %ebx, nrvecini

	pop %ebx
	pop %ebp
	ret

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
	movl $mat2, %esi

read_values:
	cmp p, %ecx
	je main_cont

	push %ecx

	push $x
	push $formatScanf
	call scanf
	addl $8, %esp 

	movl mlines, %eax
	cmp x, %eax
	jle exit # verificarea datelor de intrare	

	push $y
	push $formatScanf
	call scanf
	addl $8, %esp 

	movl nCells, %eax
	cmp y, %eax
	jle exit # verificarea datelor de intrare	

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
	jmp read_values
	
main_cont:

	push $k
	push $formatScanf
	call scanf
	addl $8, %esp #citirea lui k
	
	movl $0, kiter #numarul de generatii
#k_generatii:
#	movl kiter, %ecx
#	cmp k, %ecx
#	je print
	
parcurgere:
	movl $0, i
parcurgere_linii:
	movl i, %ecx
	cmp mlines, %ecx	
	je print #acolo unde sarim dupa o parcurgere	
	movl $0, j
parcurgere_coloane:
	movl j, %ecx
	cmp nCells, %ecx
	je parcurgere_linii_cont 
	
	mov i, %eax
	inc %eax #pt a sari peste linia de bordare

	mov nCells, %ebx
	add $2, %ebx
	mull %ebx #se adauga 2 pt cele 2 coloane de bordare
	
	addl j, %eax
	inc %eax #pt a doua coloana de bordare

	movl (%edi, %eax, 4), %ebx 
	
	movl $0, nrvecini
	push %ecx
	push %eax
	call numvecini
	pop %eax
	pop %ecx

	cmp $0, %ebx
	je case_0
case_1:
	push %ecx
	push %eax
	call unu
	pop %eax
	pop %ecx 
	
	jmp if_cont
case_0:
	push %ecx
	push %eax
	call zero 
	pop %eax
	pop %ecx

if_cont:

	push %ebx #daca puneam $nrvecini imi dadea adresa de memorie, dereferentierea e o minciuna, (%edi) muta tot o adresa in %ebx
	push $formatPrintf
	call printf
	addl $8, %esp #afisarea numarului de vecini


	incl j
	jmp parcurgere_coloane 

parcurgere_linii_cont:

	push $endl
	call printf
	add $4, %esp

	incl i
	jmp parcurgere_linii 



print:
	movl $0, i
	addl $2, mlines #afisare bordare
	addl $2, nCells #afisare bordare
print_lines:
	movl i, %ecx
	cmp mlines, %ecx	
	je exit	
	movl $0, j
print_columns:
	movl j, %ecx
	cmp nCells, %ecx
	je print_lines_cont
	
	mov i, %eax
	# inc %eax #pt a sari peste linia de bordare

	mov nCells, %ebx
	# add $2, %ebx
	mull %ebx #se adauga 2 pt cele 2 coloane de bordare
	
	addl j, %eax
	# inc %eax #pt a doua coloana de bordare

	movl (%esi, %eax, 4), %ebx 
	push %ebx
	push $formatPrintf
	call printf
	addl $8, %esp

	incl j
	jmp print_columns

print_lines_cont:

	push $endl
	call printf
	add $4, %esp
	incl i
	jmp print_lines

exit:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
