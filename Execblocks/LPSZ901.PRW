#INCLUDE "RWMAKE.CH"
User Function LPSZ901()

Local mcta  := ''
Local aArea := GetArea()

cQuery := " SELECT Z9_TIPOOP, Z9_CONTA1 " 
cQuery += " FROM "+RETSQLNAME("SD2")+"  SD2 " 
cQuery += " JOIN "+RETSQLNAME("SC5")+ " SC5 ON SC5.D_E_L_E_T_ != '*' AND SC5.C5_FILIAL = SD2.D2_FILIAL AND SC5.C5_NUM = SD2.D2_PEDIDO "
cQuery += " JOIN "+RETSQLNAME("SZ9")+"  SZ9 ON SZ9.D_E_L_E_T_ != '*' AND SZ9.Z9_FILIAL = ' '  AND SZ9.Z9_TIPOOP = SC5.C5_TIPOOP "
cQuery += " WHERE SD2.D_E_L_E_T_ != '*' "
cQuery += " AND D2_DOC = '"+SF2->F2_DOC+"' AND D2_SERIE = '"+SF2->F2_SERIE+"' "
cQuery += " GROUP BY Z9_TIPOOP, Z9_CONTA1 "

dbUseArea(.T., "TOPCONN", TCGenQry(, , cQuery), "TRB", .F., .T.)


MCTA		:=TRB->Z9_CONTA1
MTIPO		:=TRB->Z9_TIPOOP

TRB->(DBCLOSEAREA())

RestArea(aArea)

Return(MCTA)