#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/02/02
/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Programa � PFAT129  � Autor � Claudio Calazans    � Data �Seg  02/04/01���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Gera arquivo para impressao de boleto bancario.             ���
���          � Banco Banespa. (Boletos da Publicidade)                     ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico para Editora Pini Ltda.                          ���
��������������������������������������������������������������������������Ĵ��
���Outras    � ExecBlock("A116DET",.F.,.F.)                                ���
���Fun��es   �                                                             ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function Pfat129()        // incluido pelo assistente de conversao do AP5 IDE em 26/02/02

SetPrvt("_CRETALIAS,_NRETORDEM,_NRETRECNO,_CMSG1,_CMSG2,CPERG")
SetPrvt("NRESP,_LCONTINUA,_CALERTA,_CNRCTRL,_CPATHBANESPA,_CARQUIVO")
SetPrvt("_AREJEITADOS,_LBOLETO,_LSAIDA,LHEADER,_CSERIE,MV_PAR09")
SetPrvt("_CMSGAVISO,_CMSGERROR,_NHDL,_CMSG,_CLIN,_LOK")
SetPrvt("_NSEQ,_CINCREMENTA,HEAD_001_A_001,HEAD_002_A_002,HEAD_003_A_009,HEAD_010_A_011")
SetPrvt("HEAD_012_A_026,HEAD_027_A_037,HEAD_038_A_046,HEAD_047_A_076,HEAD_077_A_079,HEAD_080_A_086")
SetPrvt("HEAD_087_A_094,HEAD_095_A_100,HEAD_101_A_105,HEAD_106_A_108,HEAD_109_A_117,MV_PAR10")
SetPrvt("_CMULTA,_CMULTA1,_CPRAZO,_CDESC,_CXMSG0,_CXMSG1,_CXMSG2")
SetPrvt("_CXMSG3,HEAD_118_A_184,HEAD_185_A_252,HEAD_253_A_319,HEAD_320_A_386,HEAD_387_A_394")
SetPrvt("HEAD_395_A_400,_AHEADER,_N1,_CCEP,_LOKFAIXA,_NFAIXAATU")
SetPrvt("_ATRAILLER,_N3,_CMSGINFO,_CALIAS,_NRECNO,_NORDEM")
SetPrvt("_CNBCO,_CAGEN,_CCCOR,_NSOMA,_AFATORES,_CAGENCIA")
SetPrvt("_CNUMEROBANCARIO,X,_NNR1,_NNR2,_NRES,_NDIGITO")
SetPrvt("_SALIAS,AREGS,I,J,_N,_CARQCEP")
SetPrvt("_CINDCEP,_CDIGCEP,_LFORAPRACA,CSTRING,CDESC1,CDESC2")
SetPrvt("CDESC3,TAMANHO,ARETURN,NOMEPROG,ALINHA,NLASTKEY")
SetPrvt("LEND,TITULO,CABEC1,CABEC2,CCANCEL,M_PAG")
SetPrvt("WNREL,LI,ADRIVER,NTIPO,NLIN,mhora")

_cRetAlias:= ALIAS()
_nRetOrdem:= INDEXORD()
_nRetRecno:= RECNO()

//���������������������������������������������������������������������������Ŀ
//� Verifica as perguntas                                                     �
//���������������������������������������������������������������������������Ĵ
//� mv_par01    Banco            ?                                            �
//� mv_par02    Agencia          ?                                            �
//� mv_par03    Conta            ?                                            �
//� mv_par04    Da Nota Fiscal   ? -  Titulo  Inicial                         �
//� mv_par05    Ate Nota Fiscal  ? -  Titulo  Final                           �
//� mv_par06    Serie            ? -  Serie da Nota Fiscal                    �
//� mv_par07    Taxa de Juros/Dia? -  Taxa de Juros                           �
//� mv_par08    Instrucoes       ? -  Instrucoes p/ impressao do Boleto       �
//�����������������������������������������������������������������������������

_cMsg1:= "Esta rotina esta preparada APENAS para impressao de boletos do Banco BANESPA. Verifique ..."
_cMsg2:= "Banco Banespa nao Encontrado no Cadastro de Parametros CNAB!!"

cPerg := "FAT129"
ValidPerg()

Pergunte(cPerg,.T.)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela                                                    �
//�����������������������������������������������������������������������
@ 200,1 TO 380,395 DIALOG oDlg TITLE OemToAnsi("Geracao de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say " contas a receber (SE1).  Este programa e um programa de exem- "
@ 34,018 Say " plo, deve ser ajustado conforme o lay-out desejado.           "

@ 60,070 BMPBUTTON TYPE 01 ACTION RunProc()// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==>     @ 60,070 BMPBUTTON TYPE 01 ACTION Execute(RunProc)
@ 60,110 BMPBUTTON TYPE 02 ACTION Close(oDlg)
@ 60,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oDlg Centered

Return

Static Function RunProc()

_lContinua:= .T.

If Alltrim(mv_par01) <> "033"
	_cMsg1:= "A Banco para essa rotina deve ser o 033 (Banespa). Verifique !!!"
	_lContinua:= .F.
Endif

If Right(Alltrim(mv_par02),3) <> "001" .and. _lContinua
	_cMsg1:= "A Agencia para este Banco so podera ser 001. Verifique !!!"
	_lContinua:= .F.
EndIf

If SM0->M0_CODIGO == "01" .and. _lContinua
	If !(Alltrim(MV_PAR03) $ "13087761/13224919")
		_cMsg1:= "A Conta Corrente so podera ser 13087761 ou 13224919. Verifique !!!"
		_lContinua:= .F.
	EndIf
ElseIf SM0->M0_CODIGO == "02" .and. _lContinua
	If Alltrim(MV_PAR03)<>"50000255"
		_cMsg1:= "A Conta Corrente so podera ser 50000255. Verifique !!!"
		_lContinua:= .F.
	EndIf
Else
	_lContinua:= .F.
Endif

If _lContinua
	BolBanespa()// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==>        Execute(BolBanespa)
Else
	MsgStop(_cMsg1,"ATENCAO")
EndIf

DbSelectArea(_cRetAlias)
DbSetOrder(_nRetOrdem)
DbGoto(_nRetRecno)

Return
/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun��o   � BOLBANESPA� Autor �Gilberto A Oliveira � Data � 24/07/2000  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para continuacao do processamento (na confirmacao)   ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico para clientes Microsiga                          ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function BolBanespa()

//mv_par01
//��������������������������������������������������������������Ŀ
//� SEE - Comunica��o Remota p/guardar a Faixa Atual             �
//����������������������������������������������������������������
DbSelectArea("SEE")
DbSetOrder(1)
DbSeek(xFilial("SEE")+MV_PAR01+MV_PAR02+MV_PAR03)

If EOF()
	Help("",1,"NAOFAIXA")
	Return
Endif
IF ALLTRIM(SEE->EE_NUMBCO) == "999"
	_cAlerta:= 'ATENCAO : A numeracao sequencial dos arquivos atingiu o limite (999) !!'
	_cAlerta:= _cAlerta+' Verifique no arquivo de Configuracao de CNABS o campo "Sequencial" '
	Alert( _cAlerta )
	Return
ENDIF

_cNrCtrl:= StrZero(Val(SEE->EE_NUMBCO)+1,3)

RecLock("SEE",.F.)
SEE->EE_NUMBCO:= _cNrCtrl
DbCommit()
SEE->(MsUnLock())

_cPathBol := Alltrim(GetMV("MV_PATHBOL"))
_cPathBanespa:= Alltrim( GETMV("MV_BANESPA") )
//_cArquivo:= Subs(cUsuario,7,3)+"0"+AllTrim(MV_PAR01)+".DAT"

_cArquivo := SubS(cUsuario,7,3)
_cArquivo := _cArquivo+SM0->M0_CODIGO
_cArquivo := _cArquivo+_cNrCtrl
_cArquivo := _cArquivo+".033"

//���������������������������������������������������������������������Ŀ
//� Inicio da pesquisa no arquivo de dados                              �
//�����������������������������������������������������������������������
DbSelectArea("SE1")
DbSetOrder(1)
DbSeek(xFilial("SE1")+mv_par06+mv_par04,.T.)

If SE1->E1_PREFIXO+SE1->E1_NUM > MV_PAR06+MV_PAR05    //.OR. SE1->E1_NUM #MV_PAR05
	MsgAlert("Nao foram encontrados Titulos para Impressao !! Verifique ...","Aten��o!")
	Return
EndIf

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������
Processa({|| RunCont()},"Processando...")// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==> 	Processa({|| Execute(RunCont)},"Processando...")

Return

Static Function RunCont()

ProcRegua(RecCount())

//���������������������������������������������������������������������Ŀ
//� Processamento                                                       �
//�����������������������������������������������������������������������
_aRejeitados := {}
_lBoleto := .F.
_lSaida  := .F.
lHeader  := .T.

While !EOF() .AND. SE1->E1_FILIAL == xFilial("SE1") .and. SE1->E1_NUM <= MV_PAR05
	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua                                                  �
	//�����������������������������������������������������������������������
	IncProc("Imprimindo Boleto "+ Alltrim(SE1->E1_PREFIXO+SE1->E1_NUM))
	
	//��������������������������������������������������������������Ŀ
	//� Identifica a serie da nota                                   �
	//����������������������������������������������������������������
	If SE1->E1_PREFIXO # MV_PAR06           // Se a Serie do Arquivo for Diferente
		DbSkip()                             // do Parametro Informado !!!
		Loop
	Endif
	
	//��������������������������������������������������������������Ŀ
	//� SE1 - Contas a Receber                                       �
	//����������������������������������������������������������������
	_cSerie:= MV_PAR06
	
	If Alltrim(SE1->E1_TIPO)!="NF" .Or. SE1->E1_PREFIXO!=_cSerie
		DbSelectArea("SE1")
		DbSkip()
		Loop
	Endif
	
	IF !EMPTY(SE1->E1_BAIXA) .And.  SE1->E1_SALDO == 0
		DbSelectArea("SE1")
		DbSkip()
		Loop
	ENDIF
	
	MV_PAR09:= TRIM(MV_PAR09)
	
	If MV_PAR09 <> "."
		If !(SE1->E1_PARCELA $ MV_PAR09)
			DbSkip()
			Loop
		EndIf
	EndIf
	
	IF SE1->E1_SITUACA #"0"
		_cMsgAviso := "Aten��o: O titulo "+SE1->E1_NUM+SE1->E1_PARCELA+" "+SE1->E1_SERIE
		_cMsgAviso += " esta fora de CARTEIRA, transferido para o Banco "+Alltrim(SE1->E1_PORTADO)+"."
		_cMsgAviso += " Para reemitir esse boleto solicite a cobran�a que transfira o "
		_cMsgAviso += " titulo para carteira."
		MsgInfo( OemToAnsi(_cMsgAviso ) )
		
		DbSelectArea("SE1")
		DbSkip()
		Loop
	ENDIF
	
	// Verifica se ja foi emitido boleto para esse titulo por
	// Outro Banco.
	If SE1->E1_BOLEM == "S" .OR. !Empty(SE1->E1_NUMBCO)
		_cMsgError:= "Ja foi Emitido Boleto para esse Titulo !!!"
		_cMsgError:= _cMsgError+"Titulo "+SE1->E1_NUM+" Parcela "+SE1->E1_PARCELA + " da Serie " + _cSerie
		_cMsgError:= _cMsgError+" Verifique com a cobranca o nosso numero : "+alltrim(SE1->E1_NUMBCO)
		MsgAlert(OemToAnsi(_cMsgError),OemToAnsi("Aten��o"))
		
		DbSelectArea("SE1")
		DbSkip()
		Loop
	Endif
	
	IF SE1->E1_DIVVEN == "MERC"
		DbSelectArea("SE1")
		DbSkip()
		Loop
	ENDIF
	
	_lBoleto:= .T.
	
	If lHeader
		//���������������������������������������������������������������������Ŀ
		//� Cria o arquivo texto                                                �
		//�����������������������������������������������������������������������
		_nHdl:= fCreate(_cArquivo)
		If _nHdl == -1
			_cMsg:= "O arquivo de nome "+_cArquivo+" n�o pode ser criado! Verifique os par�metros."
			MsgAlert(_cMsg,"Aten��o!")
			Return
		Endif
		
		_cLin       :=""
		_lOk        :=.T.
		_nSeq       := 1
		_cIncrementa:= Strzero(_nSeq,6)
		
		//�������������������������������Ŀ
		//� POSICOES DO HEADER.           �
		//���������������������������������
		Head_001_a_001:= "0"
		Head_002_a_002:= "1"
		Head_003_a_009:= "REMESSA"
		Head_010_a_011:= "01"
		Head_012_a_026:= PadR("COBRANCA",15," ")
		Head_027_a_037:= PadR(Alltrim(MV_PAR02)+Alltrim(MV_PAR03),11," ")
		Head_038_a_046:= Space(09)
		Head_047_a_076:= SubStr(SM0->M0_NOMECOM,1,30)
		Head_077_a_079:= MV_PAR01
		Head_080_a_086:= "BANESPA"
		Head_087_a_094:= Space(08)
		Head_095_a_100:= GravaData(dDataBase,.F.)
		Head_101_a_105:= "01600"
		Head_106_a_108:= "BPI"
		Head_109_a_117:= Space(9)
		
		mv_par10:= iif(empty(mv_par10),10,mv_par10)
		
		_cMulta  := Alltrim(Str((SE1->E1_VALOR * MV_PAR07)/100,10,2))    // 22/07
		_cMulta1 := Alltrim(Str((SE1->E1_VALOR * MV_PAR11)/100,10,2))    // 22/07

		//      _cPrazo:= DtoC( SE1->E1_VENCTO + mv_par10 )                /// anteriormente era fixado em 10 dias...
	   //	_cMulta:= Alltrim(Str(MV_PAR07,4,2))+"%"      // 22/07
		_cPrazo:= STRZERO(mv_par10,2)                              /// anteriormente era fixado em 10 dias...
		_cDesc := Alltrim(Str(MV_PAR08,10,2))
		
//		_cXMsg0:= "PAGAVEL EM QUALQUER BANCO ATE O VENCIMENTO"
//		_cXMsg1:= iif(mv_par07 > 0 , "COBRAR "+_cMulta+" DE MULTA POR DIA DE ATRASO." , Space(2) )
//		
//		If Alltrim(MV_PAR03) == "13087761"
//			_cXMsg2:= "PROTESTAR APOS 03 DIAS UTEIS DE VENCIDO"
//		ElseIf Alltrim(MV_PAR03)=="50000255"
//			_cXMsg2:= "PROTESTAR APOS 05 DIAS UTEIS DE VENCIDO"
//		Else
//			// CONTA - 13224919 (SEM REGISTRO)
//			_cXMsg2:= "NAO RECEBER APOS "+_cPrazo+" DIAS DE VENCIDO"
//		EndIf
		
//		_cXMsg3:= iif(mv_par08 > 0 , "CONCEDER DESCONTO DE R$ "+_cDesc, Space(2) )

	  _cXMsg0 := "PAGAVEL EM QUALQUER BANCO ATE O VENCIMENTO"
	  _cXMsg1 := iif(mv_par11 > 0 , "APOS O VENCIMENTO COBRAR R$ "+_cMulta1+" DE MULTA" , Space(2) )
//	  _cXMsg2 := iif(mv_par07  > 0 , "MAIS R$ "+_cMulta+" POR DIA DE ATRASO." , Space(2) )
      _cXMsg2 := "PROTESTAR APOS 03 DIAS UTEIS DE VENCIDO"
	  _cXMsg3 := iif(mv_par08 > 0 , "     CONCEDER DESCONTO DE R$ "+_cDesc, "" )

		Head_118_a_184:= PadR(_cXMsg0,067," ")
		Head_185_a_252:= Padr(_cXMsg1,067," ")
		Head_253_a_319:= Padr(_cXMsg2,067," ")
		Head_320_a_386:= Padr(_cXMsg3,067," ")
		Head_387_a_394:= Space(9)
		Head_395_a_400:= _cIncrementa
		
		//�������������������������������ͻ
		//� GRAVA HEADER.                 �
		//�������������������������������ͼ
		_aHeader:= {}
		_aHeader:={ Head_001_a_001,Head_002_a_002,Head_003_a_009,;
		Head_010_a_011,Head_012_a_026,Head_027_a_037,;
		Head_038_a_046,Head_047_a_076,Head_077_a_079,;
		Head_080_a_086,Head_087_a_094,Head_095_a_100,;
		Head_101_a_105,Head_106_a_108,Head_109_a_117,;
		Head_118_a_184,Head_185_a_252,Head_253_a_319,;
		Head_320_a_386,Head_387_a_394,Head_395_a_400  }
		
		For _n1:= 1 to LEN(_aHeader)
			_cLin:=_cLin +  _aHeader[_n1]
		Next
		_cLin:= _cLin+CHR(13)+CHR(10)
		
		If FWrite( _nHdl,_cLin,Len(_cLin)) != Len(_cLin )
			Exibi_Alerta()
		Endif
		
		If !_lOk
			Return
		Endif
		lHeader:= .F.
	Endif
	
	DbSelectArea("SE1")
	
	//****************************************************
	//**  ALTERACAO FEITA EM 12/04/2001 POR GILBERTO.   **
	//****************************************************
	_cCEP:= Padr(ExecBlock("VCB03"),08," ")
	VerFaixaCEPs()
	If Empty(_cCEP)
		DbSelectArea("SE1")
		DbSkip()
		Loop
	Endif
	//****************************************************
	
	//�����������������������������������������Ŀ
	//� Busca faixa atual de registros no SEE.  �
	//�������������������������������������������
	_lOkFaixa:= .T.
	
	If !Empty( SE1->E1_NUMBCO )
		_nFaixaAtu:= Val( SUBS(SE1->E1_NUMBCO,4,7) )
	Else
		AcFaxAtu()
	Endif
	
	If !(_lOkFaixa)
		Return
	EndIf
	
	_cLin:= ""
	_cLin:= ExecBlock("A116DET",.F.,.F.)
	
	If fWrite( _nHdl,_cLin,Len(_cLin)) != Len(_cLin )
		Exibi_Alerta()
	Endif
	
	DbSelectArea("SE1")
	DbSkip()
	
	_lSaida:= .T.
End

If  _lBoleto .And. ( _lOk )
	_cIncrementa := StrZero(_nSeq+1,6)
	_cLin        := ""
	_lOk         := .T.
	
	//�������������������������������ͻ
	//� GRAVA TRAILLER.               �
	//�������������������������������ͼ
	_aTrailler   := {}
	Aadd(_aTrailler,"9")                        // [001]
	Aadd(_aTrailler,Space(393))                 // [393]
	Aadd(_aTrailler,_cIncrementa)               // [006]
	
	For _n3:= 1 to LEN(_aTrailler)
		_cLin:=_cLin +  _aTrailler[_n3]
	Next
	
	_cLin:= _cLin + CHR(13)+CHR(10)
	
	If fWrite( _nHdl,_cLin,Len(_cLin)) != Len(_cLin )
		Exibi_Alerta()
	Endif
	
	_lSaida:= iif(_lSaida,.T.,.F.)
EndIf

fClose(_nHdl)

If !(_lSaida)
	_cMsg:= "Nao haviam registros para geracao do boleto. Verifique ..."
	MsgStop( _cMsg )
Else
	If Select("CEPS") > 0
		DbSelectArea("CEPS")
		DbCloseArea()
	EndIf
	
	Copy File (_cArquivo) TO (_cPathBanespa+_cArquivo)
	Ferase(_cArquivo)
	WinExec(_cPathBol+_cPathBanespa+"VBISLIP N "+_cArquivo,2)
	//_cMsgINFO:= "Arquivo gerado com Sucesso !!"+CHR(13)
	//_cMsgINFO:= _cMsgINFO + "Anote o nome do Arquivo : "+_cArquivo
	//MsgInfo(OemToAnsi(_cMsgInfo))
EndIf

IF LEN(_aRejeitados) == 0
	Alert( "Nao existiram titulos rejeitados !!")
ELSE
	ALERT( "Existem titulos rejeitados, fora da praca. Tecle ENTER para imprimir ...")
	IMPDEL()
ENDIF

IF SELECT("CEPS") <> 0
	DbSelectArea("CEPS")
	DbCloseArea("CEPS")
ENDIF

Return
/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �EXIBI_ALERTA� Autor �Gilberto A de Oliveira � Data � 28/07/00 ���
���������������������������������������������������������������������������Ĵ��
���Uso       � Funcao de apoio para exibicao de mensagem.                   ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
Static Function Exibi_Alerta()

If !MsgAlert("Ocorreu um erro na grava��o do arquivo "+_cArquivo+".   Continua?","Aten��o!")
	_lOk:= .F.
Endif

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ACFAXATU  � Autor � Gilberto A de Oliveira� Data � 24/07/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Busca o proximo nr. da faixa bancaria e atualiza o mesmo.  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico para clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AcFaxAtu()

_cAlias:= Alias()
_nRecno:= Recno()
_nOrdem:= IndexOrd()

// E.P. -     13087761    P/    13 08776-1
// P.S. -     50000255    P/    50 00025-5
//����������������������������ͻ
//� Apenas para Banco Banespa. �
//����������������������������ͼ
_cNBco:= PadR( Alltrim(MV_PAR01) , 3 , " " )   // "033"              // Numero do Banco.
_cAgen:= PadR( Alltrim(MV_PAR02) , 5 , " " )   // "001  "            // Codigo da Agencia.
_cCCor:= PadR( Alltrim(MV_PAR03) ,10 , " " )   // "02124145  "       // Conta Corrente.

DbSelectArea("SEE")
DbSetOrder(1)
DbSeek(xFilial("SEE")+ _cNBco + _cAgen + _cCCor )

If Found()
	
	_nFaixaAtu:= Val(SEE->EE_FAXATU) + 1      // UTILIZADO NA ROTINA A116DET.PRX
	
	CalculaDigito()// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==>        Execute(CalculaDigito)
	
	// A GRAVACAO DOS DADOS RESTANTES DEPENDE DO TIPO DE COBRANCA SER OU NAO
	// REGISTRADA. COBRANCAS REGISTRADAS NAO PODERAO GRAVAR PORTADOR,
	// CARTEIRA, CONTA, AGENCIA NEM MUDAR A SITUACAO.
	
	DbSelectArea("SE1")
	RecLock("SE1",.F.)
	IF  (ALLTRIM(MV_PAR03)) == "13224919"
		SE1->E1_PORTADO:= _cNBco
		//SE1->E1_CODPORT:= "COB"           /// mv_par04        /// "415"
		//SE1->E1_AGEDEP := iif(Alltrim(mv_par03) $ "13087761/50000255","0001",_cAgen)
		//SE1->E1_CONTA  := iif(Alltrim(mv_par03) == "13087761","13 08776-1",iif(alltrim(mv_par03)=="50000255","50 00025-5",_cCCor))
		SE1->E1_AGEDEP := "001"
		SE1->E1_CONTA  := "13224919"
		SE1->E1_SITUACA:= "1"
	ENDIF
	
	SE1->E1_BOLEM  := "S"
	SE1->E1_NUMBCO := _cNumeroBancario   /// Str( _nFaixaAtu )
	SE1->(MsUnlock())
	
	DbSelectArea("SEE")
	RecLock("SEE",.F.)
	SEE->EE_FAXATU:= Strzero( _nFaixaAtu ,12 )
	SEE->(MsUnlock())
Else
	MsgStop(_cMsg2)
	_lOkFaixa:= .F.
EndIf

DbSelectArea(_cAlias)
DbSetOrder(_nOrdem)
DbGoto(_nRecno)

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFAT129   �Autor  �Microsiga           � Data �  04/04/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Calculo do Digito Verificador.                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CalculaDigito()

//*** Formula Banespa : O n�mero banc�rio � composto por 3 partes
//*** - 3 (tres) d�gitos para o n�mero da �gencia (constante);
//*** - 7 (sete) d�gitos para a numera��o sequencial; e
//*** - 1 (um) d�gito verificador.
//***
//*** Variavel "_nFaixaAtu" deve conter o valor de SEE->EE_FAXATU

_nSoma:= 0
_aFatores:={7,3,1,9,7,3,1,9,7,3}

_cAgencia:= "001"
_cNumeroBancario:= alltrim(_cAgencia + Strzero(_nFaixaAtu,7) )

For x:= 1 to Len(_aFatores)
	_nNr1:= Val( Subs(_cNumeroBancario,x,1) )
	_nNr2:= Val( Right( Str(_aFatores[x]*_nNr1,2),1) )
	_nSoma:= _nSoma + _nNr2
Next

_nRes:=Val( Right( Str(_nSoma,2),1 ))

if _nRes == 0
	_nDigito:= 0
else
	_nDigito:= 10 - Val( Right( Str(_nSoma,2),1 ))
endif

_cNumeroBancario:= _cNumeroBancario + str(_nDigito,1)

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �VALIDPERG � Autor �  Luiz Carlos Vieira   � Data � 18/11/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica as perguntas inclu�ndo-as caso n�o existam        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico para clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ValidPerg()

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
Aadd(aRegs,{cPerg,"01","Banco             ?","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","SA6"})
Aadd(aRegs,{cPerg,"02","Agencia           ?","mv_ch2","C",05,0,0,"G","","mv_par02","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Conta             ?","mv_ch3","C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Da Nota Fiscal    ?","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Ate Nota Fiscal   ?","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Serie             ?","mv_ch6","C",03,0,0,"G","","mv_par06","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"07","Taxa de Juros/Dia ?","mv_ch7","N",05,2,0,"G","","mv_par07","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"08","Desconto          ?","mv_ch8","N",10,2,0,"G","","mv_par08","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"09","Parcelas          ?","mv_ch9","C",10,0,0,"G","","mv_par09","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"10","Dias p/Recebimento?","mv_chA","N",02,0,0,"G","","mv_par10","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"11","Multa             ?","mv_chB","N",05,2,0,"G","","mv_par11","","","","","","","","","","","","","",""})

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

dbSelectArea(_sAlias)

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFAT129   �Autor  �Microsiga           � Data �  04/04/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GANHATEMPO()

ProcRegua(1000)
For _n := 1 to 1000
	IncProc()
Next

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VERFAIXAC.�Autor  �Microsiga           � Data �  04/04/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica faixa de CEPS                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static FUNCTION VERFAIXACEPS()

_cAlias:= Alias()
_nOrdem:= IndexOrd()
_nRecno:= Recno()

IF SELECT("CEPS") == 0
	_cPathBanespa:= Alltrim( GETMV("MV_BANESPA") )
	_cArqCEP:= "CEPS.DBF"
	_cIndCEP:= "CEPS"
	DbUseArea(.T.,, _cPathBanespa+_cArqCEP, "CEPS", .F., .F.)
	If !File(_cPathBanespa+_cIndCEP+OrdBagExt())
		IndRegua("CEPS",_cPathBanespa+_cIndCEP,"FAIXA1",,,"Indexando Arquivo de CEPS...")
	EndIf
	DbSetIndex(_cPathBanespa+_cIndCEP+OrdBagExt() )
ENDIF

_cDigCep:=SubStr(_cCep,1,1)

DbSelectArea("CEPS")
DbSetOrder(1)
DbSeek(_cDigCep)

If !Found()
	AADD( _aRejeitados , SE1->E1_PREFIXO+" "+SE1->E1_NUM+" "+SE1->E1_PARCELA+" "+SE1->E1_CLIENTE+" "+SE1->E1_LOJA+" "+_cCEP )
	_cCEP:= ""
Else
	_lForaPraca:= .T.
	While !EOF() .And. _cDigCep == SubStr(CEPS->FAIXA1,1,1)
		IF ( _cCEP >= CEPS->FAIXA1 .And. _cCEP <= CEPS->FAIXA2 )
			_lForaPraca:= .F.
			Exit
		ENDIF
		DbSkip()
	End
	If _lForaPraca
		AADD( _aRejeitados , SE1->E1_PREFIXO+" "+SE1->E1_NUM+" "+SE1->E1_PARCELA+" "+SE1->E1_CLIENTE+" "+SE1->E1_LOJA+" "+_cCEP )
		_cCEP:= ""
	Endif
EndIf

DbSelectArea(_cAlias)
DbSetOrder(_nOrdem)
DbGoTo(_nRecno)

RETURN
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImpDel()  �Autor  �Microsiga           � Data �  04/04/02   ���
�������������������������������������������������������������������������͹��
���Desc.     � Imprime rejeitados                                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpDel()

cString:="SE1"
cDesc1:= OemToAnsi("Este programa tem como objetivo, imprimir os registros ")
cDesc2:= OemToAnsi("rejeitos por estar fora da praca de compensacao do Banespa")
cDesc3:= ""
tamanho:="P"
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:="PFAT116"
aLinha  := {}
nLastKey := 0
lEnd := .f.
titulo      :="REGISTROS REJEITADOS BANESPA"
cabec1      :="TITULO       CLIENTE   CEP REJEITADO"
cabec2      :=""
cCancel := "***** CANCELADO PELO OPERADOR *****"

m_pag := 0
MHORA      := TIME()
wnrel:="PFAT116_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

Processa({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==>        RptStatus({|| Execute(RptDetail) })

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �RptDetail � Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Impressao do corpo do relatorio                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RptDetail()

li      := 80
m_pag   := 1
aDriver := ReadDriver()
nTipo   := IIF(aReturn[4]==1,15,18)

ProcRegua(LEN(_aRejeitados))

For nLin := 1 to Len(_aRejeitados)
	If lAbortPrint
		@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif
	If Li > 45
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	EndIf
	@ li,0 PSAY _aRejeitados[nLin]
	li++
	IncProc()
Next

Roda(0,"","P")

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

Return