#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
#INCLUDE "TOPCONN.CH"  //consulta SQL
/*/
Danilo C S Pala em 20110223: Nao calcular IR e ISS para o Claudio Mitidieri         
Rodrigo Simoes 20120724: Ocultar desconto ISS linha 326
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: PFAT174    �Autor: DANILO C S PALA       � Data:   20070726 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ƫo: Demonstrativos POR MES de direitos de Publicacao, BASEADO NO RFAT036         � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento                                      � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function PFAT174()

SetPrvt("cCabec1,cCabec2,CSAVTELA,CSAVCURSOR,CSAVCOR,CSAVALIAS,CPERG,MDT")
SetPrvt("M_PAG,MMES,MANO,MMESANO,CTITULO,CPROGRAMA")
SetPrvt("CTAMANHO,cLIMITE,NCARACTER,NLASTKEY,CDESC1,CDESC2")
SetPrvt("CDESC3,ARETURN,CARQ,CINDEX,CKEY,WNREL")
SetPrvt("CSTRING,MAUT,MNOME,MMOEDA,MDOC,MVMIN")
SetPrvt("MVIGPM,MVLBR,MVLLIQ,MVLISS,MQTDE,MTLIQ")
SetPrvt("MTBR,MFLAG,MPROD,L,MVLIRF,XQTDE")
SetPrvt("XLIQ,XBR,MTIT,MTIT1,MTIT2,MTIT3")
SetPrvt("MTIT4, cQuery,mhora")
SetPrvt("_aCampos, _cNome, CINDEX1, CKEY, AUTORANT, MLIVRO, SOMAVALORAUT, SOMAVLVRUTO, SOMAQTD")

//������������������������������������������Ŀ
//� Vari�veis utilizadas para parametros     �
//� mv_par01             //Periodo Inicial   �
//� mv_par02             //Periodo Final     �
//� mv_par03             //Data Pagamento    �
//��������������������������������������������
CPERG := 'PFAT49'
IF !PERGUNTE(CPERG)
	RETURN
ENDIF
MDT       := DDATABASE
M_PAG     := 1
MMES      := MONTH(MV_PAR02)
MANO      := YEAR(MV_PAR02)
MMESANO   := STR(MONTH(MV_PAR02),2)+STR(YEAR(MV_PAR02),4)
cTitulo   := SPACE(04)+"***** DEMONSTRATIVO DE DIREITOS DE PUBLICACAO *****"
cCabec1   := " "
cCabec2   := " "
cPrograma := "PFAT174"
cTamanho  := "M"
cLIMITE    := 132
nCaracter := 12
NLASTKEY  := 0
cDesc1    := PADC("Este programa imprime os demonstrativos",70)
cDesc2    := PADC("de direitos de publicacao",70)
cDesc3    := "  "
aRETURN   := {"Especial", 1,"Administracao", 1, 2, 1," ",1 }
MHORA      := TIME()
WNREL     := "PFAT174_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
CSTRING   := "SA3"
WNREL     := SETPRINT(CSTRING,WNREL,CPERG,cTitulo,cDesc1,cDesc2,cDesc3,.F.)
SETDEFAULT(aRETURN,CSTRING)

//TABELA AUXILIAR PARA TOTALIZACAO POR PRODUTO
_aCampos := {{"MES"  ,"C",7,0} ,;
{"PRODUTO"  ,"C",15,0} ,;
{"LIVRO"    ,"C",40, 0} ,;
{"QTD"      ,"N",6,  0} ,;
{"VALBRUTO" ,"N",12, 2} ,;
{"PERCENT"  ,"N",6,  2} ,;
{"VALAUT"   ,"N",12, 2} ,;
{"MOEDA"   ,"C",1, 0}}
_cNome  := CriaTrab(_aCampos,.t.)
dbUseArea(.T.,, _cNome,"AUXAUT",.F.,.F.)
CINDEX1 := CRIATRAB(NIL,.F.)
CKEY    := "PRODUTO"
INDREGUA("AUXAUT",CINDEX1,CKEY,,,"CRIANDO AUXAUT")

Processa({|| RptDetail()})
Return



/*
//���������Ŀ
//�RELATORIO�
//�����������
*/
Static Function RptDetail()
DbSelectArea("ZZV")
if RDDName() <> "TOPCONN"
		MsgStop("Este programa somente podera ser executado na versao SQL do SIGA Advanced.")
		Return nil
endif

//cQuery := "SELECT zzv_autor, zzv_produt, zzv_moeda, zzv_porc, sum(zzv_valnf - zzv_descon) as val_bruto, sum(zzv_valaut) as soma_pgautor, sum(zzv_qtd) as qtd_livro from ZZV010 WHERE ZZV_FILIAL='" +xFilial("ZZV")+ "' AND ZZV_DTPGAU>='" +DTOS(MV_PAR01)+ "' AND ZZV_DTPGAU<='" +DTOS(MV_PAR02)+ "' AND ZZV_STATUS='3' AND D_E_L_E_T_<>'*' GROUP BY zzv_autor, zzv_produt, zzv_moeda, zzv_porc" //20070525
cQuery := "SELECT zzv_autor, zzv_produt, zzv_moeda, zzv_porc, substr(zzv_emissa,1,6) as mes, sum(zzv_valnf - zzv_descon) as val_bruto, sum(zzv_valaut) as soma_pgautor, sum(zzv_qtd) as qtd_livro from ZZV010 WHERE ZZV_FILIAL='" +xFilial("ZZV")+ "' AND ZZV_DTPGAU>='" +DTOS(MV_PAR01)+ "' AND ZZV_DTPGAU<='" +DTOS(MV_PAR02)+ "' AND ZZV_STATUS='3' AND D_E_L_E_T_<>'*' GROUP BY zzv_autor, zzv_produt, zzv_moeda, zzv_porc, substr(zzv_emissa,1,6) ORDER BY zzv_autor, zzv_produt, zzv_moeda, zzv_porc, substr(zzv_emissa,1,6)"
TCQUERY cQuery NEW ALIAS "QUERYZZV"
DbSelectArea("QUERYZZV")
DBGOTOP()
AUTORANT     := ""
MLIVRO 		 := SPACE(40)
SOMAVALORAUT := 0
SOMAVLVRUTO  := 0
SOMAQTD 	 := 0       
MOEDAANT 	 := SPACE(1)
PROCREGUA(RECCOUNT())
WHILE !EOF()
	INCPROC("Lendo Autor: "+Alltrim(QUERYZZV->ZZV_AUTOR) +": "+ Alltrim(QUERYZZV->ZZV_PRODUT))
	IF AUTORANT <> QUERYZZV->ZZV_AUTOR .AND. AUTORANT <> ""
		IMPRIMIR() //IMPRIME DADOS DO AUTOR E LIVROS, ALEM DE LIMPAR AS VARIAVEIS TOTALIZADORAS
	ENDIF

	DBSELECTAREA("SB1")
	DBSETORDER(01)
	IF DBSEEK(XFILIAL()+QUERYZZV->ZZV_PRODUT)
		MLIVRO := SUBS(SB1->B1_DESC,1,40)
	ELSE
		MLIVRO := SPACE(40)
	ENDIF
	                      
	DBSELECTAREA("AUXAUT")
	RECLOCK("AUXAUT",.T.)
		AUXAUT->MES  	 := substr(QUERYZZV->MES,5,2) +'/'+ substr(QUERYZZV->MES,1,4)
		AUXAUT->PRODUTO  := QUERYZZV->ZZV_PRODUT
		AUXAUT->LIVRO    := MLIVRO
		AUXAUT->QTD      := QUERYZZV->QTD_LIVRO
		AUXAUT->VALBRUTO := QUERYZZV->VAL_BRUTO
		AUXAUT->PERCENT  := QUERYZZV->ZZV_PORC
		AUXAUT->VALAUT   := QUERYZZV->SOMA_PGAUTOR
		AUXAUT->MOEDA    := QUERYZZV->ZZV_MOEDA
	MsUnlock()   

	SOMAVALORAUT := SOMAVALORAUT + QUERYZZV->SOMA_PGAUTOR
	SOMAVLVRUTO  := SOMAVLVRUTO + QUERYZZV->VAL_BRUTO
	SOMAQTD 	 := SOMAQTD + QUERYZZV->QTD_LIVRO

	MOEDAANT := QUERYZZV->ZZV_MOEDA
	AUTORANT := QUERYZZV->ZZV_AUTOR
		
	DBSELECTAREA("QUERYZZV")
	DBSKIP()
END               
IMPRIMIR() //imprime o ultimo autor

SET DEVI TO SCREEN
IF aRETURN[5] ==1
	SET PRINTER TO
	DBCOMMITALL()
	OURSPOOL(WNREL)
ENDIF
MS_FLUSH()
DBSELECTAREA("QUERYZZV")
DBCLOSEAREA()
DBSELECTAREA("SA3")
RETINDEX("SA3")
DBSELECTAREA("SB1")
RETINDEX("SB1")     
DBSELECTAREA("AUXAUT")
DBCLOSEAREA()
RETURN


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFAT174   �Autor  �Microsiga           � Data �  11/09/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � IMPRIMIR                                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static FUNCTION IMPRIMIR()
L := Cabec(cTitulo,cCabec1,cCabec2,cPrograma,cTamanho)
//@ 00,00 PSAY AVALIMP(cLIMITE)
//@ 01,01 PSAY REPLICATE('-',(cLIMITE-1))

DBSELECTAREA("SA3")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SA3")+AUTORANT)
	MNOME  := SA3->A3_NOME
	MDOC   := SA3->A3_TIPODOC
	MFLAG  := 'P'
	if MOEDAANT == "D"
		MMOEDA := "R$"
	else
		MMOEDA := "R$"
	endif

	MVLBR  := SOMAVALORAUT      
	MVLIRF := 0
	MVLISS := 0 
	IRFISS() //CALCULA O MVLIRF e o MVLISS
	MVLLIQ := (MVLBR - MVLIRF - MVLISS)

//	@ 02,33 PSAY "DEMONSTRATIVO"
	MTIT  := "DEMONSTRATIVO DE PAGAMENTOS"
	MTIT1 := " "
	MTIT2 := SPACE(28) + "DEMONSTRATIVO DE VENDAS"
	MTIT3 := " "
	IF MFLAG == 'P'
		MTIT4 := " "
	ELSE
		MTIT4 := SPACE(36) + "ANEXO"
	ENDIF
	@ L,01 PSAY REPLICATE('-',cLIMITE)
	L := L+2
	@ L,32 PSAY "DADOS DO AUTOR"
	L := L+2
	@ L,01 PSAY "CODIGO/NOME: " + SA3->A3_COD + ' / ' + MNOME
	L++
	@ L,01 PSAY REPLICATE('-',cLIMITE)
	L := L+2
	@ L,26 PSAY MTIT
	L++
	@ L,01 PSAY "VALOR BRUTO .....: " + MMOEDA
	@ L,23 PSAY MVLBR  PICTURE "@E 999,999.99"
	L++
	@ L,01 PSAY "DESCONTOS:"
	L++
	@ L,01 PSAY "IMPOSTO DE RENDA : " + MMOEDA
	@ L,23 PSAY MVLIRF PICTURE "@E 999,999.99"
	L++
	@ L,01 PSAY "I.S.S ...........: " + MMOEDA
	@ L,23 PSAY MVLISS PICTURE "@E 999,999.99"
	@ L,60 PSAY (MVLIRF+MVLISS) PICTURE "@E 999,999.99"
	L++
	@ L,01 PSAY "VALOR LIQUIDO ...: " + MMOEDA
	@ L,23 PSAY MVLLIQ PICTURE "@E 999,999.99"
	L++
	@ L,01 PSAY "DATA PAGAMENTO ..: " + DTOC(MV_PAR03)
	L++                               
	@ L,01 PSAY REPLICATE('-',cLIMITE)
	L := L+2
	@ L,01 PSAY MTIT2
	L++
	@ L,01 PSAY MTIT3+MTIT4
	L++                               
	@ L,01 PSAY REPLICATE('-',cLIMITE)
	IF MFLAG == 'P'
		@ L,01 PSAY "MES FAT"
		@ L,10 PSAY "CODIGO"
		@ L,20 PSAY "LIVRO"
		@ L,62 PSAY "QTDE"
		@ L,68 PSAY "VL. VENDAS"
		@ L,79 PSAY "DIR PUBL."
		@ L,89 PSAY "DIR PUBLIC."
		L++
		@ L,61 PSAY "VENDID"
		@ L,69 PSAY "LIQUIDO"
		@ L,80 PSAY "PERCENT"
		@ L,91 PSAY "BRUTO"
		L++
		@ L,01 PSAY REPLICATE('-',8) +' '+REPLICATE('-',9)+' '+REPLICATE('-',40)+' '+REPLICATE('-',6) +' '+ REPLICATE('-',10)+' '+REPLICATE('-',9)+' '+REPLICATE('-',11)
	ENDIF
ENDIF
L := L+2

//LOOP NA TABELA AUXILIAR
DBSELECTAREA("AUXAUT")
DBGOTOP()
WHILE !EOF()                        
	IF L==0 .OR. L>55
		If L <> 0
			Roda(0,"",ctamanho)
		EndIf
		L := Cabec(cTitulo,cCabec1,cCabec2,cPrograma,cTamanho)
		L += 2
	ENDIF
	@ L,01 PSAY AUXAUT->MES
	@ L,11 PSAY SUBS(AUXAUT->PRODUTO,1,8)
	@ L,20 PSAY SUBS(AUXAUT->LIVRO,1,40)			
	@ L,61 PSAY AUXAUT->QTD     PICTURE "@E 999999"
	@ L,68 PSAY AUXAUT->VALBRUTO PICTURE "@E 999,999.99"
	@ L,80 PSAY AUXAUT->PERCENT  PICTURE "@E 999.99"
	@ L,89 PSAY AUXAUT->VALAUT   PICTURE "@E 999,999.99"
	L := L+2                                     
	RecLock("AUXAUT",.F.)
		DELETE
    MSUnlock()
	DBSKIP()
END
@ L,01 PSAY "TOTAIS .............................: "
@ L,61 PSAY SOMAQTD PICTURE "@E 999999"
@ L,68 PSAY SOMAVLVRUTO PICTURE "@E 999,999.99"
@ L,89 PSAY SOMAVALORAUT  PICTURE "@E 999,999.99"
Roda(0,"",ctamanho)

//LIMPAR VARIAVEIS E TABELA AUXILIAR
DBSELECTAREA("AUXAUT")
//zap()
SOMAVALORAUT := 0
SOMAVLVRUTO  := 0
SOMAQTD 	 := 0
RETURN



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IRFISS () �Autor  �DANILO C S PALA     � Data �  20061109   ���
�������������������������������������������������������������������������͹��
���Desc.     �Processa IRF e ISS do Autor                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static FUNCTION IRFISS()
	DBSELECTAREA("SZZ") //tabela com percentuais do IRF
	DBGOTOP()
	IF SA3->A3_COD == "004026" //MITIDIERI 20110223
		MVLISS := 0
		MVLIRF := 0
	ELSE
		IF SA3->A3_PESSOA == "F"
			WHILE !EOF()
				//MVLISS := (MVLBR * 5/100)  //20120724
				IF MVLBR >= SZZ->ZZ_VALORI .AND. MVLBR <= SZZ->ZZ_VALORF
					MVLIRF := ((MVLBR * (SZZ->ZZ_ALIQ/100)) - SZZ->ZZ_DEDUCAO)
				ENDIF
				DBSELECTAREA("SZZ")
				DBSKIP()
			END
		ENDIF
		IF MVLIRF < 10
			MVLIRF := 0
		ENDIF
	ENDIF
RETURN