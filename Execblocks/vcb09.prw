User Function Vcb09()

IF !EMPTY(SE1->E1_NUMBCO)
        NUMBCO:=SUBSTR(SE1->E1_NUMBCO,1,11)
ELSE
        NUMBCO:=STRZERO(0,10)
ENDIF

RETURN(NUMBCO)