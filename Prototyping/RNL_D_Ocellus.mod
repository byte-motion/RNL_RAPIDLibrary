MODULE RNL_D_Ocellus


    !===========================================================================
    !RECORD and ALIAS
    !===========================================================================

    !Object Pointer
    ALIAS virtualObjectPointer Ocellus;

    !===========================================================================
    !Data
    !===========================================================================    

    !===============
    !Buildt in Module Data
    ! DO NOT CHANGE!
    !===============

    !Default pointer when methods are called without a spesified pointer/object
    LOCAL PERS Ocellus DEFAULT_POINTER:=[0,1];

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

    CONST num RNL_X_Ocellus_CONSTANT_NUM:=0;
    PERS num RNL_X_Ocellus_n_persistantNum:=0;

    !===============
    !Task      - 
    !Instance LOCAL
    ! Data is not shared between any object instances
    ! Data is predefined with max number of instances
    ! To increase the max number of instances, increase the number
    !===============

    !Ocellus interface
    PERS num RNL_D_Ocellus_n_data{20};
    PERS item_Data RNL_D_Ocellus_itemOutBuff{20,10};

    !Ocellus Conveyor

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
            ErrWrite "Task: "+LockMaster+"has frozen in RNL_D_Ocellus","";
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
    FUNC gripper Ocellus_New(\switch persistant)
        <SMT>
    ENDFUNC

    !De-Allocates a virtual object from memory
    PROC Ocellus_Erase()
        <SMT>
    ENDPROC

    !Duplicates a virtual object in memory and returns a pointer the new object
    FUNC Ocellus Ocellus_Copy(Ocellus original)
        <SMT>
    ENDFUNC

    !===============
    !Scan Behaviours
    !===============

    !"Scan" Is called once every scan
    !delta is time since last scan, should stay < 0.5s
    PROC RNL_D_Ocellus_Scan(num delta)
        IF NOT ModuleIsReady() RETURN ;
        lockModule;

        <SMT>

        unlockModule;
    ENDPROC

    !"Init" Is called once when the module is initialized after "PP to Main"
    PROC RNL_X_Ocellus_Init()
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

    PROC Ocellus_ListActions()
        <SMT>
    ENDPROC

    !===============
    !Exposed Actions
    !===============
    PROC Ocellus_Action(\Ocellus Pointer)
        VAR Ocellus Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) Pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Action
        <SMT>

        unLockModule;

    ENDPROC


    PROC Ocellus_itemOutBuff_add(\ocellus pointer,item_Data itemToAdd,
        \switch keepLocked)
        VAR Ocellus pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        itemOutBuff_add pointer_,itemToAdd;

        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    LOCAL PROC itemOutBuff_add(ocellus pointer,item_Data itemToAdd)
        VAR item_Data item_Data_Temp;

        !Loop through output buffer and find where to add
        FOR i FROM 1 TO dim(RNL_D_Ocellus_itemOutBuff,2) DO
            IF RNL_D_Ocellus_itemOutBuff{Pointer.index,i}=RNL_D_ITEM_DATA_NULL THEN
                RNL_D_Ocellus_itemOutBuff{Pointer.index,i}:=itemToAdd;
                RETURN ;
            ENDIF
        ENDFOR

        !ERROR
        !Output Buffer Overflow

        !pop the oldest item from the buffer, and add this one again
        item_Data_Temp:=itemOutBuff_pop(pointer);
        itemOutBuff_add pointer,itemToAdd;

    ENDPROC

    PROC Ocellus_itemOutBuff_Reset(\ocellus pointer,\switch keepLocked)
        VAR Ocellus pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        itemOutBuff_Reset pointer_;

        IF NOT Present(keepLocked) unLockModule;

    ERROR
        RAISE ;
    ENDPROC

    LOCAL PROC itemOutBuff_Reset(ocellus pointer)
        VAR item_Data item_Data_Temp;

        !Loop through output buffer and set all entries to null
        FOR i FROM 1 TO dim(RNL_D_Ocellus_itemOutBuff,2) DO
            RNL_D_Ocellus_itemOutBuff{Pointer.index,i}:=RNL_D_ITEM_DATA_NULL;
        ENDFOR

    ENDPROC

    !===============
    !Exposed Questions
    !===============
    FUNC bool Ocellus_IsQuestion(\Ocellus Pointer\switch keepLocked)
        VAR Ocellus pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Question
        <SMT>

        IF NOT Present(keepLocked) unLockModule;

    ENDFUNC

    FUNC bool Ocellus_IsReady(\Ocellus Pointer\switch keepLocked)
        VAR Ocellus pointer_;
        VAR bool returnableBool;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Question
        <SMT>

        IF NOT Present(keepLocked) unLockModule;

        RETURN returnableBool;

    ENDFUNC

    FUNC item_data Ocellus_itemOutBuff_pop(\ocellus pointer\switch keepLocked)
        VAR Ocellus pointer_;
        VAR item_Data returnaValue;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        returnaValue:=itemOutBuff_pop(pointer_);

        IF NOT Present(keepLocked) unLockModule;

        RETURN returnaValue;

    ERROR
        RAISE ;
    ENDFUNC

    LOCAL FUNC item_data itemOutBuff_pop(ocellus pointer)
        VAR item_Data returnaValue;

        IF RNL_D_Ocellus_itemOutBuff{Pointer.index,1}<>RNL_D_ITEM_DATA_NULL THEN
            returnaValue:=RNL_D_Ocellus_itemOutBuff{Pointer.index,1};
        ELSE
            !ERROR
        ENDIF

        !Shift the output buffer down one
        FOR i FROM 1 TO dim(RNL_D_Ocellus_itemOutBuff,2)-1 DO
            RNL_D_Ocellus_itemOutBuff{Pointer.index,i}
            :=RNL_D_Ocellus_itemOutBuff{Pointer.index,i+1};
        ENDFOR
        RNL_D_Ocellus_itemOutBuff{Pointer.index,dim(RNL_D_Ocellus_itemOutBuff,2)}
            :=RNL_D_ITEM_DATA_NULL;

        !Return
        RETURN returnaValue;

    ENDFUNC

    FUNC bool Ocellus_itemOutBuff_IsReady(\ocellus pointer\switch keepLocked)
        VAR Ocellus pointer_;
        VAR bool returnaValue;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        returnaValue:=itemOutBuff_IsReady(pointer_);

        IF NOT Present(keepLocked) unLockModule;

        RETURN returnaValue;

    ERROR
        RAISE ;
    ENDFUNC

    LOCAL FUNC bool itemOutBuff_IsReady(ocellus pointer)

        IF RNL_D_Ocellus_itemOutBuff{Pointer.index,1}<>RNL_D_ITEM_DATA_NULL
            RETURN TRUE;

        RETURN FALSE;

    ENDFUNC

    !===========================================================================
    !Exposed Getters and Setters
    !===========================================================================

    !===============
    !Exposed Setters
    !===============
    PROC Ocellus_Set_Data(\Ocellus Pointer,num data)
        VAR Ocellus Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) Pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !RNL_X_ExDr_n_data{pointer_.index}:=data;

        unLockModule;

    ENDPROC
    

    !===============
    !Exposed Getters
    !===============
    FUNC num Ocellus_Get_Data(\Ocellus Pointer)
        VAR Ocellus pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !RETURN RNL_X_ExDr_n_data{pointer_.index};

        unLockModule;

    ENDFUNC
    
    FUNC item_Data Ocellus_get_NextItemData(\Ocellus Pointer \switch keepLocked)
        VAR Ocellus pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;
        
        RETURN get_NextItemData(pointer_);

        IF NOT Present(keepLocked) unLockModule;

    ENDFUNC
    
    LOCAL FUNC item_Data get_NextItemData(Ocellus Pointer)

        RETURN itemOutBuff_pop(Pointer);

    ENDFUNC
    
    

ENDMODULE