MODULE RNL_E_virtualObjectManager

    ALIAS num virtualObjectType;

    RECORD virtualObjectData

        string name;

        bool persistent;

        string taskName;

        virtualObjectPointer pointer;

    ENDRECORD

    RECORD virtualObjectPointer

        virtualObjectType type;

        num index;

    ENDRECORD

    PERS virtualObjectData VO_list{5000};
    CONST virtualObjectData virtualObjectData_NULL:=["",FALSE,"",[0,0]];

    CONST virtualObjectType OBJECT_TYPE_NULL:=0;
    CONST virtualObjectType OBJECT_TYPE_GENERIC:=1;

    CONST virtualObjectType OBJECT_TYPE_D_HMI:=4001;
    CONST virtualObjectType OBJECT_TYPE_D_ITEM:=4002;
    CONST virtualObjectType OBJECT_TYPE_D_ITEMSOURCE:=4003;
    CONST virtualObjectType OBJECT_TYPE_D_ITEMSINK:=4004;
    CONST virtualObjectType OBJECT_TYPE_D_:=4005;
    CONST virtualObjectType OBJECT_TYPE_D_GRIPPER:=4006;
    CONST virtualObjectType OBJECT_TYPE_D_PLC:=4007;
    CONST virtualObjectType OBJECT_TYPE_D_OCELLUS:=4008;
    CONST virtualObjectType OBJECT_TYPE_D_CONVEYOR:=4009;

    !Constructing and destructing functions

    !Allocates a new virtual object in memory and returns a pointer to it
    FUNC virtualObjectPointer virtualObjectManager_New(
        \string name
        \bool persistant
        \virtualObjectType type
        \num maxIndex)

        VAR string name_;
        VAR bool persistant_:=FALSE;
        VAR virtualObjectType type_;
        VAR num maxIndex_;
        VAR virtualObjectData data;

        VAR num Index;
        VAR num i;

        name_:="Unnamed";
        IF Present(name) name_:=name;

        IF Present(persistant) persistant_:=TRUE;

        type_:=OBJECT_TYPE_GENERIC;
        IF Present(type) type_:=type;

        maxIndex_:=999;
        IF present(maxIndex) maxIndex_:=maxIndex;

        data.name:=name_;
        data.persistent:=persistant_;
        data.taskName:=GetTaskName();
        data.pointer.type:=type_;

        !Check VO list
        IF VO_list_hasErrors() THEN
            !ERROR
            ErrWrite "CORRUPTED VO_LIST","";
            Stop;
        ELSE
            !Find next available index of type:
            i:=1;
            WHILE VO_list_SearchForPointer([data.pointer.type,i]) > 0 DO
                i := i +1;
                IF i > maxIndex_ RAISE ERR_NOMOREALLOCATEDINSTACES;
            ENDWHILE
            
            !Save index
            data.pointer.index := i;
            
            !add to VO list
            VO_list_add data;
        ENDIF

        RETURN data.pointer;

    ENDFUNC

    !De-Allocates a virtual object from memory
    PROC Erase(virtualObjectPointer pointer)
        VAR num index;
        
        index:=VO_list_SearchForPointer(pointer);
        IF index>0 THEN
            CallModuleEraseMethod pointer;
            VO_list_Remove(index);
            index:=VO_list_SearchForPointer(pointer);
            IF index>0 THEN
                !ERROR
                ErrWrite "DUPLICAT ENTRY IN VO_LIST","";
                stop;
            ENDIF
        ENDIF
        
        ERROR
        RAISE;
    ENDPROC
    
    !Initializes the virtualObjectManager and VO list
    PROC virtualObjectManager_Init()

        !Erase all non persistent virtual objects
        FOR i FROM 1 TO dim(VO_list,1) DO
            IF NOT VO_list{i}.persistent THEN
                CallModuleEraseMethod VO_list{i}.pointer \noWarning;
                VO_list_Remove(i);
            ENDIF
        ENDFOR

    ENDPROC
    
    !===========================================================================
    !LOCAL Behaviours
    !===========================================================================

    !Calls the modules own erase module for a pointer
    LOCAL PROC CallModuleEraseMethod(virtualObjectPointer Pointer \switch noWarning)
        TEST Pointer.type
        CASE OBJECT_TYPE_D_HMI:
        %"HMI_Erase Pointer"%;
        CASE OBJECT_TYPE_D_ITEM:
        %"item_Erase Pointer"%;
        CASE OBJECT_TYPE_D_ITEMSOURCE:
        %"itemSource_Erase Pointer"%;
        CASE OBJECT_TYPE_D_ITEMSINK:
        %"itemSink_Erase Pointer"%;
        CASE OBJECT_TYPE_D_GRIPPER:
        %"gripper_Erase Pointer"%;
        CASE OBJECT_TYPE_D_PLC:
        %"PLC_Erase Pointer"%;
        CASE OBJECT_TYPE_D_OCELLUS:
        %"Ocellus_Erase Pointer"%;
        CASE OBJECT_TYPE_D_OCELLUS:
        %"HMI_Erase Pointer"%;
        DEFAULT:
        IF Present(noWarning) RETURN;
        !ERROR
        ErrWrite "Object Type not configured:CallModuleEraseMethod","";
        stop;
        ENDTEST

    ENDPROC
    
    !Appends an entry to the end of the VO_list
    LOCAL PROC VO_list_add(virtualObjectData object)

        FOR i FROM dim(VO_list,1) TO 1 DO
            IF NOT VO_list{i}=virtualObjectData_NULL VO_list{i-1}:=object;
        ENDFOR

    ENDPROC

    !    !Inserts an entry in the VO_list, at an spesified Index
    !    LOCAL PROC VO_list_Insert(virtualObjectData object,num index)

    !        FOR i FROM index TO dim(VO_list,1)-1 DO
    !            VO_list{i}:=VO_list{i+1};
    !        ENDFOR

    !        VO_list{dim(VO_list,1)}:=virtualObjectData_NULL;

    !    ENDPROC

    !Removes an entry in the VO_list
    LOCAL PROC VO_list_Remove(num index)

        FOR i FROM index TO dim(VO_list,1)-1 DO
            VO_list{i}:=VO_list{i+1};
        ENDFOR

        VO_list{dim(VO_list,1)}:=virtualObjectData_NULL;

    ENDPROC

    LOCAL FUNC num VO_list_SearchForPointer(virtualObjectPointer pointer)

        FOR i FROM 1 TO dim(VO_list,1) DO
            IF VO_list{i}.pointer=pointer RETURN i;
        ENDFOR

        RETURN 0;

    ENDFUNC

    !Checks if VO_list has errors
    LOCAL FUNC bool VO_list_hasErrors()
        VAR bool bInsideUsedList:=FALSE;
        VAR virtualObjectData pointerData;

        !run through list and return true if any error is detected
        FOR i FROM dim(VO_list,1) TO 1 DO
            IF NOT VO_list{i}=virtualObjectData_NULL bInsideUsedList:=TRUE;
            IF bInsideUsedList THEN
                pointerData:=VO_list{i};
                IF pointerData.name=virtualObjectData_NULL.name RETURN TRUE;
                IF pointerData.taskName=virtualObjectData_NULL.taskName RETURN TRUE;
                IF pointerData.pointer.index=virtualObjectData_NULL.pointer.index RETURN TRUE;
                IF pointerData.pointer.type=virtualObjectData_NULL.pointer.index RETURN TRUE;
            ENDIF
        ENDFOR

        RETURN FALSE;

    ENDFUNC

    !Removes all corrupted or improperly formatted entries in VO_list
    PROC VO_list_removeCorruption()
        VAR num index;
        index:=dim(VO_list,1);
        WHILE index>0 DO
            index:=VO_list_findCorruption(\StartIndex:=index);
            IF index>0 VO_list_remove(index);
        ENDWHILE
    ENDPROC

    !Removes all entries in VO_list
    PROC VO_list_removeAll()
        FOR i FROM 1 TO dim(VO_list,1) DO
            VO_list{i}:=virtualObjectData_NULL;
        ENDFOR
    ENDPROC


    !Finds corrupted or improperly formatted entries in VO_list
    FUNC num VO_list_findCorruption(\num StartIndex)
        VAR bool bInsideUsedList:=FALSE;
        VAR virtualObjectData pointer;
        VAR num StartIndex_;

        StartIndex_:=dim(VO_list,1);
        IF Present(StartIndex) StartIndex_:=StartIndex;

        FOR i FROM StartIndex TO 1 DO
            IF NOT VO_list{i}=virtualObjectData_NULL bInsideUsedList:=TRUE;
            IF bInsideUsedList THEN
                pointer:=VO_list{i};
                IF pointer.pointer.index=virtualObjectData_NULL.pointer.index RETURN i;
                IF pointer.name=virtualObjectData_NULL.name RETURN i;
                IF pointer.taskName=virtualObjectData_NULL.taskName RETURN i;
                IF pointer.pointer.type=virtualObjectData_NULL.pointer.type RETURN i;
            ENDIF
        ENDFOR

        RETURN 0;

    ENDFUNC

    !Tries to sort VO_list, by removing empty entried inside the list
    PROC VO_list_sort()
        VAR bool bInsideUsedList:=FALSE;

        FOR i FROM dim(VO_list,1) TO 1 DO

            !Search until you hit the top of the list
            IF NOT VO_list{i}=virtualObjectData_NULL bInsideUsedList:=TRUE;

            !When inside the list body, if an empty spot is found, remove it
            IF bInsideUsedList AND VO_list{i}=virtualObjectData_NULL
                VO_list_Remove(i);

        ENDFOR

    ENDPROC


    LOCAL FUNC num VO_list_findNextEmpty()
        FOR i FROM 1 TO dim(VO_list,1) DO
            IF VO_list{i}=virtualObjectData_NULL RETURN i;
        ENDFOR
    ENDFUNC


    !===========================================================================
    !Exposed Actions and Questions
    !===========================================================================



    !Returns true if virtual object exists
    FUNC bool pointer_isValid(virtualObjectPointer pointer)
        VAR num index;
        !find index in VO list
        index:=VO_list_SearchForPointer(pointer);
        !IF NOT found, return False
        IF index < 1 RETURN FALSE;
        
        !if name or task is not initialized, return false
        IF VO_list{index}.name=virtualObjectData_NULL.name RETURN FALSE;
        IF VO_list{index}.taskName=virtualObjectData_NULL.taskName RETURN FALSE;
        
        RETURN TRUE;
    ENDFUNC

    FUNC bool pointer_isType(virtualObjectPointer pointer,
        \switch HMI
        \switch ITEM
        \switch ITEMSOURCE
        \switch ITEMSINK
        \switch GRIPPER
        \switch PLC
        \switch OCELLUS
        \switch CONVEYOR
        )

        IF present(HMI) RETURN pointer.index=OBJECT_TYPE_D_HMI;
        IF present(ITEM) RETURN pointer.index=OBJECT_TYPE_D_ITEM;
        IF present(ITEMSOURCE) RETURN pointer.index=OBJECT_TYPE_D_ITEMSOURCE;
        IF present(ITEMSINK) RETURN pointer.index=OBJECT_TYPE_D_ITEMSINK;
        IF present(GRIPPER) RETURN pointer.index=OBJECT_TYPE_D_GRIPPER;
        IF present(PLC) RETURN pointer.index=OBJECT_TYPE_D_PLC;
        IF present(OCELLUS) RETURN pointer.index=OBJECT_TYPE_D_OCELLUS;
        IF present(CONVEYOR) RETURN pointer.index=OBJECT_TYPE_D_CONVEYOR;

        !ERROR

    ENDFUNC

    !===========================================================================
    !Exposed Getters and Setters
    !===========================================================================

    FUNC virtualObjectData virtualObjectManager_listObjects(num index)
        <SMT>
    ENDFUNC




    FUNC virtualObjectType virtualObjectManager_ObjectType(string objecTypeName)

        %"RETURN OBJECT_TYPE_"+objecTypeName %;

    ENDFUNC




ENDMODULE