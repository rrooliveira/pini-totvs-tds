#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"  //consulta SQL
/*/ 
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: PFAT242   �Autor: DANILO C S PALA        � Data:   20070919 � ��
������������������������������������������������������������������������Ĵ ��
���Descricao: ATUALIZAR ZZW 											 � ��
 sp_zzwupdvlr(in_dataatual => :in_dataatual);
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento                                      � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function PFAT242()

SetPrvt("CSAVTELA,CSAVCURSOR,CSAVCOR,CSAVALIAS,CPERG,CCABEC1")
SetPrvt("CCABEC2,CPROGRAMA,CTAMANHO,LIMITE,NCARACTER,NLASTKEY")
SetPrvt("CDESC1,CDESC2,CDESC3,ARETURN,_ACAMPOS,_CNOME")
SetPrvt("CINDEX1,CKEY,CINDEX2,WNREL,CSTRING,MD")
SetPrvt("XD,CARQ,CINDEX,_CFILTRO,MIND,CONT")
SetPrvt("MPEDIDO,MNOTA,MVEND,CONTINUA,MTES,MPROD")
SetPrvt("MNOME,MAUT,MMOEDA,MTIPO,MDOC,M_PAG")
SetPrvt("L,MBRUTO,MIRF,MISS,MLIQ,MMESANO")
SetPrvt("MVLBR,MVLIRF,MVLISS,MVLLIQ,MACHEI,CTITULO")
SetPrvt("MBCO,MAGEN,MCONTA,MANO,MMES, mpessoa, MTIPOVEN, MCGC")
SetPrvt("nConF, nContJ")
SetPrvt("FMBRUTO, FMIRF, FMISS, FMLIQ")
SetPrvt("JMBRUTO, JMIRF, JMISS, JMLIQ, MSerie, _ACAMPOSA, _CNOMEA, mprod_old, mvend_old, mpedido_old")
SetPrvt("MZZVSTATUS, MZZVDTCANC")


//������������������������������������������Ŀ
//� Vari�veis utilizadas para parametros     �
//� mv_par01             //DATA ATUALIZACAO  �
//��������������������������������������������

CPERG := 'PFT242'
IF !PERGUNTE(CPERG)
	RETURN
ENDIF

lEnd := .F.
Processa({|lEnd| ProcArq(@lEnd)})
Return


Static Function ProcArq()
Private nQTD_ENT    := 0    
PRIVATE MHORA     := TIME()
Private cString   := SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
Private cArqPath  := GetMv("MV_PATHTMP")
Private _cString  := cArqPath+cString+".DBF"
         
DbSelectArea("ZZW")
if RDDName() <> "TOPCONN"
		MsgStop("Este programa somente podera ser executado na versao SQL do SIGA Advanced.")
		Return nil
endif

//Verifica se a Stored Procedure Teste existe no Servidor
If TCSPExist("sp_zzwupdvlr")
	//sp_zzwupdvlr(IN_DATAATUAL VARCHAR2)
	aRet := TCSPExec("sp_zzwupdvlr", dtos(mv_par01))
    
	cQuery := "SELECT zzw_num, zzw_client, zzw_nomecl, zzw_dtatu, zzw_valor, zzw_valoro from ZZW030 WHERE ZZW_FILIAL='" +xFilial("ZZW")+ "' AND ZZW_DTATU='" +DTOS(MV_PAR01)+ "' AND ZZW_DTFIM>='" +DTOS(MV_PAR01)+ "' AND ZZW_STATUS='A' AND D_E_L_E_T_<>'*'"
	TCQUERY cQuery NEW ALIAS "QUERYZZW"
	DbSelectArea("QUERYZZW")
	DBGOTOP()
	cArqPath   :=GetMv("MV_PATHTMP")                    
	cArquivo := cArqPath+"UPDVLRSW.DBF"
	COPY TO &cArquivo VIA "DBFCDXADS" // 20121106 
	DBCloseArea()

	cMsg := "Arquivo gerado: "+ cArquivo
	MSGINFO(cMsg)
EndIf

Return