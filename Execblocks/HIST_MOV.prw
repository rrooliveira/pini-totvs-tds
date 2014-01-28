/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HIST_MOV  �Autor  �DANILO C S PALA     � Data �  20060223   ���
�������������������������������������������������������������������������͹��
���Desc.     � RETORNAR O HISTORICO DO LANCAMENTO CONTABIL, DIFERENCIANDO ���
���          � SE HOUVER CGC NO MOVIMENTO BANCARIO OU NAO                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HIST_MOV()
Local s_hist  := space(40)
Local aArea := GetArea()   
//IF SM0->M0_CODIGO=="01" 
	If Empty(SE5->E5_CGC) 
		//s_hist := "DEPOSITOS EFETUADOS" +SA6->A6_NREDUZ    
		IF ALLTRIM(SE5->E5_NATUREZ)=="0102"
			s_hist := "AVS CREDITO REF DEPOSITO EM CC " +SA6->A6_NREDUZ    
		ELSE
			s_hist := "DEPOSITOS EFETUADOS " +SA6->A6_NREDUZ    
		END
	Else
		s_hist := "DEP CC "+ alltrim(SA6->A6_NREDUZ)  +"/ " +SE5->E5_CGC
	Endif
/*ELSE
	s_hist := "DEPOSITOS EFETUADOS" +SA6->A6_NREDUZ    
ENDIF */
RestArea(aArea)

RETURN(s_hist)