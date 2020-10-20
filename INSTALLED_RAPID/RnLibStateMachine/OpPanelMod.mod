MODULE OpPanelMod

    ! Id will hold pointer to statemachine object
    LOCAL VAR num Id:=0;

    PERS string stDebugSelectedState:="Main";
    LOCAL VAR num ForceUnlock_;
    LOCAL VAR num TimeOut_;

    PERS bool bAccessWanted:=TRUE;
    PERS bool bResetStart:=FALSE;
    PERS bool bResetStart_Err:=FALSE;

    LOCAL PROC Init(string ModName)
        bAccessWanted:=FALSE;
        bResetStart:=FALSE;
        bResetStart_Err:=FALSE;
        Id:=NewStateMachine(ModName,"Operator Panel");
        Subscribe Id,["bAccessWanted","Id","diAccessWanted","diResetAndStart","sdoRunChainOk","sdoMotorsOnState","sdoCycleOn"];
    ENDPROC

    LOCAL PROC Main()
        IF diAccessWanted=1 AND doOpPanelDoorLock<>0 SetState Id,"AccessWanted_10";
        IF bAccessWanted AND sdoCycleOn=0 SetState Id,"DoorUnlock_10";
        IF diResetAndStart=1 AND sdoCycleOn=0 SetState Id,"ResetAndStart_10";
    ENDPROC

    LOCAL PROC AccessWanted_10()
        bResetStart:=FALSE;
        bAccessWanted:=(NOT bAccessWanted);
        ForceUnlock_:=NewTimer(Id,5,"DoorUnlock_10");
        SetState Id,"AccessWanted_20";
    ENDPROC

    LOCAL PROC AccessWanted_20()
        IF diAccessWanted=0 THEN
            DeleteTimer ForceUnlock_;
            SetState Id,"Main";
        ENDIF
    ENDPROC

    LOCAL PROC DoorUnlock_10()
        ! Lås opp dør og resett I/O
        SetDO sdoxMotorsOn,0;
        SetDO sdoxStart,0;
        SetDO doOpPanelDoorLock,0;
        bResetStart:=FALSE;
        bAccessWanted:=FALSE;
        SetState Id,"Main";
    ENDPROC

    LOCAL PROC ResetAndStart_10()
        TimeOut_:=NewTimer(Id,10,"ResetAndStart_Err_10");
        bAccessWanted:=FALSE;
        bResetStart:=TRUE;
        SetDO sdoxMotorsOn,0;
        SetDO sdoxStart,0;
        SetDO doOpPanelDoorLock,1;
        SetState Id,"ResetAndStart_20";
    ENDPROC

    LOCAL PROC ResetAndStart_20()
        IF diAccessWanted=1 THEN
            DoorUnlock_10;
        ELSEIF sdoRunChainOk=1 THEN
            SetDO sdoxMotorsOn,1;
            SetState Id,"ResetAndStart_30";
        ENDIF
    ENDPROC

    LOCAL PROC ResetAndStart_30()
        IF diAccessWanted=1 THEN
            DoorUnlock_10;
        ELSEIF sdoMotorsOnState=1 THEN
            SetDO sdoxStart,1;
            SetState Id,"ResetAndStart_40";
        ENDIF
    ENDPROC

    LOCAL PROC ResetAndStart_40()
        IF diAccessWanted=1 THEN
            DoorUnlock_10;
        ELSEIF sdoCycleOn=1 THEN
            SetDO sdoxMotorsOn,0;
            SetDO sdoxStart,0;
            DeleteTimer TimeOut_;
            bResetStart:=FALSE;
            SetState Id,"Main";
        ENDIF
    ENDPROC

    LOCAL PROC ResetAndStart_Err_10()
        bResetStart_Err:=TRUE;
        TimeOut_:=NewTimer(Id,5,"ResetAndStart_Err_20");
    ENDPROC

    LOCAL PROC ResetAndStart_Err_20()
        bResetStart_Err:=FALSE;
        bResetStart:=FALSE;
        SetState Id,"Main";
    ENDPROC

    LOCAL PROC PreRun()
        stDebugSelectedState:=GetState(Id);
    ENDPROC

    LOCAL PROC PostRun()
        !
    ENDPROC

    FUNC string DataToString(string Name)
        IF IsPers(Name) THEN
            ! Pers
        ELSEIF IsVar(Name) THEN
            ! Var
        ELSEIF ValidIO(Name) THEN
            ! I/O

        ENDIF
    ENDFUNC

ENDMODULE
