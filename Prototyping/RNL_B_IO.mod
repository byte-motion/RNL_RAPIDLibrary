MODULE RNL_B_IO

    PROC setDO_fromString(string IOName)
        %"SetDO "+IOName+",1"%;

    ERROR
        RAISE ERR_IOSTRINGFAILURE;
    ENDPROC

    PROC resetDO_fromString(string IOName,num state)
        %"SetDO "+IOName+",0"%;

    ERROR
        RAISE ERR_IOSTRINGFAILURE;
    ENDPROC

    PROC writeDO_fromString(string IOName,num state)
        %"SetDO "+IOName+",state"%;

    ERROR
        RAISE ERR_IOSTRINGFAILURE;
    ENDPROC

    FUNC num readDO_fromString(string IOName)
        %"RETURN DOutput("+IOName+")"%;

    ERROR
        RAISE ERR_IOSTRINGFAILURE;
    ENDFUNC

    FUNC num readDI_fromString(string IOName)
        %"RETURN "+IOName%;

    ERROR
        RAISE ERR_IOSTRINGFAILURE;
    ENDFUNC



ENDMODULE