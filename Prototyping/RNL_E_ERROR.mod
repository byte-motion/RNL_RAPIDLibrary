MODULE RNL_E_ERROR
    
    !the instruction was called without a required argument
    VAR errnum ERR_MISSINGARGUMENT:=-1;
    
    !the virtual object pointer was invalid
    VAR errnum ERR_BADPOINTER:=-1;
    
    !the request for the object mastership timed out
    VAR errnum ERR_OBJECTMASTERSHIPTIMEOUT:=-1;
    
    !a "NEW" function was called when there were no more available 
    !Slots for a new object of that type.
    VAR errnum ERR_NOMOREALLOCATEDINSTACES:=-1;
    
    !a "get next item" function was called when the next item was not ready
    VAR errnum ERR_NEXTITEMNOTREADY:=-1;
    
    !Failed to interact with an IO through string
    VAR errnum ERR_IOSTRINGFAILURE:=-1;
    
    !a gripper failed to complete its operation in time, and timed out
    VAR errnum ERR_GRIPPERTIMEOUT:=-1;

    
    
    
    PROC ERROR_initialize()
        BookErrNo ERR_MISSINGARGUMENT;
        BookErrNo ERR_NEXTITEMNOTREADY;
    ENDPROC
    
    
ENDMODULE