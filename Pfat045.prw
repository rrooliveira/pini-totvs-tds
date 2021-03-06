#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
User Function Pfat045()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
Local aArea := GetArea()

SetPrvt("CSAVTELA,CSAVCURSOR,CSAVCOR,CSAVALIAS,CPERG,TITULO")
SetPrvt("_ACAMPOS,_CNOME,MREVISTA,MPEDIDO,MPRODUTO,MCODDEST")
SetPrvt("MCLIENTE,CLIE_NOME,MEND,MBAIRRO,MMUN,MEST")
SetPrvt("MCEP,MFONE,CLIE_DEST,CINDEX,CKEY,ARETURN")
SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,WNREL,NLASTKEY")
SetPrvt("LIN,COL,LI,mhora")

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Recupera o desenho padrao de atualizacoes�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
CPERG  := 'PFAT004'
TITULO := 'ETIQUETAS'

mRevista := Space(4)
mPedido  := Space(6)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Criacao da Interface                                                �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
@ 125,306 To 346,750 Dialog oDlg1 Title OemToAnsi("Etiquetas Avulsas")
@ 17,17 Say OemToAnsi("Revista") Size 25,10 Object oLblRev
@ 40,17 Say OemToAnsi("Pedido") Size 25,10 Object oLblPed
@ 17,50 Get mRevista Size 50,10 Object oGetRev
@ 40,50 Get mPedido  Picture "@!" Size 50,10 Object oGetPed
@ 90,112 BmpButton Type 1 Action Processa({||P045ProcA()})
@ 89,165 BmpButton Type 2 Action Close(oDlg1)
Activate Dialog oDlg1 CENTERED

If Select("ETIQAV") <> 0
	DbSelectArea("ETIQAV")
	DbCloseArea()
EndIf

RestArea(aArea)

Return

Static Function P045ProcA()

_aCampos := {  	{"NUMPED"	,"N"	,6	,0} ,;
				{"NOME" 	,"C"	,40	,0} ,;
				{"DEST"		,"C"	,40	,0} ,;
				{"V_END"	,"C"	,40	,0} ,;
				{"BAIRRO"	,"C"	,20	,0} ,;
				{"MUN"		,"C"	,20	,0} ,;
				{"CEP"		,"C"	,8	,0} ,;
				{"EST"		,"C"	,2	,2}}

_cNome := CriaTrab(_aCampos,.t.)
dbUseArea(.T.,, _cNome,"ETIQAV",.F.,.F.)
	
DBSELECTAREA("SC6")
DbSetOrder(1)
If dbSeek(xfilial("SC6")+mpedido)
	While !Eof() .and. SC6->C6_FILIAL == xFilial("SC6") .and. mpedido == SC6->C6_NUM
		If subs(SC6->C6_PRODUTO,1,4) # mrevista
			dbskip()
			loop
		Endif
		mproduto := subs(SC6->C6_PRODUTO,1,4)
		EXIT
	End
	If mproduto # mrevista
		MsgAlert("Este pedido nao possui a revista "+mrevista+" como item.","Atencao") 
	    Return
	Endif
Endif
mcoddest := SC6->C6_CODDEST
mcliente := SC6->C6_CLI
DBSELECTAREA("SA1")
If DBSEEK(XFILIAL("SA1")+MCLIENTE)
	CLIE_NOME := SA1->A1_NOME
ELSE
	CLIE_NOME := '  '
ENDIF
MEND      := SA1->A1_END
MBAIRRO   := SA1->A1_BAIRRO
MMUN      := SA1->A1_MUN
MEST      := SA1->A1_EST
MCEP      := SA1->A1_CEP
MFONE     := SA1->A1_TEL
CLIE_DEST := SPACE(40)

IF MCODDEST#' '
	DBSELECTAREA("SZN")
	If DBSEEK(XFILIAL("SZN")+MCLIENTE+MCODDEST)
		CLIE_DEST:=SZN->ZN_NOME
	ENDIF
	DBSELECTAREA("SZO")
	IF DBSEEK(XFILIAL("SZO")+MCLIENTE+MCODDEST)
		MEND    := SZO->ZO_END
		MBAIRRO := SZO->ZO_BAIRRO
		MMUN    := SZO->ZO_CIDADE
		MEST    := SZO->ZO_ESTADO
		MCEP    := SZO->ZO_CEP
		MFONE   := SZO->ZO_FONE
	ENDIF
ENDIF
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//�  GRAVA ARQUIVO TEMPORARIO                                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
GRAVA_TEMP()

DBSELECTAREA("ETIQAV")
cIndex := CriaTrab(Nil,.F.)
cKey   := "cep"
Indregua("ETIQAV",cIndex,ckey,,,"Selecionando Registros do Arq")

aReturn := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
cDesc1  := ' '
cDesc2  := ' '
cDesc3  := ' '
cString := 'ETIQAV'
MHORA      := TIME()
wnrel   := "ETIQAV_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
wnrel   := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica Posicao do Formulario na Impressora                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

Processa({|| P045ProcB()})

Return

Static Function P045ProcB()

DbSelectArea("ETIQAV")
Dbgotop()
SETPRC(0,0)
LIN := 0
COL := 1
LI  := 0
ProcRegua(RecCount())
WHILE !EOF()
	IncProc("Imprimindo Etiqueta "+Alltrim(Str(Recno(),6)))
	
	@ LIN+LI,001 PSAY NOME
	DBSKIP()
	@ LIN+LI,043 PSAY NOME
	DBSKIP(-1)
	LI++
	
	@ LIN+LI,001 PSAY DEST
	DBSKIP()
	@ LIN+LI,043 PSAY DEST
	DBSKIP(-1)
	LI++
	
	@ LIN+LI,001 PSAY V_END
	DBSKIP()
	@ LIN+LI,043 PSAY V_END
	DBSKIP(-1)
	LI++
	
	@ LIN+LI,001 PSAY BAIRRO
	@ LIN+LI,032 PSAY NUMPED
	DBSKIP()
	@ LIN+LI,043 PSAY BAIRRO
	@ LIN+LI,073 PSAY NUMPED
	DBSKIP(-1)
	LI++
	
	@ LIN+LI,001 PSAY SUBS(CEP,1,5)+'-'+SUBS(CEP,6,3)+'   ' +MUN+' ' +EST
	DBSKIP()
	@ LIN+LI,043 PSAY SUBS(CEP,1,5)+'-'+SUBS(CEP,6,3)+'   ' +MUN+' ' +EST
	LI++
	DBSKIP()
	
	LI  := 2
	setprc(0,0)
	lin := prow()
END

IF aRETURN[5] == 1
	SET PRINTER TO
	dbcommitAll()
	ourspool(WNREL)
ENDIF

MS_FLUSH()

SET DEVICE TO SCREEN

DbSelectArea("ETIQAV")
DBCLOSEAREA()

Return
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿒RAVA_TEMP튍utor  쿘icrosiga           � Data �  04/06/02   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     쿒rava arquivo temporario de processamento                   볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP5                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
Static FUNCTION GRAVA_TEMP()
DBSELECTAREA("ETIQAV")

Reclock("ETIQAV",.t.)
replace NUMPED	WITH  Val(MPEDIDO)
replace NOME		WITH  CLIE_NOME
replace DEST		WITH  CLIE_DEST
replace V_END 	WITH  MEND
REPLAce BAIRRO	WITH  MBAIRRO
REPLAce MUN		WITH  MMUN
REPLAce CEP		WITH  MCEP
REPLAce EST		WITH  MEST
MSUnlock()

RETURN