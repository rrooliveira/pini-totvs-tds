#INCLUDE "RWMAKE.CH"
User Function RACODMUN()
  Private lEnd, cArqtemp1, mChave
  lEnd:= .F.
  Processa({|lEnd| ProcMUN(@lEnd)})
Return


Static Function ProcMUN()

cArqTemp1 := "CODMUN.DBF"
dbUseArea( .T.,, cArqTemp1,"TMP", if(.F. .OR. .F., !.F., NIL), .F. )

dbSelectArea("TMP")
DbGoTop()

ProcRegua(RecCount())

DO WHILE !EOF() .and. !lEnd
	IncProc("Lendo Registro " + Str(recno(),6,0))
	mChave :=TMP->CODCLI
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbGoTop()
	If DbSeek(xFilial("SA1")+MCHAVE) 
	   RecLock("SA1",.F.)
	   SA1->A1_COD_MUN:=TMP->CODMUN 
	   MsUnlock()
	Endif  
	dbSelectArea("TMP")
	DBSKIP()      
ENDDO

DbSelectArea("TMP")
DbCloseArea()     

DbSelectArea("SA1")
RetIndex("SA1")  
Return