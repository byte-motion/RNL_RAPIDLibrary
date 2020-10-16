MODULE RNL_E_event

    !RNL_E_event implements events as a structure in RAPID.
    !Events are used to loosly connect code in a flexible and dynamic manner.
    !Events are closely integrated with state machines, objects, and data pointers,

    !Dependencies:
    ! - dataPointer
    ! - 

    RECORD event
        num id;
    ENDRECORD

    ALIAS num eventPriority;

    RECORD eventInfo
        event triggerEvent;
        dataPointer triggerObject;

        dataPointer valueData;
        unixTime timestamp;
    ENDRECORD

    RECORD eventSubscription
        eventPriority priority;

        event triggerEvent;
        dataPointer triggerObject;

        string reciverProcName;
        dataPointer reciverObject;

        event aliasEvent;
        dataPointer aliasObject;
    ENDRECORD

    RECORD eventSubscriptionList
        eventSubscription subscription_1;
        eventSubscription subscription_2;
        eventSubscription subscription_3;
        eventSubscription subscription_4;
        eventSubscription subscription_5;
    ENDRECORD

    !Data

    !NULL
    VAR eventSubscription eventSubscription_NULL;
    PERS eventSubscriptionList eventSubscriptionList_NULL;
    CONST event event_NULL:=[0];

    !List lenght
    CONST num eventSubscriptionList_NO:=5;

    !Database of "Homeless" eventSubscriptions
    PERS eventSubscription eventSubscription_List{1000};

    !Methods

    !Checks if event is still null, and if so, loops through all declared events
    !and finds an available id to allocate an event.
    !Relatively slow, but is only required once as events are PERSistant.
    PROC event_setup(INOUT event e)

        var datapos block;
        VAR string name;
        VAR event oldEventValue;
        VAR event newEventValue;
        VAR bool valueConflict;

        VAR bool symbolValid;

        !If event is allready set up, return
        IF e<>event_NULL RETURN ;

        !Loop through all events and look for an available numeric value
        newEventValue.id:=1;
        valueConflict:=TRUE;
        WHILE valueConflict=TRUE DO
            valueConflict:=FALSE;
            oldEventValue:=event_NULL;
            SetDataSearch "event"\TypeMod:="RNL_E_event"\PersSym;
            !Loop through all events, logging conflicts
            WHILE GetNextSym(name,block\Recursive) DO
                symbolValid:=TRUE;
                GetDataVal name\Block:=block,oldEventValue;
                IF symbolValid AND name<>ArgName(e) THEN
                    IF newEventValue=oldEventValue valueConflict:=TRUE;
                    IF newEventValue=oldEventValue newEventValue.id:=oldEventValue.id+1;
                ENDIF
            ENDWHILE
        ENDWHILE

        e:=newEventValue;

    ERROR
        !ERR_SYM_ACCESS means that the found symbol was unaccessable
        IF ERRNO=ERR_SYM_ACCESS THEN
            symbolValid:=FALSE;
            TRYNEXT;
        ENDIF
        RAISE ;
    ENDPROC

    !Get index from list
    FUNC eventSubscription eventSubscriptionList_getSub(
        eventSubscriptionList list,
        num i)

        TEST i
        CASE 1:
            RETURN list.subscription_1;
        CASE 2:
            RETURN list.subscription_2;
        CASE 3:
            RETURN list.subscription_3;
        CASE 4:
            RETURN list.subscription_4;
        CASE 5:
            RETURN list.subscription_5;
        DEFAULT:
            !ERROR
            ErrWrite "Index out of bounds","eventSubscriptionList_getSub";
            stop;
        ENDTEST

    ENDFUNC

    !Set index in list
    FUNC eventSubscription eventSubscriptionList_setSub(
        eventSubscriptionList list,
        num i,
        eventSubscription subscription)

        TEST i
        CASE 1:
            list.subscription_1:=subscription;
        CASE 2:
            list.subscription_2:=subscription;
        CASE 3:
            list.subscription_3:=subscription;
        CASE 4:
            list.subscription_4:=subscription;
        CASE 5:
            list.subscription_5:=subscription;
        DEFAULT:
            !ERROR
            ErrWrite "Index out of bounds","eventSubscriptionList_setSub";
            stop;
        ENDTEST
    ENDFUNC


    !Create a new event subscription
    FUNC eventSubscription NEW_eventSubscription(
    \dataPointer object,
    INOUT event e,
    \dataPointer reciverObject,
    procedurePointer reciverProcName
    \dataPointer aliasObject,
    \INOUT event aliasEvent,
    \num priority)

        VAR dataPointer object_;
        VAR dataPointer reciverObject_;
        VAR dataPointer aliasObject_;
        VAR event aliasEvent_;
        VAR num priority_;

        VAR eventSubscription subscription;

        !Setup event if not allready set up
        event_setup e;
        IF Present(aliasEvent) event_setup aliasEvent;

        !set up local data
        object_:=dataPointer_NULL;
        IF Present(object) object_:=object;

        reciverObject_:=dataPointer_NULL;
        IF Present(reciverObject) reciverObject_:=reciverObject;

        aliasObject_:=dataPointer_NULL;
        IF Present(aliasObject) aliasObject_:=aliasObject;

        aliasEvent_:=event_NULL;
        IF Present(aliasEvent) aliasEvent_:=aliasEvent;

        priority_:=0;
        IF Present(priority) priority_:=priority;

        !Construct the eventsubscription
        subscription.triggerObject:=object_;
        subscription.triggerEvent:=e;

        subscription.reciverObject:=reciverObject_;
        subscription.reciverProcName:=reciverProcName;

        subscription.aliasObject:=aliasObject_;
        subscription.aliasEvent:=aliasEvent_;

        subscription.priority:=priority_;


        RETURN subscription;

    ENDFUNC

    !Procedure used to trigger an event
    !arg2 through 12 are added for cases where an event should deliver 
    !Multible values, should rarely be used
    PROC event_trigger(
    \dataPointer object,
    INOUT event e,
    \dataPointer valueData,
    \eventSubscriptionList SubscriptionList
    |eventSubscription SubscriptionArray{*}
    \dataPointer arg2,
    \dataPointer arg3,
    \dataPointer arg4,
    \dataPointer arg5,
    \dataPointer arg6,
    \dataPointer arg7,
    \dataPointer arg8,
    \dataPointer arg9,
    \dataPointer arg10,
    \dataPointer arg11,
    \dataPointer arg12
    )

        VAR eventInfo notification;
        VAR eventSubscription subscription;

        VAR num currentPriotity;
        VAR num nextPriotity;

        !Num max and min values retrived from the documentation
        VAR num numMax:=8388608;
        VAR num numMin:=-8388607;

        !Data Search variables
        VAR datapos block;
        VAR string name;
        VAR bool symbolValid;

        !Set Timestamp for the event
        notification.timestamp:=unixTime_getCurrent();

        !Setup event if not allready set up
        event_setup e;

        !Set up event notification
        notification.triggerEvent:=e;
        IF Present(object) notification.triggerObject:=object;
        IF Present(valueData) notification.valueData:=valueData;

        !Loop through, and try to execute the eventSubscriptions on each priority
        currentPriotity:=numMax;
        WHILE currentPriotity>numMin DO

            nextPriotity:=numMin;

            !Loop over all subscriptions
            IF Present(SubscriptionList) THEN

                !Loop for Subscription List

                FOR i FROM 1 TO eventSubscriptionList_NO DO
                    subscription:=eventSubscriptionList_getSub(SubscriptionList,i);
                    !Execute subscription
                    eventSubscription_execute subscription,notification\priority:=currentPriotity
                        \arg2?arg2,
                        \arg3?arg3,
                        \arg4?arg4,
                        \arg5?arg5,
                        \arg6?arg6,
                        \arg7?arg7,
                        \arg8?arg8,
                        \arg9?arg9,
                        \arg10?arg10,
                        \arg11?arg11,
                        \arg12?arg12;

                    !Evaluate what next priority should be (current highest)
                    IF subscription.priority>nextPriotity AND subscription.priority<currentPriotity
                        nextPriotity:=subscription.priority;

                ENDFOR

            ELSEIF Present(SubscriptionArray) THEN

                !Loop for Subscription Array

                FOR i FROM 1 TO Dim(SubscriptionArray,1) DO
                    subscription:=SubscriptionArray{i};
                    eventSubscription_execute subscription,notification\priority:=currentPriotity
                        \arg2?arg2,
                        \arg3?arg3,
                        \arg4?arg4,
                        \arg5?arg5,
                        \arg6?arg6,
                        \arg7?arg7,
                        \arg8?arg8,
                        \arg9?arg9,
                        \arg10?arg10,
                        \arg11?arg11,
                        \arg12?arg12;

                    !Evaluate what next priority should be (current highest)
                    IF subscription.priority>nextPriotity AND subscription.priority<currentPriotity
                        nextPriotity:=subscription.priority;

                ENDFOR

            ELSE

                !Loop for global search (default option of nothing else is specified)

                SetDataSearch "eventSubscription"\TypeMod:="RNL_E_event"\PersSym;
                WHILE GetNextSym(name,block\Recursive) DO
                    symbolValid:=TRUE;
                    GetDataVal name,\block:=block,subscription;

                    IF symbolValid THEN

                        eventSubscription_execute subscription,notification\priority:=currentPriotity
                            \arg2?arg2,
                            \arg3?arg3,
                            \arg4?arg4,
                            \arg5?arg5,
                            \arg6?arg6,
                            \arg7?arg7,
                            \arg8?arg8,
                            \arg9?arg9,
                            \arg10?arg10,
                            \arg11?arg11,
                            \arg12?arg12;

                        !Evaluate what next priority should be (current highest)
                        IF subscription.priority>nextPriotity AND subscription.priority<currentPriotity
                        nextPriotity:=subscription.priority;

                    ENDIF

                ENDWHILE

            ENDIF

            currentPriotity:=nextPriotity;

        ENDWHILE

        !Finished

    ERROR

        IF ERRNO=ERR_SYM_ACCESS THEN
            symbolValid:=FALSE;
            TRYNEXT;
        ENDIF

        RAISE ;
    ENDPROC

    !Check an event subscription and execute it if it fits the event
    PROC eventSubscription_execute(
        eventSubscription subscription,
        eventInfo notifaction,
        \num priority
        \dataPointer arg2,
        \dataPointer arg3,
        \dataPointer arg4,
        \dataPointer arg5,
        \dataPointer arg6,
        \dataPointer arg7,
        \dataPointer arg8,
        \dataPointer arg9,
        \dataPointer arg10,
        \dataPointer arg11,
        \dataPointer arg12
        )

        VAR bool successFlag;

        !does the event match the subscription? If not, return.
        IF (notifaction.triggerEvent<>subscription.triggerEvent)
        OR (notifaction.triggerObject<>subscription.triggerObject) THEN
            RETURN ;
        ENDIF

        !If priority is specified, only execute if priority is correct
        IF Present(priority) THEN
            IF priority<>subscription.priority RETURN ;
        ENDIF

        !Does this subscription specify an alias? if so, apply it.
        IF subscription.aliasEvent<>event_NULL
        notifaction.triggerEvent:=subscription.aliasEvent;

        IF subscription.aliasObject<>dataPointer_NULL
        notifaction.triggerObject:=subscription.aliasObject;

        !Ready to call event reciver
        try
        \obj:=subscription.reciverObject,
        subscription.reciverProcName
        \arg1:=ref(\A_type:="eventInfo"\A_value:=ValToStr(notifaction))
        \arg2?arg2,
        \arg3?arg3,
        \arg4?arg4,
        \arg5?arg5,
        \arg6?arg6,
        \arg7?arg7,
        \arg8?arg8,
        \arg9?arg9,
        \arg10?arg10,
        \arg11?arg11,
        \arg12?arg12
        \successFlag:=successFlag;

        IF NOT successFlag THEN
            !ERROR
            ErrWrite "Subscription failed to call response: "+subscription.reciverProcName
            ,"in object: "+subscription.reciverObject.name
            \RL2:="The calling event was: " + ValToStr(notifaction.triggerEvent)
            \RL3:="From object: " + ValToStr(notifaction.triggerObject.name);
            stop;
        ENDIF

    ERROR
        RAISE ;

    ENDPROC

    !Example

    !on_exampleEvent is an example event response.
    PROC on_exampleEvent(eventInfo eInfo)
        <SMT>
    ENDPROC


ENDMODULE
