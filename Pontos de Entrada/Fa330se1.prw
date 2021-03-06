#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

User Function Fa330se1()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02
//Danilo C S Pala 20060526: DESPESA COM BOLETO
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_CALIAS,_NINDEX,_NORDEM,_CCHAVE,_NVALBX, MSOMABOL")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿛rograma  쿑A330SE1  � Autor � Gilberto A. Oliveira  � Data � 02/08/00 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escricao 쿛onto de Entrada Ajusta o Status do campo C5_STATFIN para   낢�
굇�          �"DC" - Debito Conta.                                        낢�
굇�          쿗e todos os titulos "RA" dentro do periodo.                 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿢so       쿐specifico para Editora Pini. Modulo Financeiro.            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴눙�
굇쿝evisao   �                                          � Data �          낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

_cAlias:= Alias()
_nIndex:= IndexOrd()
_nOrdem:= Recno()

DbSelectArea("SE1")

If SE1->E1_SALDO <> 0    .Or. ;   // Caso o Saldo seja diferente de zero (titulo nao baixado totalmente).
   Empty(SE1->E1_PEDIDO) .Or. ;   // Caso o campo com numero de pedido nao esteja preenchido.
   SE1->E1_TIPO <> "NF "          // Caso nao seja um titulo de compensa눯o.
   Return                         // Retorna sem atualizar status.
Endif

#IFNDEF WINDOWS
   Atualiza_status()
#ELSE
   Atualiza_status()// Substituido pelo assistente de conversao do AP5 IDE em 13/03/02 ==>    Execute(Atualiza_status)
#ENDIF

DbSelectArea(_cAlias)
DbSetOrder(_nIndex)
DbGoto(_nOrdem)

Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴커굇
굇쿑UNCAO    쿌tualiza_Status � Autor � Gilberto A. Oliveira � Data �02/08/00낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴캑굇
굇쿢so       쿐specifico para Editora Pini. Modulo Financeiro.               낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴컴캑굇
굇쿝evisao   �                                          � Data �             낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽

/*/

// Substituido pelo assistente de conversao do AP5 IDE em 13/03/02 ==> Function ATUALIZA_STATUS
Static Function ATUALIZA_STATUS()

DbSelectArea("SC5")
DbSetOrder(1)
DbSeek(xfilial("SC5")+SE1->E1_PEDIDO)

If (Alltrim(SC5->C5_TIPOOP) $ "80|82|83|84") .And. Found()

   DbSelectArea("SE1")
   DbOrderNickName("E1_PEDIDO") //dbSetOrder(27) 20130225  ///dbSetOrder(15) AP5 //20090114 era(21) //MP10 era(22) //dbSetOrder(26) 20100412
   DbSeek(xFilial("SE1")+SE1->E1_PEDIDO+SE1->E1_NUM)
   _cChave:= SE1->E1_PEDIDO+SE1->E1_NUM
   _nValBx:= 0
   MSOMABOL := 0 //20060526

   While ( SE1->E1_PEDIDO+SE1->E1_NUM == _cChave ) .And. !EOF()
         _nValBx:= _nValBx+SE1->E1_VALOR-SE1->E1_SALDO
         MSOMABOL := MSOMABOL + SE1->E1_DESPBOL  //20060526
         DbSkip()
   End-While

   If (SC5->C5_VLRPED + SC5->C5_DESPREM + SOMABOL)==_nValBx
      If SC5->C5_STATFIN == "RA "
         RecLock("SC5",.F.)
         SC5->C5_STATFIN:= "DC"
         MsUnLock()
      EndIf
   EndIf
EndIf

Return

