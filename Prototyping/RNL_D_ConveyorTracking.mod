MODULE RNL_D_ConveyorTracking
    !MODULE RNL_D_conveyor


    !===========================================================================
    !RECORD and ALIAS
    !===========================================================================

    !Object Pointer
    ALIAS virtualObjectPointer conveyor;

    !TrigVis - IOs determining the behaviour of the trigger outputs
    !on the conveyor tracking module.
    !DO_TrigAutoMode    - 1 -> AutoMode, 0 -> ManualMode
    !DO_TrigVis         - Manual triggering
    !GO_TrigAutoEncNo   - What encode to use for AutoMode
    !GO_TrigAutoDist    - Number of encoder counts per trigger
    RECORD conveyor_TrigVis
        string DO_TrigAutoMode;
        string DO_TrigVis;
        string GO_TrigAutoEncNo;
        string GO_TrigAutoDist;
    ENDRECORD

    !QueueAuto - IOs for interacting with the Automatic Queue
    !GI_ObjectsInQ  - Number of objects in Queue
    !DO_Rem1PObj    - Remove first object from Queue
    !DO_RemAllPObj  - Remove all objects from Queue
    !DO_DropWObj    - Stop tracking and remove object from Queue
    RECORD conveyor_QueueAuto
        string GI_ObjectsInQ;
        string DO_Rem1PObj;
        string DO_RemAllPObj;
        string DO_DropWObj;
    ENDRECORD

    !QueueManual - IOs for manually implemenitng queueing in RAPID
    !DO_PosInJobQ       - Auto/Manual queue mode selector. 1=Manual, 0=Auto
    !DI_NewObjStrobe    - Input for syncing/trigger new objects into the queue
    !GI_CntFromEnc      - Encoder Value of last triggered object
    !DO_CntToEncStr     - Strobe/Pulse to push GO_CntToEnc to active tracking memory
    !GO_CntToEnc        - encoder value to be pushed to active tracking memory
    RECORD conveyor_QueueManual
        string DO_PosInJobQ;
        string DI_NewObjStrobe;
        string GI_CntFromEnc;
        string DO_CntToEncStr;
        string GO_CntToEnc;
    ENDRECORD


    RECORD conveyor_Data

        string itemName;
        num itemCounter;
        num itemCounterRollOver;

        conveyor_TrigVis TrigVis;

        conveyor_QueueManual QueueManual;

        conveyor_QueueAuto QueueAuto;


        string DI_ScaleEncPuls;
        string DO_ForceJob;
        string DI_PassedStWin;
        string DI_DirOfTrave;
        string DI_Simulating;
        string DI_PowerUpStatus;
        string DO_SimMode;
        string DO_softSyncSig;
        string DO_softCheckSig;

        string DI_EncSelected;
        string DO_EncSelec;
        string DI_EncAFault;
        string DI_EncBFault;

    ENDRECORD


    ALIAS dnum encodervalue;

    !===========================================================================
    !Data
    !===========================================================================    

    !===============
    !Buildt in Module Data
    ! DO NOT CHANGE!
    !===============

    !Default pointer when methods are called without a spesified pointer/object
    LOCAL PERS conveyor DEFAULT_POINTER:=[0,1];

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

    CONST num RNL_X_traConv_CONSTANT_NUM:=0;
    PERS num RNL_X_traConv_n_persistantNum:=0;

    CONST conveyor_Data RNL_D_conveyor_DATA_NULL:=["",0,0,["","","",""],["","","","",""],["","","",""],"","","","","","","","","","","","",""];



    !===============
    !Task      - 
    !Instance LOCAL
    ! Data is not shared between any object instances
    ! Data is predefined with max number of instances
    ! To increase the max number of instances, increase the number
    !===============

    !PERS num RNL_X_conveyor_data{20};

    PERS conveyor_Data RNL_D_conveyor_Data{4};

    VAR intnum NewItemOnConveyor{4};

    PERS item_Data RNL_D_trakConv_itemOutBuff{4,20};





    !    !===============
    !    !Queue Handeling
    !    !===============
    !    PERS string RNL_D_conveyor_GI_ObjectsInQ{20};
    !    !Group input showing the number of objects in the object queue. These objects
    !    !have passed the synchronization switch but have not gone outside the start window.

    !    PERS string RNL_D_conveyor_DO_Rem1PObj{20};
    !    !Remove first pending object from the object queue. Setting this signal
    !    !will cause the first pending object to be dropped from the object queue.
    !    !Pending objects are objects that are in the queue but are not connected
    !    !to a work object.

    !    PERS string RNL_D_conveyor_DO_RemAllPObj{20};
    !    !Remove all pending objects. Setting this signal will empty all objects
    !    !from the object queue. If an object is connected, then it is not removed.

    !    PERS string RNL_D_conveyor_DO_DropWObj{20};
    !    !Setting this signal will drop the tracked object and disconnect that object.
    !    !The object is removed from the queue. This should not be set from
    !    !RAPID, use the DropWobj instruction instead.

    !    PERS string RNL_D_conveyor_DI_NewObjStrobe{20};
    !    !DI new position from the encoder to enter the job queue.
    !    PERS string RNL_D_conveyor_GI_CntFromEnc{20};
    !    !GI 32-bit counter value from encoder to main controller.

    !    PERS string RNL_D_conveyor_DO_CntToEncStr{20};
    !    !DO strobe for a 32-bit position to the conveyor work area from the job
    !    !queue.

    !    PERS string RNL_D_conveyor_GO_CntToEnc{20};
    !    !GO 32-bit counter value from main controller to encoder.

    !    PERS string RNL_D_conveyor_DI_ScaleEncPuls{20};
    !    !DI scaled-down encoder pulses.

    !    PERS string RNL_D_conveyor_DO_ForceJob{20};
    !    !DO run this job even if the checkpoint should fail.

    !    PERS string RNL_D_conveyor_DO_PosInJobQ{20};
    !    !DO send the position to MC to be stored in the job queue. 
    !    !(0 = Queuetracking disabled. Same mode as DSQC 354)

    !    PERS string RNL_D_conveyor_DI_PassedStWin{20};
    !    !DI notifies the main computer that an object has passed out of the start
    !    !window (object lost). If the main process is waiting in a WaitWObj instruction,
    !    !the program pointer will be moved to the nearest error handler, so
    !    !appropriate action can be taken, for example pop the job queue.

    !    PERS string RNL_D_conveyor_DI_EncSelected{20};
    !    !DI: 0 = Encoder A selected, 1= Encoder B selected

    !    PERS string RNL_D_conveyor_DI_EncAFault{20};
    !    !DI Encoder A Fault

    !    PERS string RNL_D_conveyor_DI_EncBFault{20};
    !    !DI Encoder B Fault

    !    PERS string RNL_D_conveyor_DI_DirOfTrave{20};
    !    !DI direction of travel

    !    PERS string RNL_D_conveyor_DI_Simulating{20};
    !    !DI simulating mode

    !    PERS string RNL_D_conveyor_DI_PowerUpStatus{20};
    !    !DI power up status: Counters have been lost.

    !    PERS string RNL_D_conveyor_DO_SimMode{20};
    !    ! DO puts the conveyor work area in to simulation mode

    !    PERS string RNL_D_conveyor_DO_softSyncSig{20};
    !    !DO soft-sync signal. Simulates Sync-input.

    !    PERS string RNL_D_conveyor_DO_softCheckSig{20};
    !    !DO soft-sync signal. Simulates Sync-input.

    !    PERS string RNL_D_conveyor_DO_EncSelec{20};
    !    !DO: 0 = Encoder A selected, 1 = Encoder B selected



    !    !===============
    !    !Vision trigger
    !    !===============
    !    PERS string RNL_D_conveyor_DO_TrigAutoMode{20};
    !    !DO for controlling vision trigger mode
    !    !the value 1 activates auto mode and 0 activates manual mode.

    !    PERS string RNL_D_conveyor_DO_TrigVis{20};
    !    !DO for manually triggering vision trigger output on CT module

    !    PERS string RNL_D_conveyor_GO_TrigAutoEncNo{20};
    !    !GO for Automatically triggering vision trigger output on CT module
    !    !Determines what encoder should be used (1,2,3, or 4)

    !    PERS string RNL_D_conveyor_GO_TrigAutoDist{20};
    !    !GO for Automatically triggering vision trigger output on CT module
    !    !Determines the number of encoder counts between each trigger
    !    !Trigger pulse width can be configured through RobotStudio

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
            ErrWrite "Task: "+LockMaster+" has frozen in RNL_D_conveyor","";

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
    FUNC conveyor conveyor_New(
        \string name
        \switch persistant
        )

        VAR string name_;
        VAR bool persistant_:=FALSE;
        VAR virtualObjectType type_;
        VAR virtualObjectPointer pointer;

        name_:="Unnamed Conveyor";
        IF Present(name) name_:=name;

        IF Present(persistant) persistant_:=TRUE;

        !Change this to reflext the Object type
        type_:=OBJECT_TYPE_D_CONVEYOR;

        DEFAULT_POINTER.type:=type_;

        pointer:=virtualObjectManager_New(
        \name:=name_
        \persistant:=persistant_
        \type:=type_);

        RNL_D_conveyor_Data{pointer.index}:=RNL_D_conveyor_DATA_NULL;

        RETURN pointer;

    ENDFUNC

    !De-Allocates a virtual object from memory
    PROC conveyor_Erase()
        <SMT>
    ENDPROC

    !Duplicates a virtual object in memory and returns a pointer the new object
    FUNC conveyor conveyor_Copy(conveyor original)
        <SMT>
    ENDFUNC

    !===============
    !Scan Behaviours
    !===============

    !"Scan" Is called once every scan
    !delta is time since last scan, should stay < 0.5s
    PROC RNL_X_conveyor_Scan(num delta)
        IF NOT ModuleIsReady() RETURN ;
        lockModule;

        <SMT>

        unlockModule;
    ENDPROC

    !"Init" Is called once when the module is initialized after "PP to Main"
    PROC RNL_X_conveyor_Init()
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
    !TRAP Behaviours
    !===========================================================================

    LOCAL TRAP ManualQueue_NewItemOnConveyor1
        ManualQueue_NewItemOnConveyor [DEFAULT_POINTER.type,1];
    ENDTRAP

    LOCAL TRAP ManualQueue_NewItemOnConveyor2
        ManualQueue_NewItemOnConveyor [DEFAULT_POINTER.type,2];
    ENDTRAP

    LOCAL TRAP ManualQueue_NewItemOnConveyor3
        ManualQueue_NewItemOnConveyor [DEFAULT_POINTER.type,3];
    ENDTRAP

    LOCAL TRAP ManualQueue_NewItemOnConveyor4
        ManualQueue_NewItemOnConveyor [DEFAULT_POINTER.type,4];
    ENDTRAP

    LOCAL TRAP ManualQueue_NewItemOnConveyor5
        ManualQueue_NewItemOnConveyor [DEFAULT_POINTER.type,5];
    ENDTRAP

    LOCAL TRAP ManualQueue_NewItemOnConveyor6
        ManualQueue_NewItemOnConveyor [DEFAULT_POINTER.type,6];
    ENDTRAP

    LOCAL TRAP ManualQueue_NewItemOnConveyor7
        ManualQueue_NewItemOnConveyor [DEFAULT_POINTER.type,7];
    ENDTRAP

    LOCAL TRAP ManualQueue_NewItemOnConveyor8
        ManualQueue_NewItemOnConveyor [DEFAULT_POINTER.type,8];
    ENDTRAP

    LOCAL TRAP ManualQueue_NewItemOnConveyor9
        ManualQueue_NewItemOnConveyor [DEFAULT_POINTER.type,9];
    ENDTRAP

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

    !Interrupt, Called when a item appears on the conveyor
    LOCAL PROC ManualQueue_NewItemOnConveyor(conveyor Pointer)
        VAR item_data itemOnConveyor;
        VAR string name;
        VAR encodervalue encoderVal;

        !Increase the item counter 
        Incr RNL_D_conveyor_Data{Pointer.index}.itemCounter;
        IF RNL_D_conveyor_Data{Pointer.index}.itemCounter
            >RNL_D_conveyor_Data{Pointer.index}.itemCounterRollOver
            THEN
            RNL_D_conveyor_Data{Pointer.index}.itemCounter:=1;
        ENDIF

        !save item counter to item
        itemOnConveyor.ID:=RNL_D_conveyor_Data{Pointer.index}.itemCounter;

        !Save encoder value to item:
        !encoderVal := GInputDnum(c1CntFromEnc);
        %"encoderVal := GInputDnum("
        +RNL_D_conveyor_Data{Pointer.index}.QueueManual.GI_CntFromEnc
        +")"%;
        itemOnConveyor.pos.encoderValue:=encoderVal;

        !set item parent to this instance of conveyor:
        itemOnConveyor.pos.parent:=Pointer;

        !Add item to the item output buffer
        itemOutBuff_add Pointer, itemOnConveyor;
        
    ENDPROC

    

    !===========================================================================
    !Exposed Actions and Questions
    !===========================================================================

    PROC conveyor_ListActions()
        <SMT>
    ENDPROC

    !===============
    !Exposed Actions
    !===============
    PROC conveyor_Action(\conveyor Pointer\switch keepLocked)
        VAR conveyor Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) Pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Action
        <SMT>

        IF NOT Present(keepLocked) unLockModule;

    ENDPROC
    
    PROC conveyor_TrackItem(\conveyor Pointer, \item itemPointer, \item_data itemData, 
        \switch keepLocked)
        VAR conveyor Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) Pointer_:=Pointer;
        

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Action
        IF Present(itemPointer) TrackItem Pointer \itemPointer:=itemPointer;
        IF Present(itemData) TrackItem Pointer \itemData:=itemData;

        IF NOT Present(keepLocked) unLockModule;

    ENDPROC
    
    PROC TrackItem(conveyor Pointer, \item itemPointer, \item_data itemData)
        
        IF Present(itemData) THEN
            set_TrackingEncVal Pointer, itemData.pos.encoderValue;
            RETURN;
        ENDIF
        
        IF Present(itemPointer) THEN
            set_TrackingEncVal Pointer, item_Get_encoderValue(\Pointer:= itemPointer);
            RETURN;
        ENDIF
        
        !ERROR
        
        
    ENDPROC
    
    

    PROC conveyor_itemOutBuff_add(\conveyor pointer,item_Data itemToAdd,
        \switch keepLocked)
        VAR conveyor pointer_;

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

    LOCAL PROC itemOutBuff_add(conveyor pointer,item_Data itemToAdd)
        VAR item_Data item_Data_Temp;

        !Loop through output buffer and find where to add
        FOR i FROM 1 TO dim(RNL_D_trakConv_itemOutBuff,2) DO
            IF RNL_D_trakConv_itemOutBuff{Pointer.index,i}=RNL_D_ITEM_DATA_NULL THEN
                RNL_D_trakConv_itemOutBuff{Pointer.index,i}:=itemToAdd;
                RETURN ;
            ENDIF
        ENDFOR

        !ERROR
        !Output Buffer Overflow

        !pop the oldest item from the buffer, and add this one again
        item_Data_Temp:=itemOutBuff_pop(pointer);
        itemOutBuff_add pointer,itemToAdd;

    ENDPROC


    !===============
    !Exposed Questions
    !===============
    FUNC bool conveyor_IsQuestion(\conveyor Pointer\switch keepLocked)
        VAR conveyor pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Question
        <SMT>

        IF NOT Present(keepLocked) unLockModule;

    ENDFUNC

    FUNC bool conveyor_itemOutBuff_IsReady(\conveyor pointer\switch keepLocked)
        VAR conveyor pointer_;
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

    LOCAL FUNC bool itemOutBuff_IsReady(conveyor pointer)

        IF RNL_D_trakConv_itemOutBuff{Pointer.index,1}<>RNL_D_ITEM_DATA_NULL
            RETURN TRUE;

        RETURN FALSE;

    ENDFUNC

    FUNC item_data conveyor_itemOutBuff_pop(\conveyor pointer\switch keepLocked)
        VAR conveyor pointer_;
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

    LOCAL FUNC item_data itemOutBuff_pop(conveyor pointer)
        VAR item_Data returnaValue;

        IF RNL_D_trakConv_itemOutBuff{Pointer.index,1}<>RNL_D_ITEM_DATA_NULL THEN
            returnaValue:=RNL_D_trakConv_itemOutBuff{Pointer.index,1};
        ELSE
            !ERROR
        ENDIF

        !Shift the output buffer down one
        FOR i FROM 1 TO dim(RNL_D_trakConv_itemOutBuff,2)-1 DO
            RNL_D_trakConv_itemOutBuff{Pointer.index,i}
            :=RNL_D_trakConv_itemOutBuff{Pointer.index,i+1};
        ENDFOR
        RNL_D_trakConv_itemOutBuff{Pointer.index,dim(RNL_D_trakConv_itemOutBuff,2)}
            :=RNL_D_ITEM_DATA_NULL;

        !Return
        RETURN returnaValue;

    ENDFUNC

    
    !===========================================================================
    !Exposed Getters and Setters
    !===========================================================================

    !===============
    !Exposed Setters
    !===============
    PROC conveyor_Set_Data(\conveyor Pointer,num data\switch keepLocked)
        VAR conveyor Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) Pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !RNL_X_ExDr_n_data{pointer_.index}:=data;

        IF NOT Present(keepLocked) unLockModule;

    ENDPROC

    PROC conveyor_Set_IO(\conveyor Pointer,

        \string DO_TrigAutoMode,
        \string DO_TrigVis,
        \string GO_TrigAutoEncNo,
        \string GO_TrigAutoDist,

        \string GI_ObjectsInQ,
        \string DO_Rem1PObj,
        \string DO_RemAllPObj,
        \string DO_DropWObj,

        \string DO_PosInJobQ,
        \string DI_NewObjStrobe,
        \string GI_CntFromEnc,
        \string DO_CntToEncStr,


        \switch keepLocked)
        VAR conveyor Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) Pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        IF Present(DO_TrigAutoMode) RNL_D_conveyor_data{pointer_.index}.TrigVis.DO_TrigAutoMode:=DO_TrigAutoMode;
        IF Present(DO_TrigVis) RNL_D_conveyor_data{pointer_.index}.TrigVis.DO_TrigVis:=DO_TrigVis;
        IF Present(GO_TrigAutoEncNo) RNL_D_conveyor_data{pointer_.index}.TrigVis.GO_TrigAutoEncNo:=GO_TrigAutoEncNo;
        IF Present(GO_TrigAutoDist) RNL_D_conveyor_data{pointer_.index}.TrigVis.GO_TrigAutoDist:=GO_TrigAutoDist;

        IF Present(GI_ObjectsInQ) RNL_D_conveyor_data{pointer_.index}.QueueAuto.GI_ObjectsInQ:=GI_ObjectsInQ;
        IF Present(DO_Rem1PObj) RNL_D_conveyor_data{pointer_.index}.QueueAuto.DO_Rem1PObj:=DO_Rem1PObj;
        IF Present(DO_RemAllPObj) RNL_D_conveyor_data{pointer_.index}.QueueAuto.DO_RemAllPObj:=DO_RemAllPObj;
        IF Present(DO_DropWObj) RNL_D_conveyor_data{pointer_.index}.QueueAuto.DO_DropWObj:=DO_DropWObj;

        IF Present(DO_PosInJobQ) RNL_D_conveyor_data{pointer_.index}.QueueManual.DO_PosInJobQ:=DO_PosInJobQ;
        IF Present(DI_NewObjStrobe) RNL_D_conveyor_data{pointer_.index}.QueueManual.DI_NewObjStrobe:=DI_NewObjStrobe;
        IF Present(GI_CntFromEnc) RNL_D_conveyor_data{pointer_.index}.QueueManual.GI_CntFromEnc:=GI_CntFromEnc;
        IF Present(DO_CntToEncStr) RNL_D_conveyor_data{pointer_.index}.QueueManual.DO_CntToEncStr:=DO_CntToEncStr;

        IF NOT Present(keepLocked) unLockModule;

    ENDPROC

    PROC conveyor_Set_IO_ToPreset(\conveyor Pointer,num conveyorID
        \switch keepLocked)
        VAR conveyor Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) Pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        conveyor_Set_IO

        \Pointer:=Pointer_

        \DO_TrigAutoMode:="c"+numToStr(conveyorID,0)+"TrigAutoMode"
        \DO_TrigVis:="c"+numToStr(conveyorID,0)+"TrigVis"
        \GO_TrigAutoEncNo:="c"+numToStr(conveyorID,0)+"TrigAutoEncNo"
        \GO_TrigAutoDist:="c"+numToStr(conveyorID,0)+"TrigAutoDist"

        \GI_ObjectsInQ:="c"+numToStr(conveyorID,0)+"ObjectsInQ"
        \DO_Rem1PObj:="c"+numToStr(conveyorID,0)+"Rem1PObj"
        \DO_RemAllPObj:="c"+numToStr(conveyorID,0)+"RemAllPObj"
        \DO_DropWObj:="c"+numToStr(conveyorID,0)+"DropWObj"

        \DO_PosInJobQ:="c"+numToStr(conveyorID,0)+"PosInJobQ"
        \DI_NewObjStrobe:="c"+numToStr(conveyorID,0)+"NewObjStrobe"
        \GI_CntFromEnc:="c"+numToStr(conveyorID,0)+"CntFromEnc"
        \DO_CntToEncStr:="c"+numToStr(conveyorID,0)+"CntToEncStr"

        \keepLocked;

        IF NOT Present(keepLocked) unLockModule;

    ENDPROC

    PROC conveyor_Set_QueueManualMode(\conveyor Pointer
        \switch keepLocked)
        VAR conveyor Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) Pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !Set the DI signaling that the conveyor is running with Manual Queue
        !Set c1PosInJobQ;
        %"Set "+RNL_D_conveyor_data{pointer_.index}.QueueManual.DO_PosInJobQ %;

        !Set up interupt for handeling new objectts entering the queue
        !NewItemOnConveyor{}

        !CONNECT NewItemOnConveyor{pointer_.index} WITH ManualQueue_NewItemOnConveyor1;
        %"CONNECT NewItemOnConveyor{pointer_.index} WITH ManualQueue_NewItemOnConveyor"+NumToStr(pointer_.index,0)%;

        !ISignalGI c1CntFromEnc, NewItemOnConveyor;
        %"ISignalGI "
        +RNL_D_conveyor_data{pointer_.index}.QueueManual.GI_CntFromEnc
        +", NewItemOnConveyor{pointer_.index}"%;

        IF NOT Present(keepLocked) unLockModule;

    ENDPROC

    PROC conveyor_Set_TrackingEncVal(\conveyor Pointer,encodervalue value
        \switch keepLocked)
        VAR conveyor Pointer_;

        Pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) Pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;
        
        set_TrackingEncVal Pointer_, value;
        
        IF NOT Present(keepLocked) unLockModule;

    ENDPROC
    
    
    PROC set_TrackingEncVal(conveyor Pointer,encodervalue value)

        !SetGO c1CntToEnc,ObjectPosition;
        %"SetGO "
        +RNL_D_conveyor_data{pointer.index}.QueueManual.GO_CntToEnc
        +", value"%;

        WaitTime 0.02;
        ! Validate the new reference

        !PulseDO c1CountToEncStr;
        %"PulseDO "
        +RNL_D_conveyor_data{pointer.index}.QueueManual.DO_CntToEncStr %;

    ENDPROC
    
    !===============
    !Exposed Getters
    !===============
    FUNC num conveyor_Get_Data(\conveyor Pointer
        \switch keepLocked)
        VAR conveyor pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !RETURN RNL_X_ExDr_n_data{pointer_.index};

        IF NOT Present(keepLocked) unLockModule;

    ENDFUNC

    FUNC encodervalue conveyor_get_EncounterValue(\conveyor Pointer\switch keepLocked)
        VAR conveyor pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !RETURN GInputDnum(c1CntFromEnc)
        %"RETURN GInputDnum("+RNL_D_conveyor_data{pointer_.index}.QueueManual.GI_CntFromEnc+")"%;

        IF NOT Present(keepLocked) unLockModule;

    ENDFUNC

    FUNC item conveyor_get_ItemInOutputBuffer(\conveyor Pointer\switch keepLocked)
        VAR conveyor pointer_;

        pointer_:=DEFAULT_POINTER;
        IF Present(Pointer) pointer_:=Pointer;

        waitUntilModuleIsReady;
        lockModule;

        update;

        !RETURN GInputDnum(c1CntFromEnc)
        %"RETURN GInputDnum("+RNL_D_conveyor_data{pointer_.index}.QueueManual.GI_CntFromEnc+")"%;

        IF NOT Present(keepLocked) unLockModule;

    ENDFUNC

ENDMODULE