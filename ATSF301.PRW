#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 30/03/02
//Alterado por Danilo C S Pala em 20050520: CFB
//Alterado por Danilo C S Pala em 20070315: CFE
//Alterado por Danilo C S Pala em 20070328: NFS
//Alterado por Danilo C S Pala em 20080220: SEN
//Alterado por Danilo C S Pala em 20081031: STD
User Function ATSF301()
SetPrvt("CINDEX,CKEY,MCHAVE,CARQ,MCONTA,MCONTRIB,MEST,MCONTA1,MRECO")

cPerg:="FIS001"
If !Pergunte(cPerg,.t.)
   Return
Endif

lEnd  := .F.
bBloco:= {|lEnd| ATSF3proc(@lEnd)}
Processa( bBloco, "Aguarde" ,"Processando...", .T. )  

Return

Static Function ATSF3proc()        // incluido pelo assistente de conversao do AP5 IDE em 30/03/02


MCONTA:=0
MCONTA1:=0
MRECO:=0


Do While .T.
   DBSELECTAREA("SF3")
   ProcRegua(LastRec())
   DBGOTOP()
   MCONTA:=0
   If DbSeek(xFilial("SF3")+DTOS(MV_PAR01),.T.)
      do while SF3->F3_ENTRADA<=MV_PAR02
         IncProc("Data : "+Dtoc(F3_EMISSAO)+" ATUALIZANDO : "+StrZero(mConta,7))
         mReco:=Recno()
         DBSELECTAREA("SF3")
         IF F3_SERIE<>'UNI' .and. f3_serie<>'CUP' .and. f3_serie<>'CFS' .and. f3_serie<>'CFA' .and. f3_serie<>'CFB' .and. f3_serie<>'ANG'  .and. f3_serie<>'CFE' .AND. F3_SERIE<>'NFS' .and. f3_serie<>'PUB' .and. f3_serie<>'   ' .and. f3_serie<>'SEN' .and. f3_serie<>'STD' .AND. F3_CFO>='500' .AND. YEAR(F3_ENTRADA)<=2002  //20041227 CFA  //20050520 CFB //20061031 ANG //20070315 CFE  //20070328 NFS //20080220 SEN //20081031 STD
            Reclock("SF3",.F.)
            DbDelete()
            MsUnLock()
         Endif 
         IF F3_SERIE<>'UNI' .and. f3_serie<>'CUP' .and. f3_serie<>'CFS' .and. f3_serie<>'CFA' .and. f3_serie<>'CFB' .and. f3_serie<>'ANG'  .and. f3_serie<>'CFE' .AND. F3_SERIE<>'NFS' .and. f3_serie<>'PUB' .and. f3_serie<>'   ' .and. f3_serie<>'SEN' .and. f3_serie<>'8  ' .AND. F3_CFO>='5000'.AND. YEAR(F3_ENTRADA)>=2003      //20050520 CFB //20061031 ANG  //20070315 CFE  //20070328 NFS //20080220 SEN
            Reclock("SF3",.F.)
            DbDelete()
            MsUnLock()
         Endif 
         skip
      enddo
   Endif
   MV_PAR01:=MV_PAR01+1
   IF MRECO<>0
      Exit
   ENDIF
Enddo
DbSelectArea("SF3")
Retindex("SF3")
Return
