MODULE RNL__stateMachine_TESTMOD

    LOCAL PERS string debugResult:="statemachine_TEST_B_State4";

    PERS stateMachine stateMachineA_;
    PERS dataPointer stateMachineA;

    PERS stateMachine stateMachineB1_;
    PERS dataPointer stateMachineB1;

    PERS stateMachine stateMachineB2_;
    PERS dataPointer stateMachineB2;

    PERS stateMachine stateMachineB3_;
    PERS dataPointer stateMachineB3;

    PERS stateMachine stateMachineB4_;
    PERS dataPointer stateMachineB4;



    PERS event statemachine_TEST_Event_10;
    PERS event statemachine_TEST_Event_11;
    PERS event statemachine_TEST_Event_12;
    PERS event statemachine_TEST_Event_13;
    PERS event statemachine_TEST_Event_14;

    PERS event statemachine_TEST_Event_20;
    PERS event statemachine_TEST_Event_21;
    PERS event statemachine_TEST_Event_22;
    PERS event statemachine_TEST_Event_23;
    PERS event statemachine_TEST_Event_24;

    PERS event statemachine_TEST_Event_30;
    PERS event statemachine_TEST_Event_31;
    PERS event statemachine_TEST_Event_32;
    PERS event statemachine_TEST_Event_33;
    PERS event statemachine_TEST_Event_34;

    PERS event statemachine_TEST_Event_40;
    PERS event statemachine_TEST_Event_41;
    PERS event statemachine_TEST_Event_42;
    PERS event statemachine_TEST_Event_43;
    PERS event statemachine_TEST_Event_44;

    PERS event statemachine_TEST_Event_B0_Done;
    PERS event statemachine_TEST_Event_B1;
    PERS event statemachine_TEST_Event_B2;
    PERS event statemachine_TEST_Event_B3;
    PERS event statemachine_TEST_Event_B4;

    PERS eventSubscription sub_10__to__B0;
    PERS eventSubscription sub_20__to__B0;
    PERS eventSubscription sub_30__to__B0;
    PERS eventSubscription sub_40__to__B0;

    PERS eventSubscription sub_11__to__B1;
    PERS eventSubscription sub_21__to__B1;
    PERS eventSubscription sub_31__to__B1;
    PERS eventSubscription sub_41__to__B1;

    PERS eventSubscription sub_12__to__B2;
    PERS eventSubscription sub_22__to__B2;
    PERS eventSubscription sub_32__to__B2;
    PERS eventSubscription sub_42__to__B2;

    PERS eventSubscription sub_13__to__B3;
    PERS eventSubscription sub_23__to__B3;
    PERS eventSubscription sub_33__to__B3;
    PERS eventSubscription sub_43__to__B3;

    PERS eventSubscription sub_14__to__B4;
    PERS eventSubscription sub_24__to__B4;
    PERS eventSubscription sub_34__to__B4;
    PERS eventSubscription sub_44__to__B4;


    PERS event statemachine_TEST_Event_A1toA2;
    PERS event statemachine_TEST_Event_A2toA1;

    PERS eventSubscription sub_A1toA2;
    PERS eventSubscription sub_A2oA1;

    PROC RNL__stateMachine_TEST()
        RNL__stateMachine_TEST_A;
        RNL__stateMachine_TEST_B;
    ENDPROC

    PROC RNL__stateMachine_TEST_A()
        !Test A, simple test

        TPErase;

        !Set up state machines
        stateMachineA:=NEW_stateMachine(stateMachineA_);

        setMainState_ stateMachineA,"statemachine_TEST_A_MainState1";

        sub_A1toA2:=NEW_eventSubscription(statemachine_TEST_Event_A1toA2,\reciverObject:=stateMachineA,"eventInput");
        sub_A2oA1:=NEW_eventSubscription(statemachine_TEST_Event_A2toA1,\reciverObject:=stateMachineA,"eventInput");

        !start test

        IF debugResult<>"statemachine_TEST_A_MainState1"
        OR getCurrentState_(stateMachineA)<>"statemachine_TEST_A_MainState1" THEN
            ErrWrite "RNL__stateMachine_TESTMOD TEST A FAILED","";
            Stop;
        ENDIF

        FOR i FROM 1 TO 100 DO



            event_trigger statemachine_TEST_Event_A1toA2;

            IF debugResult<>"statemachine_TEST_A_State2"
            OR getCurrentState_(stateMachineA)<>"statemachine_TEST_A_State2" THEN
                ErrWrite "RNL__stateMachine_TESTMOD TEST A FAILED","";
                Stop;
            ENDIF

            event_trigger statemachine_TEST_Event_A2toA1;

            IF debugResult<>"statemachine_TEST_A_MainState1"
            OR getCurrentState_(stateMachineA)<>"statemachine_TEST_A_MainState1" THEN
                ErrWrite "RNL__stateMachine_TESTMOD TEST A FAILED","";
                Stop;
            ENDIF


        ENDFOR

    ENDPROC

    PROC RNL__stateMachine_TEST_B()

        !Set up state machines
        stateMachineB1:=NEW_stateMachine(stateMachineB1_);
        stateMachineB2:=NEW_stateMachine(stateMachineB2_);
        stateMachineB3:=NEW_stateMachine(stateMachineB3_);
        stateMachineB4:=NEW_stateMachine(stateMachineB4_);

        setMainState_ stateMachineB1,"statemachine_TEST_B_State1";
        setMainState_ stateMachineB2,"statemachine_TEST_B_State1";
        setMainState_ stateMachineB3,"statemachine_TEST_B_State1";
        setMainState_ stateMachineB4,"statemachine_TEST_B_State1";


        !Set up event subscriptions

        sub_10__to__B0:=NEW_eventSubscription(statemachine_TEST_Event_10,
            \reciverObject:=stateMachineB1,"eventInput"\aliasEvent:=statemachine_TEST_Event_B0_Done);
        sub_20__to__B0:=NEW_eventSubscription(statemachine_TEST_Event_20,
            \reciverObject:=stateMachineB2,"eventInput"\aliasEvent:=statemachine_TEST_Event_B0_Done);
        sub_30__to__B0:=NEW_eventSubscription(statemachine_TEST_Event_30,
            \reciverObject:=stateMachineB3,"eventInput"\aliasEvent:=statemachine_TEST_Event_B0_Done);
        sub_40__to__B0:=NEW_eventSubscription(statemachine_TEST_Event_40,
            \reciverObject:=stateMachineB4,"eventInput"\aliasEvent:=statemachine_TEST_Event_B0_Done);

        sub_11__to__B1:=NEW_eventSubscription(statemachine_TEST_Event_11,
            \reciverObject:=stateMachineB1,"eventInput"\aliasEvent:=statemachine_TEST_Event_B1);
        sub_21__to__B1:=NEW_eventSubscription(statemachine_TEST_Event_21,
            \reciverObject:=stateMachineB2,"eventInput"\aliasEvent:=statemachine_TEST_Event_B1);
        sub_31__to__B1:=NEW_eventSubscription(statemachine_TEST_Event_31,
            \reciverObject:=stateMachineB3,"eventInput"\aliasEvent:=statemachine_TEST_Event_B1);
        sub_41__to__B1:=NEW_eventSubscription(statemachine_TEST_Event_41,
            \reciverObject:=stateMachineB4,"eventInput"\aliasEvent:=statemachine_TEST_Event_B1);

        sub_12__to__B2:=NEW_eventSubscription(statemachine_TEST_Event_12,
            \reciverObject:=stateMachineB1,"eventInput"\aliasEvent:=statemachine_TEST_Event_B2);
        sub_22__to__B2:=NEW_eventSubscription(statemachine_TEST_Event_22,
            \reciverObject:=stateMachineB2,"eventInput"\aliasEvent:=statemachine_TEST_Event_B2);
        sub_32__to__B2:=NEW_eventSubscription(statemachine_TEST_Event_32,
            \reciverObject:=stateMachineB3,"eventInput"\aliasEvent:=statemachine_TEST_Event_B2);
        sub_42__to__B2:=NEW_eventSubscription(statemachine_TEST_Event_42,
            \reciverObject:=stateMachineB4,"eventInput"\aliasEvent:=statemachine_TEST_Event_B2);

        sub_13__to__B3:=NEW_eventSubscription(statemachine_TEST_Event_13,
            \reciverObject:=stateMachineB1,"eventInput"\aliasEvent:=statemachine_TEST_Event_B3);
        sub_23__to__B3:=NEW_eventSubscription(statemachine_TEST_Event_23,
            \reciverObject:=stateMachineB2,"eventInput"\aliasEvent:=statemachine_TEST_Event_B3);
        sub_33__to__B3:=NEW_eventSubscription(statemachine_TEST_Event_33,
            \reciverObject:=stateMachineB3,"eventInput"\aliasEvent:=statemachine_TEST_Event_B3);
        sub_43__to__B3:=NEW_eventSubscription(statemachine_TEST_Event_43,
            \reciverObject:=stateMachineB4,"eventInput"\aliasEvent:=statemachine_TEST_Event_B3);

        sub_14__to__B4:=NEW_eventSubscription(statemachine_TEST_Event_14,
            \reciverObject:=stateMachineB1,"eventInput"\aliasEvent:=statemachine_TEST_Event_B4);
        sub_24__to__B4:=NEW_eventSubscription(statemachine_TEST_Event_24,
            \reciverObject:=stateMachineB2,"eventInput"\aliasEvent:=statemachine_TEST_Event_B4);
        sub_34__to__B4:=NEW_eventSubscription(statemachine_TEST_Event_34,
            \reciverObject:=stateMachineB3,"eventInput"\aliasEvent:=statemachine_TEST_Event_B4);
        sub_44__to__B4:=NEW_eventSubscription(statemachine_TEST_Event_44,
            \reciverObject:=stateMachineB4,"eventInput"\aliasEvent:=statemachine_TEST_Event_B4);


        !Start Test

        !Test paralell state machines

        event_trigger statemachine_TEST_Event_11;
        event_trigger statemachine_TEST_Event_22;
        event_trigger statemachine_TEST_Event_33;
        event_trigger statemachine_TEST_Event_44;
        
        IF NOT getCurrentState_(stateMachineB1)="statemachine_TEST_B_State1" stop;
        IF NOT getCurrentState_(stateMachineB2)="statemachine_TEST_B_State2" stop;
        IF NOT getCurrentState_(stateMachineB3)="statemachine_TEST_B_State3" stop;
        IF NOT getCurrentState_(stateMachineB4)="statemachine_TEST_B_State4" stop;

        
        event_trigger statemachine_TEST_Event_14;
        event_trigger statemachine_TEST_Event_23;
        event_trigger statemachine_TEST_Event_32;
        event_trigger statemachine_TEST_Event_41;

        IF NOT getCurrentState_(stateMachineB1)="statemachine_TEST_B_State4" stop;
        IF NOT getCurrentState_(stateMachineB2)="statemachine_TEST_B_State3" stop;
        IF NOT getCurrentState_(stateMachineB3)="statemachine_TEST_B_State2" stop;
        IF NOT getCurrentState_(stateMachineB4)="statemachine_TEST_B_State1" stop;

        event_trigger statemachine_TEST_Event_11;
        event_trigger statemachine_TEST_Event_22;
        event_trigger statemachine_TEST_Event_33;
        event_trigger statemachine_TEST_Event_44;

        IF NOT getCurrentState_(stateMachineB1)="statemachine_TEST_B_State1" stop;
        IF NOT getCurrentState_(stateMachineB2)="statemachine_TEST_B_State2" stop;
        IF NOT getCurrentState_(stateMachineB3)="statemachine_TEST_B_State3" stop;
        IF NOT getCurrentState_(stateMachineB4)="statemachine_TEST_B_State4" stop;

        !Test Suspend
        
        event_trigger statemachine_TEST_Event_11;
        event_trigger statemachine_TEST_Event_21;
        event_trigger statemachine_TEST_Event_31;
        event_trigger statemachine_TEST_Event_41;

        IF NOT getCurrentState_(stateMachineB1)="statemachine_TEST_B_State1" stop;
        IF NOT getCurrentState_(stateMachineB2)="statemachine_TEST_B_State1" stop;
        IF NOT getCurrentState_(stateMachineB3)="statemachine_TEST_B_State1" stop;
        IF NOT getCurrentState_(stateMachineB4)="statemachine_TEST_B_State1" stop;
        
        event_trigger statemachine_TEST_Event_12\valueData:=ref(\string_:="Suspend");
        event_trigger statemachine_TEST_Event_22\valueData:=ref(\string_:="Suspend");
        event_trigger statemachine_TEST_Event_32\valueData:=ref(\string_:="Suspend");
        event_trigger statemachine_TEST_Event_42\valueData:=ref(\string_:="Suspend");

        IF NOT getCurrentState_(stateMachineB1)="statemachine_TEST_B_State2" stop;
        IF NOT getCurrentState_(stateMachineB2)="statemachine_TEST_B_State2" stop;
        IF NOT getCurrentState_(stateMachineB3)="statemachine_TEST_B_State2" stop;
        IF NOT getCurrentState_(stateMachineB4)="statemachine_TEST_B_State2" stop;

        event_trigger statemachine_TEST_Event_13\valueData:=ref(\string_:="Suspend");
        event_trigger statemachine_TEST_Event_23\valueData:=ref(\string_:="Suspend");
        event_trigger statemachine_TEST_Event_33\valueData:=ref(\string_:="Suspend");
        event_trigger statemachine_TEST_Event_43\valueData:=ref(\string_:="Suspend");

        IF NOT getCurrentState_(stateMachineB1)="statemachine_TEST_B_State3" stop;
        IF NOT getCurrentState_(stateMachineB2)="statemachine_TEST_B_State3" stop;
        IF NOT getCurrentState_(stateMachineB3)="statemachine_TEST_B_State3" stop;
        IF NOT getCurrentState_(stateMachineB4)="statemachine_TEST_B_State3" stop;

        event_trigger statemachine_TEST_Event_14\valueData:=ref(\string_:="Suspend");
        event_trigger statemachine_TEST_Event_24\valueData:=ref(\string_:="Suspend");
        event_trigger statemachine_TEST_Event_34\valueData:=ref(\string_:="Suspend");
        event_trigger statemachine_TEST_Event_44\valueData:=ref(\string_:="Suspend");

        IF NOT getCurrentState_(stateMachineB1)="statemachine_TEST_B_State4" stop;
        IF NOT getCurrentState_(stateMachineB2)="statemachine_TEST_B_State4" stop;
        IF NOT getCurrentState_(stateMachineB3)="statemachine_TEST_B_State4" stop;
        IF NOT getCurrentState_(stateMachineB4)="statemachine_TEST_B_State4" stop;
        
        event_trigger statemachine_TEST_Event_10;
        event_trigger statemachine_TEST_Event_20;
        event_trigger statemachine_TEST_Event_30;
        event_trigger statemachine_TEST_Event_40;

        IF NOT getCurrentState_(stateMachineB1)="statemachine_TEST_B_State3" stop;
        IF NOT getCurrentState_(stateMachineB2)="statemachine_TEST_B_State3" stop;
        IF NOT getCurrentState_(stateMachineB3)="statemachine_TEST_B_State3" stop;
        IF NOT getCurrentState_(stateMachineB4)="statemachine_TEST_B_State3" stop;

        event_trigger statemachine_TEST_Event_10;
        event_trigger statemachine_TEST_Event_20;
        event_trigger statemachine_TEST_Event_30;
        event_trigger statemachine_TEST_Event_40;

        IF NOT getCurrentState_(stateMachineB1)="statemachine_TEST_B_State2" stop;
        IF NOT getCurrentState_(stateMachineB2)="statemachine_TEST_B_State2" stop;
        IF NOT getCurrentState_(stateMachineB3)="statemachine_TEST_B_State2" stop;
        IF NOT getCurrentState_(stateMachineB4)="statemachine_TEST_B_State2" stop;

        event_trigger statemachine_TEST_Event_10;
        event_trigger statemachine_TEST_Event_20;
        event_trigger statemachine_TEST_Event_30;
        event_trigger statemachine_TEST_Event_40;

        IF NOT getCurrentState_(stateMachineB1)="statemachine_TEST_B_State1" stop;
        IF NOT getCurrentState_(stateMachineB2)="statemachine_TEST_B_State1" stop;
        IF NOT getCurrentState_(stateMachineB3)="statemachine_TEST_B_State1" stop;
        IF NOT getCurrentState_(stateMachineB4)="statemachine_TEST_B_State1" stop;

        !Test completed

    ENDPROC


    PROC statemachine_TEST_A_MainState1(INOUT stateInfo info)
        TEST info.eInfo.triggerEvent

        CASE onStart:
            !TPWrite "statemachine_TEST_A_MainState1 -> onStart";
            debugResult:="statemachine_TEST_A_MainState1";
            stateContinue info;

        CASE onUpdate:
            !TPWrite "statemachine_TEST_A_MainState1 -> onUpdate";
            stateContinue info;

        CASE onEnd:
            !TPWrite "statemachine_TEST_A_MainState1 -> onEnd";
            stateContinue info;

        CASE onSuspend:
            !TPWrite "statemachine_TEST_A_MainState1 -> onSuspend";
            stateContinue info;

        CASE onResume:
            !TPWrite "statemachine_TEST_A_MainState1 -> onResume";
            stateContinue info;

        CASE statemachine_TEST_Event_A1toA2:
            !TPWrite "statemachine_TEST_A_MainState1 -> statemachine_TEST_Event_A1toA2";
            stateChangeTo info,"statemachine_TEST_A_State2","";

        DEFAULT:
            !TPWrite "statemachine_TEST_A_MainState1 -> DEFAULT";
            stateContinue info;

        ENDTEST
    ERROR
        RAISE ;
    ENDPROC

    PROC statemachine_TEST_A_State2(INOUT stateInfo info)
        TEST info.eInfo.triggerEvent

        CASE onStart:
            !TPWrite "statemachine_TEST_A_State2 -> onStart";
            debugResult:="statemachine_TEST_A_State2";
            stateContinue info;


        CASE onUpdate:
            !TPWrite "statemachine_TEST_A_State2 -> onUpdate";
            stateContinue info;

        CASE onEnd:
            !TPWrite "statemachine_TEST_A_State2 -> onEnd";
            stateContinue info;

        CASE onSuspend:
            !TPWrite "statemachine_TEST_A_State2 -> onSuspend";
            stateContinue info;

        CASE onResume:
            !TPWrite "statemachine_TEST_A_State2 -> onResume";
            stateContinue info;

        CASE statemachine_TEST_Event_A2toA1:
            !TPWrite "statemachine_TEST_A_State2 -> statemachine_TEST_Event_A2toA1";

            stateChangeTo info,"statemachine_TEST_A_MainState1","";

        DEFAULT:

        ENDTEST
    ERROR
        RAISE ;
    ENDPROC


    PROC statemachine_TEST_B_State1(INOUT stateInfo info)
        TEST info.eInfo.triggerEvent


        CASE onStart:
            debugResult:="statemachine_TEST_B_State1";

        CASE statemachine_TEST_Event_B0_Done:
            stateDone info,"";

        CASE statemachine_TEST_Event_B1:
            stateChangeTo info,"statemachine_TEST_B_State1","";
            IF info.eInfo.valueData.Value<>"" stateSuspendFor info,"statemachine_TEST_B_State1","";

        CASE statemachine_TEST_Event_B2:
            stateChangeTo info,"statemachine_TEST_B_State2","";
            IF info.eInfo.valueData.Value<>"" stateSuspendFor info,"statemachine_TEST_B_State2","";

        CASE statemachine_TEST_Event_B3:
            stateChangeTo info,"statemachine_TEST_B_State3","";
            IF info.eInfo.valueData.Value<>"" stateSuspendFor info,"statemachine_TEST_B_State3","";

        CASE statemachine_TEST_Event_B4:
            stateChangeTo info,"statemachine_TEST_B_State4","";
            IF info.eInfo.valueData.Value<>"" stateSuspendFor info,"statemachine_TEST_B_State4","";

        DEFAULT:

        ENDTEST
    ERROR
        RAISE ;
    ENDPROC

    PROC statemachine_TEST_B_State2(INOUT stateInfo info)
        TEST info.eInfo.triggerEvent

        CASE onStart:
            debugResult:="statemachine_TEST_B_State2";

        CASE statemachine_TEST_Event_B0_Done:
            stateDone info,"";

        CASE statemachine_TEST_Event_B1:
            stateChangeTo info,"statemachine_TEST_B_State1","";
            IF info.eInfo.valueData.Value<>"" stateSuspendFor info,"statemachine_TEST_B_State1","";

        CASE statemachine_TEST_Event_B2:
            stateChangeTo info,"statemachine_TEST_B_State2","";
            IF info.eInfo.valueData.Value<>"" stateSuspendFor info,"statemachine_TEST_B_State2","";

        CASE statemachine_TEST_Event_B3:
            stateChangeTo info,"statemachine_TEST_B_State3","";
            IF info.eInfo.valueData.Value<>"" stateSuspendFor info,"statemachine_TEST_B_State3","";

        CASE statemachine_TEST_Event_B4:
            stateChangeTo info,"statemachine_TEST_B_State4","";
            IF info.eInfo.valueData.Value<>"" stateSuspendFor info,"statemachine_TEST_B_State4","";

        DEFAULT:

        ENDTEST
    ERROR
        RAISE ;
    ENDPROC

    PROC statemachine_TEST_B_State3(INOUT stateInfo info)
        TEST info.eInfo.triggerEvent

        CASE onStart:
            debugResult:="statemachine_TEST_B_State3";

        CASE statemachine_TEST_Event_B0_Done:
            stateDone info,"";

        CASE statemachine_TEST_Event_B1:
            stateChangeTo info,"statemachine_TEST_B_State1","";
            IF info.eInfo.valueData.Value<>"" stateSuspendFor info,"statemachine_TEST_B_State1","";

        CASE statemachine_TEST_Event_B2:
            stateChangeTo info,"statemachine_TEST_B_State2","";
            IF info.eInfo.valueData.Value<>"" stateSuspendFor info,"statemachine_TEST_B_State2","";

        CASE statemachine_TEST_Event_B3:
            stateChangeTo info,"statemachine_TEST_B_State3","";
            IF info.eInfo.valueData.Value<>"" stateSuspendFor info,"statemachine_TEST_B_State3","";

        CASE statemachine_TEST_Event_B4:
            stateChangeTo info,"statemachine_TEST_B_State4","";
            IF info.eInfo.valueData.Value<>"" stateSuspendFor info,"statemachine_TEST_B_State4","";

        DEFAULT:

        ENDTEST
    ERROR
        RAISE ;
    ENDPROC

    PROC statemachine_TEST_B_State4(INOUT stateInfo info)
        TEST info.eInfo.triggerEvent

        CASE onStart:
            debugResult:="statemachine_TEST_B_State4";

        CASE statemachine_TEST_Event_B0_Done:
            stateDone info,"";

        CASE statemachine_TEST_Event_B1:
            stateChangeTo info,"statemachine_TEST_B_State1","";
            IF info.eInfo.valueData.Value<>"" stateSuspendFor info,"statemachine_TEST_B_State1","";

        CASE statemachine_TEST_Event_B2:
            stateChangeTo info,"statemachine_TEST_B_State2","";
            IF info.eInfo.valueData.Value<>"" stateSuspendFor info,"statemachine_TEST_B_State2","";

        CASE statemachine_TEST_Event_B3:
            stateChangeTo info,"statemachine_TEST_B_State3","";
            IF info.eInfo.valueData.Value<>"" stateSuspendFor info,"statemachine_TEST_B_State3","";

        CASE statemachine_TEST_Event_B4:
            stateChangeTo info,"statemachine_TEST_B_State4","";
            IF info.eInfo.valueData.Value<>"" stateSuspendFor info,"statemachine_TEST_B_State4","";

        DEFAULT:

        ENDTEST
    ERROR
        RAISE ;
    ENDPROC


ENDMODULE
