#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/02/02
/*/ alterado por Danilo C S Pala, em 2004071
Danilo ordenar com cliente + data decrescente 20050819 
//Danilo C S Pala 20060317: dados de enderecamento do DNE
//Danilo C S Pala 20100305: ENDBP
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪哪哪哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪履哪哪哪哪哪哪哪哪目 北
北砅rograma:  PFATC01  矨utor: Roger Cangianeli       � Data:   11/02/00 � 北
北媚哪哪哪哪哪哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪聊哪哪哪哪哪哪哪哪拇 北
北矰escri嘺o: Browse para Consulta Geral de Cliente e A.V.飐             � 北
北媚哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇 北
北砋so      : Especifico Editora PINI Ltda.                              � 北
北滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁 北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
User Function CFAT003()       

SetPrvt("_CALIAS,_NINDEX,_NREG,CPERG,_CMSG,AROTINA")
SetPrvt("CCADASTRO,VALIDADE,AREGS,I,J,, dDtPesq")

_cAlias  := Alias()
_nIndex  := IndexOrd()
_nReg    := Recno()
VALIDADE := 0

// Inclusao de perguntas para restringir datas do pedido - 16/03/00 - By RC
cPerg := "FATC01"
ValidPerg()
If !Pergunte(cPerg)
	Return
EndIf

If dDataBase <= CtoD("12/01/01") .and. SM0->M0_CODIGO #"02"
	_cMsg := "ATENCAO !!! A CONSULTA FOI ALTERADA, ESTANDO AGORA APTA A SER "
	_cMsg := _cMsg + " UTILIZADA TAMBEM NA PINI SISTEMAS. "
	MsgBox( _cMsg, "ATENCAO", "ALERT" )
EndIf

aRotina := 	{{"Pesquisa" 	, "AxPesqui"						, 0 , 1},;                         // Pesquisar
			{"Visualisa"	, "AxVisual"						, 0 , 2},;                         // Visualiza
			{"Cons"  		, 'ExecBlock("FATC01A", .F., .F.)'	, 0 , 3},;   // Consulta Geral
			{"Ocorr"		, 'ExecBlock("FATC01B", .F., .F.)'	, 0 , 4},;   // Cad.Ocorrencias
			{"conS.Ped"		, 'ExecBlock("FATC01C", .F., .F.)'	, 0 , 5},;  // Cons.AV Publ
			{"pEdidos Venda", 'ExecBlock("FATC01D", .F., .F.)'	, 0 , 6}}      // Pedidos de Venda

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Define o cabecalho da tela de atualizacoes               �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
cCadastro := "Consulta Geral"

VALIDADE := 1
// cCadastro := OemToAnsi(cCadastro)
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Ativa tecla F12 para alterar parametro                   �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
//Set Key VK_CTRL_T TO _GravOcorr()// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==>     //Set Key VK_CTRL_T TO Execute(_GravOcorr)
//Set Key VK_CTRL_Y TO _ConsAV()// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==>     //Set Key VK_CTRL_Y TO Execute(_ConsAV)
//Set Key VK_F12 TO a440Param()

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Endereca a funcao de BROWSE                              �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁

dbselectarea("SA1")
mBrowse( 6, 1,22,75,"SA1",,,,)            // "C5_LIBEROK")

dbSelectArea(_cAlias)
dbSetOrder(_nIndex)
dbGoTo(_nReg)

Return
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
壁哪哪哪哪哪履哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目�
背Funcao    砎ALIDPERG� Autor � Jose Renato July � Data � 25.01.99 潮
泵哪哪哪哪哪拍哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇�
背Descricao � Verifica perguntas, incluindo-as caso nao existam.   潮
泵哪哪哪哪哪拍哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇�
背Uso       � SX1                                                  潮
泵哪哪哪哪哪拍哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇�
背Release   � 3.0i - Roger Cangianeli - 12/05/99.                  潮
崩哪哪哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
/*/
Static Function VALIDPERG()

cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
aRegs    := {}
dbSelectArea("SX1")
dbSetOrder(1)
aAdd(aRegs,{cPerg,"01","Cons.Pedidos De","Cons.Pedidos De","Cons.Pedidos De","mv_ch1","D",08,0,2,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"01","Cons.Pedidos Ate","Cons.Pedidos Ate","Cons.Pedidos Ate","mv_ch2","D",08,0,2,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

STATIC FUNCTION FASE01()
ExecBlock("FATC01B",.F.,.F.)
RETURN

STATIC FUNCTION FASE02()
ExecBlock("FATC01C",.F.,.F.)
rETURN

STATIC FUNCTION FASE03()
ExecBlock("FATC01D",.F.,.F.)
RETURN

STATIC FUNCTION FASE04()
//ExecBlock("FATC01A",.F.,.F.)
//Return
/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪哪哪哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪履哪哪哪哪哪哪哪哪目 北
北砅rograma: FATC01A   矨utor: Roger Cangianeli       � Data:   11/02/00 � 北
北媚哪哪哪哪哪哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪聊哪哪哪哪哪哪哪哪拇 北
北矰escri嘺o: Consulta Geral de Clientes.                                � 北
北媚哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇 北
北砋so          : Especifico PINI Editora Ltda.                          � 北
北滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁 北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
//User Function Fatc01a()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02
IF VALIDADE == 1
	
	SetPrvt("_NREGSA1,NLASTKEY,NOPCX,_CCLIENTE,AHEADER,NUSADO")
	SetPrvt("CTITULO,NLINGETD,AC,AR,ACOLS,_CSTR")
	SetPrvt("_LPED,_ACAMPOS,_CNOMARQ,_CKEY,_CMSG,_CDTINIC")
	SetPrvt("_CDTFIN,_CDTVENC,_CDTSUSP,_CMOTIVO,ACGD,CLINHAOK")
	SetPrvt("CTUDOOK,LRETMOD2,")
	
	_nRegSA1:= SA1->( Recno() )
	nLastKey:= 0
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Opcao de acesso para o Modelo 2                              �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	// 3,4 Permitem alterar getdados e incluir linhas
	// 6 So permite alterar getdados e nao incluir linhas
	// Qualquer outro numero so visualiza
	nOpcx := 1
	
	_cCliente   := "Cliente : "+SA1->A1_COD + "/" + SA1->A1_LOJA + " - " + SA1->A1_NOME
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Montando aHeader                                             �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	aHeader:={}
	nUsado:=0
	
	nUsado:=nUsado+1
	aAdd( aHeader, { Padc(_cCliente,72), "TEXTO", "", 80, 0,;
	"AllWaysTrue()", "������", "C", "TRB", Space(1) } )
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Titulo da Janela                                             �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	cTitulo:= "Consulta Geral de Clientes"
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Variaveis do Rodape do Modelo 2                              �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	nLinGetD:=0
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Array com descricao dos campos do Cabecalho do Modelo 2      �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	aC:={}
	// aC[n,1] = Nome da Variavel Ex.:"cCliente"
	// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
	// aC[n,3] = Titulo do Campo
	// aC[n,4] = Picture
	// aC[n,5] = Validacao
	// aC[n,6] = F3
	// aC[n,7] = Se campo e' editavel .t. se nao .f.
	/*/
	#IFDEF WINDOWS
		AADD(aC,{"_cCliente" , {15,10}  , "Cliente "  , "@!",,, .F. })
	#ELSE
		AADD(aC,{"_cCliente" , {4,5}    , "Cliente "  , "@!",,, .F. })
	#ENDIF
	/*/
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Array com descricao dos campos do Rodape do Modelo 2         �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	aR:={}
	// aR[n,1] = Nome da Variavel Ex.:"cCliente"
	// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
	// aR[n,3] = Titulo do Campo
	// aR[n,4] = Picture
	// aR[n,5] = Validacao
	// aR[n,6] = F3
	// aR[n,7] = Se campo e' editavel .T. se nao .F.
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Montando aCols                                               �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	aCols := {}
	
	//
	//              DADOS FUNDAMENTAIS
	//
	_cStr := "Endereco : " + ALLTRIM(SA1->A1_TPLOG) + " " + ALLTRIM(SA1->A1_LOGR) + " " + ALLTRIM(SA1->A1_NLOGR) + " " + ALLTRIM(SA1->A1_COMPL) //20060324
	aAdd( aCols, { _cStr, .F. } )
	_cStr := "Bairro : " +  AllTrim(SA1->A1_BAIRRO)
	_cStr := _cStr + IIf( 76 - Len(_cStr) > 0, Space( 76 - Len(_cStr)), "" )
	aAdd( aCols, { _cStr, .F. } )
	
	_cStr := "Cidade   : " + AllTrim(SA1->A1_MUN) + " - UF : " + SA1->A1_EST + " - CEP : " + Transform(SA1->A1_CEP, "@R 99999-999")
	aAdd( aCols, { _cStr, .F. } )
	
	If Len(AllTrim(SA1->A1_CGC)) <= 11 .and. SA1->A1_TPCLI == "F"
		_cStr := "C.P.F.   : " + Transform( StrZero( Val(SA1->A1_CGC),11 ), "@R 999.999.999-99")     + "      - Insc.Est.: "+ IIf( Empty(SA1->A1_INSCR), "Nao Cadastrado", AllTrim(SA1->A1_INSCR) )
	Else
		_cStr := "C.N.P.J. : " + Transform( StrZero( Val(SA1->A1_CGC),14 ), "@R 99.999.999/9999-99") + "  - Insc.Est.: "+ IIf( Empty(SA1->A1_INSCR), "Nao Cadastrada", AllTrim(SA1->A1_INSCR) )
	EndIf
	aAdd( aCols, { _cStr, .F. } )
	
	If !Empty(SA1->A1_INSCRM)
		_cStr := "Insc.Mun.: " +  IIf( Empty(SA1->A1_INSCRM), "Nao Cadastrada", AllTrim(SA1->A1_INSCRM) )
		aAdd( aCols, { _cStr, .F. } )
	EndIf
	
	_cStr := "Telefone : " + SA1->A1_TEL + "- Fax : " + IIf(!Empty(SA1->A1_FAX), SA1->A1_FAX, "Nao Cadastrado" )
	aAdd( aCols, { _cStr, .F. } )
	
	_cStr := Repl( "=", 76 )
	aAdd( aCols, { _cStr, .F. } )
	
	//
	//              ENDERECO PARA COBRANCA ( SE EXISTIR )
	//
	dbSelectArea("SZ5")
	dbSetOrder(1)
	If Subs(SA1->A1_ENDCOB,1,1) == "S" .and. ;
		dbSeek(xFilial("SZ5")+SA1->A1_COD+SA1->A1_LOJA, .F. )
		_cStr := PadC( "DADOS COMPLEMENTARES PARA COBRANCA : ", 72 )
		aAdd( aCols, { _cStr, .F. } )
		_cStr := Repl("-", 76 )
		aAdd( aCols, { _cStr, .F. } )
		_cStr := "Endereco : " + ALLTRIM(Z5_TPLOG)+ " " + ALLTRIM(Z5_LOGR) + " " + ALLTRIM(Z5_NLOGR) + " " + ALLTRIM(Z5_COMPL) //20060324
		_cStr := _cStr + "Bairro: "	+ AllTrim(SZ5->Z5_BAIRRO)
		aAdd( aCols, { _cStr, .F. } )
		_cStr := "Cidade   : " + AllTrim(SZ5->Z5_CIDADE) + " - UF : " + SZ5->Z5_ESTADO + " - CEP : " + Transform(SZ5->Z5_CEP, "@R 99999-999")
		aAdd( aCols, { _cStr, .F. } )
	Else
		_cStr := PadC( "NAO HA DADOS COMPLEMENTARES PARA COBRANCA !", 72 )
		aAdd( aCols, { _cStr, .F. } )
	EndIf

	//ENDERECO COBRANCA BP( SE EXISTIR ) 20100305 DAQUI
	dbSelectArea("ZY3")
	dbSetOrder(1)
	If SA1->A1_ENDBP ="S" .and. dbSeek(xFilial("ZY3")+SA1->A1_COD+SA1->A1_LOJA, .F. )
		_cStr := PadC( "DADOS COMPLEMENTARES PARA COBRANCA BP: ", 72 )
		aAdd( aCols, { _cStr, .F. } )
		_cStr := Repl("-", 76 )
		aAdd( aCols, { _cStr, .F. } )
		_cStr := "Endereco : " + ALLTRIM(ZY3_TPLOG)+ " " + ALLTRIM(ZY3_LOGR) + " " + ALLTRIM(ZY3_NLOGR) + " " + ALLTRIM(ZY3_COMPL) 
		_cStr := _cStr + "Bairro: "	+ AllTrim(ZY3->ZY3_BAIRRO)
		aAdd( aCols, { _cStr, .F. } )
		_cStr := "Cidade   : " + AllTrim(ZY3->ZY3_CIDADE) + " - UF : " + ZY3->ZY3_ESTADO + " - CEP : " + Transform(ZY3->ZY3_CEP, "@R 99999-999")
		aAdd( aCols, { _cStr, .F. } )
	Else
		_cStr := PadC( "NAO HA DADOS COMPLEMENTARES PARA COBRANCA BP!", 72 )
		aAdd( aCols, { _cStr, .F. } )
	EndIf
	//20100305 ATE AQUI

	
	_cStr := Repl( "=", 76 )
	aAdd( aCols, { _cStr, .F. } )
	
	//
	//      PEDIDOS PARA O CLIENTE
	//
	_lPed := .F.    // Se nao ha pedidos para o Cliente
	
	_cStr := PadC( "PEDIDOS DO CLIENTE : ", 72 )
	aAdd( aCols, { _cStr, .F. } )
	
	// Seleciona Indices Utilizados
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSelectArea("SF4")
	dbSetOrder(1)
	
	// Cria Arquivo para Gravacao de Duplicatas
	_aCampos := {}
	aAdd( _aCampos, { "TIPO"    , "C",  1, 0 })
	aAdd( _aCampos, { "DUPL"    , "C",  6, 0 })
	aAdd( _aCampos, { "PARC"    , "C",  1, 0 })
	aAdd( _aCampos, { "VALOR"   , "N", 14, 2 })
	aAdd( _aCampos, { "EMISSAO" , "D",  8, 0 })
	aAdd( _aCampos, { "VENCTO"  , "D",  8, 0 })
	aAdd( _aCampos, { "BAIXA"   , "D",  8, 0 })
	aAdd( _aCampos, { "MOTBX"   , "C",  9, 0 })
	aAdd( _aCampos, { "PORT"    , "C",  3, 0 })
	aAdd( _aCampos, { "PEDIDO"  , "C",  6, 0 })
	
	_cNomArq := CriaTrab( _aCampos, .T. )
	dbUseArea(.T.,, _cNomArq,"TRB",.F.,.F.)
	_cKey:="TIPO+PEDIDO+DUPL+PARC"
	Indregua("TRB",_cNomArq,_cKey,,,"AGUARDE....CRIANDO INDICE ")

	dDtPesq := YearSum(ddatabase,20) //20130322
	// Analisa Pedidos
	dbSelectArea("SC5")
	DBORDERNICKNAME("C5_CLIENTE") //dbSetOrder(9) // era 3 20050819 //20130322
	//dbSeek( xFilial("SC5") + SA1->A1_COD, .T. )
	// Alterado em 02/05/00 conforme solicitacao da Srta.Cristiane ( Sol.0045 ),
	// pedidos seguindo ordem decrescente. - Roger Cangianeli
// 	dbSeek( xFilial("SC5") + SA1->A1_COD + "R9999X", .T. )// 20050819
 	dbSeek( xFilial("SC5") + SA1->A1_COD + dtos(dDtPesq), .T. )// 20050819 //20130322
	dbSkip(-1)
	//While !Eof() .and. SC5->C5_FILIAL+SC5->C5_CLIENTE==xFilial("SC5")+SA1->A1_COD
	While !Bof() .and. SC5->C5_FILIAL+SC5->C5_CLIENTE==xFilial("SC5")+SA1->A1_COD
		// Limitacao de Pedidos - inclusao em 16/03/00 By RC
		If SC5->C5_EMISSAO < MV_PAR01 .or. SC5->C5_EMISSAO > MV_PAR02;
			.or. Substr(SC5->C5_NUM,1,1) $ "ABCDEFGHIJKLMNOPQSTUVXWYZ"
			//      dbSkip()
			dbSkip(-1)
			Loop
		EndIf
		
		// Incluido devido a problemas de estouro no array - RC - 16/03/00.
		If Len(aCols) > 3800
			_cMsg := "Nao ha memoria suficiente para exibir todos os dados referentes a esta consulta."
			_cMsg := _cMsg + " Por Favor, altere os parametros e reinicie a consulta. "
			MsgAlert( _cMsg, "ATENCAO")
			Exit
		EndIf
		
		_lPed := .T.        // Existe Pedido
		
		dbSelectArea("SC6")
		dbSeek(xFilial("SC6")+SC5->C5_NUM)
		While !Eof() .and. SC6->C6_FILIAL+SC6->C6_NUM==xFilial("SC6")+SC5->C5_NUM
			
			// Incluido devido a problemas de estouro no array - RC - 16/03/00.
			If Len(aCols) > 3800
				_cMsg := "Nao ha memoria suficiente para exibir todos os dados referentes a esta consulta."
				_cMsg := _cMsg + " Por Favor, altere os parametros e reinicie a consulta. "
				MsgAlert( _cMsg, "ATENCAO")
				Exit
			EndIf
			
			// Separacao de Itens do Pedido
			_cStr := Repl( "=", 76 )
			aAdd( aCols, { _cStr, .F. } )
			
			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+SC6->C6_PRODUTO)
			
			dbSelectArea("SF4")
			dbSeek(xFilial("SF4")+SC6->C6_TES)
			
			// Pedido / Item
			_cStr := "Ped/Item:"+SC6->C6_NUM+"/"+SC6->C6_ITEM+"-"+ Subs(SB1->B1_DESC,1,29)
			_cStr := _cStr + Space( 48 - Len(_cStr) )
			// Incluido data do Pedido em 07/04/00 - By RC
			_cStr := _cStr + "-" + DTOC(SC6->C6_DATA) + "-" + IIf( !Empty(SC6->C6_NUMANT), "Edisa:"+SC6->C6_NUMANT, "" )
			aAdd( aCols, { _cStr, .F. } )
			
			// Quantidade / Valor
			_cStr := "Qtde:" + Str(SC6->C6_QTDVEN,4,0) + " Vlr.Unit:" + Str(SC6->C6_PRCVEN,8,2)
			_cStr := _cStr + " Vlr.Total:" + Str(SC6->C6_VALOR,10,2)
			_cStr := _cStr + " Nat.Oper.:" + AllTrim(SF4->F4_TEXTO)
			aAdd( aCols, { _cStr, .F. } )
			
			// Separacao Simples
			_cStr := Repl( "-", 76 )
			aAdd( aCols, { _cStr, .F. } )
			
			// Linha das Edicoes e Datas - Busca no Cronograma
			dbSelectArea("SZJ")
			dbSetOrder(1)
			If dbSeek( xFilial("SZJ") + "01" + Subs(SC6->C6_PRODUTO, 3, 2) + STR(SC6->C6_EDINIC, 4, 0), .F. )
				_cDtInic := SZJ->ZJ_DTCIRC
			Else
				_cDtInic := stod("")
			EndIf
			
			If dbSeek( xFilial("SZJ") + "01" + Subs(SC6->C6_PRODUTO, 3, 2) + STR(SC6->C6_EDFIN, 4, 0), .F. )
				_cDtFin := SZJ->ZJ_DTCIRC
			Else
				_cDtFin := stod("")
			EndIf
			
			If dbSeek( xFilial("SZJ") + "01" + Subs(SC6->C6_PRODUTO, 3, 2) + STR(SC6->C6_EDVENC, 4, 0), .F. )
				_cDtVenc := SZJ->ZJ_DTCIRC
			Else
				_cDtVenc := stod("")
			EndIf
			
			If dbSeek( xFilial("SZJ") + "01" + Subs(SC6->C6_PRODUTO, 3, 2) + STR(SC6->C6_EDSUSP, 4, 0), .F. )
				_cDtSusp := SZJ->ZJ_DTCIRC
			Else
				_cDtSusp := stod("")
			EndIf
			
			_cStr :="Ed.Inic.: "  + Str(SC6->C6_EDINIC,4,0) + " - " + DtoC(_cDtInic) +;
			" Ed.Fin. : " + Str(SC6->C6_EDFIN, 4,0) + " - " + DtoC(_cDtFin)
			aAdd( aCols, { _cStr, .F. } )
			
			_cStr := "Ed.Venc.: " + Str(SC6->C6_EDVENC,4,0) + " - " + DtoC(_cDtVenc) +;
			" Ed.Susp.: " + Str(SC6->C6_EDSUSP,4,0) + " - " + DtoC(_cDtSusp) +;
			" Ex.Adic.: " + Str(SC6->C6_EXADIC,2,0)
			aAdd( aCols, { _cStr, .F. } )
			
			_cStr := "Cod.Rev.: " + SB1->B1_TITULO + " Tipo Rev: "
			If SC6->C6_TIPOREV == '0'
				_cStr := _cStr + 'Mensal   '
			ElseIf SC6->C6_TIPOREV=='1'
				_cStr := _cStr + 'Par      '
			ElseIf SC6->C6_TIPOREV=='2'
				_cStr := _cStr + 'Impar    '
			ElseIf SC6->C6_TIPOREV=='3'
				_cStr := _cStr + 'Semanal  '
			ElseIf SC6->C6_TIPOREV=='4'
				_cStr := _cStr + 'Bimestral'
			EndIf
			
			_cStr := _cStr + " Situacao: "
			If SC6->C6_SITUAC=='AA'
				_cStr := _cStr + 'Ativo              '
			ElseIf SC6->C6_SITUAC=='SI'
				_cStr := _cStr + 'Susp.p/Inadimplenc.'
			ElseIf SC6->C6_SITUAC=='SE'
				_cStr := _cStr + 'Susp.p/Endereco    '
			ElseIf SC6->C6_SITUAC=='CP'
				_cStr := _cStr + 'Susp.Pedido Cliente'
			EndIf
			
			aAdd( aCols, { _cStr, .F. } )
			
			// Incluido em 04/05/00 por Roger Cangianeli
			dbSelectArea("SA3")
			dbSetOrder(1)
			dbSeek(xFilial("SA3")+SC5->C5_VEND1)
			
			// Vendedor / Porte
			_cStr := IIf( !Empty(SC5->C5_VEND1), "Vend. 1 : " + SC5->C5_VEND1 + ;
			"/" + Subs(SA3->A3_NOME,1, 26) + Space(1), "")
			
			If !Empty(SC6->C6_TPPORTE)
				If SC6->C6_TPPORTE == '0'
					_cStr := _cStr + ' Porte.: Correio Normal'
				ElseIf SC6->C6_TPPORTE == '1'
					_cStr := _cStr + ' Porte.: Correio CNN'
				ElseIf SC6->C6_TPPORTE == '3'
					_cStr := _cStr + ' Porte.: Carta'
				ElseIf SC6->C6_TPPORTE == '6'
					_cStr := _cStr + ' Porte.: Entr.Protocol.'
				ElseIf SC6->C6_TPPORTE == '8'
					_cStr := _cStr + ' Porte.: Suspesas'
				EndIf
			EndIf
			
			If !Empty(_cStr)
				aAdd( aCols, { _cStr, .F. } )
			EndIf
			
			// Roteiro
			_cStr := IIf( !Empty(SC6->C6_ROTEIRO), "Roteiro: " + SC6->C6_ROTEIRO, "")
			If !Empty(_cStr)
				aAdd( aCols, { _cStr, .F. } )
			EndIf
			
			// Data de Envio
			_cStr := IIf( !Empty(SC6->C6_DTENVIO), "Data de Envio: " + DTOC(SC6->C6_DTENVIO), "")
			If !Empty(_cStr)
				aAdd( aCols, { _cStr, .F. } )
			EndIf
			
			// Se houver Destinatario
			If !Empty(SC6->C6_CODDEST)
				
				dbSelectArea("SZN")
				dbSetOrder(1)
				If dbSeek( xFilial("SZN") + SA1->A1_COD + SC6->C6_CODDEST, .F. )
					
					_cStr := Repl( "-", 76 )
					aAdd( aCols, { _cStr, .F. } )
					
					_cStr := "Dest.: " + SZN->ZN_CODDEST + " - " + AllTrim(SZN->ZN_NOME)
					aAdd( aCols, { _cStr, .F. } )
					If !Empty(SZN->ZN_DEPTO) .or. !Empty(SZN->ZN_CARGO)
						_cStr := "Depto: " + AllTrim(SZN->ZN_DEPTO) + " - Cargo :" + AllTrim(SZN->ZN_CARGO)
						aAdd( aCols, { _cStr, .F. } )
					EndIf
					
					dbSelectArea("SZO")
					dbSetOrder(1)
					If dbSeek( xFilial("SZO") + SA1->A1_COD + SC6->C6_CODDEST, .F. )
						_cStr := "End. : " + ALLTRIM(SZO->ZO_TPLOG)+ " " + ALLTRIM(SZO->ZO_LOGR) + " " + ALLTRIM(SZO->ZO_NLOGR) + " " + ALLTRIM(SZO->ZO_COMPL) //20060324
						aAdd( aCols, { _cStr, .F. } )
						_cStr := "Bairro:" + SZO->ZO_BAIRRO
						aAdd( aCols, { _cStr, .F. } )
						_cStr := "Cid. : " + SZO->ZO_CIDADE + " - UF : " + SZO->ZO_ESTADO
						aAdd( aCols, { _cStr, .F. } )
						_cStr := "Tel. : " + SZO->ZO_FONE + " - CEP " + Transform( SZO->ZO_CEP, "@S 99999-999" )
						aAdd( aCols, { _cStr, .F. } )
					EndIf
					
				EndIf
				
			EndIf
			
			dbSelectArea("SC6")
			dbSkip()
			
		End
		
		//
		//      DUPLICATAS / FATURAS PARA O CLIENTE - LEVANTAMENTO
		//
		dbSelectArea("SE1")
		DbOrderNickName("E1_PEDIDO") //dbSetOrder(27) 20130225  ///dbSetOrder(15) AP5 //20090114 era(21) //20090723 mp10 era(22) //dbSetOrder(26) 20100412
		If dbSeek(xFilial("SE1")+SC5->C5_NUM, .F.)
			While !Eof() .and. SE1->E1_PEDIDO == SC5->C5_NUM
				dbSelectArea("TRB")
				If !dbSeek( SE1->E1_PEDIDO + SE1->E1_NUM + SE1->E1_PARCELA, .F. )
					If !Empty(SE1->E1_BAIXA)

/*						If "DEVOLUCAO" $ SE1->E1_MOTIVO //20041220 daki 
							If SE1->E1_PORTADOR == "904"
								_cMotivo := "LP"
							Else
								_cMotivo := "DEV"
							EndIf
						ElseIf "DACAO" $ SE1->E1_MOTIVO
							_cMotivo := "DACAO"
							
						ElseIf "LP" $ SE1->E1_MOTIVO
							_cMotivo := "LP"
							
						Else
							_cMotivo := "PAGTO"
						EndIf
						*/ //20041220 comentado ateh daki                                                          
						//20041222
						If DTOS(SE1->E1_BAIXA) <> "        " .And. SE1->E1_SALDO==0 .AND. !'LP'$(SE1->E1_MOTIVO);
							.AND. !'CAN'$(SE1->E1_MOTIVO) .AND. !'DEV'$(SE1->E1_MOTIVO) .AND. (!'920'$(SE1->E1_PORTADO) .and. !'930'$(SE1->E1_PORTADO) .and. !'904'$(SE1->E1_PORTADO))  
							_cMotivo := "PAGO"
						Else
						 Do Case
						 Case DTOS(SE1->E1_VENCTO) < DTOS(DDATABASE-30) .AND. !Alltrim(SE1->E1_MOTIVO)$"CAN" .AND. !Alltrim(SE1->E1_PORTADO)$"920/CAN/930" //20041014
							//mInadimpl := TRB->E1_VALOR
							_cMotivo := "INADIMPLENTE"
						 Case DTOS(SE1->E1_VENCTO) < DTOS(DDATABASE) .AND. !Alltrim(SE1->E1_MOTIVO)$"CAN/LP" .AND. !Alltrim(SE1->E1_PORTADO)$"920/CAN/995/930" //20041014
							//mVencido  := TRB->E1_VALOR
							_cMotivo := "VENCIDO"
						 Case Alltrim(SE1->E1_MOTIVO)$"CAN" .OR. alltrim(SE1->E1_PORTADO)$"920/CAN/930"
							//mCanc     := TRB->E1_VALOR
							_cMotivo := "CANCELADO"
						 Case Alltrim(SE1->E1_MOTIVO)=="LP" .or. Alltrim(SE1->E1_PORTADO)$"BLP/995" .or. Alltrim(SE1->E1_PORTADO) == "904" //20041027 ALTERADO E1_CODPORT PARA E1_PORTADO
							_cMotivo := "LP"
						 OtherWise
							//mAberto   := TRB->E1_VALOR
							_cMotivo := ""
						 EndCase
						Endif
						    //20041220
					Else
						_cMotivo := ""
					EndIf
					
					RecLock("TRB", .T.)
					TRB->TIPO   := IIf(Subs(SE1->E1_PEDIDO, 6, 1) == "P", "P", "" )
					TRB->DUPL   := SE1->E1_NUM
					TRB->PARC   := SE1->E1_PARCELA
					TRB->VALOR  := SE1->E1_VALOR
					TRB->EMISSAO:= SE1->E1_EMISSAO
					TRB->VENCTO := SE1->E1_VENCTO
					TRB->BAIXA  := SE1->E1_BAIXA
					TRB->MOTBX  := _cMotivo
					TRB->PORT   := SE1->E1_PORTADO
					TRB->PEDIDO := SE1->E1_PEDIDO
					msUnlock()
				EndIf
				
				dbSelectArea("SE1")
				dbSkip()
			End
		EndIf
		dbSelectArea("SC5")
		//    dbSkip()
		dbSkip(-1)
	End
	
	If !_lPed
		aCols[ Len(aCols), 1 ] := PadC( "NAO HA PEDIDOS DO CLIENTE !", 72 )
	EndIf
	_cStr := Repl( "=", 76 )
	aAdd( aCols, { _cStr, .F. } )
	
	//
	//      DUPLICATAS / FATURAS PARA O CLIENTE - APRESENTACAO
	//
	dbSelectArea("TRB")
	dbGoTop()
	If RecCount() > 0
		If Empty(TRB->TIPO)
			_cStr := PadC( "DUPLICATAS / FATURAMENTO PARA O CLIENTE ( Exceto PUBLICIDADE )", 72 )
			aAdd( aCols, { _cStr, .F. } )
			_cStr := Repl( "-", 76 )
			aAdd( aCols, { _cStr, .F. } )
			_cStr := "Dupl/NF P Valor      Emissao  Vencto   Dt.Pgto. Mot.Baixa Port Pedido"
			//        999999  9 999,999.99 99/99/99 99/99/99 99/99/99 XXXXXXXXX  XXX XXXXXX
			aAdd( aCols, { _cStr, .F. } )
			While !Eof() .and. Empty(TRB->TIPO)
				_cStr := TRB->DUPL + Space(2) + TRB->PARC + Space(1) + Transform( TRB->VALOR, "@E 999,999.99")
				_cStr := _cStr + Space(1) + DtoC(TRB->EMISSAO) + Space(1) + DtoC(TRB->VENCTO) + Space(1) + DtoC(TRB->BAIXA)
				_cStr := _cStr + Space(1) + TRB->MOTBX + Space(2) + TRB->PORT + Space(1) + TRB->PEDIDO
				aAdd( aCols, { _cStr, .F. } )
				dbSkip()
				// Incluido devido a problemas de estouro no array - RC - 16/03/00.
				If Len(aCols) > 3800
					_cMsg := "Nao ha memoria suficiente para exibir todos os dados referentes a esta consulta."
					MsgAlert( _cMsg, "ATENCAO")
					Exit
				EndIf
			End
			If !Eof()
				_cStr := Repl( "=", 76 )
				aAdd( aCols, { _cStr, .F. } )
			EndIf
		EndIf
		
		If !Empty(TRB->TIPO) .and. !Eof()
			_cStr := PadC( "DUPLICATAS / FATURAMENTO PARA O CLIENTE ( PUBLICIDADE )", 72 )
			aAdd( aCols, { _cStr, .F. } )
			_cStr := Repl( "-", 76 )
			aAdd( aCols, { _cStr, .F. } )
			_cStr := "Dupl/NF P Valor      Emissao  Vencto   Dt.Pgto. Mot.Baixa Port Pedido"
			//        999999  9 999,999.99 99/99/99 99/99/99 99/99/99 XXXXXXXXX  XXX XXXXXX
			aAdd( aCols, { _cStr, .F. } )
			While !Eof() .and. !Empty(TRB->TIPO)
				_cStr := TRB->DUPL + Space(2) + TRB->PARC + Space(1) + Transform( TRB->VALOR, "@E 999,999.99")
				_cStr := _cStr + Space(1) + DtoC(TRB->EMISSAO) + Space(1) + DtoC(TRB->VENCTO) + Space(1) + DtoC(TRB->BAIXA)
				_cStr := _cStr + Space(1) + TRB->MOTBX + Space(2) + TRB->PORT + Space(1) + TRB->PEDIDO
				aAdd( aCols, { _cStr, .F. } )
				dbSkip()
				
				// Incluido devido a problemas de estouro no array - RC - 16/03/00.
				If Len(aCols) > 3800
					_cMsg := "Nao ha memoria suficiente para exibir todos os dados referentes a esta consulta."
					MsgAlert( _cMsg, "ATENCAO")
					Exit
				EndIf
			End
		EndIf
		
	Else
		_cStr := PadC( "NAO HA DUPLICATAS A APRESENTAR !", 72 )
		aAdd( aCols, { _cStr, .F. } )
		
	EndIf
	
	_cStr := Repl( "=", 76 )
	aAdd( aCols, { _cStr, .F. } )
	_cStr := PadC( " *** F I M  D A  C O N S U L T A *** ", 72 )
	aAdd( aCols, { _cStr, .F. } )
	_cStr := Repl( "=", 76 )
	aAdd( aCols, { _cStr, .F. } )
	
	dbSelectArea("SA1")
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Array com coordenadas da GetDados no modelo2                 �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	aCGD:= {30,5,125,200}
    //{44,5,118,315}
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Validacoes na GetDados da Modelo 2                           �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	cLinhaOk        := "AllWaysTrue()"
	cTudoOk         := "AllWaysTrue()"
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Chamada da Modelo2                                           �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	//aCGD:= {30,5,125,200}
	lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,{125,50,500,635})
	
	// Fecha e elimina arquivo temporario
	dbSelectArea("TRB")
	dbCloseArea()
	fErase( _cNomArq + ".DBF" )
	fErase( _cNomArq + OrdBagExt() )
	
	// Posiciona no registro que iniciou
	dbSelectArea("SA1")
	dbGoto(_nRegSA1)
	
	//Return
ELSE
	RETURN("FASE04()")
ENDIF
RETURN(.T.)
