MODULE RNL_D_ExampleDriver


    !===========================================================================
    !RECORD and ALIAS
    !===========================================================================

    !Object Pointer
    ALIAS virtualObjectPointer exampledriver;

    RECORD exampledriver_data
        num example;
    ENDRECORD

    !===========================================================================
    !Data
    !===========================================================================    

    !===============
    !Buildt in Module Data
    ! DO NOT CHANGE!
    !===============

    !Default pointer when methods are called without a spesified pointer/object
    LOCAL PERS exampledriver DEFAULT_POINTER:=[0,1];

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

    LOCAL PERS num RNL_D_exampledriver_n_localNum:=0;

    !===============
    !Task     GLOBAL 
    !Instance GLOBAL
    ! Data is shared across all object instances in all task
    !===============

    CONST num RNL_D_ExDr_CONSTANT_NUM:=0;
    PERS num RNL_X_ExDr_n_persistantNum:=0;

    !===============
    !Task      - 
    !Instance LOCAL
    ! Data is not shared between any object instances
    ! Data is predefined with max number of instances
    ! To increase the max number of instances, increase the number
    !===============

    PERS exampledriver_data RNL_exampledriver_data{20};

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
            ErrWrite "Task: "+LockMaster+" has frozen in RNL_D_ExampleDriver","";
            <SMT>
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

    LOCAL FUNC bool PointerIsValid(exampledriver Pointer)
                        
        !check that type and index is within limits
        IF pointer.Type <> DEFAULT_POINTER.type RETURN FALSE; 
        IF pointer.Index < 1 RETURN FALSE; 
        IF pointer.Index > Dim(RNL_exampledriver_data,1) RETURN FALSE; 
        
        !Check that pointer is registered in Virtual Object Manager
        IF NOT pointer_isValid(Pointer) RETURN FALSE; 
        
        RETURN TRUE;
        
    ENDFUNC

    LOCAL FUNC bool PointerIsAvailable(exampledriver Pointer)
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
    FUNC exampledriver ExampleDriver_New(
        \string name
        \switch persistant
         \switch keepLocked
        )

        VAR string name_;
        VAR bool persistant_:=FALSE;
        VAR virtualObjectType type_;
        VAR virtualObjectPointer Pointer;
        VAR exampledriver_data data;


        name_:="Unnamed Example";
        IF Present(name) name_:=name;

        IF Present(persistant) persistant_:=TRUE;

        waitUntilModuleIsReady;
        lockModule;

        update;
        !Change this to reflext the Object type
        type_:=OBJECT_TYPE_GENERIC;

        DEFAULT_POINTER.type:=type_;

        !Get pointer
        Pointer:=virtualObjectManager_New(
        \name:=name_
        \persistant:=persistant_
        \type:=type_
        \maxIndex:=Dim(RNL_exampledriver_data,1)
        );

        !Reset object data
        RNL_exampledriver_data{Pointer.index}:=data;

        IF NOT Present(keepLocked) unLockModule;
        
        !Return pointer
        RETURN Pointer;

    ENDFUNC

    !De-Allocates a virtual object from memory
    PROC ExampleDriver_Erase(exampledriver Pointer\switch keepLocked)
        VAR exampledriver_data data;
        VAR exampledriver Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF
        waitUntilModuleIsReady;
        lockModule;

        update;

        !Reset object data
        RNL_exampledriver_data{Pointer_.index}:=data;

        IF NOT Present(keepLocked) unLockModule;
    ENDPROC

    !Duplicates a virtual object in memory and returns a pointer the new object
    FUNC exampledriver ExampleDriver_Copy(exampledriver original\switch keepLocked)
        <SMT>
    ENDFUNC

    !===============
    !Scan Behaviours
    !===============

    !"Scan" Is called once every scan
    !delta is time since last scan, should stay < 0.5s
    PROC RNL_X_ExampleDriver_Scan(num delta)
        IF NOT ModuleIsReady() RETURN ;
        lockModule;

        <SMT>

        unlockModule;
    ENDPROC

    !"Init" Is called once when the module is initialized after "PP to Main"
    PROC RNL_X_ExampleDriver_Init()
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

    LOCAL PROC <ID>()
        <SMT>
    ENDPROC

    LOCAL FUNC <ID><ID>()
        <SMT>
    ENDFUNC

    !===========================================================================
    !Exposed Actions and Questions
    !===========================================================================

    PROC ExampleDriver_ListActions()
        <SMT>
    ENDPROC

    !===============
    !Exposed Actions
    !===============
    PROC ExampleDriver_action(\exampledriver pointer\switch keepLocked)
        VAR exampledriver Pointer_;

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

    LOCAL PROC Action(exampledriver pointer)

    ENDPROC

    !===============
    !Exposed Questions
    !===============
    FUNC bool ExampleDriver_isQuestion(\exampledriver pointer\switch keepLocked)
        VAR exampledriver pointer_;
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

    ERROR
        RAISE ;
    ENDFUNC

    LOCAL FUNC bool IsQuestion(exampledriver pointer)

    ENDFUNC

    !===========================================================================
    !Exposed Getters and Setters
    !===========================================================================

    !===============
    !Exposed Setters
    !===============
    PROC ExampleDriver_set_Data(\exampledriver Pointer,exampledriver_data data\switch keepLocked)
        VAR exampledriver Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Set Data
        RNL_exampledriver_data{pointer_.index}:=data;

        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    !===============
    !Exposed Getters
    !===============
    FUNC exampledriver_data ExampleDriver_get_Data(\exampledriver Pointer\switch keepLocked)
        VAR exampledriver pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) THEN
            pointer_:=Pointer;
            IF NOT PointerIsValid(pointer_) RAISE ERR_BADPOINTER;
        ENDIF

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Get Data
        RETURN RNL_exampledriver_data{pointer_.index};

        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDFUNC

ENDMODULE