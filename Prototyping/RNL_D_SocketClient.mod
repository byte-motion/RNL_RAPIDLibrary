MODULE RNL_D_SocketClient


    !===========================================================================
    !RECORD and ALIAS
    !===========================================================================

    !Object Pointer
    ALIAS virtualObjectPointer SocketClient;

    RECORD SocketClient_Data
        
     string IP;
     num Port;
     num Timeout;

    ENDRECORD
    !===========================================================================
    !Data
    !===========================================================================    

    !===============
    !Buildt in Module Data
    ! DO NOT CHANGE!
    !===============

    !Default pointer when methods are called without a spesified pointer/object
    LOCAL CONST SocketClient DEFAULT_POINTER:=[0,0];


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

    CONST num RNL_X_SockCli_CONSTANT_NUM:=0;
    PERS num RNL_X_SockCli_n_persistantNum:=0;

    PERS num RNL_D_SockCli_n_Timeout_Default:=10;

    !===============
    !Task      - 
    !Instance LOCAL
    ! Data is not shared between any object instances
    ! Data is predefined with max number of instances
    ! To increase the max number of instances, increase the number
    !===============

    PERS num RNL_X_SockCli_n_data{20};

    PERS SocketClient_Data RNL_D_SockCli_data{20};
!    PERS string RNL_D_SockCli_s_IP{20};
!    PERS num RNL_D_SockCli_n_Port{20};
!    PERS num RNL_D_SockCli_n_Timeout{20};
    VAR socketdev RNL_D_SockCli_socketDev{20};

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
            ErrWrite "Task: "+LockMaster+"has frozen in RNL_D_SocketClient","";
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
    FUNC gripper SocketClient_New(\switch persistant)
        <SMT>
    ENDFUNC

    !De-Allocates a virtual object from memory
    PROC SocketClient_Erase()
        <SMT>
    ENDPROC

    !Duplicates a virtual object in memory and returns a pointer the new object
    FUNC SocketClient SocketClient_Copy(SocketClient original)
        <SMT>
    ENDFUNC

    !===============
    !Scan Behaviours
    !===============

    !"Scan" Is called once every scan
    !delta is time since last scan, should stay < 0.5s
    PROC RNL_X_SocketClient_Scan(num delta)
        IF NOT ModuleIsReady() RETURN ;
        lockModule;

        <SMT>

        unlockModule;
    ENDPROC

    !"Init" Is called once when the module is initialized after "PP to Main"
    PROC RNL_X_SocketClient_Init()
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

    PROC SocketClient_ListActions()
        <SMT>
    ENDPROC

    !===============
    !Exposed Actions
    !===============
    PROC SocketClient_Action(\SocketClient Pointer)
        VAR SocketClient Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) Pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Action
        <SMT>

        unLockModule;

    ENDPROC

    PROC SocketClient_Connect(\SocketClient Pointer\num Maxtime)
        VAR SocketClient Pointer_;
        VAR num Maxtime_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) Pointer_:=Pointer;

        Maxtime_:=10;
        IF Present(Maxtime) Maxtime_:=Maxtime;


        waitUntilModuleIsReady;
        lockModule;

        update;

        !Disconect socket, and reconnect it
        SocketClose RNL_D_SockCli_socketDev{pointer_.index};
        SocketCreate RNL_D_SockCli_socketDev{pointer_.index};
        SocketConnect RNL_D_SockCli_socketDev{pointer_.index},
            RNL_D_SockCli_data{pointer_.index}.IP,
            RNL_D_SockCli_data{pointer_.index}.Port
            \Time:=Maxtime_;

        unLockModule;

    ENDPROC

    !===============
    !Exposed Questions
    !===============
    FUNC bool SocketClient_IsQuestion(\SocketClient Pointer)
        VAR SocketClient pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Question
        <SMT>

        unLockModule;

    ENDFUNC

    PROC SocketClient_RequestReply(\SocketClient Pointer,var rawbytes request,var rawbytes reply)
        VAR SocketClient pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Send request, and return reply
        SocketSend RNL_D_SockCli_socketDev{pointer_.index}\RawData :=request;
        SocketReceive RNL_D_SockCli_socketDev{pointer_.index}\RawData :=reply
            \Time:=RNL_D_SockCli_data{pointer_.index}.Timeout;

        unLockModule;

    ENDPROC

    !===========================================================================
    !Exposed Getters and Setters
    !===========================================================================

    !===============
    !Exposed Setters
    !===============

    PROC SocketClient_Set_Data(\SocketClient Pointer,num data)
        VAR SocketClient Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) Pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !RNL_X_ExDr_n_data{pointer_.index}:=data;

        unLockModule;

    ENDPROC

    PROC SocketClient_Set_IP(\SocketClient Pointer,string IP)
        VAR SocketClient Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) Pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        RNL_D_SockCli_data{pointer_.index}.IP:=IP;

        unLockModule;
    ENDPROC

    PROC SocketClient_Set_Port(\SocketClient Pointer,num port)
        VAR SocketClient Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) Pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        RNL_D_SockCli_data{pointer_.index}.Port:=port;

        unLockModule;
    ENDPROC

    PROC SocketClient_Set_Timeout(\SocketClient Pointer,num timeout)
        VAR SocketClient Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) Pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        RNL_D_SockCli_data{pointer_.index}.Timeout:=timeout;

        unLockModule;
    ENDPROC

    !===============
    !Exposed Getters
    !===============
    FUNC num SocketClient_Get_Data(\SocketClient Pointer)
        VAR SocketClient pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !RETURN RNL_X_ExDr_n_data{pointer_.index};

        unLockModule;

    ENDFUNC

    FUNC string SocketClient_Get_IP(\SocketClient Pointer)
        VAR SocketClient pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        RETURN RNL_D_SockCli_data{pointer_.index}.IP;

        unLockModule;

    ENDFUNC

    FUNC num SocketClient_Get_Port(\SocketClient Pointer)
        VAR SocketClient pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        RETURN RNL_D_SockCli_data{pointer_.index}.Port;

        unLockModule;

    ENDFUNC

    FUNC num SocketClient_Get_Timeout(\SocketClient Pointer)
        VAR SocketClient pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        RETURN RNL_D_SockCli_data{pointer_.index}.Timeout;

        unLockModule;

    ENDFUNC

ENDMODULE