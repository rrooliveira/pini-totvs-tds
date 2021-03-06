#INCLUDE "RWMAKE.CH"
User Function RATASA1()
  Private lEnd, cArqtemp1, mChave,mCodcli,mEnd,mFone,mCGCant,mIeant,mNome,mvlchave,mTamalho,mTamalho1  
  lEnd:= .F.
  Processa({|lEnd| ProcSA1(@lEnd)})
Return


Static Function ProcSA1()

cArqTemp1 := "CT2000B.DBF"
dbUseArea( .T.,, cArqTemp1,"TMP", if(.F. .OR. .F., !.F., NIL), .F. )

dbSelectArea("TMP")
DbGoTop()

ProcRegua(RecCount())

WHILE !EOF() .and. !lEnd
	IncProc("Lendo Registro " + Str(recno(),6,0))
	mChave :=TMP->CGC 
	mvlchave:=val(mchave) 
	mTamanho:=Len(Alltrim(str(mvlchave,14,0)))
	mTamanho1:=14-mtamanho    
	If mTamanho<>14   .and. mTamalho<>0
	   mChave:=Alltrim(str(mvlchave,14))+space(mTamanho1)
	Endif
	mCGCANT:=" "
	mIEANT:=" "
	mCodcli:=" "
	mFone:=" "              
	mEndereco :=" "
	mNome:=" "  
	DbSelectArea("SA1")
	DbSetOrder(3)
	DbGoTop()
	If DbSeek(xFilial("SA1")+MCHAVE)  .and. mvlchave<>0 
	   WHILE SA1->A1_CGC==MCHAVE
	      RecLock("SA1",.F.)
	      If ! Empty(TMP->NIE)
	          mIEANT:=SA1->A1_INSCR 
		      SA1->A1_INSCR := ALLTRIM(TMP->NIE)
		  Endif
		  If ! Empty(TMP->NCGC)
		     mCGCANT:=SA1->A1_CGC
		     SA1->A1_CGC:=ALLTRIM(TMP->NCGC)
		  Endif 
		  mCodcli:=SA1->A1_COD
	      mFone:=SA1->A1_TEL
	      mNome:=SA1->A1_NOME    
	      mEndereco :=SA1->A1_END
	      MsUnlock()
	  	  DBSKIP()
	  	END
	Endif        
	
	DbSelectArea("SA2")
	DbSetOrder(3)
	DbGoTop()
	If DbSeek(xFilial("SA2")+MCHAVE)  .and. mvlchave<>0 
	   WHILE SA2->A2_CGC==MCHAVE
	      RecLock("SA2",.F.)
	      If ! Empty(TMP->NIE)
	          mIEANT:=SA2->A2_INSCR 
		      SA2->A2_INSCR := ALLTRIM(TMP->NIE)
		  Endif
		  If ! Empty(TMP->NCGC)  
		     mCGCANT:=SA2->A2_CGC
		     SA2->A2_CGC:=ALLTRIM(TMP->NCGC)
		  Endif 
		  mCodcli:=SA2->A2_COD
	      mFone:=SA2->A2_TEL
	      mNome:=SA2->A2_NOME    
	      mEndereco:=SA2->A2_END
	      MsUnlock()
	  	  DBSKIP()
	  	END
	Endif  
	
	DbSelectArea("TMP")
    If !Empty(mEndereco)
       RecLock("TMP",.F.)      
       REPLA FATEND WITH mEndereco
       REPLA CGCSA1 WITH mCGCANT
       REPLA IESA1  WITH mIEANT  
       REPLA CODCLI WITH mCodcli
       REPLA FONE   WITH mFone
       REPLA NOME   WITH mNome
       MsUnlock()  
    Endif
    DBSKIP()
END

DbSelectArea("TMP")
DbCloseArea()     

DbSelectArea("SA1")
DbRetIndex("SA1")  
DbSelectArea("SA2")
DbRetIndex("SA2")  
Return