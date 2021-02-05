# RnLibStateMachine.sys



## Usage

One instruction will setup error trigg conditions together with a defined procedure name to catch errors. The catch routine can be used to check if the error is relevant and/or if actions are necessary.



## Installation

1. Load modules in designated task. This should be a semistatic task to catch all errors, even when motion tasks are stopped.
* RNL_B_ErrorCatcher.sys

2. Define the initial call to setup interrupt.

3. Declare and setup catch routine.

## Example 

*Example:*
```
    LOCAL PROC Init()
        ! Catch all errors
        InitErrorHandling "ElogErrorCatcher";
    ENDPROC

    PROC ElogErrorCatcher(errdomain ErrorDomain,num ErrorNr,errtype ErrorType,string ErrText{*})

        TEST ErrorDomain
        CASE MOTION_ERR:
            ! This is a motion error
        ENDTEST

        IF ErrorNr=0008 THEN
            ! Error 10008 Program restarted
        ENDIF

        TEST ErrorType
        CASE TYPE_WARN:
            ! Only a warning
        CASE TYPE_ERR:
            ! This is an error
        ENDTEST

    ENDPROC
```



## Functions / Instructions

**PROC InitErrorHandling(\errdomain ErrorDomain,\num ErrorId,\errtype ErrorType,string Procedure)**

Setup interrupt for catching errors.



## Error handling

N/A



## Mer informasjon




