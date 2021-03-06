#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: RELAUT    �Autor: Rosane Rodrigues       � Data:   17/02/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: RELATORIO DE CANCELAMENTO DE AV - AUTOMATICO               � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento de Publicidade                       � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Relaut()        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02

SetPrvt("CPARAMETRO,CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO")
SetPrvt("ARETURN,NOMEPROG,LIMITE,ALINHA,NLASTKEY,NLIN")
SetPrvt("TITULO,CCABEC1,CCABEC2,CCANCEL,M_PAG,WNREL")
SetPrvt("_MVALOR,_MSUBT,_MCONT,_MAV,_MEDINIC,_MEDFIM")
SetPrvt("_MNUMINSI,_MNUMINSF,_MVEND,_MCODCLI,_MCODPROD,_MDTINIC")
SetPrvt("_MDTFIM,_MNOMECLI,_MNOMEAG,_MCODAG,_MNOMEVEND,_MITEM, mhora")
//�������������������������������������������Ŀ
//�   Parametros Utilizados                   �
//�   mv_par01 = N. AV                        �
//���������������������������������������������
cParametro := PARAMIXB
cString    := "SZS"
cDesc1     := PADC("Este programa emite o relat�rio de cancelamento de AVs",70)
cDesc2     := " "
cDesc3     := " "
tamanho    := "M"
aReturn    := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog   := "RELAUT"
limite     := 80
aLinha     := { }
nLastKey   := 0

nLin       := 80
titulo     := "AVs Canceladas"
cCabec1    := " "
cCabec2    := " " 
cCancel    := "***** CANCELADO PELO OPERADOR *****"
m_pag      := 1      //Variavel que acumula numero da pagina
lAbortPrint := .F.
MHORA      := TIME()
wnrel      := "RELAUT_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)            //Nome Default do relatorio em Disco
wnrel      := SetPrint(cString,wnrel,cPerg,space(30)+titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

SetDefault(aReturn,cString)

IF NLASTKEY==27 .OR. NLASTKEY==65
   RETURN
ENDIF

// �����������������������������������������������Ŀ
// �Chama Relatorio                                �
// �������������������������������������������������
Processa({|| RptDetail() })

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �RptDetail � Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Impressao do corpo do relatorio                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RptDetail()

dbSelectArea("SZS")
dbSetOrder(1)
dbSeek(xFilial("SZS")+MV_PAR01+MV_PAR03,.T.)
ProcRegua(Reccount())

_mValor   := 0
_mSubt    := 0
_mCont    := 0
_mAv      := ' '
_mEdinic  := 0
_mEdfim   := 0
_mNuminsi := 0
_mNuminsf := 0
_mVend    := ' '
_mCodcli  := ' '
_mCodprod := ' '
_mDtinic  := ' '
_mDtfim   := ' '

While !eof() .and. SZS->ZS_FILIAL == xFilial("SZS") .and. SZS->ZS_NUMAV == MV_PAR01 .AND. SZS->ZS_ITEM == MV_PAR03

   IncProc("Lendo AV" + Alltrim(SZS->SZ_NUMAV))

   IF SZS->ZS_SITUAC <> 'CC'
      DBSKIP()
      LOOP
   ENDIF

   _mNomecli  := ' '
   _mNomeag   := ' '
   _mCodag    := ' '
   _mNomevend := ' '

   DbSelectArea("SA3")
   DbSetOrder(1)
   DbSeek(xFilial("SA3")+SZS->ZS_VEND)
   _mNomevend := SA3->A3_NOME

   DbSelectArea("SA1")
   DbSetOrder(1)
   DbSeek(xFilial("SA1")+SZS->ZS_CODCLI)
   If found()
      _mNomecli := SA1->A1_NOME
   Endif
   DbSelectArea("SC5")
   DbSetOrder(1)
   DbSeek(xFilial("SC5")+SZS->ZS_NUMAV)
   _mCodag := SC5->C5_CODAG
   DbSelectArea("SA1")
   DbSetOrder(1)
   If DbSeek(xFilial("SA1")+_mCodag)
      _mNomeag := SA1->A1_NOME
   Endif

   if _mCont == 0
      _mEdinic := SZS->ZS_EDICAO
      _mNuminsi:= SZS->ZS_NUMINS
      _mEdfim  := SZS->ZS_EDICAO
      _mNuminsf:= SZS->ZS_NUMINS
      _mDtinic := SZS->ZS_DTCIRC 
      _mDtfim  := SZS->ZS_DTCIRC 
   Else
      _mEdfim  := SZS->ZS_EDICAO
      _mNuminsf:= SZS->ZS_NUMINS
      _mDtfim  := SZS->ZS_DTCIRC 
   Endif

   _mValor   := _mValor + SZS->ZS_VALOR
   _mSubt    := SZS->ZS_VALOR
   _mCont    := _mCont + 1
   _mItem    := SZS->ZS_ITEM
   _mAv      := SZS->ZS_NUMAV
   _mVend    := SZS->ZS_VEND
   _mCodcli  := SZS->ZS_CODCLI
   _mCodprod := SZS->ZS_CODPROD

   DbSelectArea("SZS")
   DbSkip()
End

If _mValor <> 0
   imp()
   nlin := nlin + 2
   @ nlin,000 PSAY "Total Geral ............................................: "
   @ nlin,059 PSAY _mValor PICTURE "@E 9,999,999.99"
Else
   @ nlin,000 PSAY "NAO HA DADOS A APRESENTAR"
Endif

dbSelectArea("SZS")
RetIndex("SZS")

// Roda(0,"",tamanho)
Set Filter To
Set Device to Screen
If aReturn[5] == 1
        Set Printer To
        Commit
        ourspool(wnrel) //Chamada do Spool de Impressao
Endif

MS_FLUSH()

Return

Static Function Imp()

   If nLin > 60
      cCabec1 := "Vendedor : " + _mVend + "   " + _mNomevend
      cCabec2 := " " 
      nLin := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,18) //Impressao do cabecalho
      nLin := nLin + 2

//                    0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//                              1         2         3         4         5         6         7         8         9        10        11        12        13
      @ nlin,0  PSAY "Cliente   Nome do Cliente                       CodAgen   Agencia                              CodProd    Produto                    "
      nLin := nLin + 1
      @ nlin,0  PSAY "Num.Av/It   Inser��o      Edi��o          Dt.Circ.              Valor Inser��o"                          
      nLin := nLin + 1
      @ nlin,0  PSAY "===================================================================================================================================="
      nlin := nLin + 1
   Endif
   nLin += 3
   @ nlin,000 PSAY _mCodcli
   @ nlin,010 PSAY SUBSTR(_mNomecli,1,35)
   @ nlin,048 PSAY _mCodag
   @ nlin,058 PSAY SUBSTR(_mNomeag,1,34)
   @ nlin,095 PSAY SUBSTR(_mCodprod,1,8)
   DbSelectArea("SB1")
   DbSetOrder(01)
   DbSeek(xFilial("SB1")+_mCodprod)
   @ nlin,106 PSAY SUBSTR(SB1->B1_DESC,1,30)
   nlin := nLin + 2
   @ nlin,000 PSAY _mAv+'/'+_mItem
   @ nlin,012 PSAY STR(_mNuminsi,2) + ' A ' + STR(_mNuminsf,2)
   @ nlin,023 PSAY STR(_mEdinic,4) + ' A ' + STR(_mEdfim,4)
   @ nlin,037 PSAY DTOC(_mDtinic) + ' A ' + DTOC(_mDtfim)
   @ nlin,061 PSAY _mSubt PICTURE "@E 999,999.99"
   nlin := nLin + 2

Return