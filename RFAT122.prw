#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"  //consulta SQL
/*/
//Danilo C S Pala em 20091214 : Cicero: emitir recibo de titulo nao baixado, pois os pedidos de eventos sao digitados somente apos o pagamento do cliente
//Danilo C S Pala 20100305: ENDBP
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �RFAT122   � Autor �  Danilo C S Pala      � Data � 20090702 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � RECIBO DE TITULO RECEBIDOR                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico PINI                                            ���
�������������������������������������������������������������������������Ĵ��
��� Release  � 															  ���
���          � 															  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RFAT122()    
Private cDoNumero := space(9) //MP10
Private cAteNumero := space(9) //MP10
Private cSerie := space(3)  
Private cDaParcela := SPACE(1)
Private cAteParcela := "Z"
Private nVias := 1
//Private aItens := {"Abertas","Baixadas","Todas"}    

@ 000,000 TO 220,300 DIALOG oDlg TITLE "Recibo de Titulo Recebido" 
@ 001,005 TO 110,120
@ 005,010 SAY "Serie:"
@ 005,070 GET cserie  Picture "@!" F3("SE1") Valid ValSE1()
@ 020,010 SAY "Do Numero:"
@ 020,070 GET cDoNumero  Picture "@R 999999999"
@ 035,010 SAY "Ate Numero"
@ 035,070 GET cAteNumero  Picture "@R 999999999"
@ 050,010 SAY "Da Parcela:"
@ 050,070 GET cDaParcela  Picture "@!"
@ 065,010 SAY "Ate Parcela:"
@ 065,070 GET cAteParcela  Picture "@!"
//@ 035,010 SAY "Tipo da nota:"
//@ 035,070 COMBOBOX cTipo ITEMS aItens SIZE 90,90
@ 085,010 BUTTON "Imprimir" SIZE 40,20 ACTION Processa({||Recibotit()})
@ 085,070 BUTTON "Sair" SIZE 40,20 Action ( Close(oDlg) )
Activate Dialog oDlg centered
Return
        


/*
Loop no SE1
*/
Static Function Recibotit()
setprvt("cNome, cEnd, cBairro, cMun, cCep, cEst, cCGC, cPreco, cPRODUTOS, cTexto1")
setprvt("nBox0_LI, nBox0_LF, nBox0_CI, nBox0_CF")
oFont1 	:= TFont():New( "Times New Roman",,12,,.T.,,,,,.F.)
oFont2 	:= TFont():New( "Tahoma",,16,,.T.,,,,,.F.)
oFont3	:= TFont():New( "Arial"       ,,20,,.F.,,,,,.F.)
oFont4 	:= TFont():New( "courier new",,12,,.T.,,,,,.F.)
oFont5 	:= TFont():New( "Times New Roman",,20,,.T.,,,,,.F.)
oPrn := tAvPrinter():New("Recibo")

Private cQuery :=  space(200)
Private nLinha := 10
Private nSomaLinha := 30
Private nColuna := 30
Private nImplinha := 0
Private nVolta := 1
Private nPosicao := 0
//cQuery := "SELECT * FROM "+ RetSqlName("SE1") +" SE1 WHERE E1_FILIAL='"+ XFILIAL("SE1") +"' AND E1_PREFIXO='"+ cSerie +"' AND E1_NUM>='"+ cDoNumero +"' AND E1_NUM<='"+ cAteNumero +"' AND E1_PARCELA>='"+ cDaParcela +"' AND E1_PARCELA<='"+ cAteParcela +"' AND E1_TIPO='NF' AND E1_BAIXA<>'        ' AND SE1.D_E_L_E_T_<>'*'" //20091214
cQuery := "SELECT * FROM "+ RetSqlName("SE1") +" SE1 WHERE E1_FILIAL='"+ XFILIAL("SE1") +"' AND E1_PREFIXO='"+ cSerie +"' AND E1_NUM>='"+ cDoNumero +"' AND E1_NUM<='"+ cAteNumero +"' AND E1_PARCELA>='"+ cDaParcela +"' AND E1_PARCELA<='"+ cAteParcela +"' AND E1_TIPO='NF' AND SE1.D_E_L_E_T_<>'*'"
TCQUERY cQuery NEW ALIAS "RECIBO"
TcSetField("RECIBO","E1_BAIXA" ,"D")
DbSelectArea("RECIBO")
DBGOTOP()

WHILE !EOF() 
	nLinha := 10
	nSomaLinha := 40
	nColuna := 30
    //cPreco := "R$ "+ alltrim(str(RECIBO->E1_VALOR,10,2))
    cPreco := "R$ "+ Alltrim(Transform(RECIBO->E1_VALOR,"@E 999,999.99"))
	cPRODUTOS := getProdutos(RECIBO->E1_PREFIXO, RECIBO->E1_NUM, RECIBO->E1_EMISSAO)

	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+RECIBO->E1_CLIENTE+RECIBO->E1_LOJA)
	cNome   := SA1->A1_NOME
	cEnd    := ALLTRIM(SA1->A1_TPLOG) + " " + ALLTRIM(SA1->A1_LOGR) + " " + ALLTRIM(SA1->A1_NLOGR) + " " + ALLTRIM(SA1->A1_COMPL) //20060327
	cBairro := SA1->A1_BAIRRO
	cMun    := SA1->A1_MUN
	cCep    := SA1->A1_CEP
	cEst    := SA1->A1_EST
	cCGC 	:= alltrim(SA1->A1_CGC)
	if len(cCGC) <14
		cCGC := "C.P.F. " + Transform(cCGC,"@R 999.999.999-99")
	else 
		cCGC := "C.N.P.J. " + Transform(cCGC,"@R 999.999.999/9999-99")
	endif
		
	//20100305 DAQUI
	IF SM0->M0_CODIGO =="03" .AND. SA1->A1_ENDBP ="S"
		DbSelectArea("ZY3")
		DbSetOrder(1)
		if DbSeek(xFilial("ZY3")+SA1->A1_COD+SA1->A1_LOJA, .F.)
			cEnd    :=ZY3_END
			cBairro :=ZY3_BAIRRO
			cMun    :=ZY3_CIDADE
			cEst    :=ZY3_ESTADO
			cCep    :=ZY3_CEP
		endif
	ELSEIF SUBS(SA1->A1_ENDCOB,1,1)=='S' .AND. SM0->M0_CODIGO <>"03"  //ATE AQUI 20100305
		dbSelectArea("SZ5")
		dbSetOrder(1)
		If dbSeek( xFilial("SZ5")+SA1->A1_COD+SA1->A1_LOJA, .F. )
			cEnd    := ALLTRIM(SZ5->Z5_TPLOG)+ " " + ALLTRIM(SZ5->Z5_LOGR) + " " + ALLTRIM(SZ5->Z5_NLOGR) + " " + ALLTRIM(SZ5->Z5_COMPL) //20060327
			cBairro := SZ5->Z5_BAIRRO
			cMun    := SZ5->Z5_CIDADE
			cCep    := SZ5->Z5_CEP
			cEst    := SZ5->Z5_ESTADO
		EndIf
	EndIf
	
	oPrn:StartPage() //inicia pagina de impressao
	
	oPrn:Say(nLinha, nColuna, ("RECIBO"),oFont5,100)
	nLinha := nLinha + (nSomaLinha *4)
   
	cTexto1 := "Recebemos da empresa "+ Alltrim(cNome)+". Sito �  "+ alltrim(cEnd) +" - "+ alltrim(cMun) +" / "+ alltrim(cEst) + ", "+ cCGC +" , � import�ncia de  "+ cPreco + " ("+ EXTENSO(RECIBO->E1_VALOR) +")" + ", correspondente ao pagamento de "+ cPRODUTOS +". T�tulo "+ RECIBO->E1_PREFIXO + RECIBO->E1_NUM + RECIBO->E1_PARCELA + " "
	nImplinha := len(cTexto1)
	//nVolta :=0 
	while nImplinha > 0	
		nVolta :=0 
		nPosicao := 0
		while nVolta <= 80
			if substr(cTexto1, 80 -nVolta,1)==" "
				exit
			endif
			nVolta++
		end     
		nPosicao := 80 -nvolta
		//oPrn:Say(nLinha, nColuna, substr(cTexto1,(nvolta*80)+1,80),oFont1,100)
		oPrn:Say(nLinha, nColuna, substr(cTexto1,1,nPosicao),oFont1,100)
		cTexto1 := substr(cTexto1,nPosicao, len(cTexto1))
		nLinha := nLinha + nSomaLinha
		nImplinha := nImplinha -nPosicao 
		//nVolta++
	end
	/*
	oPrn:Say(nLinha, nColuna, ("Recebemos da empresa "+ Alltrim(cNome)+"."),oFont1,100)
	nLinha := nLinha + nSomaLinha
	oPrn:Say(nLinha, nColuna, ("Sito �  "+ alltrim(cEnd) +" - "+ alltrim(cMun) +" / "+ alltrim(cEst) ),oFont1,100)
	nLinha := nLinha + nSomaLinha
	oPrn:Say(nLinha, nColuna, (", "+ cCGC +" , � import�ncia de  "+ cPreco) ,oFont1,100)
	nLinha := nLinha + nSomaLinha
	oPrn:Say(nLinha, nColuna, ("("+ EXTENSO(RECIBO->E1_VALOR) +")") ,oFont1,100)
	nLinha := nLinha + nSomaLinha
	oPrn:Say(nLinha, nColuna, (", correspondente ao pagamento de:"+ cPRODUTOS ) ,oFont1,100) 
	*/


	nLinha := nLinha + (nSomaLinha *3)    
	IF EMPTY(RECIBO->E1_BAIXA)      
		//MSGINFO("O RECIBO SERA EMITIDO COM A DATA DO SISTEMA, POIS AINDA NAO FOI BAIXADO NO FINANCEIRO")
		oPrn:Say(nLinha, nColuna+600, ("Sao Paulo, " + StrZero(Day(DDATABASE),2) + " de " + MesExtenso(Month(DDATABASE)) + " de " + StrZero(Year(DDATABASE),4) + ".") ,oFont1,100)
	ELSE                                                                                                                                                                                               
		oPrn:Say(nLinha, nColuna+600, ("Sao Paulo, " + StrZero(Day(RECIBO->E1_BAIXA),2) + " de " + MesExtenso(Month(RECIBO->E1_BAIXA)) + " de " + StrZero(Year(RECIBO->E1_BAIXA),4) + ".") ,oFont1,100)
	ENDIF
	nLinha := nLinha + (nSomaLinha *2)
	oPrn:Say(nLinha, nColuna+650, ("-------------------------------") ,oFont1,100)
	nLinha := nLinha + nSomaLinha
	oPrn:Say(nLinha, nColuna +700, ("Editora Pini Ltda") ,oFont1,100)
	nLinha := nLinha + nSomaLinha
	oPrn:Say(nLinha, nColuna+600 , ("C.N.P.J. 60.859.519/0001-51") ,oFont1,100)
	
	nLinha := nLinha + (nSomaLinha *3)
	oPrn:Say(nLinha, nColuna , ("Editora Pini Ltda.:   Rua Anhaia 964 e Rua dos Italianos 967") ,oFont1,100)
	nLinha := nLinha + nSomaLinha
	oPrn:Say(nLinha, nColuna +340, ("Bom Retiro -  S�o Paulo/SP   01130-900") ,oFont1,100)
	nLinha := nLinha + nSomaLinha
	oPrn:Say(nLinha, nColuna+340, ("C.N.P.J.: 60.859.519/0001-51") ,oFont1,100)
	nLinha := nLinha + nSomaLinha
	oPrn:Say(nLinha, nColuna+340, ("Tel.:11 - 21732300 Fax.: 11 - 21732446") ,oFont1,100)
	
	
	nBox0_LI := 90
	nBox0_LF := 1200
	nBox0_CI := 20
	nBox0_CF := 2000
	oPrn:Box (nBox0_LI,nBox0_CI,nBox0_LF,nBox0_CF)       
	
	oPrn:EndPage()
    
	DbSelectArea("RECIBO")
	DBSkip()
END
DbSelectArea("RECIBO")
DbCloseArea()

oPrn:Preview()
oPrn:End()

Return







/*
Loop no SE1
*/
Static Function getProdutos(mPREFIXO, mNUMERO, mEMISSAO)
Private cPRODUTOS := space(400)
Private cQuery :=  space(200)
Private nLinha := 10
cQuery := "SELECT B1_DESC FROM "+ RetSqlName("SD2") +" SD2, "+ RetSqlName("SB1") +" SB1 WHERE D2_FILIAL='"+ XFILIAL("SD2") +"' AND B1_FILIAL='"+ XFILIAL("SB1") +"' AND D2_COD=B1_COD AND D2_SERIE='"+ mPrefixo +"' AND D2_DOC='"+ mNumero +"' AND D2_EMISSAO='"+ mEMISSAO +"' AND SD2.D_E_L_E_T_<>'*' AND SB1.D_E_L_E_T_<>'*'"
TCQUERY cQuery NEW ALIAS "RECSE2"
DbSelectArea("RECSE2")
DBGOTOP()

WHILE !EOF() 
	cPRODUTOS := ALLTRIM(cPRODUTOS) + iif(ALLTRIM(cPRODUTOS)="",""," e ")+ ALLTRIM(RECSE2->B1_DESC)
	DbSelectArea("RECSE2")
	DBSkip()
END
DbSelectArea("RECSE2")
DbCloseArea()
Return (cPRODUTOS)

Static Function ValSE1()
	cSerie := SE1->E1_PREFIXO
	cDoNumero := SE1->E1_NUM
	cAteNumero := SE1->E1_NUM
	cDaParcela := " "
	cAteParcela := "Z"
RETURN (.T.)