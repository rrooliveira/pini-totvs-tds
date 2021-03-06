#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA090SE5  �Autor  �Microsiga           � Data �  04/16/02   ���
�������������������������������������������������������������������������͹��
���Desc.     � Criado para garantir gravacao do SE5                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA090SE5()

Local aArea := GetArea()

If !Empty(cBordero)
	//AtuSalBco(SEA->EA_PORTADO,SEA->EA_AGEDEP,SEA->EA_NUMCON,SE5->E5_DATA,SE5->E5_VALOR,"-")
	DbSelectArea("SEA")
	DbSetOrder(1)
	If DbSeek(xFilial("SEA")+Padr(cBordero,6)+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA)
		RecLock("SE5",.f.)
		SE5->E5_BANCO   := SEA->EA_PORTADO
		SE5->E5_AGENCIA := SEA->EA_AGEDEP
		SE5->E5_CONTA   := SEA->EA_NUMCON
		MsUnlock()
	EndIf
EndIf

RestArea(aArea)

Return(PARAMIXB)