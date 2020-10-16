MODULE RNL__stateMachine

    !stateMachine is an object that enables a event driven state machine structure

    !dependecies
    ! - dataPointer
    ! - event
    ! - unixTime
    ! - logging (To be implemented...)

    !Inherits from
    ! - none

    ALIAS string state;

    RECORD stateMachine
        dataPointer self;
        state mainState;
        state currentState;
        unixTime timestamp_lastUpdate;
        stateMachine_eventBuffer asyncEventBuffer;
        stateMachine_stateBuffer suspendBuffer;
    ENDRECORD

    RECORD stateTransition
        bool done;
        bool continue;
        state changeto;
        state suspendFor;
        string reason;
    ENDRECORD

    RECORD stateInfo
        dataPointer self;
        stateTransition transition;
        eventInfo eInfo;
    ENDRECORD

    RECORD stateMachine_eventBuffer
        eventInfo event_1;
        eventInfo event_2;
        eventInfo event_3;
        eventInfo event_4;
        eventInfo event_5;
    ENDRECORD

    RECORD stateMachine_stateBuffer
        state state_1;
        state state_2;
        state state_3;
        state state_4;
        state state_5;
    ENDRECORD

    !Dimention numbers should reflect the size of the record data
    CONST num stateMachine_stateBuffer_DIM:=5;
    CONST num stateMachine_eventBuffer_DIM:=5;

    !NULL
    CONST stateMachine stateMachine_NULL:=[["","","","",0],"","",0,[[[0],["","","","",0],["","","","",0],0],[[0],["","","","",0],["","","","",0],0],[[0],["","","","",0],["","","","",0],0],[[0],["","","","",0],["","","","",0],0],[[0],["","","","",0],["","","","",0],0]],["","","","",""]];
    CONST state state_NULL:="";
    CONST stateTransition stateTransition_NULL:=[FALSE,FALSE,"","",""];


    !regular events:
    PERS event onStart:=[100001];
    PERS event onUpdate:=[100002];
    PERS event onEnd:=[100003];
    PERS event onSuspend:=[100004];
    PERS event onResume:=[100005];

    !Constructor
    FUNC dataPointer NEW_stateMachine(INOUT stateMachine stateMachineData)
        VAR dataPointer self;

        self:=dataPointer_NULL;
        self.name:=argName(stateMachineData);
        self.type:="stateMachine";

        stateMachineData:=stateMachine_NULL;
        stateMachineData.self:=self;

        RETURN self;
    ENDFUNC


    !Procedure used to recive events
    !All events that should reach the state machine should be sent here
    LOCAL PROC eventInput(dataPointer machine,dataPointer eventNote)

        VAR stateMachine machine_;

        GetDataVal machine.name,machine_;

        !If the event is asynchronous, add it to the queue
        !IF ExecLevel()=LEVEL_TRAP THEN
        !    !add to queue
        !    RETURN ;
        !ENDIF

        !Execute all buffered events
        !        FOR i FROM 1 TO 5 DO
        !            <SMT>
        !        ENDFOR

        !Execute event
        try\obj:=machine_.self,"executeEvent"\arg1:=eventNote;

    ENDPROC

    !Executes an event on a state machine
    LOCAL PROC executeEvent(dataPointer machine,dataPointer eventNote)
        VAR stateMachine machine_;
        VAR dataPointer transition;

        GetDataVal machine.name,machine_;

        transition.value:=valToStr(stateTransition_NULL);

        !Execute state, and recive state transition
        try\obj:=machine_.self,"executeState"\arg1_INOUT:=transition\arg2:=eventNote;

        !Execute state transition
        try\obj:=machine_.self,"executeStateTransition"\arg1_INOUT:=transition;

    ERROR
        !RAISE ;
    ENDPROC


    !Calls an update event on the current state
    LOCAL PROC update(dataPointer machine)

        VAR stateMachine machine_;
        VAR eventInfo eventNote;

        GetDataVal machine.name,machine_;

        !Execute all buffered asynchronous events

        SetDataVal machine.name,machine_;
        
        !Execute an update() event
        eventNote.triggerEvent:=onUpdate;
        try\obj:=machine,"executeEvent",
            \arg1:=ref(\A_type:="eventInfo",\A_value:=ValToStr(eventNote));

    ENDPROC

    !Executes the current state in the state machine, in response ot an event
    LOCAL PROC executeState(
            dataPointer machine,
            INOUT dataPointer transition,
            dataPointer eventNote)

        VAR stateMachine machine_;

        VAR stateInfo info;
        VAR eventInfo eventNote_;
        VAR stateTransition transition_;

        GetDataVal machine.name,machine_;

        errFromBool StrToVal(eventNote.value,eventNote_),ERR_SYM_ACCESS;
        errFromBool StrToVal(transition.value,transition_),ERR_SYM_ACCESS;

        !Logg event, value and state

        !ADD CODE HERE THAT LOGS THE EVENT, EVENT VALUE, AND STATE

        !Call current state with the event notification, returning the stateTransition
        info.transition:=transition_;
        info.eInfo:=eventNote_;
        info.self:=machine_.self;
        %machine_.currentState %info;

        !Save stateTransition through INOUT argument
        transition_:=info.transition;
        transition.value:=ValToStr(transition_);

    ERROR
        !RAISE ;
    ENDPROC

    !Executes a state transition, changing current state and calling regular events
    LOCAL PROC executeStateTransition(
            dataPointer machine,
            INOUT dataPointer transition)

        VAR stateMachine machine_;
        VAR stateTransition transition_;
        !VAR dataPointer mode;
        !VAR executionMode mode_;

        VAR eventInfo eventNote;

        GetDataVal machine.name,machine_;
        errFromBool StrToVal(transition.value,transition_),ERR_SYM_ACCESS;

        !Get execution mode
        !try\obj:=machine_.self,"getExeMode"\arg1_INOUT:=mode;
        !errFromBool StrToVal(mode.value,mode_),ERR_SYM_ACCESS;

        !Logg changes and reason

        !ADD CODE HERE THAT LOGS THE TRANSITION AND REASON

        IF transition_.continue=TRUE THEN

            !No change in state
            machine_.currentState:=machine_.currentState;

        ELSEIF transition_.changeto<>state_NULL THEN

            !Change to new state

            !Call onEnd on last state
            eventNote.triggerEvent:=onEnd;
            try\obj:=machine,"executeEvent",
               \arg1:=ref(\A_type:="eventInfo",\A_value:=ValToStr(eventNote));

            !Change State
            machine_.currentState:=transition_.changeto;

            !Syncronize changes
            SetDataVal machine.name,machine_;
            GetDataVal machine.name,machine_;

            !Call onStart on the new state
            eventNote.triggerEvent:=onStart;
            try\obj:=machine,"executeEvent",
               \arg1:=ref(\A_type:="eventInfo",\A_value:=ValToStr(eventNote));

        ELSEIF transition_.suspendFor<>state_NULL THEN

            !Suspend for new state

            !Call onSuspend on last state
            eventNote.triggerEvent:=onSuspend;
            try\obj:=machine,"executeEvent",
               \arg1:=ref(\A_type:="eventInfo",\A_value:=ValToStr(eventNote));

            !append current state to suspendbuffer
            stateMachine_stateBuffer_append machine_.suspendBuffer,machine_.currentState;

            !Change State
            machine_.currentState:=transition_.suspendFor;

            !Syncronize changes
            SetDataVal machine.name,machine_;
            GetDataVal machine.name,machine_;

            !Call onStart on the new state
            eventNote.triggerEvent:=onStart;
            try\obj:=machine,"executeEvent",
               \arg1:=ref(\A_type:="eventInfo",\A_value:=ValToStr(eventNote));


        ELSEIF transition_.done=TRUE THEN

            !Complete state and resume to suspended state

            !Call onEnd on last state
            eventNote.triggerEvent:=onEnd;
            try\obj:=machine,"executeEvent",
               \arg1:=ref(\A_type:="eventInfo",\A_value:=ValToStr(eventNote));

            !Change State, to topmost state in suspend buffer
            machine_.currentState:=stateMachine_stateBuffer_pop(machine_.suspendBuffer);

            !Syncronize changes
            SetDataVal machine.name,machine_;
            GetDataVal machine.name,machine_;

            !Call onResume on the resumed state
            eventNote.triggerEvent:=onResume;
            try\obj:=machine,"executeEvent",
               \arg1:=ref(\A_type:="eventInfo",\A_value:=ValToStr(eventNote));

        ENDIF

        !Push changes
        SetDataVal machine.name,machine_;


    ENDPROC

    !== setMainState ==

    !Sets the main state, the state in whitch the state machine will start
    PROC setMainState_(dataPointer machine,state mainState)
        try\obj:=machine,"setMainState"\arg1:=ref(\A_type:="state"\A_value:=ValToStr(mainState));
    ENDPROC

    LOCAL PROC setMainState(dataPointer machine,datapointer mainState)
        VAR statemachine machine_;
        VAR state mainState_;
        VAR eventInfo eventNote;

        !Get data
        GetDataVal machine.name,machine_;
        errFromBool StrToVal(mainState.value,mainState_),ERR_SYM_ACCESS;

        !Execute
        machine_.mainState:=mainState_;

        !if current state is not set, set it to mainstate
        IF machine_.currentState=state_NULL THEN

            machine_.currentState:=machine_.mainState;

            !Set data
            SetDataVal machine.name,machine_;

            !Call onStart on the new current state
            eventNote.triggerEvent:=onStart;
            try\obj:=machine,"executeEvent",
               \arg1:=ref(\A_type:="eventInfo",\A_value:=ValToStr(eventNote));

        ELSE

            !Set data
            SetDataVal machine.name,machine_;
        ENDIF

    ENDPROC

    !== getMainState ==

    FUNC state getMainState_(dataPointer machine)
        VAR dataPointer mainState;
        VAR state mainState_;
        try\obj:=machine,"getMainState"\arg1_INOUT:=mainState;
        errFromBool StrToVal(mainState.value,mainState_),ERR_SYM_ACCESS;
        RETURN mainState_;
    ENDFUNC

    LOCAL PROC getMainState(dataPointer machine,INOUT datapointer mainState)
        VAR statemachine machine_;
        VAR state mainState_;

        !Get data
        GetDataVal machine.name,machine_;

        !Execute
        mainState_:=machine_.mainState;

        !Set data
        mainState.value:=valtoStr(mainState_);

    ENDPROC

    !== setCurrentState ==

    PROC setCurrentState_(dataPointer machine,state currentState)
        try\obj:=machine,"setCurrentState"\arg1:=ref(\A_type:="state"\A_value:=ValToStr(currentState));
    ENDPROC

    LOCAL PROC setCurrentState(dataPointer machine,datapointer newCurrentState)
        VAR statemachine machine_;
        VAR state newCurrentState_;
        VAR stateTransition transition;

        !Get data
        GetDataVal machine.name,machine_;
        errFromBool StrToVal(newCurrentState.value,newCurrentState_),ERR_SYM_ACCESS;

        !Reject setCurrentState
        ErrWrite "setCurrentState is not allowed","It is not allowed to set the current state";
        Stop;
        RETURN ;
        
        !Execute state transition to new state
        transition.changeto := newCurrentState_;
        
        try \obj:=machine_.self, "executeStateTransition" 
        \arg1:=ref(\A_type:="stateTransition"\A_value:=ValToStr(transition));
        
    ENDPROC

    !== getCurrentState ==

    FUNC state getCurrentState_(dataPointer machine)
        VAR dataPointer currentState;
        VAR state currentState_;
        try\obj:=machine,"getCurrentState"\arg1_INOUT:=currentState;
        errFromBool StrToVal(currentState.value,currentState_),ERR_SYM_ACCESS;
        RETURN currentState_;
    ENDFUNC

    LOCAL PROC getCurrentState(dataPointer machine,INOUT datapointer currentState)
        VAR statemachine machine_;
        VAR state currentState_;

        !Get data
        GetDataVal machine.name,machine_;

        !Execute
        currentState_:=machine_.currentState;

        !Set data
        currentState.value:=valtoStr(currentState_);

    ENDPROC

    !State transitions
    !argument "string reason" is a required debug string that will be logged
    !example: stateChangeTo(ProgramStop,"Stop command was given") becomes:
    ! " [stateMachine] Moved to state "ProgramStop" because "Stop command was given". "

    !No change in state. This state will be called next time an event occurs
    PROC stateContinue(INOUT stateInfo info)
        info.transition:=stateTransition_NULL;
        info.transition.continue:=TRUE;
    ENDPROC

    !Change to new state. The new state will be called next time an event occurs
    !The old state will get one last event call with "OnEnd", and the new
    !state will be called once with the event "OnStart"
    PROC stateChangeTo(INOUT stateInfo info,state newState,string reason)
        info.transition:=stateTransition_NULL;
        info.transition.changeto:=newState;
    ENDPROC

    !Temporarily changes to new state. The new state will be called next time an event occurs
    !The old state will get one last event call with "OnSuspend", and the new
    !state will be called once with the event "OnStart".
    !The old state is saved in a queue, and can be resumed at a later time
    PROC stateSuspendFor(INOUT stateInfo info,state newState,string reason)
        info.transition:=stateTransition_NULL;
        info.transition.suspendFor:=newState;
    ENDPROC

    !Change to the last state that was suspended. 
    !The suspended (now unsuspended) state will be called next time an event occurs.
    !the old state will be called one last time with the event "OnEnd".
    !the suspended (now unsuspended) state will be called once with the event "OnResume".
    PROC stateDone(INOUT stateInfo info,string reason)
        info.transition:=stateTransition_NULL;
        info.transition.done:=TRUE;
    ENDPROC

    !stateMachine_stateBuffer list handeling

    !Setting an index in a list
    PROC stateMachine_stateBuffer_set(INOUT stateMachine_stateBuffer list,num i,state s)
        TEST i
        CASE 1:
            list.state_1:=s;
        CASE 2:
            list.state_2:=s;
        CASE 3:
            list.state_3:=s;
        CASE 4:
            list.state_4:=s;
        CASE 5:
            list.state_5:=s;
        DEFAULT:
            !ERROR
            ErrWrite "stateMachine_stateBuffer_get out of range","i is out of range";
            Stop;
        ENDTEST
    ENDPROC

    !Getting an index in a list
    FUNC state stateMachine_stateBuffer_get(INOUT stateMachine_stateBuffer list,num i)
        TEST i
        CASE 1:
            RETURN list.state_1;
        CASE 2:
            RETURN list.state_2;
        CASE 3:
            RETURN list.state_3;
        CASE 4:
            RETURN list.state_4;
        CASE 5:
            RETURN list.state_5;
        DEFAULT:
            !ERROR
            ErrWrite "stateMachine_stateBuffer_set out of range","i is out of range";
            Stop;
        ENDTEST
    ENDFUNC

    !Appending an item to a list
    PROC stateMachine_stateBuffer_append(INOUT stateMachine_stateBuffer list,state item)
        FOR i FROM 1 TO stateMachine_stateBuffer_DIM DO
            IF stateMachine_stateBuffer_get(list,i)=state_NULL THEN
                stateMachine_stateBuffer_set list,i,item;
                RETURN ;
            ENDIF
        ENDFOR
    ENDPROC

    !Popping an item from a list
    FUNC state stateMachine_stateBuffer_pop(INOUT stateMachine_stateBuffer list)
        VAR state returnItem;
        FOR i FROM stateMachine_stateBuffer_DIM TO 1 DO
            returnItem:=stateMachine_stateBuffer_get(list,i);
            IF returnItem<>state_NULL THEN
                stateMachine_stateBuffer_set list,i,state_NULL;
                RETURN returnItem;
            ENDIF
        ENDFOR
    ENDFUNC




    !Examples

    !exampleState is a example of how a state should be declared
    PROC exampleState(INOUT stateInfo info)
        TEST info.eInfo.triggerEvent

        CASE onStart:
            stateContinue info;

        CASE onUpdate:
            stateContinue info;

        CASE onEnd:
            stateContinue info;

        CASE onSuspend:
            stateContinue info;

        CASE onResume:
            stateContinue info;

        DEFAULT:
            stateContinue info;

        ENDTEST
    ERROR
        RAISE ;
    ENDPROC

ENDMODULE
