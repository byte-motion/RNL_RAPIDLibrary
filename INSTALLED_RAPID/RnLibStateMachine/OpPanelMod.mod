MODULE OpPanelMod

    ! ########## ########## ########## ########## ########## ########## ########## ########## ########## ##########
    ! <StateMachine standard code segment>
    ! DO NOT EDIT!
    LOCAL PERS string stModName:="OpPanelMod";
    LOCAL PERS string stTimeOut:="ResetAndStart_Err_10";
    PERS bool bState_10:=FALSE;
    LOCAL PERS string stStateStringCopy:="State_OpPanel_Mod:State_OpPanel_Main";
    !
    ! </StateMachine standard code segment>
    ! ########## ########## ########## ########## ########## ########## ########## ########## ########## ##########



    ! ...USER CODE START...

    LOCAL VAR intnum intBlink500;
    LOCAL VAR intnum intBlink200;
    LOCAL PERS bool bBlink200:=FALSE;
    LOCAL PERS bool bBlink500:=FALSE;
    PERS bool bAccessWanted:=FALSE;
    PERS bool bResetStart:=FALSE;
    PERS bool bResetStart_Err:=FALSE;
    VAR clock clResetStart_Err;
    VAR clock clAccessWanted;

    LOCAL PROC Init()
        !
        ! Sett opp interrupt for lysblink, disse brukes i StatePreRun() for å sette lys til passende blink interval.
        IDelete intBlink200;
        CONNECT intBlink200 WITH trBlink200;
        ITimer 0.2,intBlink200;
        IDelete intBlink500;
        CONNECT intBlink500 WITH trBlink500;
        ITimer 0.5,intBlink500;
        !
        bAccessWanted:=FALSE;
        bResetStart:=FALSE;
        bResetStart_Err:=FALSE;
        !
        SetState "Main";
    ENDPROC

    LOCAL PROC Main()
        ! Alle timeouts blir resatt i main.
        TimeOutDelete;
        ! Check for available sequences
        IF diAccessWanted=1 AND doOpPanelDoorLock<>0 SetState "AccessWanted_10";
        IF bAccessWanted AND sdoCycleOn=0 SetState "DoorUnlock_10";
        IF diResetAndStart=1 SetState "ResetAndStart_10";
    ENDPROC

    LOCAL PROC AccessWanted_10()
        ! Inverter bAccessWanted. Operatør kan da "skru av" funksjon mens robot fullfører syklus.
        ! bAccessWanted er delt med T_ROB og robot stopper når denne er TRUE.
        bAccessWanted:=(NOT bAccessWanted);
        ClkReset clAccessWanted;
        ClkStart clAccessWanted;
        SetState "AccessWanted_20";
    ENDPROC

    LOCAL PROC AccessWanted_20()
        IF ClkRead(clAccessWanted)>3 THEN
            ! Tving dør til å låse opp om knapp holdes inne.
            DoorUnlock_10;
        ELSEIF diAccessWanted=0 THEN
            ! Vent til operatør slipper knapp.
            SetState "Main";
        ENDIF
    ENDPROC

    LOCAL PROC DoorUnlock_10()
        ! Lås opp dør og resett I/O
        SetDO sdoMotorsOn,0;
        SetDO sdoStart,0;
        SetDO doOpPanelDoorLock,0;
        bAccessWanted:=FALSE;
        SetState "Main";
    ENDPROC

    LOCAL PROC ResetAndStart_10()
        IF sdoCycleOn=1 THEN
            SetState "State_OpPanel_Main";
            RETURN ;
        ENDIF
        TimeOutSetup 10,\ProcTimeOut:="ResetAndStart_Err_10";
        bAccessWanted:=FALSE;
        bResetStart:=TRUE;
        SetDO sdoMotorsOn,0;
        SetDO sdoStart,0;
        SetDO doOpPanelDoorLock,1;
        SetState "ResetAndStart_20";
    ENDPROC

    LOCAL PROC ResetAndStart_20()
        IF diAccessWanted=1 THEN
            DoorUnlock_10;
        ELSEIF sdoRunChainOk=1 THEN
            SetDO sdoMotorsOn,1;
            SetState "ResetAndStart_30";
        ENDIF
    ENDPROC

    LOCAL PROC ResetAndStart_30()
        IF diAccessWanted=1 THEN
            DoorUnlock_10;
        ELSEIF sdoMotorsOnState=1 THEN
            SetDO sdoStart,1;
            SetState "ResetAndStart_40";
        ENDIF
    ENDPROC

    LOCAL PROC ResetAndStart_40()
        IF diAccessWanted=1 THEN
            DoorUnlock_10;
        ELSEIF sdoCycleOn=1 THEN
            SetDO sdoMotorsOn,0;
            SetDO sdoStart,0;
            SetState "Main";
        ENDIF
    ENDPROC

    LOCAL PROC ResetAndStart_Err_10()
        bResetStart_Err:=TRUE;
        ClkReset clResetStart_Err;
        ClkStart clResetStart_Err;
        SetState "ResetAndStart_Err_20";
    ENDPROC

    LOCAL PROC ResetAndStart_Err_20()
        IF ClkRead(clResetStart_Err)>3 THEN
            ClkStop clResetStart_Err;
            bResetStart_Err:=FALSE;
            SetState "Main";
        ENDIF
    ENDPROC

    LOCAL PROC StatePreRun()
        !
        ! Light for buttons
        IF sdoCycleOn=1 AND bAccessWanted THEN
            SetDO doLightBtnAccessWanted,BoolToNum(bBlink500);
        ELSEIF sdoCycleOn=1 OR bResetStart THEN
            SetDO doLightBtnAccessWanted,0;
        ELSE
            SetDO doLightBtnAccessWanted,1;
        ENDIF
        !
        IF sdoCycleOn=0 AND bResetStart THEN
            SetDO doLightBtnStart,BoolToNum(bBlink500);
        ELSEIF sdoCycleOn=0 AND bResetStart_Err THEN
            SetDO doLightBtnStart,BoolToNum(bBlink200);
        ELSEIF sdoCycleOn=0 THEN
            SetDO doLightBtnStart,0;
        ELSE
            SetDO doLightBtnStart,1;
        ENDIF
        !
    ENDPROC

    LOCAL PROC StatePostRun()
        !
    ENDPROC

    LOCAL TRAP trBlink200
        BoolInvert bBlink200;
    ENDTRAP

    LOCAL TRAP trBlink500
        BoolInvert bBlink500;
    ENDTRAP

    LOCAL PROC BoolInvert(INOUT bool Val)
        Val:=NOT Val;
    ENDPROC

    FUNC num BoolToNum(bool Val)
        IF Val RETURN 1;
        RETURN 0;
    ENDFUNC

    ! ...USER CODE END...



    ! ########## ########## ########## ########## ########## ########## ########## ########## ########## ##########
    ! <StateMachine standard code segment>
    ! DO NOT EDIT!

    LOCAL PROC SmInit(string ModName)
        VAR num nId;
        stModName:=ModName;
        nId:=GetId(stModName);
        !
        ! Setup scan when relevant I/O is changed. 
        SetupCyclicBool bState_10,diAccessWanted=1 XOR diResetAndStart=1;
        IDelete intIoChange{nId};
        CONNECT intIoChange{nId} WITH trSmMain;
        IPers bState_10,intIoChange{nId};
        !
    ENDPROC

    ! No need to edit below

    LOCAL PROC SmMain()
        ! Run machine only when in AUTO.
        !IF OpMode()<>OP_AUTO RETURN;
        ! Run machine only when robot task is running.
        !IF (NOT TaskIsExecuting("T_ROB1")) RETURN;
        ! Run machine only when safety is ok. (Configure <sdoRunChainOk> and system output for it)
        !IF sdoRunChainOk<>1 RETURN;
        %"StateMachineMod:SmMain"%stModName;
    ENDPROC

    LOCAL TRAP trSmMain
        SmMain;
    ENDTRAP

    LOCAL PROC SetState(string State)
        %"StateMachineMod:SetState"%stModName,State;
    ENDPROC

    LOCAL PROC TimeOutSetup(num Val,\string ProcTimeOut)
        VAR num nId;
        nId:=GetId(stModName);
        IF Present(ProcTimeOut) THEN
            stTimeOut:=ProcTimeOut;
        ELSE
            stTimeOut:="";
        ENDIF
        IDelete intTimeOut{nId};
        CONNECT intTimeOut{nId} WITH trSmTimeOut;
        ITimer\Single,Val,intTimeOut{nId};
    ENDPROC

    LOCAL PROC TimeOutDelete()
        IDelete intTimeOut{GetId(stModName)};
    ENDPROC

    LOCAL TRAP trSmTimeOut
        ErrWrite\I,"TimeOut ModName="""+stModName+"""","";
        IF StrLen(stTimeOut)>0 THEN
            %stTimeOut %;
        ELSE
            SetState GetInitState(stModName);
        ENDIF
    ENDTRAP

    ! </StateMachine standard code segment>
    ! ########## ########## ########## ########## ########## ########## ########## ########## ########## ##########

ENDMODULE
