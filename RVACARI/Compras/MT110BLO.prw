/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT110BLO  �Autor  �THIAGO COMELLI      � Data �  06/22/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �PONTO DE ENTRADA NA APROVACAO DA SOLICITACAO DE COMPRAS     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT110BLO()

Local lRet1 := .T.

//GRAVA O NOME DA FUNCAO NA Z03
U_CFGRD001(FunName())

If __CUSERID <> SC1->C1_CODAPRO
	MsgAlert("Usu�rio n�o autorizado a aprovar esta solicita��o.","Aten��o!")
	lRet1 := .F.
EndIf

Return(lRet1)