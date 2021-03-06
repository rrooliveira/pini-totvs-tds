/*BEGINDOC
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿐xemplo de relatorio usando tReport com uma Section
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
ENDDOC*/

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿐PFATR01  튍utor  쿟hiago Lima Dyonisio� Data �  11/13/13   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     � Relat�rio de Anunciantes Ativos                            볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � Editora PINI                                               볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

user function EPFATR01()

local oReport
local cPerg  := 'ANUNATIVOS'
local cAlias := getNextAlias()

criaSx1(cPerg)
Pergunte(cPerg, .F.)

oReport := reportDef(cAlias, cPerg)

oReport:printDialog()

return  
          
//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relat�rio.                                  !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport,cAlias)
                 
local oSecao1 := oReport:Section(1)

oSecao1:BeginQuery()

BeginSQL Alias cAlias
	
	SELECT  DISTINCT A1_COD, A1_NOME, A1_NREDUZ, A1_CGC 
	FROM %Table:SA1% SA1
	
	INNER JOIN %Table:SZS% SZS
 	ON ZS_CODCLI = A1_COD
	AND SZS.%NotDel%

	WHERE ZS_DTCIRC >= %Exp:MV_PAR01% 
	
	ORDER BY A1_COD//%Exp:cOrdem%   
	
EndSQL 

oSecao1:EndQuery()  

oReport:SetMeter((cAlias)->(RecCount()))  

oSecao1:Print()	   

return

//+-----------------------------------------------------------------------------------------------+
//! Fun豫o para cria豫o da estrutura do relat�rio.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)

local cTitle  := "Relat�rio de Anunciantes Ativos"
local cHelp   := "Permite gerar relat�rio de anunciantes ativos."

local oReport
local oSection1

oReport	:= TReport():New('ANUNCIANTES',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)

//Primeira se豫o
oSection1 := TRSection():New(oReport,"Rela豫o de Anunciantes Ativos",{"SA1"})    

TRCell():New(oSection1,"A1_COD"		, "SA1", "Codigo"		)
TRCell():New(oSection1,"A1_NOME"	, "SA1", "Nome"			)   
TRCell():New(oSection1,"A1_NREDUZ"	, "SA1", "Nome Fantasia")   
TRCell():New(oSection1,"A1_CGC"		, "SA1", "CNPJ / CPF"	)   

Return(oReport)

//+-----------------------------------------------------------------------------------------------+
//! Fun豫o para cria豫o das perguntas (se n�o existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Data de corte'          , '', '', 'mv_ch1', 'D',08, 0, 0, 'G', '', '', '', '', 'mv_par01')

return    
