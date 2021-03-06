#INCLUDE "RWMAKE.CH"
/*                                                                   
// Alterado por Danilo C S Pala 20050520: CFB
//Alterado por Danilo C S Pala em 20070315: CFE
//Alterado por Danilo C S Pala em 20070328: NFS
//Alterado por Danilo C S Pala em 20080220: SEN
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FATHIST2  �Autor  �Microsiga           � Data �  04/25/02   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna Historico para contabilizacao de faturamento da    ���
���          � Pini Sistemas                                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FatHist2()

Local aArea  := GetArea()
Local cRHist := "HISTORICO"

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+SD2->D2_CLIENTE)

IF ALLTRIM(SD2->D2_SERIE) $ 'UNI/D1/CUP/CFS/CFA/CFB/ANG/CFE/NFS/SEN/8' //20050520 : CFB //20061031 ANG  //20070315 CFE  //20070328 NFS //20080220 SEN
    cRHist := 'NF.' + SD2->D2_DOC + ' ' + SA1->A1_NREDUZ
ENDIF

RestArea(aArea)

RETURN(cRHist)