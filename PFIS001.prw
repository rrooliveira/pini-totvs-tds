#include "rwmake.ch"

/* alterar o nome para PFIS001
Ultima alteracao Danilo C S Pala 20050509: conversao de formato de data
20050921: alteracao dos cf
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIS001 era PFAT162   �Autor  �Danilo C S Pala     � Data �  20050313   ���
�������������������������������������������������������������������������͹��
���Desc.     � Intercambio de Dados Eletronicos(EDI)      				  ���
���			 |	 importa em SF3(Gold X Pini)						      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PFIS001
Private _cTitulo  := "EDI- Livros Fiscais"
Private cCliefor := "002067"
Private cLoja := "01"                  
Private carquivo := space(20)
Private cProcedimento := space(1)
Private nConta := 0
Private cMsgFinal := space(200)
private cfop := space(4)
SetPrvt("_ACAMPOS,_CNOME, cpath")

@ 010,001 TO 200,300 DIALOG oDlg TITLE _cTitulo
@ 005,010 SAY "Arquivo: \siga\Importa\"
@ 005,070 GET carquivo size  80,10
@ 020,010 SAY "Cliente/Fornec: "
@ 020,070 GET cCLIEFOR VALID .t. F3 "SA2"
@ 035,010 SAY "Loja: "
@ 035,070 GET cLoja
@ 050,020 BMPBUTTON TYPE 1 ACTION Processa({||Importar()})
@ 050,060 BMPBUTTON TYPE 2 ACTION ( Close(oDlg) )
Activate Dialog oDlg CENTERED

Return



//�����������������������������������������������Ŀ
//�Funcao que importa os dados, conforme o arquivo�
//�������������������������������������������������
Static Function Importar()
nConta := 0
DBSELECTAREA("SA2")
DBSETORDER(1)
IF DbSeek(xfilial("SA2")+CCLIEFOR+CLOJA)
	CESTADO :=    SA2->A2_EST
END IF          
DBSelectArea("SA2")
DbCloseArea("SA2")

DbSelectArea("SF3")   
/*DBUSEAREA(.T.,,"\SIGA\IMPORTA\"+ CARQUIVO,"ARQEDI",.F.,.F.)
DbSelectArea("ARQEDI")
cIndex  := CriaTrab(nil,.f.)
cChave  := "NFISCAL+SERIE"
cFiltro := ""
IndRegua("ARQEDI",cIndex,cChave,,cFiltro,"Indexando ...")
Dbgotop()                                                    */

cpath := "\SIGA\IMPORTA\"+ CARQUIVO
_aCampos := {}
AADD(_aCampos,{"LOTE"	,"N",	6,	0})
AADD(_aCampos,{"DTLOTE"	,"C",	8,	0})
AADD(_aCampos,{"NFISCAL","C",	6,	0})
AADD(_aCampos,{"SERIE"	,"C",	3,	0})
AADD(_aCampos,{"CFO"	,"C",   4,	0})
AADD(_aCampos,{"EMISSAO","C",	8,	0})
AADD(_aCampos,{"VALOR"	,"N",	14,	2})
AADD(_aCampos,{"BASEICM","N",	14,	2})
AADD(_aCampos,{"VALICM"	,"N",	14,	2})
AADD(_aCampos,{"ISENICM","N",	14,	2})
AADD(_aCampos,{"OUTRICM","N",	14,	2})
AADD(_aCampos,{"BASEIPI","N",	14,	2})
AADD(_aCampos,{"VALIPI" ,"N",	14,	2})
AADD(_aCampos,{"ISENIPI","N",	14,	2})
AADD(_aCampos,{"OUTRIPI","N",	14,	2})

_cNome := CriaTrab(_aCampos,.t.)
MsAguarde({|| dbUseArea(.T.,, _cNome,"ARQEDI",.F.,.F.)},"Criando arquivo temporario...")

//20050331 : appendar um arquivo sdf
DBSELECTAREA("ARQEDI")
   bBloco := "APPEND FROM &cpath SDF"
   APPEND FROM &cpath SDF
   MsAguarde({|| bBloco},"Apendando arquivo temporario...")
   MSUNLOCK()
   DBGOTOP()

if MsgYesNo("Confirma a Importacao do lote: "+ alltrim(str(ARQEDI->LOTE)) + " de "+ (ARQEDI->DTLOTE) + "?")
  ProcRegua(Reccount())
  While !Eof()
  //	MsgStop(ARQEDI->NFISCAL)      
	DbSelectArea("SF3")   	
	RecLock("SF3",.T.) //insert .T.         
		SF3->F3_FILIAL := xfilial("SF3")
		SF3->F3_NFISCAL := ARQEDI->NFISCAL
		SF3->F3_SERIE := ARQEDI->SERIE
		if ARQEDI->CFO = "5906" //20050921
			cfop := "1906"
		elseif ARQEDI->CFO = "5907"
			cfop := "1907"
		else             
			cfop := ARQEDI->CFO
		endif
		SF3->F3_CFO := cfop  //20050921
		SF3->F3_EMISSAO :=  stod(substr(ARQEDI->EMISSAO,5,4) + substr(ARQEDI->EMISSAO,3,2) + substr(ARQEDI->EMISSAO,1,2))
		SF3->F3_VALCONT := (ARQEDI->VALOR / 100)
		SF3->F3_BASEICM := (ARQEDI->BASEICM / 100)
		SF3->F3_VALICM := (ARQEDI->VALICM / 100)
		SF3->F3_ISENICM := (ARQEDI->VALOR / 100) //20050921
		SF3->F3_OUTRICM := (ARQEDI->OUTRICM / 100)
		SF3->F3_BASEIPI := (ARQEDI->BASEIPI / 100)
		SF3->F3_VALIPI := (ARQEDI->VALIPI / 100)
		SF3->F3_ISENIPI := (ARQEDI->ISENIPI / 100)
		SF3->F3_OUTRIPI := (ARQEDI->OUTRIPI / 100)
//OBRIGATORIOS
		SF3->F3_CLIEFOR := cCLIEFOR
		SF3->F3_LOJA := cLOJA
		SF3->F3_ESTADO := cESTADO
		SF3->F3_ENTRADA := DDATABASE
		SF3->F3_REPROC := "N"
		SF3->F3_ESPECIE := "NF"
	MsUnlock()
	DbSElectArea("ARQEDI")	
	DBSkip()
	IncProc()                 
	nConta := nConta +1
  end
end if
DBSelectArea("ARQEDI")
DbCloseArea("ARQEDI")
DBSelectArea("SF3")
DbCloseArea("SF3")
cMsgFinal := "Processamento finalizado!" + chr(10)
cMsgFinal += "Importados " + Alltrim(Str(nConta))+" arquivos."
MsgAlert( cMsgFinal)

return