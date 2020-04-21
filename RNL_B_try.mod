MODULE RNL_B_try


    PROC try(string str,\INOUT bool successFlag)
        IF present(successFlag) successFlag:=FALSE;
        %str%;
        IF present(successFlag) successFlag:=TRUE;

    ERROR
        IF errno=ERR_REFUNKDAT
        OR errno=ERR_REFUNKFUN
        OR errno=ERR_REFUNKPRC
        OR errno=ERR_CALLPROC
        THEN
            SkipWarn;
            RETURN;
        ENDIF
        
        RAISE;
    ENDPROC



ENDMODULEs