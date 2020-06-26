MODULE MainModule

    PROC Main()
        Init;
        WHILE TRUE DO
            StateMachineScan;
            WaitTime 0.2;
        ENDWHILE
    ENDPROC

    PROC Init()
        StateMachineInit;
    ENDPROC

ENDMODULE
