#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PINILOGCONS�Autor  �DANILO C S PALA     � Data �  20120503   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � PINI                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION PINILOGCONS(cEmp, cCliente, cLoja, cSerie, cNum, cParc, dEmissao, cPedido, cTipo, cRotina, cObs)
IF SM0->M0_CODIGO=='01' .or. SM0->M0_CODIGO=='02' .or. SM0->M0_CODIGO=='03'
	DBSELECTAREA("ZY8")
	Reclock("ZY8",.T.)
	REPLACE ZY8_FILIAL	WITH XFILIAL("ZY8")
	REPLACE ZY8_EMP		WITH cEmp
	REPLACE ZY8_CLIENT	WITH cCliente
	REPLACE ZY8_LOJA	WITH cLoja
	REPLACE ZY8_SERIE	WITH cSerie
	REPLACE ZY8_NUM 	WITH cNum
	REPLACE ZY8_PARC	WITH cParc
	REPLACE ZY8_EMISS	WITH dEmissao
	REPLACE ZY8_PEDIDO	WITH cPedido
	REPLACE ZY8_TIPO	WITH cTipo
	REPLACE ZY8_ROTINA 	WITH cRotina
	REPLACE ZY8_OBS 	WITH cObs
	REPLACE ZY8_USUARI	WITH substr(cUsuario,7,15)
	REPLACE ZY8_DATALO	WITH dtos(date()) + " " + time()
	REPLACE ZY8_HOSTAN	WITH GETCOMPUTERNAME()
	MSUnlock()
ENDIF
RETURN