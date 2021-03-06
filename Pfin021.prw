#include "rwmake.ch"
/*/
Alterado por Danilo C S Pala em 20070418: adicionar o E1_VENCORI
//Danilo C S Pala 20090514: filtrar por cliente
//Danilo C S Pala 20091001: AGENCIA E CONTA - IOLANDA
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ ±±
±±³Programa: PFIN021   ³Autor: Danilo C S Pala        ³ Data:   20060426 ³ ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ ±±
±±³Descri‡ao: Gera arquivo DBF dos Recebimentos por titulo               ³ ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ ±±
±±³Uso      : M¢dulo de Financeiro                                       ³ ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
User Function Pfin021()
Private Programa, mhora, carq, cString, wnrel, nLastKey, _cNome 
Private lContinua, cArqPath, _cString, lEnd, _aCampos, cIndex, cKey 
Private mPedido, mTipoop, mDescrop, mSerie, mDtFat, mBaixa, mNatureza,MVENCREAL, MSITUACA
Private mDescNat, mDtAlt,mVencto, mNota, mParcela, mValor, mPago, mDesconto
Private mAberto, mVencido, mInadimpl, mCancelado, mLp, mPortado, mDescPort, mCodProm
Private mCodCli,  mNome, mUF, mMun, mAtividade, mTelefone, mCGC, mEndereco, mBairro, mCep, mTipo
Private mVend, mRegiao, mEquipe, mDivVend, mNomeVend, mconta, MDESPREM, MDESPBOL, MVENCORI
Private mAgencia, mContaBanco

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                    ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ mv_par01 Vencimento de:                                                 ³
//³ mv_par02 Vencimento at‚:                                                ³
//³ mv_par03 Baixado   Em Aberto    Ambos                                   ³
//| MV_PAR04 VENCIMENTO EMISSAO												³
//³ mv_par05 cliente de 				                                    ³
//³ mv_par06 cliente ate 				                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Programa  := "PFIN021"
MHORA     := TIME()
cArq      := SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
cString   := SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
wnrel     := SUBS(CUSUARIO,7,6)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
nLastKey  := 00
lContinua := .T.
cArqPath  := GetMv("MV_PATHTMP")
_cString  := cArqPath+cString+".DBF"
cPerg:="PFT146"
mConta := 0

If !Pergunte(cPerg)
	Return
Endif

IF Lastkey()==27
	Return
Endif

FArqTrab()

Filtra()

lEnd:= .F.
bBloco:= {|lEnd| ProcTitulos(@lEnd)}
Processa( bBloco, "Aguarde" ,"Processando...", .T. )
   
cMsg:= "Arquivo Gerado com Sucesso em: "+_cString

DbSelectArea(cArq)
dbGoTop()
COPY TO &_cString VIA "DBFCDXADS" // 20121106 
MSGINFO(cMsg)

DbSelectArea("TRB")
DbCloseArea()

DbSelectArea(cArq)
DbCloseArea()
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Function  ³ Filtra()                                                      ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ Descricao ³ Filtra arquivo SE1 para ser utilizado no programa.            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function FILTRA()
Local cQuerySE1 := ""
                                          
cQuerySE1 += "SELECT E1_FILIAL, E1_VENCTO, E1_CLIENTE, E1_PEDIDO, E1_NUM, E1_SERIE, E1_EMISSAO,"
cQuerySE1 += " E1_PARCELA, E1_PORTADO, E1_NATUREZ, E1_VENCREA, E1_SITUACA, E1_VALOR,E1_DTALT, E1_BAIXA,"
cQuerySE1 += " E1_SALDO, E1_MOTIVO, E1_DESCONT, E1_NATUREZ, E1_DESPREM, E1_DESPBOL, E1_VENCORI, E1_AGEDEP, E1_CONTA FROM " + RetSqlName("SE1") + " SE1"
cQuerySE1 += " WHERE SE1.E1_FILIAL = '" + xFilial("SE1") + "'"
cQuerySE1 += " AND SE1.E1_CLIENTE >= '" + MV_PAR05 + "' AND SE1.E1_CLIENTE <= '" + MV_PAR06 + "'" //20090514
IF MV_PAR04 == 1 //VENCIMENTO
	cQuerySE1 += " AND SE1.E1_VENCTO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' AND SE1.E1_TIPO ='NF'"
ELSE //EMISSAO
	cQuerySE1 += " AND SE1.E1_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' AND SE1.E1_TIPO ='NF'"
ENDIF
cQuerySE1 += " AND SE1.D_E_L_E_T_ <> '*' "
cQuerySE1 += " ORDER BY SE1.E1_FILIAL, SE1.E1_VENCTO"

lEnd := .f.

If Select("TRB") <> 0
	DbselectArea("TRB")
	DbCloseArea()
EndIf	
MsAguarde({|| DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuerySE1), "TRB", .T., .F. )},"Aguarde - NAO DESCONECTE!","Selecionando dados. Isto pode demorar...")

TcSetField("TRB","E1_VENCTO"  ,"D")
TcSetField("TRB","E1_BAIXA"   ,"D")
TcSetField("TRB","E1_EMISSAO" ,"D")
TcSetField("TRB","E1_DTALT"   ,"D")
TcSetField("TRB","E1_VENCREA" ,"D")
TcSetField("TRB","E1_VENCORI" ,"D") //20070418
Dbgotop()
Return




//ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Function  ³ ProcTitulos()                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ProcTitulos()
mConta := 0
DbSelectArea("TRB")
ProcRegua(LastRec())
DbGoTop()
While !EOF() .and. TRB->E1_FILIAL == xFilial("SE1") .AND. !lEnd //DTOS(TRB->E1_VENCTO) <= DTOS(MV_PAR02) .and.
	mDTFat     := stod("")
	mVend      := ""
	mNome      := ""
	mUF        := ""
	mMun       := ""
	mTipo      := ""
	mAtividade := ""
	mDescPort  := ""
	mTelefone  := ""
	mEndereco  := ""
	mBairro	   := ""
	mCEP	   := ""
	mDescrop   := ""
	mDivVend   := ""
	mAtividade := ""
	mTipoop    := "" 
	mPago      := 0
	mCancelado := 0
	mAberto    := 0
	mInadimpl  := 0
	mVencido   := 0
	mLp        := 0
	mDesconto  := 0
	mNomeVend  := "" 
	mCodCli	   := TRB->E1_CLIENTE
	mPedido    := TRB->E1_PEDIDO
	mNota      := TRB->E1_NUM
	mSerie     := TRB->E1_SERIE
	mDTFat     := TRB->E1_EMISSAO
	mParcela   := TRB->E1_PARCELA
	mVencto    := TRB->E1_VENCTO
	mPortado   := TRB->E1_PORTADO
	mNatureza  := TRB->E1_NATUREZ                                                
	mVencReal  := TRB->E1_VENCREA
	MSITUACA   := TRB->E1_SITUACA
	mValor     := TRB->E1_VALOR
	MDESPREM   := TRB->E1_DESPREM  //20060526
	MDESPBOL   := TRB->E1_DESPBOL  //20060526
	MVENCORI   := TRB->E1_VENCORI  //20070418
	mAgencia   := TRB->E1_AGEDEP //20091001
	mContaBanco := TRB->E1_CONTA  //20091001
	mCGC	   := space(14)
	If DTOS(TRB->E1_DTALT)='       '
	   mDtAlt:=DTOS(TRB->E1_BAIXA)  
	Else
	   mDtAlt:= DTOS(TRB->E1_DTALT)
	Endif      
	
	If mDtAlt<DTOS(DDATABASE)
       mBaixa     := TRB->E1_BAIXA
	Else
	   mBaixa      :=stod("")
	Endif  

	IncProc("Lendo Registros : "+StrZero(Recno(),7)+"  Gravando...... "+StrZero(mConta,7))
	
	If MV_PAR03 == 1 .and. DTOS(TRB->E1_BAIXA) == "        "
		DbSelectArea("TRB")
		DbSkip()
		Loop
	Endif
	
	If MV_PAR03 == 2 .and. DTOS(mBaixa) <> "       "
		DbSelectArea("TRB")
		DbSkip()
		Loop
	Endif
	
	DbSelectArea(cArq)
	If DbSeek(TRB->E1_PEDIDO + TRB->E1_NUM + TRB->E1_PARCELA)
		DbSelectArea("TRB")
		DbSkip()
		Loop
	Endif
	
	DbSelectArea("SC5")
	DbSetOrder(1)
	If DbSeek(xFilial("SC5")+mPedido)
		mCodProm  := SC5->C5_CODPROM
		mTipoop   := SC5->C5_TIPOOP
		mVend     := SC5->C5_VEND1
		mCondPgto := SC5->C5_CONDPAG
		mValorPed := SC5->C5_VLRPED
		mDivVend  := SC5->C5_DIVVEN
	Endif

	If DTOS(TRB->E1_BAIXA) <> "        " .And. TRB->E1_SALDO==0 .AND. !'LP'$(TRB->E1_MOTIVO);
		.AND. !'CAN'$(TRB->E1_MOTIVO) .AND. !'DEV'$(TRB->E1_MOTIVO) .AND. (!'920'$(TRB->E1_PORTADO) .and. !'930'$(TRB->E1_PORTADO) .and. !'904'$(TRB->E1_PORTADO)) ; 
		.AND. mDtalt<=DTOS(DDATABASE)
		mPago     := TRB->E1_VALOR
		mDesconto := TRB->E1_DESCONT
	Else
		Do Case                                   
			Case DTOS(TRB->E1_VENCTO) < DTOS(DDATABASE-30) .AND. !Alltrim(TRB->E1_MOTIVO)$"CAN" .AND. !Alltrim(TRB->E1_PORTADO)$"920/CAN/930" //20041014
				mInadimpl := TRB->E1_VALOR
			Case DTOS(TRB->E1_VENCTO) < DTOS(DDATABASE) .AND. !Alltrim(TRB->E1_MOTIVO)$"CAN/LP" .AND. !Alltrim(TRB->E1_PORTADO)$"920/CAN/995/930" //20041014
				mVencido  := TRB->E1_VALOR
			Case Alltrim(TRB->E1_MOTIVO)$"CAN" .OR. alltrim(TRB->E1_PORTADO)$"920/CAN/930"
				mCancelado     := TRB->E1_VALOR
			Case Alltrim(TRB->E1_MOTIVO)=="LP" .or. Alltrim(TRB->E1_PORTADO)$"BLP/995" .or. Alltrim(TRB->E1_PORTADO) == "904" //20041027 ALTERADO E1_CODPORT PARA E1_PORTADO
				mLp       := TRB->E1_VALOR
			OtherWise
				mAberto   := TRB->E1_VALOR
		EndCase
	Endif 

	// Tratamento para Lucros e Perdas de Assinaturas - devem ser cancelados
	If DTOS(TRB->E1_BAIXA) <> "        "
		If Alltrim(TRB->E1_MOTIVO) == "LP" .or. Alltrim(TRB->E1_PORTADO) $ "995/BLP" .and. mCancelado == 0
				mCancelado   := IIF(mVencido > 0, mVencido, IIF(mLp > 0,mLp,mInadimpl))
				mVencido := 0
				mLp     := 0
				mInadimpl := 0
		EndIf
	EndIf
	
	DbSelectArea("SA3")
	DbSetOrder(1)
	If DbSeek(xFilial("SA3")+mVend)
		mEquipe  := SA3->A3_EQUIPE
		mRegiao  := SA3->A3_REGIAO
		mDivVend := SA3->A3_DIVVEND
		mNomeVend:= SA3->A3_NREDUZ
	EndIf
	
	DbSelectArea("SZ9")
	DbSetOrder(1)
	If DbSeek(xFilial("SZ9")+mTipoop) //,.T.)
		mDescrop := SZ9->Z9_DESCR
	Endif
	
	IF SC5->C5_DIVVEN == 'PUBL'
		DbSelectArea("SE4")
		DbSetOrder(1)
		If DbSeek(xFilial("SE4")+mCondpgto)
			mDescrop := SE4->E4_DESCRI
		Endif
	Endif     

	DbSelectArea("SA6")
	DbSetOrder(1)
	If DbSeek(xFilial("SA6")+mPortado)
		mDescPort := SA6->A6_NOME
	EndIf

	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial("SA1")+mCodcli)
		mNome      := SA1->A1_NOME
		mUF        := SA1->A1_EST
		mMun       := SA1->A1_MUN
		mTipo      := SA1->A1_TIPO
		mAtividade := SA1->A1_ATIVIDA
		mTelefone  := SA1->A1_TEL
		mCGC	   := SA1->A1_CGC  
		mEndereco  := ALLTRIM(SA1->A1_TPLOG) + " " + ALLTRIM(SA1->A1_LOGR) + " " + ALLTRIM(SA1->A1_NLOGR) + " " + ALLTRIM(SA1->A1_COMPL) //20060327
		mBairro	   := SA1->A1_BAIRRO
		mCEP	   := SA1->A1_CEP
	Endif

	DbSelectArea("ZZ8")
	DbSetOrder(1)
	If DbSeek(xFilial("ZZ8")+mAtividade)
		mAtividade := ZZ8->ZZ8_DESCR
	Endif

	mDescNat := ""
	DbSelectArea("SED")
	DbSetOrder(1)
	If DbSeek(xFilial("SED")+TRB->E1_NATUREZ)
		mDescNat := SED->ED_DESCRIC
	EndIf


    GRAVA()	
    
	DbSelectArea("TRB")
	DbSkip()
End
Return



//ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Function  ³ GRAVA()                                                       ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ Descricao ³ Realiza gravacao dos registros ideais (conforme parametros)   ³
//³           ³ para impressao de Relatorio.                                  ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ Observ.   ³                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function GRAVA()
mConta++

DbSelectArea(cArq)
RecLock(cArq,.T.)
Replace Pedido    With  mPedido
Replace Tipoop    With  mTipoop
Replace Descrop   With  mDescrop
Replace Serie     With  mSerie
Replace DtFat     With  mDtFat
Replace Baixa     With  mBaixa
Replace Natureza  With  mNatureza
Replace DescNat   With  mDescNat
Replace DtAlt     With  STOD(mDtAlt)
Replace Vencto    With  mVencto
Replace Dupl      With  mNota
Replace Parcela   With  mParcela
Replace VlDupl    With  mValor
Replace Pago      With  mPago
Replace Desconto  With  mDesconto
Replace AVencer   With  mAberto
Replace Vencido   with  mVencido +mInadimpl
Replace Inadimpl  with  mInadimpl
Replace Cancelado With  mCancelado
Replace Lp        With  mLp
Replace Portado   With  mPortado
Replace NomPort   With  mDescPort
Replace CodProm   With  mCodProm
Replace CodCli    With  mCodCli
Replace Nome      With  mNome
Replace UF        With  mUF
Replace Mun       With  mMun
Replace Ativida   With  mAtividade
Replace Telefone  With  mTelefone
Replace Tipo	  with  mTipo
Replace Vend      With  mVend
Replace Regiao    With  mRegiao
Replace Equipe    With  mEquipe
Replace DivVend   With  mDivVend
Replace NomeVend  With  mNomeVend                  
Replace VENCREAL  With  MVENCREAL
Replace CGC	      With  mCGC
Replace COBEND	  With  mEndereco
Replace BAIRRO	  With  mBairro 
Replace CEP	      With  mCep
Replace SITUACA	  With  MSITUACA   
Replace DESPREM  With  MDESPREM
Replace DESPBOL  With  MDESPBOL
Replace VENCORI  With  MVENCORI  //20070418
Replace AGENCIA  With  mAgencia  //20091001
Replace CONTA    With  mContaBanco  //20091001
MsUnlock()
Return




//ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Function  ³ FARQTRAB()                                                    ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ Descricao ³ Cria arquivo de trabalho para guardar registros que serao     ³
//³           ³ impressos em forma de etiquetas.                              ³
//³           ³ serem gravados. Faz chamada a funcao GRAVA.                   ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ Observ.   ³                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function FArqTrab()
_aCampos := {}
AADD(_aCampos,{"PEDIDO"    ,"C",6  ,0})
AADD(_aCampos,{"TIPOOP"    ,"C",2  ,0})
AADD(_aCampos,{"DESCROP"   ,"C",50 ,0})
AADD(_aCampos,{"SERIE"     ,"C",3  ,0})
AADD(_aCampos,{"DTFAT "    ,"D",8  ,0})
AADD(_aCampos,{"BAIXA"     ,"D",8  ,0})
AADD(_aCampos,{"DTALT"     ,"D",8  ,0})
AADD(_aCampos,{"VENCTO "   ,"D",8  ,0})
AADD(_aCampos,{"VENCREAL"  ,"D",8  ,0})
AADD(_aCampos,{"NATUREZA"  ,"C",10 ,0})
AADD(_aCampos,{"DESCNAT"   ,"C",30 ,0})
AADD(_aCampos,{"DUPL"      ,"C",9  ,0})
AADD(_aCampos,{"PARCELA"   ,"C",1  ,0})
AADD(_aCampos,{"VLDUPL"    ,"N",12 ,2})
AADD(_aCampos,{"PAGO"      ,"N",12 ,2})
AADD(_aCampos,{"DESCONTO"  ,"N",12 ,2})
AADD(_aCampos,{"AVENCER"   ,"N",12 ,2})
AADD(_aCampos,{"VENCIDO"   ,"N",12 ,2})
AADD(_aCampos,{"CANCELADO" ,"N",12 ,2})
AADD(_aCampos,{"LP"        ,"N",12 ,2})
AADD(_aCampos,{"PORTADO"   ,"C",3  ,0})
AADD(_aCampos,{"NOMPORT"   ,"C",40 ,0})
AADD(_aCampos,{"CODPROM"   ,"C",15 ,0})
AADD(_aCampos,{"CODCLI"    ,"C",6  ,0})
AADD(_aCampos,{"TIPO"      ,"C",1  ,0})
AADD(_aCampos,{"NOME"      ,"C",40 ,0})
AADD(_aCampos,{"MUN"      ,"C",30 ,0})
AADD(_aCampos,{"UF"        ,"C",2  ,0})
AADD(_aCampos,{"COBEND"    ,"C",120 ,0})
AADD(_aCampos,{"BAIRRO"    ,"C",20 ,0})
AADD(_aCampos,{"CEP"       ,"C",9  ,0}) 
AADD(_aCampos,{"ATIVIDA"   ,"C",40 ,0})    
AADD(_aCampos,{"TELEFONE"  ,"C",22 ,0})
AADD(_aCampos,{"VEND"      ,"C",6  ,0})
AADD(_aCampos,{"NOMEVEND"  ,"C",15 ,0})
AADD(_aCampos,{"REGIAO"    ,"C",3  ,0})
AADD(_aCampos,{"EQUIPE"    ,"C",15 ,0})
AADD(_aCampos,{"DIVVEND"   ,"C",40 ,0})
AADD(_aCampos,{"INADIMPL"  ,"N",12 ,2})
AADD(_aCampos,{"FLUXO"     ,"N",12 ,2})
AADD(_aCampos,{"CGC"       ,"C",14 ,0})          
AADD(_aCampos,{"SITUACA"   ,"C",1  ,0})
AADD(_aCampos,{"DESPREM"   ,"N",12 ,2})
AADD(_aCampos,{"DESPBOL"   ,"N",12 ,2})
AADD(_aCampos,{"VENCORI"   ,"D",8  ,0}) //20070418
AADD(_aCampos,{"AGENCIA"   ,"C",5  ,0}) //20091001
AADD(_aCampos,{"CONTA"     ,"C",10 ,0}) //20091001

_cNome := CriaTrab(_aCampos,.t.)

cIndex := CriaTrab(Nil,.F.)
cKey   := "Pedido+Dupl+Parcela"
dbUseArea(.T.,, _cNome,cArq,.F.,.F.)
dbSelectArea(cArq)

MsAguarde({|| Indregua(cArq,cIndex,ckey,,,"Selecionando Registros do Arq")},"Aguarde","Gerando Indice Temporario (TRB)...")

return