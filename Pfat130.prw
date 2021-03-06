#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/02/02
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � PFAT130  � Autor � Alex Egydio (Original)� Data � 12/04/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Pergunte do Boleto Itau quando chamado do MENU             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico (SEAL)   (PUBLICIDADE)                          ���
��� Uso      � Especifico (PINI) - Autor: Gilberto - Data: 12/04/2001     ���
�������������������������������������������������������������������������Ĵ��
���ROTINAS RELACIONADAS                                                   ���
���                                                                       ���
���PFAT130       - PRINCIPAL                                              ���
��� PFAT130A     - LOOP                                                   ���
���  A130DET     - PREPARA DADOS DO ARQUIVO TEXTO.                        ���
�������������������������������������������������������������������������Ĵ��
��� Revis�o  �                                          � Data �          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Pfat130()        // incluido pelo assistente de conversao do AP5 IDE em 26/02/02

SetPrvt("_CALIAS,_NRECNO,_NORDER,_CPERG,_ACRA,_CSAVSCR1")
SetPrvt("_CSAVCUR1,_CSAVROW1,_CSAVCOL1,_CSAVCOR1,_LEMFRENTE,NOPCA")
SetPrvt("_CMSG,_SALIAS,_AREGS,I,J,")

_cAlias:= Alias()
_nRecno:= Recno()
_nOrder:= IndexOrd()

//��������������������������������������������������������������Ŀ
//� Define Variaveis PRIVADAS BASICAS                            �
//����������������������������������������������������������������
_cPerg := "ITAUBO"
_ValidPerg()
Pergunte(_cPerg,.T.)

Pergunte(_cPerg,.F.)

//��������������������������������������������������������������Ŀ
//� Monta Tela Inicial Do Programa                               �
//����������������������������������������������������������������
@ 96,42 TO 323,505 DIALOG oDlg TITLE "Boleto - Itau"
@ 8,10 TO 84,222
@ 91,136 BMPBUTTON TYPE 5 ACTION Pergunte(_cPerg,.T.)
@ 91,166 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==>     @ 91,166 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg)

//��������������������������������������������������������������Ŀ
//� Descricao generica do programa                               �
//����������������������������������������������������������������
@ 23,14 SAY "Este programa tem como objetivo gerar o arquivo"
@ 33,14 SAY "de boletos itau para impressao."
ACTIVATE DIALOG oDlg CENTERED

Return


Static Function OkProc()
Pergunte(_cPerg,.F.)
Close(oDlg)
Processa( {|| RunProc() } )// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==>             Processa( {|| Execute(RunProc) } )
Return

// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==>     Function RunProc
Static Function RunProc()

If mv_par01 #"341"
	_cMsg := OemToAnsi('O Banco deve obrigatoriamente ser o 341 - Itau. Favor Verificar !!!')
	MsgBox(_cMsg,"* * * ATENCAO * * *","STOP")
	Return
EndIf
If Alltrim(mv_par02) #"0585"
	_cMsg := OemToAnsi("A ag�ncia deve obrigatoriamente ser 0585.  Favor Verificar !!!")
	MsgBox(_cMsg,"* * * ATENCAO * * *","STOP")
	Return
Endif
If Alltrim(mv_par03) #"92273-5"
	_cMsg := OemToAnsi("A conta deve obrigatoriamente ser 92273-5. Favor Verificar !!!")
	MsgBox(_cMsg,"* * * ATENCAO * * *","STOP")
	Return
Endif
If Alltrim(mv_par04) #"175"
	_cMsg := OemToAnsi("A carteira deve obrigatoriamente ser 175. Favor Verificar !!!")
	MsgBox(_cMsg,"* * * ATENCAO * * *","STOP" )
	Return
EndIf

//��������������������������������������������������������������Ŀ
//� Gera arq. para impressao do Boleto Itau                      �
//����������������������������������������������������������������
ExecBlock('PFAT130A',.F.,.F., MV_PAR07)

DbSelectArea(_cAlias)
DbSetOrder(_nOrder)
DbGoto(_nRecno)
Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �_ValidPerg� Autor �  Luiz Carlos Vieira   � Data � 18/11/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica as perguntas inclu�ndo-as caso n�o existam        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico para clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==> Function _ValidPerg
Static Function _ValidPerg()

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
_cPerg    := PADR(_cPerg,10) //mp10 x1_grupo char(10)
_aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
Aadd(_aRegs,{_cPerg,"01","Banco             ?","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","SA6"})
Aadd(_aRegs,{_cPerg,"02","Agencia           ?","mv_ch2","C",05,0,0,"G","","mv_par02","","","","","","","","","","","","","",""})
Aadd(_aRegs,{_cPerg,"03","Conta             ?","mv_ch3","C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","",""})
Aadd(_aRegs,{_cPerg,"04","Carteira          ?","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","",""})
Aadd(_aRegs,{_cPerg,"05","Da Nota Fiscal    ?","mv_ch5","C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","",""})
Aadd(_aRegs,{_cPerg,"06","Ate Nota Fiscal  ?","mv_ch6","C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","",""})
Aadd(_aRegs,{_cPerg,"07","Serie             ?","mv_ch7","C",03,0,0,"G","","mv_par07","","","","","","","","","","","","","",""})
Aadd(_aRegs,{_cPerg,"08","Juros/Dia         ?","mv_ch8","N",05,2,0,"G","","mv_par08","","","","","","","","","","","","","",""})
Aadd(_aRegs,{_cPerg,"09","Desconto          ?","mv_ch9","N",10,2,0,"G","","mv_par09","","","","","","","","","","","","","",""})
Aadd(_aRegs,{_cPerg,"10","Parcelas          ?","mv_chA","C",10,0,0,"G","","mv_par10","","","","","","","","","","","","","",""})
Aadd(_aRegs,{_cPerg,"11","Dias p/Recebimento?","mv_chB","N",02,0,0,"G","","mv_par11","","","","","","","","","","","","","",""})
Aadd(_aRegs,{_cPerg,"12","Vencimento de     ?","mv_chC","D",02,0,0,"G","","mv_par12","","","","","","","","","","","","","",""})
Aadd(_aRegs,{_cPerg,"13","Vencimento Ate    ?","mv_chC","D",02,0,0,"G","","mv_par13","","","","","","","","","","","","","",""})
Aadd(_aRegs,{_cPerg,"14","Multa             ?","mv_chE","D",02,0,0,"G","","mv_par14","","","","","","","","","","","","","",""})

For i:=1 to Len(_aRegs)
	If !dbSeek(_cPerg+_aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(_aRegs[i])
				FieldPut(j,_aRegs[i,j])
			Endif
		Next
		SX1->(MsUnlock())
	Endif
Next

dbSelectArea(_sAlias)

Return
