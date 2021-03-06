#include "rwmake.ch" 
#INCLUDE "TOPCONN.CH"  //consulta SQL
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HISTBXPG  �Autor  �Danilo C S Pala     � Data �  20100322   ���
�������������������������������������������������������������������������͹��
���Desc.     � LOCALIZAR NOME DO FORNECEDOR DO TITULO PAI                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � COMPRAS                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
                 
User Function HISTBXPG()
Private xTitPai := RIGHT(Alltrim(SE2->E2_TITPAI),8)
Private cFORNECE := subs(xTitPai,1,6)
Private cLOJA := subs(xTitPai,7,2)
Private cQuery :=""
Private cNome := ""
Private cImposto :=""                         

if SE2->E2_TIPO=="TX " .AND. ALLTRIM(SE2->E2_NATUREZ)=="IRF"
	cImposto := "IRRF/"
elseif SE2->E2_TIPO=="TX " .AND. ALLTRIM(SE2->E2_NATUREZ)=="PIS"
	cImposto := "PIS/"
elseif SE2->E2_TIPO=="TX " .AND. ALLTRIM(SE2->E2_NATUREZ)=="COFINS"
	cImposto := "COFINS/"
elseif SE2->E2_TIPO=="TX " .AND. ALLTRIM(SE2->E2_NATUREZ)=="CSLL"
	cImposto := "CSLL/"
elseif SE2->E2_TIPO=="ISS" .AND. ALLTRIM(SE2->E2_NATUREZ)=="ISS"
	cImposto := "ISS/"
elseif SE2->E2_TIPO=="INS" .AND. ALLTRIM(SE2->E2_NATUREZ)=="INSS"
	cImposto := "INSS/"
else
	cImposto := ""
endif
 

cQuery := "SELECT A2_COD, A2_LOJA, A2_NOME, A2_NREDUZ FROM "+ RetSqlName("SA2") +" SA2 WHERE A2_FILIAL='"+ XFILIAL("SA2") +"' AND A2_COD ='"+ cFornece  +"' AND A2_LOJA='"+ cLoja +"' AND SA2.D_E_L_E_T_<>'*'"
TCQUERY cQuery NEW ALIAS "SA2PAI"
DbSelectArea("SA2PAI")
DBGOTOP()
IF !eof()
	cNome := cImposto+ ALLTRIM(SA2PAI->A2_NREDUZ) +"/NF"+ SE2->E2_NUM
ELSE                         
	cNome := "NF"+ SE2->E2_NUM
ENDIF     
DbCloseArea("SA2PAI")



return (cNome)