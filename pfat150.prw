#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"  //consulta SQL

/*/   Alterado por Danilo C S Pala em 20040324
Alterado por Danilo C S Pala 20090611 : arvore + ajustes: cida
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: PFAT150   �Autor: Raquel Ramalho         � Data:   19/03/02 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Gera arquivo DBF das vendas                                � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento                                      � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Pfat150()
//�������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                                    �
//�������������������������������������������������������������������������Ĵ
//� mv_par01 Circula�ao de......:                                           �
//� mv_par02 Circula��o at�.....:                                           �
//� mv_par03 Tipo do Pedido.....: Pagos, Cortesia                           �
//���������������������������������������������������������������������������
Private cArq150a, cArq150c, cArq150d, qual

Programa  := "PFT150"
MHORA     := TIME()
cArq      := SUBS(CUSUARIO,7,3) + SUBS(MHORA,1,2) + SUBS(MHORA,7,2)
cString   := SUBS(CUSUARIO,7,3) + SUBS(MHORA,1,2) + SUBS(MHORA,7,2)
lContinua := .T.
cArqPath  := GetMv("MV_PATHTMP")
_cString  := cArqPath+cString+".DBF"             

Public mPEQUIPE:= space(6) //20090611 DAQUI
Public mPTIPO:= space(6)
Public mPREGIAO:= space(6)
Public mPATEND:= space(6)
Public mPPORCENT:= space(6)
Public mPARVORE1:= space(20)
Public mPARVORE2:= space(20)
Public mPARVORE3:= space(20) //20090611 ATE DAQUI

//��������������������������������������������������������������Ŀ
//� Caso nao exista, cria grupo de perguntas.                    �
//����������������������������������������������������������������
cPerg     := "PFT150"

//_ValidPerg()

If !Pergunte(cPerg)
	Return
Endif

IF Lastkey()==27
	Return
Endif

FArqTrab()

FiltraAtivos()
lEnd   := .F.
bBloco := {|lEnd| PRODUTOS(@lEnd) }
Processa( bBloco, "Aguarde" ,"Processando ativos...", .T. )
//Produtos()

FiltraCancelados()
Processa( bBloco, "Aguarde" ,"Processando cancelados...", .T. )
//Produtos()


DbSelectArea(cArq)
dbGoTop()
cIndex := CriaTrab(Nil,.F.)
cKey   := "TITULO"
MsAguarde({|| Indregua(cArq,cIndex,ckey,,,"Selecionando Registros do Arq")},"Aguarde","Gerando Indice Temporario (TITULO)...")

cMsg   := "Arquivo Gerado com Sucesso em: "+_cString
//MsAguarde("Aguarde" ,"Copiando Arquivo...", .T. )
DbSelectArea(cArq)
dbGoTop()
COPY TO &_cString VIA "DBFCDXADS" // 20121106 
MSGINFO(cMsg)


NOVAVERSAO() //20090615
//��������������������������������������������������������������Ŀ
//� Retorna indices originais...                                 �
//����������������������������������������������������������������

DbSelectArea("PFAT150")
DbCloseArea()

DbSelectArea(cArq)
DbCloseArea()

DbSelectArea("SA1")
Retindex("SA1")

DbSelectArea("SC6")
Retindex("SC6")

DbSelectArea("SC5")
Retindex("SC5")

DbSelectArea("SA3")
Retindex("SA3")

DbSelectArea("SB1")
Retindex("SB1")

DbSelectArea("SX5")
Retindex("SX5")

DbSelectArea("SF4")
Retindex("SF4")

DbSelectArea("SZ9")
Retindex("SZ9")

DbSelectArea("SE4")
Retindex("SE4")

DbSelectArea("ZZ8")
Retindex("ZZ8")

DbSelectArea("SZS")
Retindex("SZS")
Return





//���������������������������������������������������������������������������Ŀ
//� Function  � FiltraAtivos()                                                �
//���������������������������������������������������������������������������Ĵ
//� Descricao � Filtra arquivo SZS para as a.v.s ativas com numins=1    	  �
//�����������������������������������������������������������������������������
Static Function FiltraAtivos()
qual = "A"
DbSelectArea("SZS")
DbGoTop()
DbSetOrder(1)
cChave  := IndexKey()
cFiltro := 'DTOS(ZS_DTCIRC) >= "' + DTOS(MV_PAR01) + '"'
cFiltro += ' .AND. DTOS(ZS_DTCIRC) <= "' + DTOS(MV_PAR02) + '"'
cFiltro += ' .AND. Alltrim(ZS_SITUAC) == "AA"'
cFiltro += ' .AND. ZS_NUMINS == 1'
cInd    := CriaTrab(NIL,.f.)
MsAguarde({|| IndRegua("SZS",cInd,cChave,,cFiltro,"Filtrando...")},"Aguarde","Gerando Novo Indice Temporario (SZS)...")

cArq150a := "PFAT150A.DBF"
Copy to &cArq150a VIA "DBFCDXADS" // 20121106 

DbSelectArea("SZS")
Set Filter to
Retindex()
Return




//���������������������������������������������������������������������������Ŀ
//� Function  � FiltraCancelados()                                            �
//���������������������������������������������������������������������������Ĵ
//� Descricao � Filtra arquivo SZS para as a.v.s cancelados lanc de estorno	  �
//�����������������������������������������������������������������������������
Static Function FiltraCancelados()
qual = "C"
DbSelectArea("SZS")
DbGoTop()
DbSetOrder(1)
cChave  := IndexKey()
cFiltro := 'DTOS(ZS_DTCANC) >= "' + DTOS(MV_PAR01) + '"'
cFiltro += ' .AND. DTOS(ZS_DTCANC) <= "' + DTOS(MV_PAR02) + '"'
cFiltro += ' .AND. Alltrim(ZS_SITUAC) == "CC"'
cInd    := CriaTrab(NIL,.f.)
MsAguarde({|| IndRegua("SZS",cInd,cChave,,cFiltro,"Filtrando...")},"Aguarde","Gerando Indice Temporario (SZS)...")

cArq150c := "PFAT150C.DBF"
Copy to &cArq150c VIA "DBFCDXADS" // 20121106 

DbSelectArea("SZS")
Set Filter to
Retindex()
Return






//���������������������������������������������������������������������������Ŀ
//� Function  � PRODUTOS()                                                    �
//���������������������������������������������������������������������������Ĵ
//� Descricao � Realiza leitura dos registros do SZS ja filtrado e aplica     �
//�           � restante dos filtros de parametros. Prepara os dados para     �
//�           � serem gravados. Faz chamada a funcao GRAVA.                   �
//���������������������������������������������������������������������������Ĵ
//� Observ.   �                                                               �
//�����������������������������������������������������������������������������
Static Function PRODUTOS()
if qual = "A"
	cArqTemp1 := "PFAT150A.DBF"
else
	cArqTemp1 := "PFAT150C.DBF"
endif

dbUseArea( .T.,, cArqTemp1,"PFAT150", if(.F. .OR. .F., !.F., NIL), .F. )
mConta1 := 0

ProcRegua(RecCount())

While !Eof()
	mCodProm  := ""
	mIdentif  := ""
	mCondPgto := ""
	mTpTrans  := ""
	mEquipe   := ""
	mRegiao   := ""
	mDivVend  := ""
	mNomeVend := ""
	mDescrop  := ""
	mVend     := ""
	mTipoop   := ""
	mVlliq    := 0
	mValor    := 0
	mDtPed    := stod("")
	mPedido   := Padr(PFAT150->ZS_NUMAV,6)
	mProduto  := ZS_CODPROD
	mSituac   := Padr(PFAT150->ZS_SITUAC,2)
	mItemAv   := Padr(PFAT150->ZS_ITEM,2)
	mNumIns   := Str(PFAT150->ZS_NUMINS)
	
	/*//teste 20040324
	if mpedido == '60940P'
		msgalert("achou! "+mpedido+"("+mItemAv+") - "+mnumins)
	endif
	*///ateh aki
	
	dbSelectArea(cArq)
	DbGoTop()
	If DbSeek(mPedido+mItemAv+mSituac)
		dbSelectArea("PFAT150")
		DbSkip()
		Loop
	Endif
	
	DbSelectArea("SC5")
	DbSetOrder(1)
	If DbSeek(xFilial("SC5")+mPedido)
		mVend     := SC5->C5_VEND1
		mCodProm  := SC5->C5_CODPROM
		mIdentif  := SC5->C5_IDENTIF
		mTipoop   := SC5->C5_TIPOOP
		mDtPed    := SC5->C5_DATA
		mCondPgto := SC5->C5_CONDPAG
		mTpTrans  := SC5->C5_TPTRANS
		mDtPed    := SC5->C5_DATA
	Endif
	
	DbSelectArea("SA3")
	DbSetOrder(1)
	If DbSeek(xFilial("SA3")+mVend)
		mEquipe   := SA3->A3_EQUIPE
		mRegiao   := SA3->A3_REGIAO
		mDivVend  := SA3->A3_DIVVEND
		mNomeVend := SA3->A3_NOME
	Endif
	
	DbSelectArea("SZ9")
	//DbGoTop()
	DbSetOrder(1)
	If DbSeek(xFilial("SZ9")+mTipoop)
		mDescrop := SZ9->Z9_DESCR
	Endif
	
	IF Alltrim(SC5->C5_DIVVEN) == 'PUBL'
		DbSelectArea("SE4")
		DbSetOrder(1)
		If DbSeek(xFilial("SE4")+mCondpgto)
			mDescrop := SE4->E4_DESCRI
		Endif
	Endif
	
	DbSelectArea(cArq)
	
	dbSelectArea("SZS")
	DbSetOrder(1)
	DbGoTop()
	DbSeek(xFilial("SZS")+mPedido+mItemAv,.T.)
	While !Eof() .and. SZS->ZS_FILIAL == xFilial("SZS") .and. SZS->ZS_NUMAV == mPedido .and. SZS->ZS_ITEM == mItemAV
		
		mDTFat   := ""
		mCodCli  := ""
		mItem    := ""
		mCF      := ""
		mCodDest := ""
		mQtde    := 0
		mDTFat   := stod("")
		mEdicao  := SZS->ZS_EDICAO
		mValor   := SZS->ZS_VALOR
		mDtcirc := SZS->ZS_DTCIRC
		
		dbSelectArea(cArq)
		DbGoTop()
		If DbSeek(SZS->ZS_NUMAV+SZS->ZS_ITEM+SZS->ZS_SITUAC+STR(SZS->ZS_NUMINS))
			dbSelectArea("SZS")
			DbSkip()
			Loop
		Endif   
		
		IF qual="C" .and. Alltrim(SZS->ZS_SITUAC) <> 'CC'
			dbSelectArea("SZS")
			DbSkip()
			Loop		
		ENDIF 
		
		
		if qual = "A"
			If Alltrim(SZS->ZS_SITUAC) == 'CC'
				mSituac := "AA"
			Endif
			mFator  := 1
		else
			If Alltrim(SZS->ZS_SITUAC) == 'CC'
				mSituac := SZS->ZS_SITUAC
				mFator  := -1
			Else
				mFator  := 1
			Endif
		endif
		
		//If mTptrans == '04' .or. mTptrans == '12' .or. mTptrans == '05' .or. mTptrans == '13'
		//	mVlliq  := (mValor*0.80)*mFator
		//Else
		//	mVlliq  := mValor*mFator
		//Endif
		
		mCodTit    := SZS->ZS_CODTIT
		mItem      := SZS->ZS_ITEM
		mDtCanc    := SZS->ZS_DTCANC
		
		DbSelectArea("SC6")
		//DbGoTop()
		DbSetOrder(1)
		If DbSeek(xFilial("SC6")+mPedido+mItem) //, .T.)
			mDTFat   := SC6->C6_DATFAT
			mCodCli  := SC6->C6_CLI
			mItem    := SC6->C6_ITEM
			mCF      := AllTrim(SC6->C6_CF)
			mCodDest := SC6->C6_CODDEST
			mFilial  := SC6->C6_FILIAL
			mQtde    := SC6->C6_QTDVEN
		Endif
		
		mValor   := mValor //* mQtde
		
		If Alltrim(mTptrans) == '04' .or. Alltrim(mTptrans) == '12' // .or. Alltrim(mTptrans) == '05' .or. Alltrim(mTptrans) == '13'
			mVlliq  := (mValor*0.80)*mFator
		Else
			mVlliq  := mValor*mFator
		Endif
		
		DbSelectArea("SF4")
		//DbGoTop()
		DbSetOrder(1)
		DbSeek(xFilial("SF4")+SC6->C6_TES)
		If 'N' $(SF4->F4_DUPLIC) .OR. SC6->C6_PRCVEN == 1 .OR. SC6->C6_PRCVEN == 0
			//��������������������������������������������������������������Ŀ
			//� Verifica se � cortesia para par�metro=pago                   �
			//����������������������������������������������������������������
			If MV_PAR03 == 1
				DbSelectArea("SZS")
				DbSkip()
				Loop
			EndIf
		Else
			//��������������������������������������������������������������Ŀ
			//� Verifica se � pago para par�metro=cortesia                   �
			//����������������������������������������������������������������
			If MV_PAR03 == 2
				DbSelectArea("SZS")
				DbSkip()
				Loop
			EndIf
		EndIf
		
		DbSelectArea("PFAT150")
		GRAVA()
		//IncProc("Lendo Registros : "+StrZero(Recno(),7)+"  Gravando...... "+StrZero(mConta1,7))
		
		DbSelectArea("SZS")
		DbSkip()
	End
	IncProc("Lendo Registros : "+StrZero(Recno(),7)+"  Gravando...... "+StrZero(mConta1,7))
	DbSelectArea("PFAT150")
	DbSkip()
End  
if qual = "A"               
	cArq150d := "PFAT150D"
	Copy to &cArq150d VIA "DBFCDXADS" // 20121106 
	DbSelectArea("PFAT150")
	DBCloseArea()	
else       
	append from &cArq150d
endif
Return


//���������������������������������������������������������������������������Ŀ
//� Function  � GRAVA()                                                       �
//���������������������������������������������������������������������������Ĵ
//� Descricao � Realiza gravacao dos registros    �
//�           � para impressao de Relatorio.                                  �
//���������������������������������������������������������������������������Ĵ
//� Observ.   �                                                               �
//�����������������������������������������������������������������������������
Static Function GRAVA()
mNome      := ""
mUF        := ""
mMun       := ""
mGrupo     := ""
mDescr     := ""
mRevista   := ""
mTitulo    := ""
mDescr2    := ""
mAtividade := ""
mDescrTp   := ""

DbSelectArea("SB1")
DbSetOrder(1)
If DbSeek(xFilial("SB1")+mProduto)
	mGrupo  := AllTrim((SB1->B1_GRUPO))
	mDescr  := SB1->B1_DESC
	mDescr2 := SB1->B1_DESC
Endif

DbSelectArea("SB1")
DbSetOrder(1)
If DbSeek(xFilial("SB1")+subs(mProduto,1,4)+'000')
	mRevista := SB1->B1_DESC
Endif

If substr(mProduto,1,2)=='03'
	mDescr   := mRevista
Endif

DbSelectArea("SBM")
If DbSeek(xFilial("SBM")+mGrupo)
	mTitulo := SBM->BM_DESC
Endif

DbSelectArea("SX5")
If DbSeek(xFilial("SX5")+'Z0'+mTpTrans+'  ')
	mDescrTp := SX5->X5_DESCRI
Endif

DbSelectArea("SA1")
DbSetOrder(1)
If DbSeek(xFilial("SA1")+mCodcli)
	mNome      := SA1->A1_NOME
	mUF        := SA1->A1_EST
	mMun       := SA1->A1_MUN
	mAtividade := SA1->A1_ATIVIDA
Endif

DbSelectArea("ZZ8")
DbSetOrder(1)
If DbSeek(xFilial("ZZ8")+mAtividade)
	mAtividade := ZZ8->ZZ8_DESCR
Endif

//Arvore() //20090611

mConta1++

//IncProc("Lendo Registros : "+Str(Recno(),7)+"  Gravando...... "+StrZero(mConta1,7))

DbSelectArea(cArq)
RecLock(cArq,.T.)
Replace Pedido   With  mPedido
Replace Item     With  mItem
Replace CodCli   With  mCodCli
Replace CodDest  With  mCodDest
Replace Produto  With  mProduto
Replace Tipoop   With  mTipoop
Replace Descrop  With  mDescrop
Replace NomeVend With  mNomeVend
Replace CF       With  mCF
Replace VlItem   With  mValor
Replace VlLiq    With  mVlliq
Replace Situac   With  mSituac
Replace NumIns   With  SZS->ZS_NUMINS
Replace DtCanc   With  mDtcanc
Replace DtPed    With  mDtPed
Replace Titulo   With  mTitulo
Replace Revista  With  mRevista
Replace Descr    With  mDescr
Replace Descr2   With  mDescr2
Replace Vend     With  mVend
Replace Regiao   With  mRegiao
Replace Equipe   With  mEquipe
Replace Qtde     With  mQtde
Replace CodProm  With  mCodProm
Replace Identif  With  mIdentif
Replace Nome     With  mNome
Replace UF       With  mUF
Replace Mun      With  mMun
Replace DivVend  With  mDivVend
Replace Ativida  With  mAtividade
Replace Tptrans  With  mDescrTp
Replace CodTit   With  mCodTit
Replace Edicao   With  mEdicao
Replace DtCirc   With  mDtcirc
Replace Ano      With  year(mDtcirc)
Replace Mes      With  Month(mDtcirc)
/*Replace PEQUIPE  With  mPEQUIPE//20090611 DAQUI
Replace PTIPO    With  mPTIPO
Replace PREGIAO  With  mPREGIAO
Replace PATEND   With  mPATEND
Replace PPORCENT With  mPPORCENT
Replace PARVORE1 With  mPARVORE1
Replace PARVORE2 With  mPARVORE2
Replace PARVORE3 With  mPARVORE3 //20090611 ATE DAQUI
*/
MsUnlock()

Return



//���������������������������������������������������������������������������Ŀ
//� Function  � FARQTRAB()                                                    �
//���������������������������������������������������������������������������Ĵ
//� Descricao � Cria arquivo de trabalho para guardar registros que serao     �
//�           � impressos em forma de etiquetas.                              �
//�           � serem gravados. Faz chamada a funcao GRAVA.                   �
//���������������������������������������������������������������������������Ĵ
//� Observ.   �                                                               �
//�����������������������������������������������������������������������������
Static Function FARQTRAB()

_aCampos := {}
AADD(_aCampos,{"PEDIDO","C",6,0})
AADD(_aCampos,{"ITEM","C",2,0})
AADD(_aCampos,{"CF","C",5,0})
AADD(_aCampos,{"CODCLI","C",6,0})
AADD(_aCampos,{"NOME","C",40,0})
AADD(_aCampos,{"CODDEST","C",6,0})
AADD(_aCampos,{"PRODUTO" ,"C",15,0})
AADD(_aCampos,{"TITULO","C",40,0})
AADD(_aCampos,{"REVISTA","C",40,0})
AADD(_aCampos,{"DESCR","C",40,0})
AADD(_aCampos,{"DESCR2","C",40,0})
AADD(_aCampos,{"DTPED ","D",8,0})
AADD(_aCampos,{"DTFAT ","D",8,0})
AADD(_aCampos,{"QTDE","N",10,0})
AADD(_aCampos,{"NUMINS","N",2,0})
AADD(_aCampos,{"VLITEM","N",12,2})
AADD(_aCampos,{"VLLIQ","N",12,2})
AADD(_aCampos,{"SITUAC","C",2,0})
AADD(_aCampos,{"DTCANC","D",8,0})
AADD(_aCampos,{"VEND","C",6,0})
AADD(_aCampos,{"REGIAO","C",3,0})
AADD(_aCampos,{"EQUIPE","C",15,0})
AADD(_aCampos,{"NOMEVEND","C",40,0})
AADD(_aCampos,{"DIVVEND","C",40,0})
AADD(_aCampos,{"CODPROM","C",15,0})
AADD(_aCampos,{"IDENTIF","C",8,0})
AADD(_aCampos,{"MUN ","C",30,0})
AADD(_aCampos,{"UF","C",2,0})
AADD(_aCampos,{"ATIVIDA","C",40,0})
AADD(_aCampos,{"TIPOOP","C",2,0})
AADD(_aCampos,{"DESCROP","C",50,0})
AADD(_aCampos,{"TPTRANS","C",60,0})
AADD(_aCampos,{"CODTIT","C",3,0})
AADD(_aCampos,{"EDICAO","N",4,0})
AADD(_aCampos,{"DTCIRC","D",08,0})
AADD(_aCampos,{"ANO","N",4,0})
AADD(_aCampos,{"MES","N",2,0})
/*AADD(_aCampos,{"PEQUIPE","C",6,0}) //20090611 DAQUI
AADD(_aCampos,{"PTIPO","C",6,0})
AADD(_aCampos,{"PREGIAO","C",6,0})
AADD(_aCampos,{"PATEND","C",6,0})
AADD(_aCampos,{"PPORCENT","N",3,0})
AADD(_aCampos,{"PARVORE1","C",20,0})
AADD(_aCampos,{"PARVORE2","C",20,0})
AADD(_aCampos,{"PARVORE3","C",20,0}) //20090611 ATE DAQUI
*/
_cNome := CriaTrab(_aCampos,.t.)
cIndex := CriaTrab(Nil,.F.)
cKey   := "Pedido+Item+Situac+Str(NumIns)"
dbUseArea(.T.,, _cNome,cArq,.F.,.F.)
dbSelectArea(cArq)
MsAguarde({|| Indregua(cArq,cIndex,ckey,,,"Selecionando Registros do Arq")},"Aguarde","Gerando Indice Temporario (PEDIDO)...")
Return




Static Function Arvore() //20090611
private cQuery := space(200)
cQuery := "SELECT C5_PUBEQUI EQUIPE, C5_PUBTIP1 TIPO, C5_PUBREG1 REGIAO, C5_PUBATE1 ATEND, DECODE(C5_PUBREG2,'      ',100,50) AS PORCENT"
cQuery += " , SUBSTR(F_SB5_ARVORE(C6_PRODUTO,1),1,60) ARVORE1, SUBSTR(F_SB5_ARVORE(C6_PRODUTO,2),1,60) ARVORE2, SUBSTR(F_SB5_ARVORE(C6_PRODUTO,3),1,60) ARVORE3"
cQuery += " FROM "+ RetSqlName("SC6") +" SC6, "+ RetSqlName("SC5") +" SC5 WHERE C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C5_DATA=C6_DATA AND C6_FILIAL='"+ xfilial("SC5") +"' AND C6_NUM='"+ mPedido +"' AND C6_ITEM='"+ mItem +"' AND C6_DATA='"+ dtos(mDtPed) +"' AND SC5.D_E_L_E_T_<>'*' AND SC6.D_E_L_E_T_<>'*'"

MsAguarde({|| DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "PUBARV", .T., .F. )},"Aguarde - NAO DESCONECTE!","Selecionando dados...")
DBSELECTAREA("PUBARV")       
DBGOTOP()

mPEQUIPE  := PUBARV->EQUIPE
mPTIPO    := PUBARV->TIPO
mPREGIAO  := PUBARV->REGIAO
mPATEND   := PUBARV->ATEND
mPPORCENT := PUBARV->PORCENT
mPARVORE1 := PUBARV->ARVORE1
mPARVORE2 := PUBARV->ARVORE2
mPARVORE3 := PUBARV->ARVORE3

DBSELECTAREA("PUBARV")       
DbCloseArea()
Return

      

Static Function NOVAVERSAO() //20090612
private cQuery := space(400)
Private cGerado := cArqPath+"PUBPREM.DBF"
If TCSPExist("SP_PUBLICIDADEPREMIO")
	//SP_PUBLICIDADEPREMIO(IN_DATADE VARCHAR2, IN_DATAATE VARCHAR2, IN_TIPO VARCHAR2)
	aRet := TCSPExec("SP_PUBLICIDADEPREMIO", dtos(mv_par01), dtos(mv_par02), iif(mv_par03==1,'P','C'))
	
	cQuery := "SELECT * FROM DANILO_PUBLICIDADEPREMIO ORDER BY PEDIDO, ITEM, NUMINS, SITUAC"
	MsAguarde({|| DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "PUBPREM", .T., .F. )},"Aguarde - NAO DESCONECTE!","Selecionando dados...")
	TcSetField("PUBPREM","DTPED"   ,"D")
	TcSetField("PUBPREM","DTFAT"   ,"D")
	TcSetField("PUBPREM","DTCANC"  ,"D")
	TcSetField("PUBPREM","DTCIRC"  ,"D")
	TcSetField("PUBPREM","DTAGRUP" ,"D")

	DBSELECTAREA("PUBPREM")
	DBGOTOP()
	//COPIAR
	COPY TO &cGerado VIA "DBFCDXADS" // 20121106 
	MSGINFO(cGerado)

DBSELECTAREA("PUBPREM")
DbCloseArea()
else
	MSGINFO("NAO EXISTE A PROCEDURE: ")
endif
Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �VALIDPERG � Autor �  Luiz Carlos Vieira   � Data � 16/07/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica as perguntas inclu�ndo-as caso n�o existam        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico para clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function _ValidPerg
_sAlias := Alias()
DbSelectArea("SX1")
DbSetOrder(1)
cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3

AADD(aRegs,{cPerg,"01","Circula��o de......:","mv_ch1","D",08,0,0,"G","","mv_par01","","'01/06/99'","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Circula��o at�.....:","mv_ch2","D",08,0,0,"G","","mv_par02","","'17/04/00'","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Tipo do Pedido.....:","mv_ch3","C",01,0,2,"C","","mv_par03","Pagos","","","Cortesias","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
DbSelectArea(_sAlias)
Return
