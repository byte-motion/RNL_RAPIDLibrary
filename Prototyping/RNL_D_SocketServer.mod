MODULE RNL_D_SocketServer


    !===========================================================================
    !RECORD and ALIAS
    !===========================================================================

    !Object Pointer
    ALIAS virtualObjectPointer SocketServer;

    !===========================================================================
    !Data
    !===========================================================================    

    !===============
    !Buildt in Module Data
    ! DO NOT CHANGE!
    !===============

    !Default pointer when methods are called without a spesified pointer/object
    LOCAL CONST SocketServer DEFAULT_POINTER:=[0,0];


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

    LOCAL PERS num RNL_X_ExDr_n_localNum:=0;

    !===============
    !Task     GLOBAL 
    !Instance GLOBAL
    ! Data is shared across all object instances in all task
    !===============

    CONST num RNL_X_SockSer_CONSTANT_NUM:=0;
    PERS num RNL_X_SockSer_n_persistantNum:=0;

    !===============
    !Task      - 
    !Instance LOCAL
    ! Data is not shared between any object instances
    ! Data is predefined with max number of instances
    ! To increase the max number of instances, increase the number
    !===============

    PERS num RNL_X_SockSer_n_data{20};

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
            ErrWrite "Task: "+LockMaster+"has frozen in RNL_D_SocketServer","";
            <SMT>
        ENDIF
    ENDPROC


    !Called to lock the module from beeing accessed when executing
    LOCAL PROC lockModule(\string MasterName)
        VAR string MasterName_;
        
        MasterName_ := GetTaskName();
        IF Present(MasterName) MasterName := MasterName;
        
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
    
    LOCAL FUNC bool PointerISValid()
        <SMT>
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
    FUNC gripper SocketServer_New(\switch persistant)
        <SMT>
    ENDFUNC

    !De-Allocates a virtual object from memory
    PROC SocketServer_Erase()
        <SMT>
    ENDPROC

    !Duplicates a virtual object in memory and returns a pointer the new object
    FUNC SocketServer SocketServer_Copy(SocketServer original)
        <SMT>
    ENDFUNC

    !===============
    !Scan Behaviours
    !===============

    !"Scan" Is called once every scan
    !delta is time since last scan, should stay < 0.5s
    PROC RNL_X_SocketServer_Scan(num delta)
        IF NOT ModuleIsReady() RETURN;
        lockModule;
        
        <SMT>
        
        unlockModule;
    ENDPROC
    
    !"Init" Is called once when the module is initialized after "PP to Main"
    PROC RNL_X_SocketServer_Init()
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

    PROC SocketServer_ListActions()
        <SMT>
    ENDPROC
    
    !===============
    !Exposed Actions
    !===============
    PROC SocketServer_Action(\SocketServer Pointer)
        VAR SocketServer Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) Pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;
        
        update;

        !Action
        <SMT>

        unLockModule;

    ENDPROC

    !===============
    !Exposed Questions
    !===============
    FUNC bool SocketServer_IsQuestion(\SocketServer Pointer)
        VAR SocketServer pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;
        
        update;

        !Question
        <SMT>

        unLockModule;

    ENDFUNC

    !===========================================================================
    !Exposed Getters and Setters
    !===========================================================================

    !===============
    !Exposed Getters
    !===============
    PROC SocketServer_Set_Data(\SocketServer Pointer,num data)
        VAR SocketServer Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) Pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;
        
        !RNL_X_ExDr_n_data{pointer_.index}:=data;

        unLockModule;

    ENDPROC

    !===============
    !Exposed Setters
    !===============
    FUNC num SocketServer_Get_Data(\SocketServer Pointer)
        VAR SocketServer pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;
        
        !RETURN RNL_X_ExDr_n_data{pointer_.index};

        unLockModule;

    ENDFUNC

ENDMODULE