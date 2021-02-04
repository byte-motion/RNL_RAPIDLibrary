MODULE FestoControlMod(NOSTEPIN)

    CONST num nMaxWaitTime:=10;
    VAR intnum intDisableFesto;

    PROC MoveFesto(num Point,num Speed,\switch NoWait,\switch NoStart)
        VAR num Retries:=3;
        EnableFesto;
        SetGO goFestoUnit_VelSet,Speed;
        SetGO goFestoUnit_PositionSet,Point;
        IF NOT Present(NoStart) PulseDO\High\PLength:=0.1,doFestoUnit_9_Start;
        IF Present(NoWait) RETURN ;
        WaitUntil giFestoUnit_Position=Point\MaxTime:=nMaxWaitTime;
    ERROR
        RAISE ;
    ENDPROC

    FUNC bool SearchFesto(VAR signaldi Signal,INOUT num SearchPoint,num Point,num Speed,\switch NoRegain,\switch NoWait)
        IF Signal=1 RETURN FALSE;
        MoveFesto Point,Speed\NoWait;
        WaitUntil Signal=1 OR giFestoUnit_Position=Point\MaxTime:=60\PollRate:=0.1;
        IF giFestoUnit_Position=Point RETURN FALSE;
        SearchPoint:=giFestoUnit_Position;
        StopFesto;
        IF NOT Present(NoRegain) MoveFesto SearchPoint,150;
        RETURN TRUE;
    ERROR
        RAISE ;
    ENDFUNC

    PROC StopFesto()
        ! Stopper Festo controller, men beholder Enable
        SetDO doFestoUnit_1_Stop,0;
        WaitUntil diFestoUnit_12_Move<>1;
        SetDO doFestoUnit_1_Stop,1;
    ERROR
        RAISE ;
    ENDPROC

    PROC EnableFesto()
        ! Start Interrupt for turning off servo, 1min should be enough.
        IDelete intDisableFesto;
        CONNECT intDisableFesto WITH tDisableFesto;
        ITimer\SingleSafe,60,intDisableFesto;
        !
        IF diFestoUnit_0_Enabled=1 AND
            diFestoUnit_6_OpMode1=1 AND
            diFestoUnit_8_Halt=1 AND
            doFestoUnit_1_Stop=1 RETURN ;
        !
        DisableFesto;
        WaitTime 0.1;
        ! Drive Enable
        SetDO doFestoUnit_0_Enable,1;
        ! Stop (Invertert stopper når 0)
        SetDO doFestoUnit_1_Stop,1;
        ! Operating mode Out 6 høy for å kjøre etter posisjon
        SetDO doFestoUnit_6_OPM1,1;
        ! Halt (Invertert 0 stopper motorens kjøring)
        SetDO doFestoUnit_8_Halt,1;
        WaitTime 0.1;
        ! Puls reset
        PulseDO\High\PLength:=0.1,doFestoUnit_3_Reset;
        WaitTime 0.1;
        WaitUntil doFestoUnit_3_Reset=0\MaxTime:=nMaxWaitTime;
    ERROR
        RAISE ;
    ENDPROC

    TRAP tDisableFesto
        IDelete intDisableFesto;
        DisableFesto;
    ENDTRAP

    PROC DisableFesto()
        SetDO doFestoUnit_0_Enable,0;
        SetDO doFestoUnit_1_Stop,0;
        SetDO doFestoUnit_6_OPM1,0;
        SetDO doFestoUnit_8_Halt,0;
    ENDPROC

ENDMODULE
