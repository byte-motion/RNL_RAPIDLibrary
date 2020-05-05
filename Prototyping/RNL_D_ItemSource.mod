MODULE RNL_D_ItemSource
    !MODULE RNL_D_ItemSource


    !===========================================================================
    !RECORD and ALIAS
    !===========================================================================

    !Object Pointer
    ALIAS virtualObjectPointer ItemSource;

    RECORD ItemSource_Data
        virtualObjectPointer ItemSource;
        virtualObjectPointer Trigger;
        virtualObjectPointer Conveyor;
        string DI_Ready;
        string DI_Interupt;
    ENDRECORD

    !===========================================================================
    !Data
    !===========================================================================    

    !===============
    !Buildt in Module Data
    ! DO NOT CHANGE!
    !===============

    !Default pointer when methods are called without a spesified pointer/object
    LOCAL PERS ItemSource DEFAULT_POINTER:=[0,1];

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

    LOCAL PERS num RNL_D_ItemSource_n_localNum:=0;

    !===============
    !Task     GLOBAL 
    !Instance GLOBAL
    ! Data is shared across all object instances in all task
    !===============

    CONST num RNL_D_ItemSource_CONSTANT_NUM:=0;
    PERS num RNL_D_ItemSource_n_persistantNum:=0;

    !===============
    !Task      - 
    !Instance LOCAL
    ! Data is not shared between any object instances
    ! Data is predefined with max number of instances
    ! To increase the max number of instances, increase the number
    !===============

    PERS ItemSource_Data RNL_D_ItemSource_data{20};

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
            ErrWrite "Task: "+LockMaster+" has frozen in RNL_D_ItemSource","";
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
    FUNC ItemSource ItemSource_New(
        \string name
        \switch persistant
        )

        VAR string name_;
        VAR bool persistant_:=FALSE;
        VAR virtualObjectType type_;

        name_:="Unnamed Gripper";
        IF Present(name) name_:=name;

        IF Present(persistant) persistant_:=TRUE;

        !Change this to reflext the Object type
        type_:=OBJECT_TYPE_GENERIC;

        DEFAULT_POINTER.type:=type_;

        RETURN virtualObjectManager_New(
        \name:=name_
        \persistant:=persistant_
        \type:=type_);

    ENDFUNC

    !De-Allocates a virtual object from memory
    PROC ItemSource_Erase()
        <SMT>
    ENDPROC

    !Duplicates a virtual object in memory and returns a pointer the new object
    FUNC ItemSource ItemSource_Copy(ItemSource original)
        <SMT>
    ENDFUNC

    !===============
    !Scan Behaviours
    !===============

    !"Scan" Is called once every scan
    !delta is time since last scan, should stay < 0.5s
    PROC RNL_X_ItemSource_Scan(num delta)
        IF NOT ModuleIsReady() RETURN ;
        lockModule;

        <SMT>

        unlockModule;
    ENDPROC

    !"Init" Is called once when the module is initialized after "PP to Main"
    PROC RNL_X_ItemSource_Init()
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

    PROC ItemSource_ListActions()
        <SMT>
    ENDPROC

    !===============
    !Exposed Actions
    !===============
    PROC ItemSource_Action(\ItemSource Pointer\switch keepLocked)
        VAR ItemSource Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) Pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Action
        <SMT>

        IF NOT Present(keepLocked) unLockModule;

    ENDPROC

    !===============
    !Exposed Questions
    !===============
    FUNC bool ItemSource_IsQuestion(\ItemSource Pointer\switch keepLocked)
        VAR ItemSource pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Question
        <SMT>

        IF NOT Present(keepLocked) unLockModule;

    ENDFUNC

    !===========================================================================
    !Exposed Getters and Setters
    !===========================================================================

    !===============
    !Exposed Setter
    !===============
    PROC ItemSource_Set_Data(\ItemSource Pointer,num data\switch keepLocked)
        VAR ItemSource Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) Pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !RNL_X_ExDr_n_data{pointer_.index}:=data;

        IF NOT Present(keepLocked) unLockModule;

    ENDPROC


    !===============
    !Exposed Getter
    !===============
    FUNC num ItemSource_Get_Data(\ItemSource Pointer\switch keepLocked)
        VAR ItemSource pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !RETURN RNL_X_ExDr_n_data{pointer_.index};

        IF NOT Present(keepLocked) unLockModule;

    ENDFUNC

    FUNC item ItemSource_Get_NextItem(\ItemSource Pointer\switch keepLocked)
        VAR ItemSource pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        RETURN get_NextItem(Pointer);

        IF NOT Present(keepLocked) unLockModule;

    ENDFUNC
    
    LOCAL FUNC item get_NextItem(ItemSource Pointer)
 
        VAR item NewItemPointer;
        VAR item_data NewItemData;

        !Check if nextItem is ready
        
        !get next data
        NewItemData := get_NextItemData(Pointer);

        ! if item is on an conveyor, start tracking the item/conveyor
        IF pointer_isType(NewItemData.pos.parent \CONVEYOR) THEN
            conveyor_TrackItem \Pointer:=NewItemData.pos.parent \itemData:=NewItemData;
        ENDIF

        ! instanciate a new item object and return it
        NewItemPointer:=item_New(\name:=NewItemData.name\data:=NewItemData);

        RETURN NewItemPointer;
        
    ENDFUNC

    FUNC item_Data ItemSource_get_NextItemData(\ItemSource Pointer\switch keepLocked)
        VAR ItemSource pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        RETURN get_NextItemData(Pointer);

        IF NOT Present(keepLocked) unLockModule;

    ENDFUNC
    
    LOCAL FUNC item_Data get_NextItemData(ItemSource Pointer)
        
        VAR virtualObjectPointer UpstreamItemSourcePointer;
        UpstreamItemSourcePointer := RNL_D_ItemSource_data{Pointer.index}.ItemSource;
        
        !if Next item comes from another item source, call it
        IF pointer_isType(UpstreamItemSourcePointer \ITEMSOURCE) 
            RETURN get_NextItemData(Pointer);
        !Ocellus is also an item source
        IF pointer_isType(UpstreamItemSourcePointer \OCELLUS) 
            RETURN Ocellus_get_NextItemData(\Pointer:=Pointer);
        
        !if next item comes from a master item, use it
        IF pointer_isType(UpstreamItemSourcePointer \ITEM) 
            RETURN item_get_Data(\Pointer:=UpstreamItemSourcePointer);
            
    ENDFUNC


ENDMODULE