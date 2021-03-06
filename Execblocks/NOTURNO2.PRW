#include "rwmake.ch"
#include "ap5mail.ch"
/*/ Alterado em 20030818 por Danilo
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Rdmake    � NOTURNO  � Autor � Danilo C S Pala       � Data � 05/03/01  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Copia dos arquivos da producao com tempo pre-definido.      ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe   � NOTURNO2()                                                  ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � Generico - Editora PINI                                     ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function Noturno2

Private _cTitulo  := "Backup Noturno"
Private _ccMens1  := "Hora Inicial.: "
Private _cTempo   := Time()
Private _ccMens2  := "Previsto para: "
Private _ccMens3  := "Hora Atual...: "
Private _cHora    := Time()
Private lEnd      := .F.
Private nCont     := 0
Private cSubdir   := DTOS(dDataBase) 
Setprvt("Mdia, _aAlias, Memp")

//WinExec("C:\WINDOWS\COMMAND.COM /c md \BKP_AP5\"+cSubdir,2)
Msgalert("Certifique-se que o diretorio \BKP_AP5\"+cSubdir+" esteja criado.")

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������


DbUseArea(.T.,, "\SIGA\ARQASS\BACKUP.DBF","BACKUP",.F.,.F.)
/*DbUseArea(.T.,, "\SIGA\ARQASS\BKTABLES.DBF","BKTABLES",.F.,.F.)
DbUseArea(.T.,, "\SIGA\ARQASS\BKTAB02.dbf","BKTAB02",.F.,.F.) //EMPRESA 02 EXCETO AS COMUNS
DbUseArea(.T.,, "\SIGA\ARQASS\BKTAB03.dbf","BKTAB03",.F.,.F.) //EMPRESA 03 EXCETO AS COMUNS
//DbUseArea(.T.,, "\SIGA\ARQASS\NBKTABLE.dbf","NBKTABLE",.F.,.F.)*/
Memp := SM0->M0_CODIGO
Mdia := BACKUP->DIA

@ 010,001 TO 250,400 DIALOG oDlg TITLE _cTitulo
@ 005,010 SAY "Dia:"
@ 005,020 GET Mdia
@ 005,040 BUTTON "Set" SIZE 40,11 ACTION Processa({||SetDia()})
@ 015,010 SAY _ccMens1
@ 015,100 SAY _cTempo  Picture "@R 99:99:99"
@ 025,010 SAY _ccMens2
@ 025,100 GET _cHora   Picture "@R 99:99:99" VALID _cHora >= _cTempo
@ 080,100 BMPBUTTON TYPE 1 ACTION ( Processa({||CopiaDados()},_ccMens1+_cTempo+"        "+_ccMens2+Transform(_cHora,"@R 99:99:99")), Close(oDlg))
@ 080,140 BMPBUTTON TYPE 2 ACTION ( Close(oDlg) )
Activate Dialog oDlg CENTERED
DbselectArea("backup")
DbCloseArea()
Return



//��������������������������������������������������������������Ŀ
//� Executa a funcao COPIADADOS()                                �
//����������������������������������������������������������������
Static Function CopiaDados()
// VERIFICAO DO DIA DO BACKUP
if (Memp=="02" .AND. mdia==5) .or. (Memp=="03" .AND. mdia==6) .or. (Memp == "01") .and. ((Mdia >= 1) .and. (Mdia < 5))
   //	MsgAlert("Ok, dia: "+alltrim(str(mdia)))
else
	_cMsgINFO:= "Dia do processamento: "+alltrim(str(mdia))+", acesse a empresa conforme abaixo:"+CHR(13)
	_cMsgINFO:= _cMsgINFO + "Dias 1 ate 4: Editora Pini;"+CHR(13)
	_cMsgINFO:= _cMsgINFO + "Dia 5: Pini Sistemas;"+CHR(13)
	_cMsgINFO:= _cMsgINFO + "Dia 6: BP S/A;"+CHR(13)
	MsgInfo(OemToAnsi(_cMsgInfo))
	return
end if

_lExecuta   := .F.
_cTempo     := Time()
_lProcessou := .F.
_nFinal     := ( 3600 * Val( Substr( _cHora,  01, 02 ) ) ) + ( 60 * Val( Substr( _cHora,  04, 02 ) ) ) + Val( Substr( _cHora,  07, 02 ) )
_nTempo     := ( 3600 * Val( Substr( _cTempo, 01, 02 ) ) ) + ( 60 * Val( Substr( _cTempo, 04, 02 ) ) ) + Val( Substr( _cTempo, 07, 02 ) )
_nTime      := (_nFinal - _nTempo)/30
_cTempoAux  := _cTempo


ProcRegua( _nTime )
If !Empty( _cHora ) .and. _cHora >= _cTempo
	While _cTempo < _cHora
		If _cTempo != _cTempoAux
			_cTempoAux := _cTempo
			IncProc("Hora Atual...: " + _cTempo)
		EndIf
		If lEnd // Cancela processamento
			Return .t.
		Endif
		_cTempo := Time()
		If _cTempo >= _cHora
			_lExecuta := .T.
			Exit
		Endif
		Sleep(30000)
	End
Else
	If Empty(_cHora)
		MsgStop("Hora nao pode ficar vazia!")
	Endif
	If _cHora < _cTempo
		MsgStop("Hora para execucao do processamento deve ser..."+chr(13)+chr(13)+;
		"...MAIOR ou IGUAL a HORA ATUAL.")
	Endif
	Envia("P")
Endif
  


nCont := 0 
_lExecuta := .T. //20040129 TESTES

If _lExecuta
	Envia("I")
	//���������������������������������������������������������� asH�
	//�Esta table contem uma coluna com o dia a ser executado   �
	//� o backup, a qual servira para procurar o arquivo com as �
	//�tabelas a serem copiadas naquele                         �
	//���������������������������������������������������������� asH�
	
	
	//DbUseArea(.T.,, "\SIGA\ARQASS\BACKUP.dbf","BACKUP",.F.,.F.)
	DbSelectarea("BACKUP")
	DbGoTop()
	
	if (Memp=="02" .AND. mdia==5)
		DbUseArea(.T.,, "\SIGA\ARQASS\BKTAB02.dbf","BKTAB02",.F.,.F.)
		DbSelectArea("BKTAB02")
		cIndex  := CriaTrab(nil,.f.)
		cChave  := "TABELA"
		cFiltro := ""
		IndRegua("BKTAB02",cIndex,cChave,,cFiltro,"Filtrando ..")
		Dbgotop()
		
		While !Eof()
			cDriver   := __cRdd
			_cAlias   := alltrim(BKTAB02->TABELA)
			_cArquivo := RetArq(cDriver,_cAlias+"020",.T.)  // Nome do arquivo depEndEndo da Rdd(dbfcdx ou topcon)
			IncProc( "Copiando o arquivo "+_cArquivo+".DBF" )
			_lProcessou := .F.
			
			dbSelectArea(_cAlias)
			dbGotop()
			_aAlias := "\BKP_AP5\"+cSubdir+"\"+_cArquivo   //+".dbf"
		   	Copy To &_aAlias  VIA "DBFCDXADS" // 20121106 //teste 20040204
			dbCloseArea()
			
			_lProcessou := .T.
			nCont++
			
			dbSelectArea("BKTAB02")
			dbSkip()
		End
		DbselectArea("bktab02")
		DbCloseArea()		
		
	ELSEif (Memp=="03" .AND. mdia==6)
		DbUseArea(.T.,, "\SIGA\ARQASS\BKTAB03.dbf","BKTAB03",.F.,.F.)
		DbSelectArea("BKTAB03")
		cIndex  := CriaTrab(nil,.f.)
		cChave  := "TABELA"
		cFiltro := ""
		IndRegua("BKTAB03",cIndex,cChave,,cFiltro,"Filtrando ..")
		Dbgotop()
		
		While !Eof()
			cDriver   := __cRdd
			_cAlias   := alltrim(BKTAB03->TABELA)
			_cArquivo := RetArq(cDriver,_cAlias+"030",.T.)  // Nome do arquivo depEndEndo da Rdd(dbfcdx ou topcon)
			IncProc( "Copiando o arquivo "+_cArquivo+".DBF" )
			_lProcessou := .F.
			
			dbSelectArea(_cAlias)
			dbGotop()
			_aAlias := "\BKP_AP5\"+cSubdir+"\"+_cArquivo  //+".dbf"
		   	Copy To &_aAlias  VIA "DBFCDXADS" // 20121106 //teste 20040204
			dbCloseArea()
			
			_lProcessou := .T.
			nCont++
			dbSelectArea("BKTAB03")
			dbSkip()
		End
		DbselectArea("bktab03")
		DbCloseArea()
		
	elseif ((Memp == "01") .and. ((Mdia >= 1) .and. (Mdia < 5)))
		
		// NO FIM ATUALIZA_DIA()
		// tabela com CAMPOS: tabela, dia  ==> para fazer o backup daquelas com o dia especificado
		DbUseArea(.T.,, "\SIGA\ARQASS\BKTABLES.dbf","BKTABLES",.F.,.F.)
		dbSelectArea("BKTABLES")
		cIndex  := CriaTrab(nil,.f.)
		cChave  := "TABELA"
		cFiltro := "BKTABLES->DIA == MDIA"
		IndRegua("BKTABLES",cIndex,cChave,,cFiltro,"Filtrando ..")
		Dbgotop()
		
		While !Eof()  
			if alltrim(BKTABLES->TABELA)="SIGAGPE" 	//20040129
				MSGALERT("ACHOU!")
			ENDIF
			cDriver   := __cRdd
			_cAlias   := alltrim(BKTABLES->TABELA)
			_cArquivo := RetArq(cDriver,_cAlias+"010",.T.)  // Nome do arquivo depEndEndo da Rdd(dbfcdx ou topcon)
			IncProc( "Copiando o arquivo "+_cArquivo+".DBF" )
			_lProcessou := .F.
			
			dbSelectArea(_cAlias)
			dbGotop()
			_aAlias := "\BKP_AP5\"+cSubdir+"\"+_cArquivo   //+".dbf"
			Copy To &_aAlias  VIA "DBFCDXADS" // 20121106 
			dbCloseArea()
			
			_lProcessou := .T.
			nCont++
			
			dbSelectArea("BKTABLES")
			dbSkip()
		End
		DbselectArea("bktables")
		DbCloseArea()
	ELSE
		Msgalert("Empresa e/ou dia incorretos!"+chr(13)+"Verifique em \SIGA\ARQASS\BACKUP.DBF")
	endif
	Atualiza_dia()
Endif

If _lProcessou
	Envia("F")
	MsgBox("Hora Inicial........... : "+transform(_cHora,"@r 99:99:99")+Chr(13)+;
	"Hora Final............. : "+transform(Time()  ,"@r 99:99:99"),"Backup concluido...")
Else
	MsgStop("Nao houve processamento ( Backup )","Processo Concluido...")
	Envia("F")
Endif

Return .T.
             



// funcao para enviar um e-mail sobre o backup
Static Function Envia(cTipo)
Private cDest     := "dpala@pini.com.br;raquel@pini.com.br"
Private cServMail := "172.22.4.51"
Private cSend     := "ap5@pini.com.br"
Private cBody     := "" //"Nao responda esta mensagem."+CHR(10)+CHR(13) //O Backup da base foi programado para "+Time()
Private cTitulo   := "" // "AP5"

If cTipo == "P"
	cTitulo += "programacao"
	cBody += "Backup programado para "+Transform(_cHora,"@R 99:99:99") +" as "+Time()+CHR(10)+CHR(13)
	cBody += "pelo usuario "+Substr(cUsuario,7,13)+"."+CHR(10)+CHR(13)
	cBody += "Empresa: "+MEMP+"  dia: "+Str(Mdia)+CHR(10)+CHR(13)
	cBody += "FIM DA MENSAGEM."+CHR(10)+CHR(13)
ElseIf cTipo == "I"
	cTitulo += "iniciado"
	cBody += "Backup iniciado as "+Time()+"."+CHR(10)+CHR(13)
	cBody += "Empresa: "+MEMP+"  dia: "+Str(MDIA)+CHR(10)+CHR(13)
	cBody += "FIM DA MENSAGEM."+CHR(10)+CHR(13)
ElseIf cTipo == "F"
	cTitulo += "finalizado"
	cBody += "Backup finalizado as "+Time()+"."+CHR(10)+CHR(13)
	cBody += "Copiadas "+Str(nCont)+" tabelas."+CHR(10)+CHR(13)
	cBody += "Empresa: "+MEMP+"  dia: "+Str(MDIA)+CHR(10)+CHR(13)
	cBody += "FIM DA MENSAGEM."+CHR(10)+CHR(13)
EndIf

CONNECT SMTP SERVER cServMail ACCOUNT cSend PASSWORD ""
SEND MAIL FROM cSend TO cDest SUBJECT cTitulo BODY cBody
DISCONNECT SMTP SERVER

Return






// Atualiza o dia do backup
Static Function Atualiza_dia()
DbSelectArea("BACKUP")
DbGoTop()
if Mdia > 5
	RecLock("BACKUP",.f.) //update (.f.)
	DIA := 1
	MsUnlock()
else
	RecLock("BACKUP",.f.) //update (.f.)
	DIA := MDIA+1
	MsUnlock()
endif
return



// Set o dia do backup
Static Function SetDia()
DbSelectArea("BACKUP")
DbGoTop()      
if Mdia >=1 .and. Mdia <=6
	RecLock("BACKUP",.f.) //update (.f.)
	DIA := Mdia
	MsUnlock()
	MSgAlert("Dia alterado para: " + alltrim(str(mdia)))
else                      
	MSgAlert("Dia inv�lido!")
endif
return
