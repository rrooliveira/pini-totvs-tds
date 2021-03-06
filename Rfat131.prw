#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "Fileio.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  |Rfat131   �Autor  �Danilo C S Pala     � Data �  20120525   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Rfat131()
Local cArquivo 	:= CriaTrab(,.F.)
Local oExcelApp
Local nHandle
Local cCrLf 	:= Chr(13) + Chr(10)
Local nX
local _cArq		:= ""
Private cQuery := ""
Private cNomeArquivo :=""

cPerg    := "RFAT131"  
ValidPerg()
If !Pergunte(cPerg)
   Return
Endif                    

cNomeArquivo :=  alltrim(mv_par04)
nHandle := MsfCreate(Alltrim(cNomeArquivo),0)
	
If nHandle > 0
	// Grava o cabecalho do arquivo
	fWrite(nHandle, "FORNECEDOR;LOJA;NOME;SERIE;NUMERO;EMISSAO;PARCELA;VENCTO;BAIXA;PRODUTO;DESCRICAO;VALOR_PRODUTO_TITULO")
	fWrite(nHandle, cCrLf ) // Pula linha

	CQuery := "select a2_cod FORNECEDOR, a2_loja LOJA, a2_nome NOME, d1_serie SERIE, d1_doc NUMERO, d1_emissao EMISSAO, e2_parcela PARCELA, e2_vencto VENCTO,  e2_baixa BAIXA, b1_cod PRODUTO, d1_descri DESCRICAO, (e2_valor * (d1_total /f1_valmerc)) as VALOR"
	CQuery += " from "+ RetSqlName("SF1") +" f1, "+ RetSqlName("SD1") +" d1, "+ RetSqlName("SB1") +" b1, "+ RetSqlName("SE2") +" e2, "+ RetSqlName("SA2") +" a2"
	CQuery += " where f1_filial='"+ XFILIAL("SF1") +"' and f1_doc=d1_doc and f1_serie=d1_serie and f1_fornece=d1_fornece and f1_loja=d1_loja and f1_emissao=d1_emissao and f1.d_e_l_e_t_<>'*'"
	CQuery += " and d1_filial='"+ XFILIAL("SD1") +"' and b1_filial='"+ XFILIAL("SB1") +"' and d1_cod=b1_cod and d1_fornece='"+ MV_PAR01 +"' and d1_emissao>='"+ dtos(MV_PAR02) + "' and d1_emissao<='"+ dtos(MV_PAR03) + "' and d1.d_e_l_e_t_<>'*' and b1.d_e_l_e_t_<>'*'"
	CQuery += " and e2_filial='"+ XFILIAL("SE2") +"' and e2_prefixo = 'COM' and e2_num= d1_doc and e2_fornece=d1_fornece and e2_loja =d1_loja and e2_emissao=d1_emissao and e2.d_e_l_e_t_<>'*' and e2_tipo='NF'"
	CQuery += " and a2_filial='"+ XFILIAL("SA2") +"' and a2_cod=d1_fornece and a2_loja=d1_loja and a2.d_e_l_e_t_<>'*'"

	TCQUERY cQuery NEW ALIAS "NOTA"
	TcSetField("NOTA","EMISSAO","D")
	TcSetField("NOTA","VENCTO","D")
	TcSetField("NOTA","BAIXA","D")
	DbSelectArea("NOTA")
	DBGOTOP()
	WHILE !EOF()       
		fWrite(nHandle, ("'"+ NOTA->FORNECEDOR) +";")
		fWrite(nHandle, ("'"+ NOTA->LOJA) +";")
		fWrite(nHandle, LimparCSV(NOTA->NOME) +";")
		fWrite(nHandle, LimparCSV("'"+ NOTA->SERIE) +";")
		fWrite(nHandle, LimparCSV("'"+ NOTA->NUMERO) +";")
		fWrite(nHandle, DTOC(NOTA->EMISSAO) +";")
		fWrite(nHandle, NOTA->PARCELA +";")
		fWrite(nHandle, DTOC(NOTA->VENCTO) +";")
		fWrite(nHandle, DTOC(NOTA->BAIXA) +";")      
		fWrite(nHandle, ("'"+ NOTA->PRODUTO) +";")
		fWrite(nHandle, NOTA->DESCRICAO +";")
		fWrite(nHandle, Transform(NOTA->VALOR,"@E 999,999,999.99") +";")
		
		fWrite(nHandle, cCrLf )

		DbSelectArea("NOTA")
		DBSkip()
	END
	DbSelectArea("NOTA")
	DbCloseArea()

	fClose(nHandle)
	//CpyS2T( cNomeArquivo , cPath, .T. )
		
	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado. Arquivo gerado: ' + alltrim(cNomeArquivo))
		Return
	EndIf
		
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(alltrim(cNomeArquivo)) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
Else
	MsgAlert("Falha na cria��o do arquivo")
Endif

Return 



Static Function LimparCSV(cTel)
cTel := upper(cTel)
cTel := Alltrim(StrTran(cTel,";",""))
Return cTel




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg �Autor  �Marcio Torresson    � Data �  10/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria parametros no SX1 nao existir os parametros.           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValidPerg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
aRegs := {}
//�������������������������������������������Ŀ
//� Vari�veis utilizadas para parametros      �
//� mv_par01             //Fornecedor         �
//� mv_par02             //EmissaoDe          �
//� mv_par03             //EmissaoAte         �
//���������������������������������������������
aAdd(aRegs,{cPerg,"01","Fornecedor","Fornecedor","Fornecedor","mv_ch1","C",15,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""})
aAdd(aRegs,{cPerg,"02","Emissao de","Emissao de","Emissao de","mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Emissao ate","Emissao ate","Emissao ate","mv_ch3","D",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Arquivo saida","Arquivo saida","Arquivo saida","mv_ch4","C",50,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

_nLimite := If(Len(aRegs[1])<FCount(),Len(aRegs[1]),FCount())
For i := 1 To Len(aRegs)
	If !DbSeek(cPerg + aRegs[i,2])
		Reclock("SX1", .T.)
		For j := 1 to _nLimite
			FieldPut(j, aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next
DbSelectArea(_sAlias)

Return(.T.)