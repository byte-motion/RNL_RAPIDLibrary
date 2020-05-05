MODULE RNL_E_ScanManager

    LOCAL VAR dnum scanCycle:=1;
    LOCAL VAR num scanDeltaTime:=1;
    LOCAL VAR clock deltaClock;

    PROC RN_Library_Scan()
        
        VAR bool success;
        
        ClkReset deltaClock;
        ClkStart deltaClock;
        
        WaitUntil main_getCycle() > 1;
        

        !Execute scan routines

        Incr scanCycle;
        IF scanCycle >= 4503599627370495 scanCycle := 2;
        !log cycle time
    ENDPROC
    
    FUNC bool scan_firstCycle()
        RETURN scanCycle<=1;
    ENDFUNC

    FUNC dnum scan_getCycle()
        RETURN scanCycle;
    ENDFUNC
    
    FUNC num scan_getDeltaTime()
        RETURN scanDeltaTime;
    ENDFUNC


ENDMODULE