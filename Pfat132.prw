#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/02/02

User Function Pfat132()        // incluido pelo assistente de conversao do AP5 IDE em 26/02/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CPERG,_SALIAS,AREGS,I,J,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴커 굇
굇쿛rograma: PFAT132   쿌utor: Raquel Ramalho         � Data:   12/06/01 � 굇
굇쳐컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴캑 굇
굇쿏escri놹o: Cancela Baixa do Lucros e Perdas - Programa Base: Cancbx   � 굇
굇쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑 굇
굇쿢so      : Especifico PINI                                            � 굇
굇쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑 굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Titulo  C-6                          �
//� mv_par02             // Prefixo C-3                          �
//� mv_par03             // Parcela C-1                          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

cPerg    := "PFT132"
_ValidPerg()


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Verifica as perguntas selecionadas                                      �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Pergunte(cPerg,.T.)               // Pergunta no SX1

   
   
Do While .T.
   DbSelectArea("SE5")
   DbSetOrder(7)
   DbSeek(xfilial()+MV_PAR02+MV_PAR01+MV_PAR03)
   If Found()
      MsgAlert(SE5->E5_NUMERO+"  "+ "N�o � um titulo v�lido para esta rotina")   
      Exit   
   Endif
   DbSelectArea("SE1")
   DbSetOrder(1)
   DbSeek(xfilial()+MV_PAR02+MV_PAR01+MV_PAR03)
   If Found() .and. 'LP' $(SE1->E1_MOTIVO) .OR. 'PERDA' $(SE1->E1_MOTIVO) 
      If 'LP' $(SE1->E1_MOTIVO) .OR. 'PERDA' $(SE1->E1_MOTIVO) ;
      .or. 'LP' $(SE1->E1_HIST) .OR. 'PERDA' $(SE1->E1_HIST)
         RecLock("SE1")
         REPLACE E1_SALDO WITH E1_VALOR
         REPLACE E1_BAIXA WITH CTOD('  /  /  ')
         REPLACE E1_MOTIVO WITH SPACE(15)
         REPLACE E1_HIST WITH SPACE(15)
         REPLACE E1_CODPORT WITH SPACE(3)
         REPLACE E1_PORTADOR WITH SPACE(3)
         REPLACE E1_REAB WITH 'S'
         SE1->(MsUnLock())
      Else
         MsgAlert(SE1->E1_NUM+"  "+ " N�o � um titulo baixado por LP")     
      Endif
      Exit
   else
      help(" ",1,"REGNOIS")
      Exit
   EndIf
End-While

dbSelectArea("SE1")
Retindex("SE1")  

dbSelectArea("SE5")
Retindex("SE5")

Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    쿣ALIDPERG � Autor �  Luiz Carlos Vieira   � Data � 16/07/97 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Verifica as perguntas inclu죒do-as caso n꼘 existam        낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿢so       � Espec죉ico para clientes Microsiga                         낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==> Function _ValidPerg
Static Function _ValidPerg()

         _sAlias := Alias()
         DbSelectArea("SX1")
         DbSetOrder(1)
         cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
         aRegs:={}

         // Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3

         AADD(aRegs,{cPerg,"01","Titulo.:","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
         AADD(aRegs,{cPerg,"02","Prefixo:","mv_ch2","C",3,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
         AADD(aRegs,{cPerg,"03","Parcela:","mv_ch3","C",1,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})

         For i:=1 to Len(aRegs)
             If !dbSeek(cPerg+aRegs[i,2])
                 RecLock("SX1",.T.)
                 For j:=1 to FCount()
                     If j <= Len(aRegs[i])
                         FieldPut(j,aRegs[i,j])
                     Endif
                 Next
                 SX1->(MsUnlock())
             Endif
         Next

         DbSelectArea(_sAlias)

Return

