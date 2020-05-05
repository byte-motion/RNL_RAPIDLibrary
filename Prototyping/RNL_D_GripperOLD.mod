MODULE RNL_D_GripperOLD 

!    ALIAS virtualObjectPointer gripper;

!    ALIAS num gripperActionType;

!    RECORD RNL_D_Gripper_Action
!        gripper gripper_reference;
!        gripperActionType actionType;
!        string doNormal;
!        string doOpposite;
!        string diNormal;
!        string diOpposite;
!        num timeNormal;
!        num timeOpposite;
!        num timeOutNormal;
!        num timeOutOpposite;
!        bool Success;
!    ENDRECORD

!    !========
!    !Gripper Name and Descriptio 
!    PERS string RNL_D_Gripper_s_Name{20};
!    PERS string RNL_D_Gripper_s_Description{20};
!    PERS string RNL_D_Gripper_s_LogFileName{20};
!    LOCAL CONST gripper DEFAULT_GRIPPER:=[0,1];


!    !========
!    !Alias IO 
!    VAR signaldo RNL_D_Gripper_IO_doNormal;
!    VAR signaldo RNL_D_Gripper_IO_doOpposite;
!    VAR signaldi RNL_D_Gripper_IO_diNormal;
!    VAR signaldi RNL_D_Gripper_IO_diOpposite;
!    LOCAL VAR num Current_TimeActionNormal;
!    LOCAL VAR num Current_TimeActionOpposite;
!    LOCAL VAR num Current_TimeOutActionNormal;
!    LOCAL VAR num Current_TimeOutActionOpposite;


!    !========
!    !Action Types 
!    LOCAL CONST gripperActionType ACTIONTYPE_NULL:=0;
!    LOCAL CONST gripperActionType ACTIONTYPE_IN:=1;
!    LOCAL CONST gripperActionType ACTIONTYPE_OUT:=2;
!    LOCAL CONST gripperActionType ACTIONTYPE_OPEN:=3;
!    LOCAL CONST gripperActionType ACTIONTYPE_CLOSE:=4;
!    LOCAL CONST gripperActionType ACTIONTYPE_EXTEND:=5;
!    LOCAL CONST gripperActionType ACTIONTYPE_RETRACT:=6;
!    LOCAL CONST gripperActionType ACTIONTYPE_SUCTION_ON:=7;
!    LOCAL CONST gripperActionType ACTIONTYPE_SUCTION_OFF:=8;
!    LOCAL CONST gripperActionType ACTIONTYPE_BLOWOFF_ON:=9;
!    LOCAL CONST gripperActionType ACTIONTYPE_BLOWOFF_OFF:=10;
!    LOCAL CONST gripperActionType ACTIONTYPE_MOVETO:=11;
!    LOCAL CONST gripperActionType ACTIONTYPE_CALIBRATE:=12;


!    !===============
!    !Action IO Names 
!    PERS string RNL_D_Gripper_s_doAction{12,20};
!    PERS string RNL_D_Gripper_s_diAction{12,20};

!    !    PERS string RNL_D_Gripper_s_doIn{20};
!    !    PERS string RNL_D_Gripper_s_doOut{20};
!    !    PERS string RNL_D_Gripper_s_doClose{20};
!    !    PERS string RNL_D_Gripper_s_doOpen{20};
!    !    PERS string RNL_D_Gripper_s_doExtend{20};
!    !    PERS string RNL_D_Gripper_s_doRetract{20};
!    !    PERS string RNL_D_Gripper_s_doSuctionON{20};
!    !    PERS string RNL_D_Gripper_s_doSuctionOFF{20};
!    !    PERS string RNL_D_Gripper_s_doBlowoffON{20};
!    !    PERS string RNL_D_Gripper_s_doBlowoffOFF{20};

!    !    PERS string RNL_D_Gripper_s_diIn{20};
!    !    PERS string RNL_D_Gripper_s_diInOut_Mid{20};
!    !    PERS string RNL_D_Gripper_s_diOut{20};
!    !    PERS string RNL_D_Gripper_s_diOpen{20};
!    !    PERS string RNL_D_Gripper_s_diOpenClose_Mid{20};
!    !    PERS string RNL_D_Gripper_s_diClose{20};
!    !    PERS string RNL_D_Gripper_s_diExtend{20};
!    !    PERS string RNL_D_Gripper_s_diExtRet_Mid{20};
!    !    PERS string RNL_D_Gripper_s_diRetract{20};
!    !    PERS string RNL_D_Gripper_s_diSuctionOK{20};
!    !    PERS string RNL_D_Gripper_s_diBlowoffOK{20};
!    !    PERS string RNL_D_Gripper_s_diItemInGrip{20};

!    !==========
!    !Action time 
!    PERS num RNL_D_Gripper_n_TimeAction{12,20};
!    PERS num RNL_D_Gripper_n_TimeOutAction{12,20};
!    PERS num RNL_D_Gripper_n_TimeOut_Default{20};

!    !    PERS num RNL_D_Gripper_n_TimeIn{20};
!    !    PERS num RNL_D_Gripper_n_TimeOut{20};
!    !    PERS num RNL_D_Gripper_n_TimeOpen{20};
!    !    PERS num RNL_D_Gripper_n_TimeClose{20};
!    !    PERS num RNL_D_Gripper_n_TimeExtend{20};
!    !    PERS num RNL_D_Gripper_n_TimeRetract{20};
!    !    PERS num RNL_D_Gripper_n_TimeSuctionON{20};
!    !    PERS num RNL_D_Gripper_n_TimeSuctionOFF{20};
!    !    PERS num RNL_D_Gripper_n_TimeBlowoffON{20};
!    !    PERS num RNL_D_Gripper_n_TimeBlowoffOFF{20};


!    !===========================================================================
!    !Constructing and destructing functions
!    !===========================================================================

!    !Allocates a new virtual object in memory and returns a pointer to it
!    FUNC gripper gripper_New(\switch persistant)
!        <SMT>
!    ENDFUNC

!    !De-Allocates a virtual object from memory 
!    PROC gripper_Erase()
!        <SMT>
!    ENDPROC

!    !Duplicates a virtual object in memory and returns a pointer the new object
!    FUNC gripper gripper_Copy(gripper original)
!        <SMT>
!    ENDFUNC

!    !===========================================================================
!    !Scan Behavious
!    !===========================================================================

!    !Is called once every scan
!    PROC RNL_D_Gripper_Scan()
!        RETURN ;
!    ENDPROC

!    !===========================================================================
!    !Exposed callable behaviours
!    !===========================================================================

!    !Handles Gripping
!    PROC gripper_action(gripper Gripper_Pointer
!        \switch GripIn
!        |switch GripOut
!        |switch GripClose
!        |switch GripOpen
!        |num MoveToPosition
!        |switch Extend
!        |switch Retract
!        |switch SuctionOn
!        |switch SuctionOff
!        |num SuctionOffAndBlowoffPulseTime
!        |switch BlowoffOff
!        |switch BlowoffOn
!        |switch Calibrate

!        \switch NoWaitTime
!        |num MaxWaitTime
!        \num force
!        \num speed
!        \num pressure
!        \num time
!        \num MaxPosError
!        \virtualObjectPointer object
!        )
        
!        VAR virtualObjectPointer Gripper_Pointer_;
!        VAR gripperActionType ActionType_:=0;

!        ActionType_:=determineGripperActionType(
!        \GripIn:=present(GripIn)
!        \GripOut:=present(GripOut)
!        \GripClose:=present(GripClose)
!        \GripOpen:=present(GripOpen)
!        \MoveToPosition:=present(MoveToPosition)
!        \Extend:=present(Extend)
!        \Retract:=present(Retract)
!        \SuctionOn:=present(SuctionOn)
!        \SuctionOff:=present(SuctionOff)
!        \BlowoffOn:=present(BlowoffOn)
!        \BlowoffOff:=present(BlowoffOff)
!        \Calibrate:=present(Calibrate));
        
!        Gripper_Pointer:=DEFAULT_GRIPPER;
!        IF Present(Gripper_Pointer) Gripper_Pointer_:=Gripper_Pointer;

!        !Set up logging/Timing
        
!        !Execute the action
!        ExecuteAction Gripper_Pointer,ActionType_;
        
!        !Conclude logging/Timing
        
!    ENDPROC

!    FUNC bool gripper_Is(gripper Gripper_Pointer
!        \switch In
!        |switch Out
!        |switch Closed
!        |switch Open
!        |num InPosition
!        |switch Extended
!        |switch Retracted
!        |switch SuctionON
!        |switch SuctionOFF
!        |switch VacumeOK
!        |switch BlowoffOff
!        |switch BlowoffOn
!        |switch BlowoffOK
!        |switch Calibrated
!        )

!        VAR virtualObjectPointer Gripper_Pointer_;
!        VAR gripperActionType ActionType_:=0;

!        ActionType_:=determineGripperActionType(
!        \GripIn:=present(In)
!        \GripOut:=present(Out)
!        \GripClose:=present(Closed)
!        \GripOpen:=present(Open)
!        \MoveToPosition:=present(InPosition)
!        \Extend:=present(Extended)
!        \Retract:=present(Retracted)
!        \SuctionOn:=present(SuctionOn)
!        \SuctionOff:=present(SuctionOff)
!        \BlowoffOn:=present(BlowoffOn)
!        \BlowoffOff:=present(BlowoffOff)
!        \Calibrate:=present(Calibrated));
        
!        Gripper_Pointer:=DEFAULT_GRIPPER;
!        IF Present(Gripper_Pointer) Gripper_Pointer_:=Gripper_Pointer;
        
!        <SMT>
!    ENDFUNC

!    FUNC bool gripper_getContent()
!        <SMT>
!    ENDFUNC

!    !FUNC signaldi gripper_SearchSignal()
!    !    <SMT>
!    !ENDFUNC


!    !===========================================================================
!    !LOCAL Behaviours
!    !===========================================================================

!    !==================
!    !Alias IO handeling

!    LOCAL PROC updateAliasIO(

!        \virtualObjectPointer gripper,

!        \switch input
!        |switch output
!        |switch time
!        |switch timeOut
!        |switch input_Opposite
!        |switch output_Opposite
!        |switch timeOut_Opposite

!        \gripperActionType ActionType
!        |switch GripIn
!        |switch GripOut
!        |switch GripClose
!        |switch GripOpen
!        |switch MoveToPosition
!        |switch Extend
!        |switch Retract
!        |switch SuctionOn
!        |switch SuctionOff
!        |switch BlowoffOn
!        |switch BlowoffOff
!        |switch Calibrate
!        )


!        VAR virtualObjectPointer gripper_;
!        VAR gripperActionType ActionType_:=0;

!        ActionType_:=determineGripperActionType(
!        \GripIn:=present(GripIn)
!        \GripOut:=present(GripOut)
!        \GripClose:=present(GripClose)
!        \GripOpen:=present(GripOpen)
!        \MoveToPosition:=present(MoveToPosition)
!        \Extend:=present(Extend)
!        \Retract:=present(Retract)
!        \SuctionOn:=present(SuctionOn)
!        \SuctionOff:=present(SuctionOff)
!        \BlowoffOn:=present(BlowoffOn)
!        \BlowoffOff:=present(BlowoffOff)
!        \Calibrate:=present(Calibrate));

!        IF Present(ActionType) ActionType_:=ActionType;
!        IF ActionType_=ACTIONTYPE_NULL THEN
!            !Error
!            stop;
!        ENDIF

!        gripper_:=DEFAULT_GRIPPER;
!        IF Present(gripper) gripper_:=gripper;


!        !Sets a Alias IO, or "Time" parameter,
!        !by using the actionType index and the gripper index

!        IF Present(input) THEN
!            <SMT>
!        ELSEIF Present(output) THEN
!        ELSEIF Present(time) THEN
!        ELSEIF Present(timeOut) THEN
!        ENDIF

!    ENDPROC



!    LOCAL FUNC bool ActionParameterIsDefined(

!        \virtualObjectPointer gripper,

!        \switch input
!        |switch output
!        |switch time
!        |switch input_Opposite
!        |switch output_Opposite
!        |switch time_Opposite

!        \gripperActionType ActionType
!        |switch GripIn
!        |switch GripOut
!        |switch GripClose
!        |switch GripOpen
!        |switch MoveToPosition
!        |switch Extend
!        |switch Retract
!        |switch SuctionOn
!        |switch SuctionOff
!        |switch BlowoffOn
!        |switch BlowoffOff
!        |switch Calibrate
!        )


!        VAR virtualObjectPointer gripper_;
!        VAR gripperActionType ActionType_:=0;

!        ActionType_:=determineGripperActionType(
!        \GripIn:=present(GripIn)
!        \GripOut:=present(GripOut)
!        \GripClose:=present(GripClose)
!        \GripOpen:=present(GripOpen)
!        \MoveToPosition:=present(MoveToPosition)
!        \Extend:=present(Extend)
!        \Retract:=present(Retract)
!        \SuctionOn:=present(SuctionOn)
!        \SuctionOff:=present(SuctionOff)
!        \BlowoffOn:=present(BlowoffOn)
!        \BlowoffOff:=present(BlowoffOff)
!        \Calibrate:=present(Calibrate));

!        IF Present(ActionType) ActionType_:=ActionType;
!        IF ActionType_=ACTIONTYPE_NULL THEN
!            !Error
!            stop;
!        ENDIF

!        gripper_:=DEFAULT_GRIPPER;
!        IF Present(gripper) gripper_:=gripper;


!        !Look up if a parameter is defined,
!        !by using the actionType index and the gripper index

!        IF Present(input) THEN
!            IF RNL_D_Gripper_s_diAction{ActionType_,gripper_.index}<>"" RETURN TRUE;
!        ELSEIF Present(output) THEN
!            IF RNL_D_Gripper_s_doAction{ActionType_,gripper_.index}<>"" RETURN TRUE;
!        ELSEIF Present(time) THEN
!            IF RNL_D_Gripper_n_TimeAction{ActionType_,gripper_.index}>0 RETURN TRUE;

!        ELSEIF Present(input_Opposite) THEN
!            IF RNL_D_Gripper_s_diAction{GripperActionType_Opposite(ActionType_),gripper_.index}<>"" RETURN TRUE;
!        ELSEIF Present(output_Opposite) THEN
!            IF RNL_D_Gripper_s_doAction{GripperActionType_Opposite(ActionType_),gripper_.index}<>"" RETURN TRUE;
!        ELSEIF Present(time_Opposite) THEN
!            IF RNL_D_Gripper_n_TimeAction{GripperActionType_Opposite(ActionType_),gripper_.index}>0 RETURN TRUE;
!        ELSE
!            !ERROR
!            stop;
!        ENDIF

!        RETURN FALSE;

!    ENDFUNC

!    LOCAL FUNC gripperActionType GripperActionType_Opposite(gripperActionType ActionType)
!        TEST ActionType

!        CASE ACTIONTYPE_NULL:
!            RETURN ACTIONTYPE_NULL;

!        CASE ACTIONTYPE_IN:
!            RETURN ACTIONTYPE_OUT;
!        CASE ACTIONTYPE_OUT:
!            RETURN ACTIONTYPE_IN;

!        CASE ACTIONTYPE_OPEN:
!            RETURN ACTIONTYPE_CLOSE;
!        CASE ACTIONTYPE_CLOSE:
!            RETURN ACTIONTYPE_OPEN;

!        CASE ACTIONTYPE_MOVETO:
!            RETURN ACTIONTYPE_NULL;

!        CASE ACTIONTYPE_EXTEND:
!            RETURN ACTIONTYPE_RETRACT;
!        CASE ACTIONTYPE_RETRACT:
!            RETURN ACTIONTYPE_EXTEND;

!        CASE ACTIONTYPE_SUCTION_ON:
!            RETURN ACTIONTYPE_SUCTION_OFF;
!        CASE ACTIONTYPE_SUCTION_OFF:
!            RETURN ACTIONTYPE_SUCTION_ON;

!        CASE ACTIONTYPE_BLOWOFF_ON:
!            RETURN ACTIONTYPE_BLOWOFF_OFF;
!        CASE ACTIONTYPE_BLOWOFF_OFF:
!            RETURN ACTIONTYPE_BLOWOFF_ON;

!        CASE ACTIONTYPE_CALIBRATE:
!            RETURN ACTIONTYPE_NULL;
!        DEFAULT:
!            !ERROR
!            stop;
!        ENDTEST
!    ENDFUNC

!    LOCAL FUNC gripperActionType determineGripperActionType(
!        \bool GripIn
!        \bool GripOut
!        \bool GripClose
!        \bool GripOpen
!        \bool MoveToPosition
!        \bool Extend
!        \bool Retract
!        \bool SuctionOn
!        \bool SuctionOff
!        \bool BlowoffOn
!        \bool BlowoffOff
!        \bool Calibrate)

!        VAR gripperActionType ActionType_;
!        VAR num counter:=0;

!        IF Present(GripIn) THEN
!            ActionType_:=ACTIONTYPE_IN;
!        ENDIF
!        IF Present(GripOut) THEN
!            ActionType_:=ACTIONTYPE_OUT;
!        ENDIF
!        IF Present(GripClose) THEN
!            ActionType_:=ACTIONTYPE_Close;
!        ENDIF
!        IF Present(GripOpen) THEN
!            ActionType_:=ACTIONTYPE_Open;
!        ENDIF
!        IF Present(MoveToPosition) THEN
!            ActionType_:=ACTIONTYPE_MoveTo;
!        ENDIF
!        IF Present(Extend) THEN
!            ActionType_:=ACTIONTYPE_Extend;
!        ENDIF
!        IF Present(Retract) THEN
!            ActionType_:=ACTIONTYPE_Retract;
!        ENDIF
!        IF Present(SuctionOn) THEN
!            ActionType_:=ACTIONTYPE_Suction_ON;
!        ENDIF
!        IF Present(SuctionOff) THEN
!            ActionType_:=ACTIONTYPE_Suction_OFF;
!        ENDIF
!        IF Present(BlowoffOn) THEN
!            ActionType_:=ACTIONTYPE_BLOWOFF_ON;
!        ENDIF
!        IF Present(BlowoffOff) THEN
!            ActionType_:=ACTIONTYPE_BLOWOFF_OFF;
!        ENDIF
!        IF Present(Calibrate) THEN
!            ActionType_:=ACTIONTYPE_IN;
!        ENDIF

!        IF counter=0 THEN
!            ActionType_:=ACTIONTYPE_NULL;
!        ENDIF

!        IF
!         counter>1 THEN
!            !ERROR
!            stop;
!        ENDIF

!        RETURN ActionType_;

!    ENDFUNC

!    !==========================
!    !Action Execution Handeling

!    LOCAL PROC a()
!        <SMT>
!    ENDPROC

!    PROC ExecuteAction(gripper grip,gripperActionType ActionType \switch NoWait)

!        !Execute Outputs
!        !Set Normal output, if configured
!        IF ActionParameterIsDefined(\gripper:=grip\Output\ActionType:=ActionType) THEN
!            updateAliasIO\gripper:=grip\Output\ActionType:=ActionType;

!            Action_Execute_Normal;

!        ENDIF

!        !Reset Oppositeed output, if configured
!        IF ActionParameterIsDefined(\gripper:=grip\output_Opposite\ActionType:=ActionType) THEN
!            updateAliasIO\gripper:=grip\output_Opposite\ActionType:=ActionType;

!            Action_Execute_Opposite;

!        ENDIF

!        !If no Wait is included, Return before handeling inputs
!        IF present(NoWait) RETURN;
        
!        !Wait For Inputs
!        updateAliasIO\gripper:=grip\Timeout\ActionType:=ActionType;
!        updateAliasIO\gripper:=grip\Timeout_Opposite\ActionType:=ActionType;

!        IF ActionParameterIsDefined(\gripper:=grip\time\ActionType:=ActionType) THEN
!            !If time is configured, wait for hard signals if configured
!            updateAliasIO\gripper:=grip\time\ActionType:=ActionType;

!            !Wait first for Oppositeed to become 0
!            IF ActionParameterIsDefined(\gripper:=grip\input_Opposite\ActionType:=ActionType) THEN
!                updateAliasIO\gripper:=grip\input_Opposite\ActionType:=ActionType;

!                Action_waitFor_Opposite;

!            ENDIF

!            !Wait then for normal to not become 1 (INVERTED), if input signal is configured
!            IF ActionParameterIsDefined(\gripper:=grip\input\ActionType:=ActionType) THEN
!                updateAliasIO\gripper:=grip\input\ActionType:=ActionType;

!                Action_waitFor_InvertedNormal;

!            ELSE
!                !If time is configured, but no input signal is, wait the time

!                Action_On_waitForTime;

!            ENDIF

!        ELSE
!            !If no time is configured, wait for hard signals if configured

!            !Wait first for Oppositeed to become 0
!            IF ActionParameterIsDefined(\gripper:=grip\input_Opposite\ActionType:=ActionType) THEN
!                updateAliasIO\gripper:=grip\input_Opposite\ActionType:=ActionType;

!                Action_waitFor_Opposite;

!            ENDIF

!            !Wait then for normal to become 1
!            IF ActionParameterIsDefined(\gripper:=grip\input\ActionType:=ActionType) THEN
!                updateAliasIO\gripper:=grip\input\ActionType:=ActionType;

!                Action_waitFor_Normal;


!            ENDIF

!        ENDIF

!    ENDPROC



!    LOCAL PROC Action_Execute_Normal()
!        SetDO RNL_D_Gripper_IO_doNormal,1;
!    ENDPROC

!    LOCAL PROC Action_Execute_Opposite()
!        SetDO RNL_D_Gripper_IO_doOpposite,0;
!    ENDPROC

!    LOCAL PROC Action_waitFor_Normal()
!        VAR bool TimeFlag;
!        WaitUntil RNL_D_Gripper_IO_diNormal=1\MaxTime:=Current_TimeOutActionNormal\TimeFlag:=TimeFlag;
!    ENDPROC

!    LOCAL PROC Action_waitFor_Opposite()
!        WaitUntil RNL_D_Gripper_IO_diOpposite=0\MaxTime:=Current_TimeOutActionNormal;
!    ENDPROC

!    LOCAL PROC Action_waitFor_InvertedNormal()
!        VAR bool TimeFlag;
!        WaitUntil RNL_D_Gripper_IO_diNormal=1\MaxTime:=Current_TimeActionNormal\TimeFlag:=TimeFlag;
!    ENDPROC

!    LOCAL PROC Action_On_waitForTime()
!        WaitTime Current_TimeActionNormal;
!    ENDPROC


!    !===========================================================================
!    !Exposed Getters and Setters
!    !===========================================================================

    
    
!    PROC gripper_Set_Input(gripper Gripper_Pointer
!        \string GripIn
!        \string GripOut
!        \string GripClose
!        \string GripOpen
!        \string MoveToPosition
!        \string Extend
!        \string Retract
!        \string SuctionOn
!        \string SuctionOff
!        \string SuctionOffAndBlowoffPulseTime
!        \string BlowoffOff
!        \string BlowoffOn)

!        <SMT>
!    ENDPROC

!    PROC gripper_Set_Output(gripper Gripper_Pointer
!        \string GripIn
!        \string GripOut
!        \string GripClose
!        \string GripOpen
!        \string MoveToPosition
!        \string Extend
!        \string Retract
!        \string SuctionOn
!        \string SuctionOff
!        \string SuctionOffAndBlowoffPulseTime
!        \string BlowoffOff
!        \string BlowoffOn)

!        <SMT>
!    ENDPROC

!    PROC gripper_Set_Time(gripper Gripper_Pointer
!        \num GripIn
!        \num GripOut
!        \num GripClose
!        \num GripOpen
!        \num MoveToPosition
!        \num Extend
!        \num Retract
!        \num SuctionOn
!        \num SuctionOff
!        \num BlowoffOff
!        \num BlowoffOn)

!        IF Present(GripIn) RNL_D_Gripper_n_TimeAction{ACTIONTYPE_IN,Gripper_Pointer.index}:=GripIn;
!        IF Present(GripOut) RNL_D_Gripper_n_TimeAction{ACTIONTYPE_OUT,Gripper_Pointer.index}:=GripOut;
!        IF Present(GripOpen) RNL_D_Gripper_n_TimeAction{ACTIONTYPE_OPEN,Gripper_Pointer.index}:=GripOpen;
!        IF Present(GripClose) RNL_D_Gripper_n_TimeAction{ACTIONTYPE_CLOSE,Gripper_Pointer.index}:=GripClose;
!        IF Present(MoveToPosition) RNL_D_Gripper_n_TimeAction{ACTIONTYPE_MOVETO,Gripper_Pointer.index}:=MoveToPosition;
!        IF Present(Extend) RNL_D_Gripper_n_TimeAction{ACTIONTYPE_EXTEND,Gripper_Pointer.index}:=Extend;
!        IF Present(Retract) RNL_D_Gripper_n_TimeAction{ACTIONTYPE_RETRACT,Gripper_Pointer.index}:=Retract;
!        IF Present(SuctionOn) RNL_D_Gripper_n_TimeAction{ACTIONTYPE_SUCTION_ON,Gripper_Pointer.index}:=SuctionOn;
!        IF Present(SuctionOff) RNL_D_Gripper_n_TimeAction{ACTIONTYPE_SUCTION_OFF,Gripper_Pointer.index}:=SuctionOff;
!        IF Present(BlowoffOn) RNL_D_Gripper_n_TimeAction{ACTIONTYPE_BLOWOFF_ON,Gripper_Pointer.index}:=BlowoffOn;
!        IF Present(BlowoffOff) RNL_D_Gripper_n_TimeAction{ACTIONTYPE_BLOWOFF_OFF,Gripper_Pointer.index}:=BlowoffOff;

!    ENDPROC

!    PROC gripper_Set_TimeOut(\gripper Gripper_Pointer
!        \num GripIn
!        \num GripOut
!        \num GripOpen
!        \num GripClose
!        \num MoveToPosition
!        \num Extend
!        \num Retract
!        \num SuctionOn
!        \num SuctionOff
!        \num BlowoffOn
!        \num BlowoffOff
!        \num DefaultTimeout
!        )

!        VAR virtualObjectPointer Gripper_Pointer_;
!        Gripper_Pointer:=DEFAULT_GRIPPER;
!        IF Present(Gripper_Pointer) Gripper_Pointer_:=Gripper_Pointer;

!        IF Present(GripIn) RNL_D_Gripper_n_TimeOutAction{ACTIONTYPE_IN,Gripper_Pointer_.index}:=GripIn;
!        IF Present(GripOut) RNL_D_Gripper_n_TimeOutAction{ACTIONTYPE_OUT,Gripper_Pointer_.index}:=GripOut;
!        IF Present(GripOpen) RNL_D_Gripper_n_TimeOutAction{ACTIONTYPE_OPEN,Gripper_Pointer_.index}:=GripOpen;
!        IF Present(GripClose) RNL_D_Gripper_n_TimeOutAction{ACTIONTYPE_CLOSE,Gripper_Pointer_.index}:=GripClose;
!        IF Present(MoveToPosition) RNL_D_Gripper_n_TimeOutAction{ACTIONTYPE_MOVETO,Gripper_Pointer_.index}:=MoveToPosition;
!        IF Present(Extend) RNL_D_Gripper_n_TimeOutAction{ACTIONTYPE_EXTEND,Gripper_Pointer_.index}:=Extend;
!        IF Present(Retract) RNL_D_Gripper_n_TimeOutAction{ACTIONTYPE_RETRACT,Gripper_Pointer_.index}:=Retract;
!        IF Present(SuctionOn) RNL_D_Gripper_n_TimeOutAction{ACTIONTYPE_SUCTION_ON,Gripper_Pointer_.index}:=SuctionOn;
!        IF Present(SuctionOff) RNL_D_Gripper_n_TimeOutAction{ACTIONTYPE_SUCTION_OFF,Gripper_Pointer_.index}:=SuctionOff;
!        IF Present(BlowoffOn) RNL_D_Gripper_n_TimeOutAction{ACTIONTYPE_BLOWOFF_ON,Gripper_Pointer_.index}:=BlowoffOn;
!        IF Present(BlowoffOff) RNL_D_Gripper_n_TimeOutAction{ACTIONTYPE_BLOWOFF_OFF,Gripper_Pointer_.index}:=BlowoffOff;
!        IF Present(DefaultTimeout) RNL_D_Gripper_n_TimeOut_Default{Gripper_Pointer_.index}:=DefaultTimeout;

!    ENDPROC



ENDMODULE