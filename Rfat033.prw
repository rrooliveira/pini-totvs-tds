#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
//20080220 Danilo C S Pala: correcao para ajustes causados pela Migracao para MP8
//Danilo C S Pala 20100305: ENDBP
/*
*浜様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様融
*� Programa    : ETIQ.prx                                                 �
*� Descricao   : Etiquetas  de livros e assinaturas e P.Sistemas          �
*� Programador : Solange Nalini                                           �
*� Data        : 18/05/98                                                 �
*� ALTERADO    : 14/10/00 - Retirado arq SZF(criado arq.temporario)       �
*藩様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様夕
*/
User Function Rfat033()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

SetPrvt("LI,LIN,CBTXT,CBCONT,NORDEM,ALFA,DIV_VEN,RESPONS")
SetPrvt("Z,M,TAMANHO,LIMITE,TITULO,CDESC1,CLIENTE,NUMERO")
SetPrvt("CDESC2,CDESC3,CNATUREZA,ARETURN,SERNF,NOMEPROG")
SetPrvt("CPERG,NLASTKEY,LCONTINUA,NLIN,WNREL,CSTRING")
SetPrvt("_ACAMPOS,_CNOME,_CCLIENTE,_CLOJA,CLIE_NOME,CLIE_ENDE")
SetPrvt("CLIE_BAIR,CLIE_MUNI,CLIE_ESTA,CLIE_CEP,_ULTREG,NRECNO,mhora")

//敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // NF_inicial                           �
//� mv_par02             // NF_Final                             �
//� mv_par03             // Serie da N.Fiscal                    �
//青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰

li       := 0
LIN      := 0
CbTxt    := ""
CbCont   := ""
nOrdem   := 0
Alfa     := 0
Z        := 0
M        := 0
tamanho  := "G"
limite   := 220
titulo   := PADC("ETIQUETAS  ",74)
cDesc1   := PADC("Este programa ira emitir as Etiquetas p/N.Fiscais",74)
cDesc2   := ""
cDesc3   := ""
cNatureza:= ""

aReturn  := { "Especial", 1,"Administracao", 1, 2, 1," ",1 }
SERNF    :='UNI'
nomeprog :="etiq"

cPerg    :="FAT004"
nLastKey := 0

lContinua:= .T.
nLin     := 0
MHORA := TIME()
wnrel    := "ETIQASLI_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)

//敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
//� Verifica as perguntas selecionadas                                      �
//青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
Pergunte(cPerg,.T.)               // Pergunta no SX1

cString:="SF2"

If Select("ETILA") >0
	DbSelectArea("ETILA")
	DbCloseArea()
EndIf

//敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
//� Envia controle para a funcao SETPRINT                        �
//青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
WHILE LCONTINUA
	wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.)
	
	If nLastKey == 27
		Return
	Endif
	
	//敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
	//� Verifica Posicao do Formulario na Impressora                 �
	//青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return
	Endif
	LCONTINUA:=.T.
	
	_aCampos :=  {{"NF"      ,"C",6  ,0} ,;
	{"NOME"    ,"C",40 ,0} ,;
	{"RESPCOB" ,"C",40 ,0} ,;
	{"V_END"     ,"C",40 ,0} ,;
	{"BAIRRO"  ,"C",20 ,0} ,;
	{"MUN"     ,"C",20 ,0} ,;
	{"EST"     ,"C",2  ,0} ,;
	{"CEP"     ,"C",8  ,0  }}
	
	_cNome := CriaTrab(_aCampos,.t.)
	dbUseArea(.T.,, _cNome,"ETILA",.F.,.F.)
	
	DBSELECTAREA('SF2')
	DBSETORDER(1)
	DbSeek(xFilial()+MV_PAR01+MV_PAR03)
	IF SF2->F2_SERIE # MV_PAR03
		DBSKIP()
		LOOP
	ENDIF
	
	IF !FOUND()
		RETURN
	ENDIF
	WHILE SF2->F2_DOC >= MV_PAR01 .AND.  SF2->F2_DOC <= MV_PAR02
		IF SF2->F2_SERIE # MV_PAR03
			DBSKIP()
			LOOP
		ENDIF

		DBSELECTAREA("SD2")
		DBSETORDER(3)
		DBSEEK(XFILIAL() + SF2->F2_DOC + SF2->F2_SERIE)
		
		DBSELECTAREA("SC5")
		DBSETORDER(1)
		DBSEEK(XFILIAL() + SD2->D2_PEDIDO) 
		
		IF !EMPTY(SC5->C5_CLIFAT)
			_cCliente := SC5->C5_CLIFAT
			_CLOJA    :=  SC5->C5_LJCLFAT
		ELSE
			_cCliente := SC5->C5_CLIENTE
			_CLOJA    := SC5->C5_LOJACLI
		ENDIF
		RESPONS := SC5->C5_RESPCOB

		// ------> Alteracao para emissao da etiqueta do destinatario - 23/05/03 - inicio
		
		DIV_VEN := SC5->C5_DIVVEN
		CLIENTE := SC5->C5_CLIENTE
		NUMERO  := SC5->C5_NUM
		
		// ------> Alteracao para emissao da etiqueta do destinatario - 23/05/03 - fim
		
		//敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳朕
		//�  Inicio do levantamento dos dados do Cliente                 �
		//青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳潰
		DbSelectArea("SA1")
		DBSETORDER(1)
		//		IF _CLOJA=='1 '                      	21/08/02
		//			_CLOJA:='01'                     	21/08/02
		//		ENDIF                                	21/08/02
		//		DBSEEK(xFilial()+_CCLIENTE+_CLOJA)   	21/08/02
		DBSEEK(xFilial()+_CCLIENTE)      	// 	21/08/02
		CLIE_NOME := SA1->A1_NOME
		
		//*陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�*
		//* VERIFICA ENDERECO DA COBRANCA                     *
		//*陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�*
		
		//20100305 DAQUI
		IF SM0->M0_CODIGO =="03" .AND. SA1->A1_ENDBP ="S"
			DbSelectArea("ZY3")
			DbSetOrder(1)
			DbSeek(XFilial()+_CCLIENTE)
			CLIE_ENDE :=ZY3_END
			CLIE_BAIR :=ZY3_BAIRRO
			CLIE_MUNI :=ZY3_CIDADE
			CLIE_ESTA :=ZY3_ESTADO
			CLIE_CEP  :=ZY3_CEP
        ELSEIF SUBS(SA1->A1_ENDCOB,1,1)=='S' .AND. SM0->M0_CODIGO <>"03"  //ATE AQUI 20100305
			DbSelectArea("SZ5")
			DbSetOrder(1)
			//			DbSeek(XFilial()+_CCLIENTE+_CLOJA)            21/08/02
			DbSeek(XFilial()+_CCLIENTE)             //   21/08/02
			CLIE_ENDE := Z5_END
			CLIE_BAIR := Z5_BAIRRO
			CLIE_MUNI := Z5_CIDADE
			CLIE_ESTA := Z5_ESTADO
			CLIE_CEP  := Z5_CEP
		ELSE
			CLIE_ENDE := SA1->A1_END
			CLIE_BAIR := SA1->A1_BAIRRO
			CLIE_MUNI := SA1->A1_MUN
			CLIE_ESTA := SA1->A1_EST
			CLIE_CEP  := SA1->A1_CEP
		ENDIF
		GRAVA_TEMP()
		
		// ------> Alteracao para emissao da etiqueta do destinatario - 23/05/03 - inicio
		
		IF  DIV_VEN == "SOFT"
			DbSelectArea("SC6")
			DBSETORDER(1)
			IF DBSEEK(xFilial()+NUMERO)
				WHILE SC6->C6_NUM >= NUMERO .AND. SC6->C6_NUM <= NUMERO
					
					IF SC6->C6_NUM <> NUMERO
						EXIT
					ENDIF
					
					DbSelectArea("SZN")
					IF DBSEEK(xFilial()+SC6->C6_CLI+SC6->C6_CODDEST)
						CLIE_NOME := SZN->ZN_NOME
						
						DbSelectArea("SZO")
						IF DBSEEK(xFilial()+SC6->C6_CLI+SC6->C6_CODDEST)
							RESPONS   := ""
							CLIE_ENDE := SZO->ZO_END
							CLIE_BAIR := SZO->ZO_BAIRRO
							CLIE_MUNI := SZO->ZO_CIDADE
							CLIE_ESTA := SZO->ZO_ESTADO
							CLIE_CEP  := SZO->ZO_CEP
						ELSE
							DbSelectArea("SA1")
							DBSETORDER(1)
							DBSEEK(xFilial()+CLIENTE)
							CLIE_NOME := SA1->A1_NOME
							RESPONS   := SZN->ZN_NOME
							CLIE_ENDE := SA1->A1_END
							CLIE_BAIR := SA1->A1_BAIRRO
							CLIE_MUNI := SA1->A1_MUN
							CLIE_ESTA := SA1->A1_EST
							CLIE_CEP  := SA1->A1_CEP
						ENDIF
						GRAVA_TEMP()
					ENDIF
					DBSELECTAREA("SC6")
					DBSKIP()
				END
			ENDIF
		ENDIF
		
		// ------> Alteracao para emissao da etiqueta do destinatario - 23/05/03 - fim
		
		DBSELECTAREA("SF2")
		DBSKIP()
	END
	IMPETIQ()
	LCONTINUA:=.F.
END
DbSelectArea("SF2")
Retindex("SF2")
DbSelectArea("SC5")
Retindex("SC5")
DbSelectArea("SA1")
Retindex("SA1")
DbSelectArea("SZ5")
Retindex("SZ5")

//set devi to screen
//IF aRETURN[5] == 1
//  Set Printer to
//  dbcommitAll()
//  ourspool(WNREL)
//ENDIF
//MS_FLUSH()

return

// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> FUNCTION GRAVA_TEMP
Static FUNCTION GRAVA_TEMP()
DBSELECTAREA("ETILA")
Reclock("ETILA",.T.)
REPLA NF         WITH  SF2->F2_DOC
REPLA NOME       WITH  CLIE_NOME
REPLA RESPCOB    WITH  RESPONS
REPLA V_END      WITH  CLIE_ENDE
REPLA BAIRRO     WITH  CLIE_BAIR
REPLA MUN        WITH  CLIE_MUNI
REPLA EST        WITH  CLIE_ESTA
REPLA CEP        WITH  CLIE_CEP
ETILA->(Msunlock())
RETURN

Static FUNCTION IMPETIQ()
SET DEVICE TO PRINTER
SETPRC(0,0)

DBSELECTAREA("ETILA")
DBGOTOP()
_ULTREG:=RECCOUNT()
WHILE !EOF()
	nRecno := Recno()
	if LI == 0 //20080220
		@ LIN+LI,001 PSAY ' ' + ETILA->NOME
	else     
		@ LIN+LI,001 PSAY ETILA->NOME
	endif // ate aqui 20080220	
	IF RECNO()#_ULTREG
		DBSKIP()
		if LI == 0 //20080220
			@ LIN+LI,045 PSAY ' ' + ETILA->NOME
		else     
			@ LIN+LI,045 PSAY ETILA->NOME
		endif // ate aqui 20080220	
	ENDIF
	IF RECNO()#_ULTREG
		DBSKIP()                  
		if LI == 0 //20080220
			@ LIN+LI,089 PSAY ' ' + ETILA->NOME
		else     
			@ LIN+LI,089 PSAY ETILA->NOME
		endif // ate aqui 20080220	
	ENDIF
	dbGoto(nRecno)
	LI:=LI+1
	
	@ LIN+LI,001 PSAY ETILA->RESPCOB
	IF RECNO()#_ULTREG
		DBSKIP()
		@ LIN+LI,045 PSAY ETILA->RESPCOB
	ENDIF
	IF RECNO()#_ULTREG
		DBSKIP()
		@ LIN+LI,089 PSAY ETILA->RESPCOB
		//      DBSKIP(-2)
	ENDIF
	dbGoto(nRecno)
	LI:=LI+1
	
	@ LIN+LI,001 PSAY ETILA->V_END
	IF RECNO()#_ULTREG
		DBSKIP()
		@ LIN+LI,045 PSAY ETILA->V_END
	ENDIF
	IF RECNO()#_ULTREG
		DBSKIP()
		@ LIN+LI,089 PSAY ETILA->V_END
		//      DBSKIP(-2)
	ENDIF
	dbGoto(nRecno)
	LI:=LI+1
	
	@ LIN+LI,001 PSAY ETILA->BAIRRO
	IF RECNO()#_ULTREG
		DBSKIP()
		@ LIN+LI,045 PSAY ETILA->BAIRRO
	ENDIF
	IF RECNO()#_ULTREG
		DBSKIP()
		@ LIN+LI,089 PSAY ETILA->BAIRRO
		//      DBSKIP(-2)
	ENDIF
	dbGoto(nRecno)
	LI:=LI+1
	
	@ LIN+LI,001 PSAY SUBS(ETILA->CEP,1,5)+'-'+SUBS(ETILA->CEP,6,3)+'   ' +MUN+' ' +ETILA->EST
	IF RECNO()#_ULTREG
		DBSKIP()
		@ LIN+LI,045 PSAY SUBS(ETILA->CEP,1,5)+'-'+SUBS(ETILA->CEP,6,3)+'   ' +MUN+' ' +ETILA->EST
	ENDIF
	IF RECNO()#_ULTREG
		DBSKIP()
		@ LIN+LI,089 PSAY SUBS(ETILA->CEP,1,5)+'-'+SUBS(ETILA->CEP,6,3)+'   ' +MUN+' ' +ETILA->EST
		LI:=LI+1
	ENDIF
	DBSKIP()
	LI:=2
	setprc(0,0)
	lin:=prow()
END

SET DEVICE TO SCREEN

DBSelectArea("ETILA")
DBCLOSEAREA()

IF aRETURN[5] == 1
	SET PRINTER TO
	dbcommitAll()
	ourspool(WNREL)
ENDIF
MS_FLUSH()

return
