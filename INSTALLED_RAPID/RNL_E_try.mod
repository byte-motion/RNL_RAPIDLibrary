MODULE RNL_E_try

    !RNL_E_try is module that allows the creation and manipulation of "objects"
    !objects have the following features:
    ! - All objects have pointers of type "objectPointer", allowing interchangeability
    ! - Object can inherit methods and data from other objects
    ! - inherited methods are overwritable, allowing "Younger" objects to customize
    ! - 

    !Dependencies
    ! - ----RNL_E_procedurePointer----
    ! - RNL_E_dataPointer
    ! - 

    !objectSelf is included in every object to describe where in the
    !inheritance chain it appears
    RECORD objectSelf
        dataPointer data;
        num inheritancelevel;
        dataPointer object;
    ENDRECORD

    !universal procedure for calling other procedures by late binding.
    !Use without objects:
    ! - Will call any global procedure
    ! - Allows up to 12 arguments that are dataPointer
    !Use with objects:
    ! - Will call any global procedure on any global object
    ! - Allows up to 12 arguments that are dataPointer
    ! (1st argument is allways a data pointer to the object data)
    ! - Will try to call the procedure on the topmost object in the inheritane
    ! - wil continue to try calling the procedure down the inheritor chain
    PROC try(

        \dataPointer obj,

        string procedureName,

        \dataPointer arg1
        |INOUT dataPointer arg1_INOUT
        \dataPointer arg2
        |INOUT dataPointer arg2_INOUT
        \dataPointer arg3
        \dataPointer arg4
        \dataPointer arg5
        \dataPointer arg6
        \dataPointer arg7
        \dataPointer arg8
        \dataPointer arg9
        \dataPointer arg10
        \dataPointer arg11
        \dataPointer arg12

        \INOUT bool successFlag
        \num MaxTime
        \INOUT bool TimeFlag
        \INOUT num executionTime
        )

        VAR dataPointer object_;
        VAR dataPointer object_inheritanceParent_;

        VAR string objectModuleName;
        VAR bool procedureExecuted;

        VAR clock executionTimeClock;

        !Setup object_ data 
        object_:=dataPointer_NULL;
        IF Present(obj) object_:=obj;

        !Handle successFlag
        IF Present(successFlag) successFlag:=FALSE;

        !Start executionTimeClock 
        ClkStart executionTimeClock;

        !Find object module name for this inheritor. This is nessesary to call local
        !procedures from that module
        !If object is not specified, object module name is left blank
        objectModuleName:="";
        IF object_<>dataPointer_NULL objectModuleName:="RNL__"+object_.type+":";

        !Try to call the method
        procedureExecuted:=TRUE;
        IF object_<>dataPointer_NULL THEN
            !With object
            IF Present(arg12) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %object_,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %object_,arg1_INOUT,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1_INOUT,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1_INOUT,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12;
            ELSEIF Present(arg11) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %object_,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %object_,arg1_INOUT,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1,arg2_INOUT,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1_INOUT,arg2_INOUT,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11;
            ELSEIF Present(arg10) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %object_,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %object_,arg1_INOUT,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1,arg2_INOUT,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1_INOUT,arg2_INOUT,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10;
            ELSEIF Present(arg9) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %object_,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %object_,arg1_INOUT,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1,arg2_INOUT,arg3,arg4,arg5,arg6,arg7,arg8,arg9;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1_INOUT,arg2_INOUT,arg3,arg4,arg5,arg6,arg7,arg8,arg9;
            ELSEIF Present(arg8) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %object_,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %object_,arg1_INOUT,arg2,arg3,arg4,arg5,arg6,arg7,arg8;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1,arg2_INOUT,arg3,arg4,arg5,arg6,arg7,arg8;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1_INOUT,arg2_INOUT,arg3,arg4,arg5,arg6,arg7,arg8;
            ELSEIF Present(arg7) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %object_,arg1,arg2,arg3,arg4,arg5,arg6,arg7;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %object_,arg1_INOUT,arg2,arg3,arg4,arg5,arg6,arg7;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1,arg2_INOUT,arg3,arg4,arg5,arg6,arg7;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1_INOUT,arg2_INOUT,arg3,arg4,arg5,arg6,arg7;
            ELSEIF Present(arg6) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %object_,arg1,arg2,arg3,arg4,arg5,arg6;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %object_,arg1_INOUT,arg2,arg3,arg4,arg5,arg6;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1,arg2_INOUT,arg3,arg4,arg5,arg6;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1_INOUT,arg2_INOUT,arg3,arg4,arg5,arg6;
            ELSEIF Present(arg5) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %object_,arg1,arg2,arg3,arg4,arg5;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %object_,arg1_INOUT,arg2,arg3,arg4,arg5;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1,arg2_INOUT,arg3,arg4,arg5;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1_INOUT,arg2_INOUT,arg3,arg4,arg5;
            ELSEIF Present(arg4) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %object_,arg1,arg2,arg3,arg4;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %object_,arg1_INOUT,arg2,arg3,arg4;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1,arg2_INOUT,arg3,arg4;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1_INOUT,arg2_INOUT,arg3,arg4;
            ELSEIF Present(arg3) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %object_,arg1,arg2,arg3;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %object_,arg1_INOUT,arg2,arg3;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1,arg2_INOUT,arg3;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1_INOUT,arg2_INOUT,arg3;
            ELSEIF Present(arg2) OR Present(arg2_INOUT) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %object_,arg1,arg2;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %object_,arg1_INOUT,arg2;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1,arg2_INOUT;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %object_,arg1_INOUT,arg2_INOUT;
            ELSEIF Present(arg1) OR Present(arg1_INOUT) THEN
                IF Present(arg1)%objectModuleName+procedureName %object_,arg1;
                IF Present(arg1_INOUT)%objectModuleName+procedureName %object_,arg1_INOUT;
            ELSE
                %objectModuleName+procedureName %object_;
            ENDIF
        ELSE
            !Without object
            IF Present(arg12) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %arg1_INOUT,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1,arg2_INOUT,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1_INOUT,arg2_INOUT,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12;
            ELSEIF Present(arg11) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %arg1_INOUT,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1,arg2_INOUT,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1_INOUT,arg2_INOUT,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11;
            ELSEIF Present(arg10) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %arg1_INOUT,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1,arg2_INOUT,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1_INOUT,arg2_INOUT,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10;
            ELSEIF Present(arg9) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %arg1_INOUT,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1,arg2_INOUT,arg3,arg4,arg5,arg6,arg7,arg8,arg9;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1_INOUT,arg2_INOUT,arg3,arg4,arg5,arg6,arg7,arg8,arg9;
            ELSEIF Present(arg8) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %arg1_INOUT,arg2,arg3,arg4,arg5,arg6,arg7,arg8;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1,arg2_INOUT,arg3,arg4,arg5,arg6,arg7,arg8;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1_INOUT,arg2_INOUT,arg3,arg4,arg5,arg6,arg7,arg8;
            ELSEIF Present(arg7) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %arg1,arg2,arg3,arg4,arg5,arg6,arg7;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %arg1_INOUT,arg2,arg3,arg4,arg5,arg6,arg7;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1,arg2_INOUT,arg3,arg4,arg5,arg6,arg7;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1_INOUT,arg2_INOUT,arg3,arg4,arg5,arg6,arg7;
            ELSEIF Present(arg6) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %arg1,arg2,arg3,arg4,arg5,arg6;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %arg1_INOUT,arg2,arg3,arg4,arg5,arg6;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1,arg2_INOUT,arg3,arg4,arg5,arg6;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1_INOUT,arg2_INOUT,arg3,arg4,arg5,arg6;
            ELSEIF Present(arg5) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %arg1,arg2,arg3,arg4,arg5;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %arg1_INOUT,arg2,arg3,arg4,arg5;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1,arg2_INOUT,arg3,arg4,arg5;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1_INOUT,arg2_INOUT,arg3,arg4,arg5;
            ELSEIF Present(arg4) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %arg1,arg2,arg3,arg4;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %arg1_INOUT,arg2,arg3,arg4;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1,arg2_INOUT,arg3,arg4;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1_INOUT,arg2_INOUT,arg3,arg4;
            ELSEIF Present(arg3) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %arg1,arg2,arg3;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %arg1_INOUT,arg2,arg3;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1,arg2_INOUT,arg3;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1_INOUT,arg2_INOUT,arg3;
            ELSEIF Present(arg2) OR Present(arg2_INOUT) THEN
                IF Present(arg1) AND Present(arg2)%objectModuleName+procedureName %arg1,arg2;
                IF Present(arg1_INOUT) AND Present(arg2)%objectModuleName+procedureName %arg1_INOUT,arg2;
                IF Present(arg1) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1,arg2_INOUT;
                IF Present(arg1_INOUT) AND Present(arg2_INOUT)%objectModuleName+procedureName %arg1_INOUT,arg2_INOUT;
            ELSEIF Present(arg1) OR Present(arg1_INOUT) THEN
                IF Present(arg1)%objectModuleName+procedureName %arg1;
                IF Present(arg1_INOUT)%objectModuleName+procedureName %arg1_INOUT;
            ELSE
                %objectModuleName+procedureName %;
            ENDIF
        ENDIF

        !If procedure call failed, and there exists an inehritance parent:
        !Recursively try to call the inheritance parent chain
        IF procedureExecuted=FALSE AND object_.inheritanceParent<>"" THEN

            !Fetch inheritanceParent
            GetDataVal object_.inheritanceParent,object_inheritanceParent_;

            !Recursive call using inheritanceParent as object
            try
            \obj:=object_inheritanceParent_,
            procedureName
            \arg1?arg1
            \arg1_INOUT?arg1_INOUT
            \arg2?arg2
            \arg2_INOUT?arg2_INOUT
            \arg3?arg3
            \arg4?arg4
            \arg5?arg5
            \arg6?arg6
            \arg7?arg7
            \arg8?arg8
            \arg9?arg9
            \arg10?arg10
            \arg11?arg11
            \arg12?arg12
            \successFlag:=procedureExecuted
            \MaxTime?MaxTime
            \TimeFlag?TimeFlag
            \executionTime?executionTime;
        ENDIF

        !Stop executionTimeClock 
        ClkStop executionTimeClock;
        IF Present(executionTime) executionTime:=ClkRead(executionTimeClock);

        !If no recursive inheritance call was successfull, handle failure
        IF procedureExecuted=FALSE THEN
            !ERROR
            !Was not able to call any inheritor with that object/procedure/argument combination
            !successFlag stays false

        ELSE
            !Success
            IF Present(successFlag) successFlag:=TRUE;
        ENDIF

    ERROR

        !Check if error is latebinding
        IF ERRNO=ERR_REFUNKDAT
        OR ERRNO=ERR_REFUNKFUN
        OR ERRNO=ERR_REFUNKPRC
        OR ERRNO=ERR_CALLPROC
        THEN
            !late bidning failed, set flag
            SkipWarn;
            procedureExecuted:=FALSE;
            TRYNEXT;
        ENDIF

        ! Failed to reach inheritorParent
        IF ERRNO=ERR_SYM_ACCESS THEN
            !Inheritor chain is broken
            ErrWrite "try() - inheritor chain broken",
                "unable to reach inheritor in object inheritor chain";

            !Stop executionTimeClock 
            ClkStop executionTimeClock;
            IF Present(executionTime) executionTime:=ClkRead(executionTimeClock);

            RAISE ;
        ENDIF

        !Stop executionTimeClock 
        ClkStop executionTimeClock;
        IF Present(executionTime) executionTime:=ClkRead(executionTimeClock);

        RAISE ;

    ENDPROC


    !Simplified interface to call try
    PROC call(

        dataPointer obj,

        string procedureName,

        \string n1
        |string v1
        |INOUT string v1_INOUT
        \string n2
        |string v2
        |INOUT string v2_INOUT
        \string n3
        |string v3
        \string n4
        |string v4
        \string n5
        |string v5
        \string n6
        |string v6
        \string n7
        |string v7
        \string n8
        |string v8
        \string n9
        |string v9
        \string n10
        |string v10
        \string n11
        |string v11
        \string n12
        |string v12

        \INOUT bool successFlag
        \num MaxTime
        \INOUT bool TimeFlag
        \INOUT num executionTime
        )

        VAR dataPointer arg1;
        VAR dataPointer arg2;
        VAR dataPointer arg3;
        VAR dataPointer arg4;
        VAR dataPointer arg5;
        VAR dataPointer arg6;
        VAR dataPointer arg7;
        VAR dataPointer arg8;
        VAR dataPointer arg9;
        VAR dataPointer arg10;
        VAR dataPointer arg11;
        VAR dataPointer arg12;

        !Prepare arguments for try()
        IF Present(n1) arg1.name:=n1;
        IF Present(v1) arg1.value:=v1;
        IF Present(v1_INOUT) arg1.value:=v1_INOUT;
        IF Present(n2) arg2.name:=n2;
        IF Present(v2) arg2.value:=v2;
        IF Present(v2_INOUT) arg2.value:=v2_INOUT;
        IF Present(n3) arg3.name:=n3;
        IF Present(v3) arg3.value:=v3;
        IF Present(n4) arg4.name:=n4;
        IF Present(v4) arg4.value:=v4;
        IF Present(n5) arg5.name:=n5;
        IF Present(v5) arg5.value:=v5;
        IF Present(n6) arg6.name:=n6;
        IF Present(v6) arg6.value:=v6;
        IF Present(n7) arg7.name:=n7;
        IF Present(v7) arg7.value:=v7;
        IF Present(n8) arg8.name:=n8;
        IF Present(v8) arg8.value:=v8;
        IF Present(n9) arg9.name:=n9;
        IF Present(v9) arg9.value:=v9;
        IF Present(n11) arg11.name:=n11;
        IF Present(v11) arg11.value:=v11;
        IF Present(n10) arg10.name:=n10;
        IF Present(v10) arg10.value:=v10;
        IF Present(n12) arg12.name:=n12;
        IF Present(v12) arg12.value:=v12;
        IF Present(n10) arg10.name:=n10;
        IF Present(v10) arg10.value:=v10;

        !Call try()
        IF arg12<>dataPointer_NULL THEN
            try\obj:=obj,procedureName\arg1_INOUT:=arg1\arg2_INOUT:=arg2\arg3:=arg3\arg4:=arg4\arg5:=arg5\arg6:=arg6\arg7:=arg7\arg8:=arg8\arg9:=arg9\arg10:=arg10\arg11:=arg11\arg12:=arg12\successFlag?successFlag\MaxTime?MaxTime\TimeFlag?TimeFlag\executionTime?executionTime;
        ELSEIF arg11<>dataPointer_NULL THEN
            try\obj:=obj,procedureName\arg1_INOUT:=arg1\arg2_INOUT:=arg2\arg3:=arg3\arg4:=arg4\arg5:=arg5\arg6:=arg6\arg7:=arg7\arg8:=arg8\arg9:=arg9\arg10:=arg10\arg11:=arg11\successFlag?successFlag\MaxTime?MaxTime\TimeFlag?TimeFlag\executionTime?executionTime;
        ELSEIF arg10<>dataPointer_NULL THEN
            try\obj:=obj,procedureName\arg1_INOUT:=arg1\arg2_INOUT:=arg2\arg3:=arg3\arg4:=arg4\arg5:=arg5\arg6:=arg6\arg7:=arg7\arg8:=arg8\arg9:=arg9\arg10:=arg10\successFlag?successFlag\MaxTime?MaxTime\TimeFlag?TimeFlag\executionTime?executionTime;
        ELSEIF arg9<>dataPointer_NULL THEN
            try\obj:=obj,procedureName\arg1_INOUT:=arg1\arg2_INOUT:=arg2\arg3:=arg3\arg4:=arg4\arg5:=arg5\arg6:=arg6\arg7:=arg7\arg8:=arg8\arg9:=arg9\successFlag?successFlag\MaxTime?MaxTime\TimeFlag?TimeFlag\executionTime?executionTime;
        ELSEIF arg8<>dataPointer_NULL THEN
            try\obj:=obj,procedureName\arg1_INOUT:=arg1\arg2_INOUT:=arg2\arg3:=arg3\arg4:=arg4\arg5:=arg5\arg6:=arg6\arg7:=arg7\arg8:=arg8\successFlag?successFlag\MaxTime?MaxTime\TimeFlag?TimeFlag\executionTime?executionTime;
        ELSEIF arg7<>dataPointer_NULL THEN
            try\obj:=obj,procedureName\arg1_INOUT:=arg1\arg2_INOUT:=arg2\arg3:=arg3\arg4:=arg4\arg5:=arg5\arg6:=arg6\arg7:=arg7\successFlag?successFlag\MaxTime?MaxTime\TimeFlag?TimeFlag\executionTime?executionTime;
        ELSEIF arg6<>dataPointer_NULL THEN
            try\obj:=obj,procedureName\arg1_INOUT:=arg1\arg2_INOUT:=arg2\arg3:=arg3\arg4:=arg4\arg5:=arg5\arg6:=arg6\successFlag?successFlag\MaxTime?MaxTime\TimeFlag?TimeFlag\executionTime?executionTime;
        ELSEIF arg5<>dataPointer_NULL THEN
            try\obj:=obj,procedureName\arg1_INOUT:=arg1\arg2_INOUT:=arg2\arg3:=arg3\arg4:=arg4\arg5:=arg5\successFlag?successFlag\MaxTime?MaxTime\TimeFlag?TimeFlag\executionTime?executionTime;
        ELSEIF arg4<>dataPointer_NULL THEN
            try\obj:=obj,procedureName\arg1_INOUT:=arg1\arg2_INOUT:=arg2\arg3:=arg3\arg4:=arg4\successFlag?successFlag\MaxTime?MaxTime\TimeFlag?TimeFlag\executionTime?executionTime;
        ELSEIF arg3<>dataPointer_NULL THEN
            try\obj:=obj,procedureName\arg1_INOUT:=arg1\arg2_INOUT:=arg2\arg3:=arg3\successFlag?successFlag\MaxTime?MaxTime\TimeFlag?TimeFlag\executionTime?executionTime;
        ELSEIF arg2<>dataPointer_NULL THEN
            try\obj:=obj,procedureName\arg1_INOUT:=arg1\arg2_INOUT:=arg2\successFlag?successFlag\MaxTime?MaxTime\TimeFlag?TimeFlag\executionTime?executionTime;
        ELSEIF arg1<>dataPointer_NULL THEN
            try\obj:=obj,procedureName\arg1_INOUT:=arg1\successFlag?successFlag\MaxTime?MaxTime\TimeFlag?TimeFlag\executionTime?executionTime;
        ELSE
            try\obj:=obj,procedureName\successFlag?successFlag\MaxTime?MaxTime\TimeFlag?TimeFlag\executionTime?executionTime;
        ENDIF

        !Set INOUT parameters
        IF Present(v1_INOUT) v1_INOUT:=arg1.value;
        IF Present(v2_INOUT) v2_INOUT:=arg2.value;

    ERROR
        RAISE ;
    ENDPROC

    !simplified interface for call() with generic return value
    FUNC string get(

        dataPointer obj,

        string procedureName,

        \string n2
        \string v2
        |string v2_INOUT
        \string n3
        |string v3
        \string n4
        |string v4
        \string n5
        |string v5
        \string n6
        |string v6
        \string n7
        |string v7
        \string n8
        |string v8
        \string n9
        |string v9
        \string n10
        |string v10
        \string n11
        |string v11
        \string n12
        |string v12

        \INOUT bool successFlag
        \num MaxTime
        \INOUT bool TimeFlag
        \INOUT num executionTime
        )

        VAR string returnData;

        call
            obj,
            "get"+procedureName
            \v1_INOUT:=returnData,
            \n2?n2
            \v2?v2
            \v2_INOUT?v2_INOUT
            \n3?n3
            \v3?v3
            \n4?n4
            \v4?v4
            \n5?n5
            \v5?v5
            \n6?n6
            \v6?v6
            \n7?n7
            \v7?v7
            \n8?n8
            \v8?v8
            \n9?n9
            \v9?v9
            \n10?n10
            \v10?v10
            \n11?n11
            \v11?v11
            \n12?n12
            \v12?v12
            \successFlag?successFlag
            \MaxTime?MaxTime
            \TimeFlag?TimeFlag
            \executionTime?executionTime;

        RETURN returnData;

    ERROR
        RAISE ;
    ENDFUNC

    !simplified interface for call() with boolean return value
    FUNC bool is(

        dataPointer obj,

        string procedureName,

        \string n2
        \string v2
        |string v2_INOUT
        \string n3
        |string v3
        \string n4
        |string v4
        \string n5
        |string v5
        \string n6
        |string v6
        \string n7
        |string v7
        \string n8
        |string v8
        \string n9
        |string v9
        \string n10
        |string v10
        \string n11
        |string v11
        \string n12
        |string v12

        \INOUT bool successFlag
        \num MaxTime
        \INOUT bool TimeFlag
        \INOUT num executionTime
        )

        VAR dataPointer returnData;
        VAR bool returnBool;

        call
            obj,
            "is"+procedureName
            \v1_INOUT:=returnData.value,
            \n2?n2
            \v2?v2
            \v2_INOUT?v2_INOUT
            \n3?n3
            \v3?v3
            \n4?n4
            \v4?v4
            \n5?n5
            \v5?v5
            \n6?n6
            \v6?v6
            \n7?n7
            \v7?v7
            \n8?n8
            \v8?v8
            \n9?n9
            \v9?v9
            \n10?n10
            \v10?v10
            \n11?n11
            \v11?v11
            \n12?n12
            \v12?v12
            \successFlag?successFlag
            \MaxTime?MaxTime
            \TimeFlag?TimeFlag
            \executionTime?executionTime;

        errFromBool StrToVal(returnData.value,returnBool),ERR_SYM_ACCESS;

        RETURN returnBool;

    ERROR
        RAISE ;
    ENDFUNC


ENDMODULE
