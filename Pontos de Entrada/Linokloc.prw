#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

User Function Linokloc()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("LRET,ZI,")

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿛rograma  � LINOKLOC � Autor � Rodrigo de A. Sartorio� Data � 16/04/98 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Valida linha da GetDados do programa CRIALOC               낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Compatibilizacao Versao 2.05 / 2.06                        낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
lRet:=.T.

// ("DA_PRODUTO")
// ("DA_LOCAL")
// ("DB_LOCALIZ")
// ("DB_QUANT")
// ("DA_LOTECTL")
// ("DA_NUMLOTE")
// ("DB_NUMSERI")

If !aCols[n,Len(aCols[n])]
	
	// Verifica campos obrigatorios
	For zi:=1 to 4
		If	Empty(aCols[n,zi])
			Help(" ",1,"OBRIGAT")
			lRet:=.F.	
			Exit
		EndIf
	Next zi
	
	// Verifica campos rastreabilidade
	If lRet .And. Rastro(aCols[n,1]) 
		If Empty(aCols[n,5]) 
			Help(" ",1,"A240NUMLOT")
			lRet:=.F.
		EndIf	
		If lRet .And. Rastro(aCols[n,1],"S") .And. Empty(aCols[n,6]) 
			Help(" ",1,"A240NUMLOT")
			lRet:=.F.	
		EndIf
	EndIf
	
	// Verifica campos localizacao
	If lRet .And. Localiza(aCols[n,1])
		If Empty(aCols[n,3]) .And. Empty(aCols[n,7])
			Help(" ",1,"LOCALIZOBR")
			lRet:=.F.
		EndIf
	EndIf

	If lRet .And. !Empty(aCols[n,7]) .And. aCols[n,4] #1
		Help(" ",1,"QUANTSERIE")
		lRet:=.F.
	EndIf
EndIf
// Substituido pelo assistente de conversao do AP5 IDE em 13/03/02 ==> __Return(lRet)	
Return(lRet)	        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02
