MODULE FestoControlMod(NOSTEPIN)

    ! Configuration

    ! -Name "FestoUnit" -VendorName "Festo AG & Co. KG" -ProductName "CMMP-AS-C2-3A-M3" -Label "CMMP-AS-C2-3A-M3 - FHPP Data, In/Out" -Address "192.168.124.20"\
    ! -VendorId 26 -ProductCode 20512 -DeviceType 43 -OutputAssembly 100 -InputAssembly 101 -ConfigurationAssembly 1 -ConnectionPriority "SCHEDULE" -InputSize 12

    ! -Name "diFestoUnit_0_Enabled" -SignalType "DI" -Device "FestoUnit" -DeviceMap "32" -Category "ServoDrive" -Access "All"
    ! -Name "diFestoUnit_1_OpEnabeled" -SignalType "DI" -Device "FestoUnit" -DeviceMap "33" -Category "ServoDrive" -Access "All"
    ! -Name "diFestoUnit_2_Warning" -SignalType "DI" -Device "FestoUnit" -DeviceMap "34" -Category "ServoDrive" -Access "All"
    ! -Name "diFestoUnit_3_Fault" -SignalType "DI" -Device "FestoUnit" -DeviceMap "35" -Category "ServoDrive" -Access "All"
    ! -Name "diFestoUnit_4_SVA" -SignalType "DI" -Device "FestoUnit" -DeviceMap "36" -Category "ServoDrive" -Access "All"
    ! -Name "diFestoUnit_6_OpMode1" -SignalType "DI" -Device "FestoUnit" -DeviceMap "38" -Category "ServoDrive" -Access "All"
    ! -Name "diFestoUnit_7_OpMode2" -SignalType "DI" -Device "FestoUnit" -DeviceMap "39" -Category "ServoDrive" -Access "All"
    ! -Name "diFestoUnit_8_Halt" -SignalType "DI" -Device "FestoUnit" -DeviceMap "40" -Category "ServoDrive" -Access "All"
    ! -Name "diFestoUnit_9_Ack" -SignalType "DI" -Device "FestoUnit" -DeviceMap "41" -Category "ServoDrive" -Access "All"
    ! -Name "diFestoUnit_10_MC" -SignalType "DI" -Device "FestoUnit" -DeviceMap "42" -Category "ServoDrive" -Access "All"
    ! -Name "diFestoUnit_12_Move" -SignalType "DI" -Device "FestoUnit" -DeviceMap "44" -Category "ServoDrive" -Access "All"
    ! -Name "diFestoUnit_13_Dev" -SignalType "DI" -Device "FestoUnit" -DeviceMap "45" -Category "ServoDrive" -Access "All"
    ! -Name "diFestoUnit_14_Still" -SignalType "DI" -Device "FestoUnit" -DeviceMap "46" -Category "ServoDrive" -Access "All"
    ! -Name "diFestoUnit_15_Ref" -SignalType "DI" -Device "FestoUnit" -DeviceMap "47" -Category "ServoDrive" -Access "All"
    ! -Name "diFestoUnit_16_Abs" -SignalType "DI" -Device "FestoUnit" -DeviceMap "48" -Category "ServoDrive" -Access "All"
    ! -Name "diFestoUnit_17_CM1" -SignalType "DI" -Device "FestoUnit" -DeviceMap "49" -Category "ServoDrive" -Access "All"
    ! -Name "diFestoUnit_18_CM2" -SignalType "DI" -Device "FestoUnit" -DeviceMap "50" -Category "ServoDrive" -Access "All"

    ! -Name "doFestoUnit_0_Enable" -SignalType "DO" -Device "FestoUnit" -DeviceMap "0" -Category "ServoDrive" -Access "All"
    ! -Name "doFestoUnit_1_Stop" -SignalType "DO" -Device "FestoUnit" -DeviceMap "1" -Category "ServoDrive" -Access "All"
    ! -Name "doFestoUnit_2" -SignalType "DO" -Device "FestoUnit" -DeviceMap "2" -Category "ServoDrive" -Access "All"
    ! -Name "doFestoUnit_3_Reset" -SignalType "DO" -Device "FestoUnit" -DeviceMap "3" -Category "ServoDrive" -Access "All"
    ! -Name "doFestoUnit_6_OPM1" -SignalType "DO" -Device "FestoUnit" -DeviceMap "6" -Category "ServoDrive" -Access "All"
    ! -Name "doFestoUnit_7_OPM2" -SignalType "DO" -Device "FestoUnit" -DeviceMap "7" -Category "ServoDrive" -Access "All"
    ! -Name "doFestoUnit_8_Halt" -SignalType "DO" -Device "FestoUnit" -DeviceMap "8" -Category "ServoDrive" -Access "All"
    ! -Name "doFestoUnit_9_Start" -SignalType "DO" -Device "FestoUnit" -DeviceMap "9" -Category "ServoDrive" -Access "All"
    ! -Name "doFestoUnit_10_Homeing" -SignalType "DO" -Device "FestoUnit" -DeviceMap "10" -Category "ServoDrive" -Access "All"
    ! -Name "doFestoUnit_11_JogP" -SignalType "DO" -Device "FestoUnit" -DeviceMap "11" -Category "ServoDrive" -Access "All"
    ! -Name "doFestoUnit_12_JogN" -SignalType "DO" -Device "FestoUnit" -DeviceMap "12" -Category "ServoDrive" -Access "All"
    ! -Name "doFestoUnit_14_Clear" -SignalType "DO" -Device "FestoUnit" -DeviceMap "14" -Category "ServoDrive" -Access "All"
    ! -Name "doFestoUnit_15" -SignalType "DO" -Device "FestoUnit" -DeviceMap "15" -Category "ServoDrive" -Access "All"
    ! -Name "doFestoUnit_16_Abs" -SignalType "DO" -Device "FestoUnit" -DeviceMap "16" -Category "ServoDrive" -Access "All"
    ! -Name "doFestoUnit_17_CM1" -SignalType "DO" -Device "FestoUnit" -DeviceMap "17" -Category "ServoDrive" -Access "All"
    ! -Name "doFestoUnit_18_CM2" -SignalType "DO" -Device "FestoUnit" -DeviceMap "18" -Category "ServoDrive" -Access "All"

    ! -Name "giFestoUnit_Vel" -SignalType "GI" -Device "FestoUnit" -DeviceMap "56-63" -Access "All"
    ! -Name "giFestoUnit_Position" -SignalType "GI" -Device "FestoUnit" -DeviceMap "64-80" -Category "ServoDrive"

    ! -Name "goFestoUnit_CM" -SignalType "GO" -Device "FestoUnit" -DeviceMap "17-18" -Access "All"
    ! -Name "goFestoUnit_VelSet" -SignalType "GO" -Device "FestoUnit" -DeviceMap "24-31" -Access "All" -MaxLog 127 -MaxBitVal 255 -MinLog -128
    ! -Name "goFestoUnit_PositionSet" -SignalType "GO" -Device "FestoUnit" -DeviceMap "32-63" -Category "ServoDrive" -Access "All"



    ! nMaxWaitTime is used when servo is positioned, will raise error ERR_WAIT_MAXTIME if position is not reached within time
    CONST num nMaxWaitTime:=10;
    VAR intnum intDisableFesto;



    ! Will move servo to given position and given speed. Can wait until arrived or not. 
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



    ! Will move servo to given position and given speed. Will stop if input triggers and return position. Works like SearchL.
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
        ! Stop Festo controller, keep Enable active
        SetDO doFestoUnit_1_Stop,0;
        WaitUntil diFestoUnit_12_Move<>1;
        SetDO doFestoUnit_1_Stop,1;
    ERROR
        RAISE ;
    ENDPROC



    ! Enable on, reset errors etc. Also starts a timed interrupt to disable servo if not moved within x min.
    PROC EnableFesto()
        ! Start Interrupt for turning off servo, 1min should be enough.
        IDelete intDisableFesto;
        CONNECT intDisableFesto WITH tDisableFesto;
        ITimer\SingleSafe,60,intDisableFesto;

        IF diFestoUnit_0_Enabled=1 AND
            diFestoUnit_6_OpMode1=1 AND
            diFestoUnit_8_Halt=1 AND
            doFestoUnit_1_Stop=1 RETURN ;

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
