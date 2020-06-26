MODULE State_Example_Mod

    ! ########## ########## ########## ########## ########## ########## ########## ########## ########## ##########
    ! <StateMachine standard code segment>
    ! DO NOT EDIT!
    LOCAL PERS string stModName:="State_Example_Mod";
    LOCAL PERS string stTimeOut:="State_ResetAndStart";
    PERS bool bState_20:=FALSE;
    LOCAL PERS string stStateStringCopy:="State_Example_Mod:State_Proc_Main";
    !
    ! </StateMachine standard code segment>
    ! ########## ########## ########## ########## ########## ########## ########## ########## ########## ##########



    ! ...USER CODE START...

    LOCAL PROC Init()
        ! Init process
        SetState "Main";
    ENDPROC

    LOCAL PROC Main()
        TimeOutDelete;
        ! Check for available sequences
        IF diTest1=1 SetState "Example_10";
        IF diTest2=1 SetState "State_20";
        IF diTest3=1 SetState "State_30";
    ENDPROC

    LOCAL PROC Example_10()
        ! Set timeout, startactions, and then change state.
        TimeOutSetup 60;
        !SetDO doDoSomething,1;
        !SetDO doDoSomething,1;
        SetState "Example_20";
    ENDPROC

    LOCAL PROC Example_20()
        IF diTest2=1 SetState "Main";
    ENDPROC

    LOCAL PROC State_20()
        !SetDO doDoSomething,0;
        !SetDO doDoSomething,0;
        !SetDO doDoSomething,0;
        SetState "Main";
    ENDPROC

    LOCAL PROC State_30()
        ! Set timeout, startactions, and then change state.
        TimeOutSetup 60;
        !SetDO doDoSomething,1;
        !SetDO doDoSomething,1;
        !SetDO doDoSomething,1;
        SetState "Main";
    ENDPROC

    LOCAL PROC StatePreRun()
        !
    ENDPROC

    LOCAL PROC StatePostRun()
        !
    ENDPROC

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
        SetupCyclicBool bState_10,diTest1=1 XOR diTest2=1;
        IDelete intIoChange{nId};
        CONNECT intIoChange{nId} WITH trSmMain;
        IPers bState_20,intIoChange{nId};
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
