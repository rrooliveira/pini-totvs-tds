#INCLUDE "RWMAKE.CH"
/*
Alterado por Danilo C S Pala em 20120730: n�o aparecer a mensagem da natureza de baixa
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO4     �Autor  �Microsiga           � Data �  08/27/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA070TIT() 

/*Local oDlgNat //20120730 daqui
Local cNatBx := Space(10)

@ 315, 310 to 405, 650 Dialog oDlgNat Title OemToAnsi("Informe Natureza de Baixa")
@ 010, 010 Say OemToAnsi("Nat Baixa?") Size 50,10
@ 010, 065 Get cNatBx Size 50,10 F3("Z5")
@ 025, 120 BmpButton Type 1 Action Close(oDlgNat)
Activate Dialog oDlgNat Centered
*/ ////20120730 ate aqui
DbSelectArea("SE1")
RECLOCK("SE1",.f.)
SE1->E1_DTALT  := dDataBase
//SE1->E1_NATBX  := cNatBx                                   // Grava Natureza na Baixa  //20120730
MsUnlock()

Return(.t.)