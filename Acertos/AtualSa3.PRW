#include "rwmake.ch"        
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: Atualsz0  �Autor: Valdir Diocleciano     � Data:   28/04/03 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Atualizacao do campo Sa3->a3_Local                         � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento                                      � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function AtualSa3()        
SetPrvt("cArqTEMP1,cKey,Chave,bBloco,codigo")

cArqTemp1 := "LOC_GER.DBF"
dbUseArea( .F.,, cArqTemp1,"TMP", .F. )

bBloco:= { |lEnd| ATUALIZA()  }

MsAguarde( bBloco, "Aguarde" ,"Processando...", .T. )

Static Function Atualiza()

dbselectarea("TMP")
dbgotop()

While !Eof()
	codigo := TMP->COD
	dbSelectArea("SA3")
	If DBSEEK(xFILIAL()+codigo)
		RecLock("SA3",.F.)
		SA3->A3_LOCAL := "T4" 
		MsUnlock()
	Endif
	dbselectarea("TMP")
	dbskip()
	loop
End
Return
