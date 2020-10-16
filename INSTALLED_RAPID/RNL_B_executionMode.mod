MODULE RNL_B_executionMode

    !executionMode is a set of modes that descibe different ways for the robot
    !to behave. 

    !Dependencies:
    ! - None

    RECORD executionMode
        bool disableExecution;
        bool printDebug;

        bool simulateSignalInput;
        bool disableSignalOutput;
        bool disableEvents;
    ENDRECORD

    !disableExecution - skip all execution
    !printDebug - print debug to TCP and/or file
    !simulateSignalInput - simulate input signals so they are not required
    !disableSignalOutput - disable output signals, not setting them
    !disableEvents - disable events, not calling them

    !Pre defined execution modes
    CONST executionMode executionMode_Normal:=[FALSE,FALSE,FALSE,FALSE,FALSE];
    CONST executionMode executionMode_Simulation:=[FALSE,FALSE,TRUE,FALSE,FALSE];
    CONST executionMode executionMode_Debug:=[FALSE,TRUE,FALSE,FALSE,FALSE];
    CONST executionMode executionMode_Disable:=[TRUE,FALSE,FALSE,FALSE,FALSE];

    !Global Execution mode - Used if no mode is specified
    LOCAL VAR executionMode executionModeGlobal:=[FALSE,FALSE,FALSE,FALSE,FALSE];

    FUNC executionMode executionMode_getGlobalMode()
        RETURN executionModeGlobal;
    ENDFUNC

    PROC executionMode_setGlobalMode(executionMode mode)
        executionModeGlobal:=mode;
    ENDPROC

ENDMODULE
