#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFAT402   � Autor � Marcos Farineli    � Data �  27/09/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP5 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function PFAT402()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cString  := "ZZL"
Private cPerg    := "ATR240"
Private cQuery   := ""
Private nA       := 0
Private nEdInic  := 0
Private nEdAtu   := 0
Private nQtdADif := 0
Private nQtdEx   := 0
Private aCampos  := {}
Private cArq     := ""
Private cField   := ""
Private lEnd     := .f.
Private nSaldo   := 0
Private mHora    := Time()
Private cString  := SUBS(CUSUARIO,1,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
Private cArqPath := GetMv("MV_PATHTMP")
Private cStringCp:= cArqPath+cString+".DBF"
Private cMsg     := ""
Private lDifMes  := .f.

If !Pergunte(cPerg,.t.)
	Return
EndIf

Processa({|lEnd| P402Proc(@lEnd)},"Mapa de Diferimento", "Preparando processamento",.t.)

Return

Static Function P402Proc()

//���������������������Ŀ
//�Cria arquivo de saida�
//�����������������������
AADD(aCampos,{"PEDIDO"    ,"C",6  ,0})
AADD(aCampos,{"ITEM"      ,"C",2  ,0})
AADD(aCampos,{"REVISTA"   ,"C",4  ,0})
AADD(aCampos,{"VALTOT"    ,"N",12 ,2})
AADD(aCampos,{"SALDO"     ,"N",12 ,2})
AADD(aCampos,{"SITUAC"    ,"C",1  ,0})
AADD(aCampos,{"MESREF"    ,"C",6  ,0})
AADD(aCampos,{"MES00"     ,"N",12 ,2})
AADD(aCampos,{"MES01"     ,"N",12 ,2})
AADD(aCampos,{"MES02"     ,"N",12 ,2})
AADD(aCampos,{"MES03"     ,"N",12 ,2})
AADD(aCampos,{"MES04"     ,"N",12 ,2})
AADD(aCampos,{"MES05"     ,"N",12 ,2})
AADD(aCampos,{"MES06"     ,"N",12 ,2})
AADD(aCampos,{"MES07"     ,"N",12 ,2})
AADD(aCampos,{"MES08"     ,"N",12 ,2})
AADD(aCampos,{"MES09"     ,"N",12 ,2})
AADD(aCampos,{"MES10"     ,"N",12 ,2})
AADD(aCampos,{"MES11"     ,"N",12 ,2})
AADD(aCampos,{"MES12"     ,"N",12 ,2})
AADD(aCampos,{"MES13"     ,"N",12 ,2})
AADD(aCampos,{"MES14"     ,"N",12 ,2})
AADD(aCampos,{"MES15"     ,"N",12 ,2})
AADD(aCampos,{"MES16"     ,"N",12 ,2})
AADD(aCampos,{"MES17"     ,"N",12 ,2})
AADD(aCampos,{"MES18"     ,"N",12 ,2})
AADD(aCampos,{"MES19"     ,"N",12 ,2})
AADD(aCampos,{"MES20"     ,"N",12 ,2})
AADD(aCampos,{"MES21"     ,"N",12 ,2})
AADD(aCampos,{"MES22"     ,"N",12 ,2})
AADD(aCampos,{"MES23"     ,"N",12 ,2})
AADD(aCampos,{"MES24"     ,"N",12 ,2})

cArq := CriaTrab(aCampos,.t.)

If Select("TRB") <> 0
	DbSelectArea("TRB")
	DbCloseArea()
EndIf

dbUseArea(.T.,, carq,"TRB",.F.,.F.)

DbSelectArea("ZZL")
ProcRegua(RecCount())
DbGoTop()
DbSetOrder(1)
//DbSeek(xFilial("ZZL")+DTOS(MV_PAR02),.t.)

While !eof() .and. !lEnd
	IncProc("Pedido : "	+ ZZL->ZZL_PEDIDO)
	lBimestral := .f.
	lDifMes    := .t.
	If DTOS(ZZL->ZZL_DTINIC) > DTOS(MV_PAR02)
		DbSelectArea("ZZL")
		DbSkip()
		Loop
	EndIf
	DbSelectArea("SC6")
	DbSetOrder(1)
	If DbSeek(xFilial("SC6")+ZZL->ZZL_PEDIDO+ZZl->ZZL_ITEM)
		nEdInic    := SC6->C6_EDINIC
		If SC6->C6_TIPOREV == "4"
			lBimestral := .t.
		EndIf
		If SC6->C6_TES $ "700" // TES de conversao
			DbSelectArea("ZZL")
			DbSkip()
			Loop
		EndIf
	Else
		DbSelectArea("ZZL")
		DbSkip()
		Loop
	EndIf
	DbSelectArea("SZJ")
	DbSetOrder(6)
	DbSeek(xFilial("SZJ")+ZZL->ZZL_CODREV+DTOS(MV_PAR01),.t.)
	If Alltrim(SZJ->ZJ_CODREV) <> Alltrim(ZZL->ZZL_CODREV)
		DbSelectArea("ZZL")
		DbSkip()
		Loop
	EndIf
	//�����������������������������������Ŀ
	//�Define se ira diferir no mes de ref�
	//�������������������������������������
	If DTOS(SZJ->ZJ_DTCIRC) > DTOS(MV_PAR02)
		lDifMes := .f.
	Else
		lDifMes := .t.
	EndIf
	
	//������������������������������������������������Ŀ
	//�Determina aqui a quantidade de edicoes a diferir�
	//��������������������������������������������������
	nQtdEx   := ZZL->ZZL_QTDEX
	nEdAtu   := SZJ->ZJ_EDICAO
	nQtdADif := IIF((nQtdEx-(nEdAtu-nEdInic))<=24,(nQtdEx-(nEdAtu-nEdInic)),24)
	nQtdADif := IIF(lDifMes, nQtdADif -1,nQtdADif)
	
	DbSelectArea("TRB")
	RecLock("TRB",.t.)
	TRB->PEDIDO := ZZL->ZZL_PEDIDO
	TRB->ITEM   := ZZL->ZZL_ITEM
	TRB->REVISTA:= ZZL->ZZL_CODREV
	TRB->VALTOT := ZZL->ZZL_VALOR
	TRB->MESREF := SUBSTR(DTOS(MV_PAR01),1,6)

	If lDifMes
		If lBimestral
			For nA := 0 to (nQtdAdif*2) step 2
				cField  := "TRB->MES"+StrZero(nA,2)
				If nA <= 24
					If (nA%2) == 0 // meses pares
						&cField := ZZL->ZZL_VLDIF
						nSaldo  += IIF(nA <> 0,ZZL->ZZL_VLDIF,0)
					EndIf
				EndIf	
			Next nA		
		 Else
		 	For nA := 0 to (nQtdAdif)
				cField  := "TRB->MES"+StrZero(nA,2)
				&cField := ZZL->ZZL_VLDIF
				nSaldo  += IIF(nA <> 0,ZZL->ZZL_VLDIF,0)
			Next nA		
		EndIf	
	Else
		If lBimestral
			For nA := 1 to (nQtdAdif*2) step 2
				cField  := "TRB->MES"+StrZero(nA,2)
				If nA <= 24
					If (nA%2) <> 0 .or. nA == 1
						&cField := ZZL->ZZL_VLDIF
						nSaldo  += ZZL->ZZL_VLDIF
					EndIf	
				EndIf
			Next nA
		Else		
			For nA := 1 to nQtdAdif
				cField  := "TRB->MES"+StrZero(nA,2)
				&cField := ZZL->ZZL_VLDIF
				nSaldo  += ZZL->ZZL_VLDIF
			Next nA		
		EndIf
	EndIf
		
	TRB->SALDO := nSaldo
	MsUnlock()
	
	If TRB->SALDO == 0
		DbSelectArea("TRB")
		RecLock("TRB",.f.)
		DbDelete()
		MsUnlock()
	EndIf
	
	nSaldo := 0
	
	DbSelectArea("ZZL")
	DbSkip()
End
	
DbSelectArea("TRB")

Copy To &cStringCp

DbCloseArea()

cMsg := "Arquivo gerado com sucesso em " + cStringCp

MsgInfo(cMsg)

Return