#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
/*/ //Danilo C S Pala 20051222: indices diferentes no ct2 em relacao ao si2
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: PCONR01   �Autor: Roger Cangianeli       � Data:   17/01/01 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Geracao do arquivo contabil para Srta.Cleide               � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Contabilidade                                    � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Rfat034()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

SetPrvt("_CALIAS,_NORD,_NREG,CPERG,_ACAMPOS,_CARQ")
SetPrvt("_CKEY,_CARQTRB,_CMSG,AREGS,I,J")

_cAlias := Alias()
_nOrd   := IndexOrd()
_nReg   := Recno()

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Mov.Contabil De                      �
//� mv_par02             // Mov.Contabil Ate                     �
//� mv_par03             // Conta Contabil De                    �
//� mv_par04             // Conta Contabil Ate                   �
//����������������������������������������������������������������
cPerg := "CONR01"
//ValidPerg()

If !Pergunte(cPerg,.T.)
    Return
EndIf

Processa({|| _RunProc()},"Gerando Arquivo Contabil...")// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==>     Processa({||Execute(_RunProc)},"Gerando Arquivo Contabil...")

dbSelectArea(_cAlias)
dbSetOrder(_nOrd)
dbGoTo(_nReg)

Return

Static Function _RunProc()

_aCampos := {  {"PRODUTO",  "C",    15,     0} ,;
               {"CONTA",    "C",    20,     0} ,;
               {"VALOR",    "N",    15,     2} }

_cArq   := CriaTrab(_aCampos,.t.)
dbUseArea(.T.,, _cArq,"TRB",.F.,.F.)

_cKey   := "PRODUTO+CONTA"
IndRegua("TRB",_cArq,_cKey,,,"Selecionando Registros Temporarios...")

dbSelectArea("CT2")
ProcRegua(RecCount()/3)
dbSetOrder(2)           // Fil + Debito + Data
dbSeek( xFilial("CT2") + MV_PAR03 + DTOS(MV_PAR01), .T.)
While !Eof() .and. CT2->CT2_FILIAL == xFilial("CT2") .and. CT2->CT2_DEBITO <= MV_PAR04
    IncProc("Processando Registro "+ StrZero(Recno(),10))
    If CT2->CT2_DATA < MV_PAR01 .or. CT2->CT2_DATA > MV_PAR02
        dbSkip()
        Loop
    EndIf
    dbSelectArea("TRB")
    RecLock("TRB", .T.)
    TRB->PRODUTO    := CT2->CT2_PRODUTO
    TRB->CONTA      := CT2->CT2_DEBITO
    TRB->VALOR      := CT2->CT2_VALOR * -1
    msUnlock()
    dbSelectArea("CT2")
    dbSkip()
End

dbSelectArea("CT2")
dbSetOrder(3)           // Fil + Credito + Data
dbSeek( xFilial("CT2") + MV_PAR03 + DTOS(MV_PAR01), .T.)
While !Eof() .and. CT2->CT2_FILIAL == xFilial("CT2") .and. CT2->CT2_CREDIT <= MV_PAR04
    IncProc("Processando Registro "+ StrZero(Recno(),10))
    If CT2->CT2_DATA < MV_PAR01 .or. CT2->CT2_DATA > MV_PAR02
        dbSkip()
        Loop
    EndIf
    dbSelectArea("TRB")
    RecLock("TRB", .T.)
    TRB->PRODUTO    := CT2->CT2_PRODUTO
    TRB->CONTA      := CT2->CT2_CREDIT
    TRB->VALOR      := CT2->CT2_VALOR
    TRB->(msUnlock())
    dbSelectArea("CT2")
    dbSkip()
End

dbSelectArea("TRB")
If RecCount() > 0
    //If Upper(Subs(cUsuario,7,6)) == "CLEIDE"
    //    _cArqTrb :="F:\USUARIOS\CASC\GR"+AllTrim(Subs(MV_PAR03,1,4))+".DBF"
    //Else
        _cArqTrb :="\SIGA\EXPORTA\GR"+AllTrim(Subs(MV_PAR03,1,4))+".DBF"
    //EndIf
    Copy to &(_cArqTrb) VIA "DBFCDXADS" // 20121106 
    _cMsg := "Arquivo "+_cArqTrb+" gerado com sucesso."
Else
    _cMsg := "Nao foram encontrados dados para a geracao do arquivo. Verifique"
    _cMsg := _cMsg + " os parametros e tente novamente."
EndIf

Alert(_cMsg)

dbSelectArea("TRB")
dbCloseArea()
fErase(_cArq+".DBF")
fErase(_cArq+OrdBagExt())

Return
/*/
���������������������������������������������������������������������
������������������������������������������������������������������Ŀ�
��Funcao    �VALIDPERG� Autor � Jose Renato July � Data � 25.01.99 ��
������������������������������������������������������������������Ĵ�
��Descricao � Verifica perguntas, incluindo-as caso nao existam.   ��
������������������������������������������������������������������Ĵ�
��Uso       � SX1                                                  ��
������������������������������������������������������������������Ĵ�
��Release   � 3.0i - Roger Cangianeli - 12/05/99.                  ��
�������������������������������������������������������������������ٱ
���������������������������������������������������������������������
/*/
Static Function VALIDPERG()

cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
   aRegs    := {}
   dbSelectArea("SX1")
   dbSetOrder(1)
   AADD(aRegs,{cPerg,"01","Mov.Contabil De     ?","mv_ch1","D",08,0,2,"G","","mv_par01","","","","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"02","Mov.Contabil Ate    ?","mv_ch2","D",08,0,2,"G","","mv_par02","","","","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"03","Conta Contabil De   ?","mv_ch3","C",20,0,2,"G","","mv_par03","","","","","","","","","","","","","","","CT1"})
   AADD(aRegs,{cPerg,"04","Conta Contabil Ate  ?","mv_ch4","C",20,0,2,"G","","mv_par04","","","","","","","","","","","","","","","CT1"})
   For i := 1 to Len(aRegs)
      If !dbSeek(cPerg+aRegs[i,2])
         RecLock("SX1",.T.)
         For j := 1 to FCount()
            If j <= Len(aRegs[i])
               FieldPut(j,aRegs[i,j])
            Endif
         Next
         SX1->(MsUnlock())
      Endif
   Next

Return