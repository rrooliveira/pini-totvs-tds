#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function rfatr19()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CPERG,CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO")
SetPrvt("ARETURN,NOMEPROG,LIMITE,ALINHA,NLASTKEY,NLIN")
SetPrvt("TITULO,CCABEC1,CCABEC2,CCANCEL,M_PAG,WNREL")
SetPrvt("_CIND,_CKEY,_CFILTRO,_MVEND,_MTOT,_MTOTG")
SetPrvt("_MNOTA,_CALIAS,_NINDEX,_NREG,AREGS,I")
SetPrvt("J,mhora")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/02/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴커 굇
굇쿛rograma: RFATR19   쿌utor: Rosane Rodrigues       � Data:   03/02/00 � 굇
굇쳐컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴캑 굇
굇쿏escri놹o: RELATORIO DE N.F POR VENDEDOR                              � 굇
굇쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑 굇
굇쿢so      : M줰ulo de Faturamento de Publicidade                       � 굇
굇읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸 굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//�   Parametros Utilizados                   �
//�   mv_par01 = Vendedor Inicial             �
//�   mv_par02 = Vendedor Final               �
//�   mv_par03 = Data Inicial                 �
//�   mv_par04 = Data Final                   �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

cPerg    := "PFAT18"
ValidPerg()
If !Pergunte(CPERG)
   Return
EndIf
cString  := "SE1"
cDesc1   := PADC("Este programa emite o relat줿io das N.F. por Vendedor",70)
cDesc2   := PADC("com emiss�o no per죓do solicitado.",70)
cDesc3   := " "
tamanho  := "M"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog := "RFATR19"
limite   := 80
aLinha   := { }
nLastKey := 0
nLin     := 80
titulo   := "N.F. por Vendedor/Emiss�o"
cCabec1  := "Vendedor Inicial : " + MV_PAR01 + SPACE(10) + "Vendedor Final : " + MV_PAR02 + SPACE(10) +;
            "Emiss�o Inicial : " + DTOC(MV_PAR03) + SPACE(10) + "Emiss�o Final : " + DTOC(MV_PAR04)
cCabec2  := " " 
cCancel  := "***** CANCELADO PELO OPERADOR *****"
m_pag    := 1               //Variavel que acumula numero da pagina
MHORA := TIME()
wnrel    := "RFATR19_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)       //Nome Default do relatorio em Disco
wnrel    := SetPrint(cString,wnrel,cPerg,space(20)+titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

SetDefault(aReturn,cString)

IF NLASTKEY==27 .OR. NLASTKEY==65
   RETURN
ENDIF

// 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
// 쿎hama Relatorio                                �
// 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
#IFDEF WINDOWS
   RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==>    RptStatus({|| Execute(RptDetail) })
#ELSE
   RptDetail()
#ENDIF
Return
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿝ptDetail � Autor � Ary Medeiros          � Data � 15.02.96 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿔mpressao do corpo do relatorio                             낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function RptDetail
Static Function RptDetail()

dbSelectArea("SE1")
_cInd   := CriaTrab(NIL,.F.)
_cKey   := "E1_FILIAL+E1_VEND1+DTOS(E1_EMISSAO)+E1_NUM+E1_PARCELA"
_cFiltro := "E1_FILIAL == '"+xFilial("SE1")+"'"
_cFiltro := _cFiltro+".and.DTOS(E1_EMISSAO)>=DTOS(CTOD('"+DTOC(MV_PAR03)+"'))"
_cFiltro := _cFiltro+".and.DTOS(E1_EMISSAO)<=DTOS(CTOD('"+DTOC(MV_PAR04)+"'))"
IndRegua("SE1",_cInd,_cKey,,_cFiltro,"Selecionando registros .. ")

SetRegua(Reccount()/7)
dbSeek(xFilial("SE1")+MV_PAR01,.T.)

_mvend := ' '
_mtot  := 0
_mtotg := 0

While !eof()
    IncRegua()

    If !"P" $ SE1->E1_PEDIDO .OR. SE1->E1_VEND1 > MV_PAR02
        dbSkip()
        Loop
    EndIf

    If 'CAN' $(SE1->E1_MOTIVO) .OR. 'DEV' $(SE1->E1_MOTIVO) .OR.;
       'CANC' $(SE1->E1_HIST)
        dbSkip()
        Loop
    EndIf

    _mnota := SE1->E1_NUM

    if nLin > 60
       nLin     := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,18) //IIF(aReturn[4]==1,15,18) ) //Impressao do cabecalho
       nLin     := nLin + 2
                    //           1         2         3         4         5         6         7         8         9        10        11        12        13
                    // 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
       @ nlin,00 PSAY "Vendedor  Nome do Vendedor                          A.V.    N.F.    Val.N.Fiscal  Dt.Emissao  Num.Duplic.  Val.Duplic.  Dt.Vencto"
       nLin     := nLin + 1
       @ nlin,00 PSAY "--------  ----------------------------------------  ------  ------  ------------  ----------  -----------  -----------  ---------"
       nLin     := nLin + 1                                                                  
    Endif

    If _mvend <> ' ' .and. _mvend <> SE1->E1_VEND1
       nLin     := nLin + 2                                                                  
       @ nlin,000 PSAY "Total do Vendedor ........................................: "
       @ nlin,105 PSAY _mtot PICTURE "@E 9,999,999.99"
       nlin  := nlin + 2
       @ nlin,000 PSAY REPLICATE ("-",132)
       nlin  := nlin + 1
       _mtot := 0
    Endif

    Do While _mnota == SE1->E1_NUM
       if nLin > 60
          nLin     := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,18) //IIF(aReturn[4]==1,15,18) ) //Impressao do cabecalho
          nLin     := nLin + 2
                       //           1         2         3         4         5         6         7         8         9        10        11        12        13
                       // 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
          @ nlin,00 PSAY "Vendedor  Nome do Vendedor                          A.V.    N.F.    Val.N.Fiscal  Dt.Emissao  Num.Duplic.  Val.Duplic.  Dt.Vencto"
          nLin     := nLin + 1
          @ nlin,00 PSAY "--------  ----------------------------------------  ------  ------  ------------  ----------  -----------  -----------  ---------"
          nLin     := nLin + 1                                                                  
       Endif
       nLin := nLin + 1
       If SE1->E1_PARCELA == 'A' .OR. SE1->E1_PARCELA == ' '
          dbSelectArea("SF2")
          dbSetOrder(1)
          dbSeek(xFilial("SF2")+SE1->E1_NUM+SE1->E1_SERIE+SE1->E1_CLIENTE+SE1->E1_LOJA,.F.)
          @ nlin,001 PSAY SE1->E1_VEND1
          dbSelectArea("SA3")
          dbSetOrder(1)
          dbSeek(xFilial("SA3")+SE1->E1_VEND1)
          @ nlin,010 PSAY SA3->A3_NOME
          @ nlin,052 PSAY SE1->E1_PEDIDO
          @ nlin,060 PSAY SF2->F2_DOC
          @ nlin,070 PSAY (SF2->F2_VALBRUT-SF2->F2_DESCONT) PICTURE "@E 999,999.99"
          @ nlin,083 PSAY SF2->F2_EMISSAO
       Endif
       @ nlin,095 PSAY SE1->E1_NUM+' '+SE1->E1_PARCELA
       @ nlin,107 PSAY SE1->E1_VALOR PICTURE "@E 999,999.99"
       @ nlin,120 PSAY SE1->E1_VENCTO
       _mnota := SE1->E1_NUM
       _mvend := SE1->E1_VEND1
       _mtot  := _mtot + SE1->E1_VALOR
       _mtotg := _mtotg + SE1->E1_VALOR
       DbSelectArea("SE1")
       DbSkip()
    Enddo
End

If _mtot <> 0 
   nLin     := nLin + 2
   @ nlin,000 PSAY "Total do Vendedor ........................................: "
   @ nlin,105 PSAY _mtot PICTURE "@E 9,999,999.99"
   nLin     := nLin + 3
   @ nlin,000 PSAY "Total Geral ..............................................: "
   @ nlin,105 PSAY _mtotg PICTURE "@E 9,999,999.99"
Else
   Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,18)
   @ 15, 00 PSAY "NAO HA DADOS A APRESENTAR !!! "
Endif

dbSelectarea("SE1")
RetIndex("SE1")
// Apaga Indice SE1
fErase(_cInd+OrdBagExt())

Set Device to Screen
If aReturn[5] == 1
    Set Printer To
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return


/*/
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
귿컴컴컴컴컴쩡컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴커�
교Funcao    쿣ALIDPERG� Autor � Jose Renato July � Data � 25.01.99 낢
궁컴컴컴컴컴탠컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴캑�
교Descricao � Verifica perguntas, incluindo-as caso nao existam.   낢
궁컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑�
교Uso       � SX1                                                  낢
궁컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑�
교Release   � 3.0i - Roger Cangianeli - 12/05/99.                  낢
굼컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function VALIDPERG
Static Function VALIDPERG()

_cAlias := Alias()
_nIndex := IndexOrd()
_nReg   := Recno()


   cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
   aRegs    := {}
   dbSelectArea("SX1")
   dbSetOrder(1)
   AADD(aRegs,{cPerg,"01","Vendedor Inicial : ","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"02","Vendedor Final ..: ","mv_ch2","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"03","Data Inicial ....: ","mv_ch3","D",8,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"04","Data Final ......: ","mv_ch4","D",8,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
   For i := 1 to Len(aRegs)
      If !dbSeek(cPerg+aRegs[i,2])
         RecLock("SX1",.T.)
         For j := 1 to FCount()
            If j <= Len(aRegs[i])
               FieldPut(j,aRegs[i,j])
            Endif
         Next
         MsUnlock()
      Endif
   Next

dbSelectArea(_cAlias)
dbSetOrder(_nIndex)
dbGoTo(_nReg)

Return
