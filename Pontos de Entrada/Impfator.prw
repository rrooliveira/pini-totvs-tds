#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

User Function Impfator()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("NIL,NPORTA,CIMPRESSORA,CNUMCUP,NE,NTOTFATOR")
SetPrvt("NPRIMPARC,ASN,NSN,ABOLETO,NVEZ,CPORTA")
SetPrvt("NI,CLINHA,NLIN,NLOOP,")

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o	 쿔MPFAT.PRX� Autor � Fernando Godoy		  � Data � 21.10.97 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿔mprime as parcelas do financiamento.							  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe	 쿙IL := IMPFATOR 														  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso		 쿞igaLoja																	  낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
If lFiscal
	nPorta		:= GetPorta("F")
	cImpressora := GetMv("MV_IMPFIS")
EndIf
cNumCup		:= Space(6)
nE 			:= 1
nTotFator	:= 0
nPrimParc	:= 0
aSN			:= { "Sim","N꼘" }
nSN			:= 1

dbSelectArea("SA1")
dbSetOrder( 1 )
dbSeek(xFilial("SA1") + SL1->L1_CLIENTE + SL1->L1_LOJA )

aBoleto := {}
nVez		 := 1

*旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
*� Posiciona no arquivo de Condicao de pagamento  �
*읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
dbSelectArea("SE4")
dbSetOrder( 1 )
dbSeek(xFilial("SE4") + SL1->L1_CONDPG )

*旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
*� Posiciona no arquivo de Vendedores	�
*읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
dbSelectArea("SA3")
dbSetOrder( 1 )
dbSeek(xFilial("SA3") + SL1->L1_VEND )

*旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
*� Posiciona no arquivo de itens de Venda �
*읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
dbSelectArea( "SL2" )
dbSeek( xFilial("SL2") + SL1->L1_NUM )

If lFiscal
	If Substr(cImpressora,1,7) == "SIGTRON"
		inicia_com( nPorta )
		cNumCup := FiscalSr(nPorta,Chr(27) + Chr(211))
	EndIf
EndIf
nPrimParc := Val(ConValor(Substr(aParFator[1],12,14),14))

For nE := 1 to Len( aParFator )
	nTotFator := NoRound(nTotFator + Val(ConValor(Substr(aParFator[nE],12,18),14)),2)
Next nE

Aadd(aBoleto ,Replicate(" ",47))
Aadd(aBoleto ,Space(17) + cDescrOutr)
Aadd(aBoleto ,Replicate(" ",47))
Aadd(aBoleto ,Space(15) + "Autorizacao de Debito")
Aadd(aBoleto ,"Endereco: " + SM0->M0_ENDCOB)
Aadd(aBoleto ,"Cidade: " + SM0->M0_CIDCOB + Space(4) + "Estado: " +;
	SM0->M0_ESTCOB)
Aadd(aBoleto ,"Codigo do Caixa: " + xNumCaixa() + Space(8) + ;
	"Data: " + Dtoc(dDataBase) )
Aadd(aBoleto ,"Condicao de Pagto: " + SE4->E4_DESCRI)
Aadd(aBoleto ,Replicate(" ",47))
Aadd(aBoleto ,Replicate(" ",47))
Aadd(aBoleto ,"Primeira Parcela: " + Transform( nPrimParc, "@E 999,999,999.99" ))
Aadd(aBoleto ,"VALOR:                " + "R$ " + TransForm(nTotFator,"@E 999,999,999.99"))
Aadd(aBoleto ,Replicate(" ",47))
Aadd(aBoleto ,Replicate(" ",47))
Aadd(aBoleto ,Replicate("-",47))
Aadd(aBoleto ,Replicate(" ",47))
Aadd(aBoleto ,SA1->A1_NOME)
Aadd(aBoleto ,"Vendedor: " + SA3->A3_NOME)

*旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
*� Caso a impressora for sigtron abre cupom nao fiscal �
*읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
If lFiscal
	If Substr(cImpressora,1,7) == "SIGTRON"
		Set Device To PRINT
		cPorta := "COM" + Str(nPorta + 1,1)
		Set Printer To &cPorta
	EndIf

	While nVez < 3
		For nI := 1 to Len(aBoleto)
			cLinha := aBoleto[nI]
			If Substr(cImpressora,1,8) == "BEMATECH"
				LjEnviaBm("20|" + cLinha + Chr( 10 ))
			ElseIf Substr(cImpressora,1,7) == "SIGTRON"
				@ 1,1 SAY cLinha + Chr(10)
			EndIf
		Next nI
		nVez := nVez + 1
	EndDo

	If Substr(cImpressora,1,8) == "BEMATECH"
		LjEnviaBm("21|")
	ElseIf Substr(cImpressora,1,7) == "SIGTRON"
		FiscalSr(nPorta,Chr(27) + Chr(212))
		Set Device To SCREEN
		Set Printer To
	EndIf
Else
	#IFNDEF WINDOWS
		For nI := 1 to Len(aBoleto)
			cLinha := aBoleto[nI]
			DevPos( PROW()+1,   0 ) ; DevOut( cLinha )
		Next nI
	#ELSE
		nLin	:= 1
		nLoop := 0
		For nLoop := 1 to Len(aBoleto)
			cLinha := aBoleto[nLoop]
			@nLin ,1 PSay cLinha
			nLin := nLin + 1
			If nLin > 60
				nLin := 1
			EndIf
		Next nLoop
	#ENDIF
EndIf

// Substituido pelo assistente de conversao do AP5 IDE em 13/03/02 ==> __Return(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

