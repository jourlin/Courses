# assembler avec "gcc -ggdb TriBulle.s -o Tribulle" 
# deboguer avec "ddd Tribulle"

.data

Stock: 		.byte	         5		# nombre (8 bits) d'objets 
						# dans la liste
		.long	0x12345678		# taille (32 bits) du premier objet
 		.word	0x1234			# poids  (16 bits) du premier objet
		.word	0x5678			# volume (16 bits) du premier objet
		.long	0x87654321		# taille (32 bits) du deuxième objet
		.word	0x0123			# poids  (16 bits) du deuxième objet
		.word 	0x4321			# volume (16 bits) du deuxième objet
		.long	0x01234567 		# taille (32 bits) du troisième objet
		.word	0x1123			# poids  (16 bits) du troisième objet
		.word	0x2345			# volume (16 bits) du troisième objet
		.long	0x98765432		# taille (32 bits) du quatrième objet
		.word	0x0012			# poids  (16 bits) du quatrième objet
		.word	0x7654			# volume (16 bits) du quatrième objet
		.long	0x09876543		# taille (32 bits) du cinquième objet
		.word	0x1234			# poids  (16 bits) du cinquième objet
		.word	0x8765			# volume (16 bits) du cinquième objet


 .text		# directive de création d'une zone d'instructions
 .globl main	# directive de création d'une étiquette de portée globale

############################ Programme Principal ###############################

main:		pushq $Stock		# empile l'adresse du tableau d'objets
 		call TriBulle		# appel de la procédure tribulle
fin:    	retq			# retour au système d'exploitation

############################ Procedure Tribulle  ###############################

TriBulle: 
		 movq	8(%rsp), %rsi	# %rsi pointe sur le tableau à trier
		 movq	$0, %rdx	# pour mettre à zéro la partie haute de %rdx
		 movb	 (%rsi), %dl	# %rdx contient le nombre N d'objets à trier
		 subq	$1, %rdx	# %rdx est la limite de la boucle Pour (N-1)
Repeter: 
		 call FaitPermutations	# appel de la procédure 
		 cmpb $0, %bl		# %bl = 0 si pas de nouvelle permutation
		 jne	Repeter		# tant que permut = VRAI
		 retq	$8		# retour à l'appel avec dépilement du
					# paramètre d'appel

#########################   Procedure FaitPermutations ######################

FaitPermutations:
 		movb	$0, 	%bl		# permut = FAUX
PourInit:	movq	$0,	%rcx		# Pour i=0
PourTest:	cmpq	%rdx,	%rcx		# Jusqu'à n-1
 		jae	FinPour			# on sort de la boucle quand i>=n-1
Si:		movw	5(%rsi, %rcx, 8), %ax	# compare T[i].poids
		cmpw	%ax, 13(%rsi, %rcx, 8)	# avec T[i+1].poids
		jae	FinSi
		call	Permute
		movb	$1, %bl			# permut = VRAI
FinSi:	addq	$1, %rcx			# élément suivant
		jmp PourTest			# Boucle Pour
FinPour:	retq

############################   Procedure Permute    ############################

Permute:	pushq	%rdx			# sauve le nombre d'objets à trier
		movq	1(%rsi, %rcx, 8), %rax	# sauve T[i]
		movq	9(%rsi, %rcx, 8), %rdx	# sauve T[i+1]
		movq	%rdx, 1(%rsi, %rcx, 8)	# copie T[i+1] dans T[i]
		movq	%rax, 9(%rsi, %rcx, 8)	# copie ancien T[i] dans 
						# T[i+1]
		popq	%rdx			# restaure le nombre
						# d'objets à trier
		retq
