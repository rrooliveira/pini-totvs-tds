/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: LP527S3   �Autor: Roger Cangianeli       � Data:   21/01/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Retorna .T. ou .F., se lancamento nao for L&P e Situacao 3 � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : Especifico PINI                                            � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function LP527S3()

Local _lRet := .T.

If 'LP' $ SUBS(SE1->E1_MOTIVO,1,2) .or. SE1->E1_SITUACA # '3'
    _lRet := .F.
EndIf

Return(_lRet)