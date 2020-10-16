MODULE RNL_B_unixTime
    
    !unixTime is the number of seconds since 1970/01/01 00:00:00 UTC.
    !Every day consists of exactly 86400 seconds.
    !Based on SSLibTimestamp
    
    !Dependencies
    ! - None
    
    ALIAS dnum unixTime;
    
    VAR unixTime unixTime_NULL;
    
    FUNC unixTime unixTime_getCurrent()
        RETURN unixTime_NULL; 
    ENDFUNC
    
    FUNC unixTime unixTime_fromDate(string stDate)

    ENDFUNC

    
    
ENDMODULE