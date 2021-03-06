** BAIXA DE TITULOS A RECEBER
** RETORNA HISTORICO                                               
// Alterado por Danilo C S Pala 20050520: CFB
//Alterado por Danilo C S Pala em 20070315: CFE
//Alterado por Danilo C S Pala em 20070328: NFS
//Alterado por Danilo C S Pala em 20080220: SEN
User Function RecHist()

Local CRHIST := 'HISTORICO'

   IF TRIM(SE1->E1_SERIE) $ 'UNI/D1/CUP/CFS/CFA/CFB/ANG/CFE/NFS/SEN/8' //20050520 CFB //20061031 ANG //20070315 CFE  //20070328 NFS //20080220 SEN
      DO CASE
         CASE TRIM(SE5->E5_MOTBX)=='NOR'
              CRHIST := 'RECBTO DUPL.' + SE1->E1_NUM +' '+SE1->E1_PARCELA+'-'+SE1->E1_NOMCLI
         CASE TRIM(SE5->E5_MOTBX)=='CAN'
              CRHIST := 'RECBTO DUPL.' + SE1->E1_NUM +' '+SE1->E1_PARCELA+'-'+SE1->E1_NOMCLI
         CASE TRIM(SE5->E5_MOTBX)=='LP'
              CRHIST := 'DUPL.INCOBRAVEL '+SE1->E1_NUM +' '+SE1->E1_PARCELA+'-'+SUBS(SE1->E1_NOMCLI,1,20)
      ENDCASE
   ENDIF

IF TRIM(SE1->E1_TIPO) == 'CH'
      CRHIST := 'DEP.CHEQUE ' + SE1->E1_NUM +' CLIENTE:'+SE1->E1_NOMCLI
ENDIF

RETURN(CRHIST)