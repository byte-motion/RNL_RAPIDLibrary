MODULE RNL_B_try


    PROC try(string str,\INOUT bool successFlag)
        IF present(successFlag) successFlag:=FALSE;
        %str%;
        IF present(successFlag) successFlag:=TRUE;

    ERROR
        IF errno=ERR_REFUNKDATMODULE RNL_E_MainManager

    LOCAL VAR dnum mainCycle:=1;
    LOCAL VAR num mainDeltaTime:=1;

    PROC RN_Library_Main()

        VAR bool success;
        VAR clock deltaClock;

        !Initializing
        IF main_firstCycle() THEN

            ClkReset deltaClock;
            ClkStart deltaClock;

            try "config";
            !
            try "init";
            
            !log init time
        ENDIF

        !Execute main if defined. 
        mainDeltaTime := ClkRead(deltaClock);
        try "main" \successFlag:=success;
        
        Incr mainCycle;
        IF mainCycle >= 4503599627370495 mainCycle := 2;
        
        !log cycle time - To be implemented
        
        ClkReset deltaClock;
        ClkStart deltaClock;
    ENDPROC
    
    FUNC bool main_firstCycle()
        RETURN mainCycle<=1;
    ENDFUNC

    FUNC dnum main_getCycle()
        RETURN mainCycle;
    ENDFUNC
    
    FUNC num main_getDeltaTime()
        RETURN mainDeltaTime;
    ENDFUNC


ENDMODULE
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