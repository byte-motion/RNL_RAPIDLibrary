MODULE RNL_D_gripper


    !===========================================================================
    !RECORD and ALIAS
    !===========================================================================

    !Object Pointer
    ALIAS virtualObjectPointer gripper;

    RECORD gripper_BinaryOperation
        string DO_Normal;
        string DO_Inverted;
        string DI_Normal;
        string DI_Inverted;
        num maxWaitTime;
        string example;
    ENDRECORD

    RECORD gripper_data
        gripper_BinaryOperation in;
        gripper_BinaryOperation out;
        gripper_BinaryOperation open;
        gripper_BinaryOperation close;
        gripper_BinaryOperation extend;
        gripper_BinaryOperation retract;
        gripper_BinaryOperation suctionOn;
        gripper_BinaryOperation suctionOff;
        gripper_BinaryOperation blowoffOn;
        gripper_BinaryOperation blowoffOff;
    ENDRECORD


    !===========================================================================
    !Data
    !===========================================================================    

    !===============
    !Buildt in Module Data
    ! DO NOT CHANGE!
    !===============

    !Default pointer when methods are called without a spesified pointer/object
    LOCAL PERS gripper DEFAULT_POINTER:=[4006,1];

    !Stores which task currently has mastership over this module,
    !to avoid race conditions. Empty string means "Available"
    LOCAL PERS string LockMaster:="";
    LOCAL CONST string MASTERSHIP_AVAILABLE:="";
    LOCAL CONST num MASTERSHIP_TIMEOUT:=10;


    !===============
    !Task     LOCAL 
    !Instance GLOBAL
    ! Data is shared across all object instances in a task
    !===============

    !LOCAL PERS num RNL_D_gripper_n_localNum:=0;

    !===============
    !Task     GLOBAL 
    !Instance GLOBAL
    ! Data is shared across all object instances in all task
    !===============

    !CONST num RNL_D_ExDr_CONSTANT_NUM:=0;
    !PERS num RNL_X_ExDr_n_persistantNum:=0;

    !===============
    !Task      - 
    !Instance LOCAL
    ! Data is not shared between any object instances
    ! Data is predefined with max number of instances
    ! To increase the max number of instances, increase the number
    !===============

    PERS gripper_data RNL_gripper_data{20};

    !===========================================================================
    !Buildt In Module Methods
    ! DO NOT CHANGE!
    !===========================================================================

    !Called when a task want to check if it can gain mastership of the module
    LOCAL FUNC bool moduleIsReady()
        !If mastership is available return true
        IF LockMaster=MASTERSHIP_AVAILABLE RETURN TRUE;
        !If task allready has mastership, return true
        IF LockMaster=GetTaskName() RETURN TRUE;
        RETURN FALSE;
    ENDFUNC

    !Waits for mastership to be available, 
    LOCAL PROC waitUntilModuleIsReady()
        WaitUntil moduleIsReady()\MaxTime:=MASTERSHIP_TIMEOUT;

    ERROR
        IF ERRNO=ERR_WAIT_MAXTIME THEN
            !Module has frozen
            RAISE ERR_OBJECTMASTERSHIPTIMEOUT;
        ENDIF
    ENDPROC


    !Called to lock the module from beeing accessed when executing
    LOCAL PROC lockModule(\string MasterName)
        VAR string MasterName_;

        MasterName_:=GetTaskName();
        IF Present(MasterName) MasterName:=MasterName;

        IF moduleIsReady() THEN
            LockMaster:=MasterName_;
        ELSE
            !ERROR
        ENDIF
    ENDPROC

    !Called to unlock the module to beeing accessed after executing
    LOCAL PROC unlockModule()
        IF NOT moduleIsReady() THEN
            LockMaster:=MASTERSHIP_AVAILABLE;
        ELSE
            !ERROR
        ENDIF
    ENDPROC

    LOCAL FUNC bool PointerIsValid(gripper Pointer)
        
        !check that type and index is within limits
        IF pointer.Type <> DEFAULT_POINTER.type RETURN FALSE; 
        IF pointer.Index < 1 RETURN FALSE; 
        IF pointer.Index > Dim(RNL_exampledriver_data,1) RETURN FALSE; 
        
        !Check that pointer is registered in Virtual Object Manager
        IF NOT pointer_isValid(Pointer) RETURN FALSE; 
        
        RETURN TRUE;
        
    ENDFUNC

    LOCAL FUNC bool PointerISAvailable()
        <SMT>
    ENDFUNC


    !===========================================================================
    !Standard Module Methods
    !===========================================================================

    !===============
    !Constructing and
    !destructing functions
    !===============

    !Allocates a new virtual object in memory and returns a pointer to it.
    !Also initializes it with default values
    FUNC gripper gripper_New(
        \string name
        \switch persistant
         \switch keepLocked
        )

        VAR string name_;
        VAR bool persistant_:=FALSE;
        VAR virtualObjectType type_;
        VAR virtualObjectPointer Pointer;
        VAR gripper_data data;

        name_:="Unnamed Gripper";
        IF Present(name) name_:=name;

        IF Present(persistant) persistant_:=TRUE;
        
        waitUntilModuleIsReady;
        lockModule;

        update;

        !Change this to reflext the Object type
        type_:=OBJECT_TYPE_D_GRIPPER;

        DEFAULT_POINTER.type:=type_;
        
        !Get Pointer
        Pointer:=virtualObjectManager_New(
        \name:=name_
        \persistant:=persistant_
        \type:=type_
        \maxIndex:=Dim(RNL_gripper_data,1)
        );
        
        !Reset object data
        RNL_gripper_data{Pointer.index} := data;
        
        IF NOT Present(keepLocked) unLockModule;
        
        !Return pointer
        RETURN Pointer;
        
    ENDFUNC

    !De-Allocates a virtual object from memory
    PROC gripper_Erase(gripper Pointer \switch keepLocked)
        VAR gripper Pointer_;
        VAR gripper_data data;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Reset object data
        RNL_gripper_data{Pointer.index} := data;
        
        IF NOT Present(keepLocked) unLockModule;
    ENDPROC

    !Duplicates a virtual object in memory and returns a pointer the new object
    FUNC gripper gripper_Copy(gripper original)
        <SMT>
    ENDFUNC

    !===============
    !Scan Behaviours
    !===============

    !"Scan" Is called once every scan
    !delta is time since last scan, should stay < 0.5s
    PROC RNL_X_gripper_Scan(num delta)
        IF NOT ModuleIsReady() RETURN ;
        lockModule;

        <SMT>

        unlockModule;
    ENDPROC

    !"Init" Is called once when the module is initialized after "PP to Main"
    PROC RNL_X_gripper_Init()
        waitUntilModuleIsReady;
        lockModule;

        <SMT>

        unlockModule;
    ENDPROC

    !"Update" Is allways called when the main task calls a module function
    !"Update" should update all the data in the module to be accurate
    LOCAL PROC update()
        <SMT>
    ENDPROC

    !===========================================================================
    !LOCAL Behaviours
    !===========================================================================

    LOCAL PROC UpdateCommunication()
        <SMT>
    ENDPROC

    LOCAL PROC UpdateData()
        <SMT>
    ENDPROC

    LOCAL PROC ExecuteBinaryOperation(
            gripper_BinaryOperation operation,
            num maxWaitTimeOverride,
            bool NoWait,
            string OperationName)

        VAR clock ClockTimeout;
        VAR gripper_BinaryOperation operation_;

        operation_:=operation;
        IF maxWaitTimeOverride>0 operation_.maxWaitTime:=maxWaitTimeOverride;

        !if waittime is 0, set to a very high number: clock max time - 1
        !IF operation_.maxWaitTime>0 operation_.maxWaitTime := 4294966;? 

        ClkStart ClockTimeout;

        !Set Normal
        IF operation.DO_Normal<>"" setDO_fromString operation.DO_Normal;
        !Reset Inverted
        IF operation.DO_Inverted<>"" setDO_fromString operation.DO_Inverted;

        !if noWait is true, skip waiting
        IF NOT NoWait THEN

            !If neither normal or inverted DI is defined, simply wait max waittime
            IF operation_.DI_Inverted<>""
                AND operation_.DI_Normal<>""
                AND operation.maxWaitTime>0 THEN
                WaitUntil ClkRead(ClockTimeout)>=operation_.maxWaitTime;
            ENDIF

            !Wait for inverted DI to go low
            IF operation_.DI_Inverted<>"" THEN
                WaitUntil readDI_fromString(operation_.DI_Inverted)=0
                    OR ClkRead(ClockTimeout)>=operation_.maxWaitTime;
            ENDIF
            !Wait for normal DI to go high
            IF operation_.DI_Normal<>"" THEN
                WaitUntil readDI_fromString(operation_.DI_Normal)=1
                    OR ClkRead(ClockTimeout)>=operation_.maxWaitTime;
            ENDIF
            !Wait for inverted DI to go low, again
            IF operation_.DI_Inverted<>"" THEN
                WaitUntil readDI_fromString(operation_.DI_Inverted)=0
                    OR ClkRead(ClockTimeout)>=operation_.maxWaitTime;
            ENDIF
            !Wait for normal DI to go high, again
            IF operation_.DI_Normal<>"" THEN
                WaitUntil readDI_fromString(operation_.DI_Normal)=1
                    OR ClkRead(ClockTimeout)>=operation_.maxWaitTime;
            ENDIF

        ENDIF

        ClkStop ClockTimeout;

        !Report Time to logging
        !To be implemented
        !WriteLogMessage(timestamp - OperationName completed in ClkRead(ClockTimeout))

        !Check if timed out
        IF ClkRead(ClockTimeout)>=operation_.maxWaitTime RAISE ERR_GRIPPERTIMEOUT;

        RETURN ;

    ERROR
        IF ERRNO=ERR_WAIT_MAXTIME OR ERRNO=ERR_GRIPPERTIMEOUT THEN
            RAISE ERR_GRIPPERTIMEOUT;
        ENDIF
        IF ERRNO=ERR_IOSTRINGFAILURE THEN
            RAISE ERR_IOSTRINGFAILURE;
        ENDIF
        RAISE ;
    ENDPROC


    LOCAL FUNC <ID><ID>()
        <SMT>
    ENDFUNC

    !===========================================================================
    !Exposed Actions and Questions
    !===========================================================================

    PROC gripper_ListActions()
        <SMT>
    ENDPROC

    !===============
    !Exposed Actions
    !===============
    PROC gripper_Action(\gripper pointer\switch keepLocked)
        VAR gripper Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Action
        Action(pointer_);

        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    LOCAL PROC Action(gripper pointer)

    ENDPROC

    PROC gripper_gripIn(\gripper pointer,\switch NoWait|num MaxTimeOverride
        \switch keepLocked)
        VAR gripper Pointer_;
        VAR num MaxTimeOverride_:=0;
        VAR bool NoWait_:=FALSE;


        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        IF Present(NoWait) NoWait_:=TRUE;
        IF Present(MaxTimeOverride) MaxTimeOverride_:=MaxTimeOverride;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Action
        ExecuteBinaryOperation
            RNL_gripper_data{Pointer_.index}.In,
            MaxTimeOverride_,
            NoWait_,
            "gripIn";


        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_gripOut(\gripper pointer,\switch NoWait|num MaxTimeOverride
        \switch keepLocked)
        VAR gripper Pointer_;
        VAR num MaxTimeOverride_:=0;
        VAR bool NoWait_:=FALSE;


        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        IF Present(NoWait) NoWait_:=TRUE;
        IF Present(MaxTimeOverride) MaxTimeOverride_:=MaxTimeOverride;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Action
        ExecuteBinaryOperation
            RNL_gripper_data{Pointer_.index}.Out,
            MaxTimeOverride_,
            NoWait_,
            "gripOut";


        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_Open(\gripper pointer,\switch NoWait|num MaxTimeOverride
        \switch keepLocked)
        VAR gripper Pointer_;
        VAR num MaxTimeOverride_:=0;
        VAR bool NoWait_:=FALSE;


        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        IF Present(NoWait) NoWait_:=TRUE;
        IF Present(MaxTimeOverride) MaxTimeOverride_:=MaxTimeOverride;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Action
        ExecuteBinaryOperation
            RNL_gripper_data{Pointer_.index}.Open,
            MaxTimeOverride_,
            NoWait_,
            "Open";


        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_Close(\gripper pointer,\switch NoWait|num MaxTimeOverride
        \switch keepLocked)
        VAR gripper Pointer_;
        VAR num MaxTimeOverride_:=0;
        VAR bool NoWait_:=FALSE;


        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        IF Present(NoWait) NoWait_:=TRUE;
        IF Present(MaxTimeOverride) MaxTimeOverride_:=MaxTimeOverride;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Action
        ExecuteBinaryOperation
            RNL_gripper_data{Pointer_.index}.Close,
            MaxTimeOverride_,
            NoWait_,
            "Close";


        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_Extend(\gripper pointer,\switch NoWait|num MaxTimeOverride
        \switch keepLocked)
        VAR gripper Pointer_;
        VAR num MaxTimeOverride_:=0;
        VAR bool NoWait_:=FALSE;


        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        IF Present(NoWait) NoWait_:=TRUE;
        IF Present(MaxTimeOverride) MaxTimeOverride_:=MaxTimeOverride;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Action
        ExecuteBinaryOperation
            RNL_gripper_data{Pointer_.index}.Extend,
            MaxTimeOverride_,
            NoWait_,
            "Extend";


        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_Retract(\gripper pointer,\switch NoWait|num MaxTimeOverride
        \switch keepLocked)
        VAR gripper Pointer_;
        VAR num MaxTimeOverride_:=0;
        VAR bool NoWait_:=FALSE;


        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        IF Present(NoWait) NoWait_:=TRUE;
        IF Present(MaxTimeOverride) MaxTimeOverride_:=MaxTimeOverride;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Action
        ExecuteBinaryOperation
            RNL_gripper_data{Pointer_.index}.Retract,
            MaxTimeOverride_,
            NoWait_,
            "Retract";


        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_SuctionON(\gripper pointer,\switch NoWait|num MaxTimeOverride
        \switch keepLocked)
        VAR gripper Pointer_;
        VAR num MaxTimeOverride_:=0;
        VAR bool NoWait_:=FALSE;


        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        IF Present(NoWait) NoWait_:=TRUE;
        IF Present(MaxTimeOverride) MaxTimeOverride_:=MaxTimeOverride;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Action
        ExecuteBinaryOperation
            RNL_gripper_data{Pointer_.index}.SuctionON,
            MaxTimeOverride_,
            NoWait_,
            "SuctionON";


        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_SuctionOFF(\gripper pointer,\switch NoWait|num MaxTimeOverride
        \switch keepLocked)
        VAR gripper Pointer_;
        VAR num MaxTimeOverride_:=0;
        VAR bool NoWait_:=FALSE;


        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        IF Present(NoWait) NoWait_:=TRUE;
        IF Present(MaxTimeOverride) MaxTimeOverride_:=MaxTimeOverride;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Action
        ExecuteBinaryOperation
            RNL_gripper_data{Pointer_.index}.SuctionOFF,
            MaxTimeOverride_,
            NoWait_,
            "SuctionOFF";


        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_BlowoffON(\gripper pointer,\switch NoWait|num MaxTimeOverride
        \switch keepLocked)
        VAR gripper Pointer_;
        VAR num MaxTimeOverride_:=0;
        VAR bool NoWait_:=FALSE;


        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        IF Present(NoWait) NoWait_:=TRUE;
        IF Present(MaxTimeOverride) MaxTimeOverride_:=MaxTimeOverride;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Action
        ExecuteBinaryOperation
            RNL_gripper_data{Pointer_.index}.BlowoffON,
            MaxTimeOverride_,
            NoWait_,
            "BlowoffON";


        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_BlowoffOFF(\gripper pointer,\switch NoWait|num MaxTimeOverride
        \switch keepLocked)
        VAR gripper Pointer_;
        VAR num MaxTimeOverride_:=0;
        VAR bool NoWait_:=FALSE;


        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        IF Present(NoWait) NoWait_:=TRUE;
        IF Present(MaxTimeOverride) MaxTimeOverride_:=MaxTimeOverride;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Action
        ExecuteBinaryOperation
            RNL_gripper_data{Pointer_.index}.BlowoffOFF,
            MaxTimeOverride_,
            NoWait_,
            "BlowoffOFF";


        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC




    !===============
    !Exposed Questions
    !===============
    FUNC bool gripper_IsQuestion(\gripper pointer\switch keepLocked)
        VAR gripper pointer_;
        VAR bool returnValue;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        returnValue:=IsQuestion(pointer_);

        IF NOT Present(keepLocked) unLockModule;

        RETURN returnValue;

    ENDFUNC

    LOCAL FUNC bool IsQuestion(gripper pointer)

    ENDFUNC

    !===========================================================================
    !Exposed Getters and Setters
    !===========================================================================
    !===============
    !Exposed Setters
    !===============
    PROC gripper_Set_Data(\gripper Pointer,gripper_data data\switch keepLocked)
        VAR gripper Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        RNL_gripper_data{pointer_.index}:=data;

        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_set_gripInData(\gripper Pointer,
        \string DO_Normal_name
        \string DO_Inverted_name
        \string DI_Normal_name
        \string DI_Inverted_name
        \num maxWaitTime

        \switch keepLocked)
        VAR gripper Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        IF Present(DO_Normal_name) RNL_gripper_data{pointer_.index}.in.DO_Normal:=DO_Normal_name;
        IF Present(DO_Inverted_name) RNL_gripper_data{pointer_.index}.in.DO_Inverted:=DO_Inverted_name;
        IF Present(DI_Normal_name) RNL_gripper_data{pointer_.index}.in.DI_Normal:=DI_Normal_name;
        IF Present(DI_Inverted_name) RNL_gripper_data{pointer_.index}.in.DI_Inverted:=DI_Inverted_name;
        IF Present(maxWaitTime) RNL_gripper_data{pointer_.index}.in.maxWaitTime:=maxWaitTime;

        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_set_gripOutData(\gripper Pointer,
        \string DO_Normal_name
        \string DO_Inverted_name
        \string DI_Normal_name
        \string DI_Inverted_name
        \num maxWaitTime

        \switch keepLocked)
        VAR gripper Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        IF Present(DO_Normal_name) RNL_gripper_data{pointer_.index}.out.DO_Normal:=DO_Normal_name;
        IF Present(DO_Inverted_name) RNL_gripper_data{pointer_.index}.out.DO_Inverted:=DO_Inverted_name;
        IF Present(DI_Normal_name) RNL_gripper_data{pointer_.index}.out.DI_Normal:=DI_Normal_name;
        IF Present(DI_Inverted_name) RNL_gripper_data{pointer_.index}.out.DI_Inverted:=DI_Inverted_name;
        IF Present(maxWaitTime) RNL_gripper_data{pointer_.index}.out.maxWaitTime:=maxWaitTime;

        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_set_gripInGripOutData(\gripper Pointer,
        \string DO_Normal_name
        \string DO_Inverted_name
        \string DI_Normal_name
        \string DI_Inverted_name
        \num maxWaitTime

        \switch keepLocked)
        VAR gripper Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        IF Present(DO_Normal_name) RNL_gripper_data{pointer_.index}.in.DO_Normal:=DO_Normal_name;
        IF Present(DO_Inverted_name) RNL_gripper_data{pointer_.index}.in.DO_Inverted:=DO_Inverted_name;
        IF Present(DI_Normal_name) RNL_gripper_data{pointer_.index}.in.DI_Normal:=DI_Normal_name;
        IF Present(DI_Inverted_name) RNL_gripper_data{pointer_.index}.in.DI_Inverted:=DI_Inverted_name;
        IF Present(maxWaitTime) RNL_gripper_data{pointer_.index}.in.maxWaitTime:=maxWaitTime;

        IF Present(DO_Normal_name) RNL_gripper_data{pointer_.index}.out.DO_Normal:=DO_Inverted_name;
        IF Present(DO_Inverted_name) RNL_gripper_data{pointer_.index}.out.DO_Inverted:=DO_Normal_name;
        IF Present(DI_Normal_name) RNL_gripper_data{pointer_.index}.out.DI_Normal:=DI_Inverted_name;
        IF Present(DI_Inverted_name) RNL_gripper_data{pointer_.index}.out.DI_Inverted:=DI_Normal_name;
        IF Present(maxWaitTime) RNL_gripper_data{pointer_.index}.out.maxWaitTime:=maxWaitTime;


        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_set_openData(\gripper Pointer,
        \string DO_Normal_name
        \string DO_Inverted_name
        \string DI_Normal_name
        \string DI_Inverted_name
        \num maxWaitTime

        \switch keepLocked)
        VAR gripper Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        IF Present(DO_Normal_name) RNL_gripper_data{pointer_.index}.open.DO_Normal:=DO_Normal_name;
        IF Present(DO_Inverted_name) RNL_gripper_data{pointer_.index}.open.DO_Inverted:=DO_Inverted_name;
        IF Present(DI_Normal_name) RNL_gripper_data{pointer_.index}.open.DI_Normal:=DI_Normal_name;
        IF Present(DI_Inverted_name) RNL_gripper_data{pointer_.index}.open.DI_Inverted:=DI_Inverted_name;
        IF Present(maxWaitTime) RNL_gripper_data{pointer_.index}.open.maxWaitTime:=maxWaitTime;

        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_set_closeData(\gripper Pointer,
        \string DO_Normal_name
        \string DO_Inverted_name
        \string DI_Normal_name
        \string DI_Inverted_name
        \num maxWaitTime

        \switch keepLocked)
        VAR gripper Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        IF Present(DO_Normal_name) RNL_gripper_data{pointer_.index}.close.DO_Normal:=DO_Normal_name;
        IF Present(DO_Inverted_name) RNL_gripper_data{pointer_.index}.close.DO_Inverted:=DO_Inverted_name;
        IF Present(DI_Normal_name) RNL_gripper_data{pointer_.index}.close.DI_Normal:=DI_Normal_name;
        IF Present(DI_Inverted_name) RNL_gripper_data{pointer_.index}.close.DI_Inverted:=DI_Inverted_name;
        IF Present(maxWaitTime) RNL_gripper_data{pointer_.index}.close.maxWaitTime:=maxWaitTime;

        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_set_OpenCloseData(\gripper Pointer,
        \string DO_Normal_name
        \string DO_Inverted_name
        \string DI_Normal_name
        \string DI_Inverted_name
        \num maxWaitTime

        \switch keepLocked)
        VAR gripper Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        IF Present(DO_Normal_name) RNL_gripper_data{pointer_.index}.open.DO_Normal:=DO_Normal_name;
        IF Present(DO_Inverted_name) RNL_gripper_data{pointer_.index}.open.DO_Inverted:=DO_Inverted_name;
        IF Present(DI_Normal_name) RNL_gripper_data{pointer_.index}.open.DI_Normal:=DI_Normal_name;
        IF Present(DI_Inverted_name) RNL_gripper_data{pointer_.index}.open.DI_Inverted:=DI_Inverted_name;
        IF Present(maxWaitTime) RNL_gripper_data{pointer_.index}.open.maxWaitTime:=maxWaitTime;

        IF Present(DO_Normal_name) RNL_gripper_data{pointer_.index}.close.DO_Normal:=DO_Inverted_name;
        IF Present(DO_Inverted_name) RNL_gripper_data{pointer_.index}.close.DO_Inverted:=DO_Normal_name;
        IF Present(DI_Normal_name) RNL_gripper_data{pointer_.index}.close.DI_Normal:=DI_Inverted_name;
        IF Present(DI_Inverted_name) RNL_gripper_data{pointer_.index}.close.DI_Inverted:=DI_Normal_name;
        IF Present(maxWaitTime) RNL_gripper_data{pointer_.index}.close.maxWaitTime:=maxWaitTime;


        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_set_extendData(\gripper Pointer,
        \string DO_Normal_name
        \string DO_Inverted_name
        \string DI_Normal_name
        \string DI_Inverted_name
        \num maxWaitTime

        \switch keepLocked)
        VAR gripper Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        IF Present(DO_Normal_name) RNL_gripper_data{pointer_.index}.extend.DO_Normal:=DO_Normal_name;
        IF Present(DO_Inverted_name) RNL_gripper_data{pointer_.index}.extend.DO_Inverted:=DO_Inverted_name;
        IF Present(DI_Normal_name) RNL_gripper_data{pointer_.index}.extend.DI_Normal:=DI_Normal_name;
        IF Present(DI_Inverted_name) RNL_gripper_data{pointer_.index}.extend.DI_Inverted:=DI_Inverted_name;
        IF Present(maxWaitTime) RNL_gripper_data{pointer_.index}.extend.maxWaitTime:=maxWaitTime;

        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_set_retractData(\gripper Pointer,
        \string DO_Normal_name
        \string DO_Inverted_name
        \string DI_Normal_name
        \string DI_Inverted_name
        \num maxWaitTime

        \switch keepLocked)
        VAR gripper Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        IF Present(DO_Normal_name) RNL_gripper_data{pointer_.index}.retract.DO_Normal:=DO_Normal_name;
        IF Present(DO_Inverted_name) RNL_gripper_data{pointer_.index}.retract.DO_Inverted:=DO_Inverted_name;
        IF Present(DI_Normal_name) RNL_gripper_data{pointer_.index}.retract.DI_Normal:=DI_Normal_name;
        IF Present(DI_Inverted_name) RNL_gripper_data{pointer_.index}.retract.DI_Inverted:=DI_Inverted_name;
        IF Present(maxWaitTime) RNL_gripper_data{pointer_.index}.retract.maxWaitTime:=maxWaitTime;

        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_set_ExtendRetractData(\gripper Pointer,
        \string DO_Normal_name
        \string DO_Inverted_name
        \string DI_Normal_name
        \string DI_Inverted_name
        \num maxWaitTime

        \switch keepLocked)
        VAR gripper Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        IF Present(DO_Normal_name) RNL_gripper_data{pointer_.index}.extend.DO_Normal:=DO_Normal_name;
        IF Present(DO_Inverted_name) RNL_gripper_data{pointer_.index}.extend.DO_Inverted:=DO_Inverted_name;
        IF Present(DI_Normal_name) RNL_gripper_data{pointer_.index}.extend.DI_Normal:=DI_Normal_name;
        IF Present(DI_Inverted_name) RNL_gripper_data{pointer_.index}.extend.DI_Inverted:=DI_Inverted_name;
        IF Present(maxWaitTime) RNL_gripper_data{pointer_.index}.extend.maxWaitTime:=maxWaitTime;

        IF Present(DO_Normal_name) RNL_gripper_data{pointer_.index}.retract.DO_Normal:=DO_Inverted_name;
        IF Present(DO_Inverted_name) RNL_gripper_data{pointer_.index}.retract.DO_Inverted:=DO_Normal_name;
        IF Present(DI_Normal_name) RNL_gripper_data{pointer_.index}.retract.DI_Normal:=DI_Inverted_name;
        IF Present(DI_Inverted_name) RNL_gripper_data{pointer_.index}.retract.DI_Inverted:=DI_Normal_name;
        IF Present(maxWaitTime) RNL_gripper_data{pointer_.index}.retract.maxWaitTime:=maxWaitTime;


        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_set_suctionONData(\gripper Pointer,
        \string DO_Normal_name
        \string DO_Inverted_name
        \string DI_Normal_name
        \string DI_Inverted_name
        \num maxWaitTime

        \switch keepLocked)
        VAR gripper Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        IF Present(DO_Normal_name) RNL_gripper_data{pointer_.index}.suctionON.DO_Normal:=DO_Normal_name;
        IF Present(DO_Inverted_name) RNL_gripper_data{pointer_.index}.suctionON.DO_Inverted:=DO_Inverted_name;
        IF Present(DI_Normal_name) RNL_gripper_data{pointer_.index}.suctionON.DI_Normal:=DI_Normal_name;
        IF Present(DI_Inverted_name) RNL_gripper_data{pointer_.index}.suctionON.DI_Inverted:=DI_Inverted_name;
        IF Present(maxWaitTime) RNL_gripper_data{pointer_.index}.suctionON.maxWaitTime:=maxWaitTime;

        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_set_suctionOFFData(\gripper Pointer,
        \string DO_Normal_name
        \string DO_Inverted_name
        \string DI_Normal_name
        \string DI_Inverted_name
        \num maxWaitTime

        \switch keepLocked)
        VAR gripper Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        IF Present(DO_Normal_name) RNL_gripper_data{pointer_.index}.suctionOFF.DO_Normal:=DO_Normal_name;
        IF Present(DO_Inverted_name) RNL_gripper_data{pointer_.index}.suctionOFF.DO_Inverted:=DO_Inverted_name;
        IF Present(DI_Normal_name) RNL_gripper_data{pointer_.index}.suctionOFF.DI_Normal:=DI_Normal_name;
        IF Present(DI_Inverted_name) RNL_gripper_data{pointer_.index}.suctionOFF.DI_Inverted:=DI_Inverted_name;
        IF Present(maxWaitTime) RNL_gripper_data{pointer_.index}.suctionOFF.maxWaitTime:=maxWaitTime;

        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC


    PROC gripper_set_SuctionONOFFData(\gripper Pointer,
        \string DO_Normal_name
        \string DO_Inverted_name
        \string DI_Normal_name
        \string DI_Inverted_name
        \num maxWaitTime

        \switch keepLocked)
        VAR gripper Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        IF Present(DO_Normal_name) RNL_gripper_data{pointer_.index}.suctionOn.DO_Normal:=DO_Normal_name;
        IF Present(DO_Inverted_name) RNL_gripper_data{pointer_.index}.suctionOn.DO_Inverted:=DO_Inverted_name;
        IF Present(DI_Normal_name) RNL_gripper_data{pointer_.index}.suctionOn.DI_Normal:=DI_Normal_name;
        IF Present(DI_Inverted_name) RNL_gripper_data{pointer_.index}.suctionOn.DI_Inverted:=DI_Inverted_name;
        IF Present(maxWaitTime) RNL_gripper_data{pointer_.index}.suctionOn.maxWaitTime:=maxWaitTime;

        IF Present(DO_Normal_name) RNL_gripper_data{pointer_.index}.suctionOFF.DO_Normal:=DO_Inverted_name;
        IF Present(DO_Inverted_name) RNL_gripper_data{pointer_.index}.suctionOFF.DO_Inverted:=DO_Normal_name;
        IF Present(DI_Normal_name) RNL_gripper_data{pointer_.index}.suctionOFF.DI_Normal:=DI_Inverted_name;
        IF Present(DI_Inverted_name) RNL_gripper_data{pointer_.index}.suctionOFF.DI_Inverted:=DI_Normal_name;
        IF Present(maxWaitTime) RNL_gripper_data{pointer_.index}.suctionOFF.maxWaitTime:=maxWaitTime;


        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_set_blowoffONData(\gripper Pointer,
        \string DO_Normal_name
        \string DO_Inverted_name
        \string DI_Normal_name
        \string DI_Inverted_name
        \num maxWaitTime

        \switch keepLocked)
        VAR gripper Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        IF Present(DO_Normal_name) RNL_gripper_data{pointer_.index}.blowoffON.DO_Normal:=DO_Normal_name;
        IF Present(DO_Inverted_name) RNL_gripper_data{pointer_.index}.blowoffON.DO_Inverted:=DO_Inverted_name;
        IF Present(DI_Normal_name) RNL_gripper_data{pointer_.index}.blowoffON.DI_Normal:=DI_Normal_name;
        IF Present(DI_Inverted_name) RNL_gripper_data{pointer_.index}.blowoffON.DI_Inverted:=DI_Inverted_name;
        IF Present(maxWaitTime) RNL_gripper_data{pointer_.index}.blowoffON.maxWaitTime:=maxWaitTime;

        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    PROC gripper_set_blowoffOFFData(\gripper Pointer,
        \string DO_Normal_name
        \string DO_Inverted_name
        \string DI_Normal_name
        \string DI_Inverted_name
        \num maxWaitTime

        \switch keepLocked)
        VAR gripper Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        IF Present(DO_Normal_name) RNL_gripper_data{pointer_.index}.blowoffOFF.DO_Normal:=DO_Normal_name;
        IF Present(DO_Inverted_name) RNL_gripper_data{pointer_.index}.blowoffOFF.DO_Inverted:=DO_Inverted_name;
        IF Present(DI_Normal_name) RNL_gripper_data{pointer_.index}.blowoffOFF.DI_Normal:=DI_Normal_name;
        IF Present(DI_Inverted_name) RNL_gripper_data{pointer_.index}.blowoffOFF.DI_Inverted:=DI_Inverted_name;
        IF Present(maxWaitTime) RNL_gripper_data{pointer_.index}.blowoffOFF.maxWaitTime:=maxWaitTime;

        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC


    PROC gripper_set_BlowoffONOFFData(\gripper Pointer,
        \string DO_Normal_name
        \string DO_Inverted_name
        \string DI_Normal_name
        \string DI_Inverted_name
        \num maxWaitTime

        \switch keepLocked)
        VAR gripper Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        IF Present(DO_Normal_name) RNL_gripper_data{pointer_.index}.blowoffON.DO_Normal:=DO_Normal_name;
        IF Present(DO_Inverted_name) RNL_gripper_data{pointer_.index}.blowoffON.DO_Inverted:=DO_Inverted_name;
        IF Present(DI_Normal_name) RNL_gripper_data{pointer_.index}.blowoffON.DI_Normal:=DI_Normal_name;
        IF Present(DI_Inverted_name) RNL_gripper_data{pointer_.index}.blowoffON.DI_Inverted:=DI_Inverted_name;
        IF Present(maxWaitTime) RNL_gripper_data{pointer_.index}.blowoffON.maxWaitTime:=maxWaitTime;

        IF Present(DO_Normal_name) RNL_gripper_data{pointer_.index}.blowoffOFF.DO_Normal:=DO_Inverted_name;
        IF Present(DO_Inverted_name) RNL_gripper_data{pointer_.index}.suctionOFF.DO_Inverted:=DO_Normal_name;
        IF Present(DI_Normal_name) RNL_gripper_data{pointer_.index}.suctionOFF.DI_Normal:=DI_Inverted_name;
        IF Present(DI_Inverted_name) RNL_gripper_data{pointer_.index}.suctionOFF.DI_Inverted:=DI_Normal_name;
        IF Present(maxWaitTime) RNL_gripper_data{pointer_.index}.suctionOFF.maxWaitTime:=maxWaitTime;


        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    !===============
    !Exposed Getters
    !===============
    FUNC gripper_data gripper_Get_Data(\gripper Pointer\switch keepLocked)
        VAR gripper pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        RETURN RNL_gripper_data{pointer_.index};

        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDFUNC

ENDMODULE