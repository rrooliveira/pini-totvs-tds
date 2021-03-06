#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02
/* alterado por Danilo C S Pala em 20060123                 
//20070524 Danilo C S Pala: SC5->C5_TPTRANS == "12"
//Danilo C S Pala 20100305: ENDBP
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VCB06     �Autor  �Microsiga           � Data �  03/27/02   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna "A/C" para o boleto                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Vcb06()        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02

SetPrvt("MAC,")

// AUTOR : CLAUDIO
// ALTERACAO : GILBERTO - 04.01.2001 - INCLUSAO DO TPTRANS 12
MAC:=' '
DbselectArea("SC5")         
DbSetOrder(1)
DBSEEK(XFILIAL()+SE1->E1_PEDIDO)
IF TRIM(SC5->C5_DIVVEN)=="PUBL" .AND. (SC5->C5_TPTRANS == "04" .OR. SC5->C5_TPTRANS == "12") .AND. !EMPTY(SC5->C5_CODAG)  //20070524 SC5->C5_TPTRANS == "12"
	DbselectArea("SA1")
	DBSEEK(XFILIAL()+SC5->C5_CODAG+SC5->C5_LOJACLI)
	MAC:="A/C "+SA1->A1_NOME
ELSEIF SE1->E1_PORTADO == "637" //20060123
	MAC:="A/C "+SA1->A1_NOME   //20060123
ELSEIF SE1->E1_PORTADO == "479" //20090910 422 excluido
	MAC:= "PROTESTAR APOS 03 DIAS UTEIS"
ELSEIF SM0->M0_CODIGO =="03" .AND. SA1->A1_ENDBP ="S"
		DbSelectArea("ZY3")
		DbSetOrder(1)
		IF DbSeek(xFilial("ZY3")+SA1->A1_COD+SA1->A1_LOJA, .F. )
			MAC:= "A/C " + ZY3->ZY3_CONTAT
		ENDIF
ELSE
	MAC:=' '
ENDIF

Return(MAC)