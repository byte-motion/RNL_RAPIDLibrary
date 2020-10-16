MODULE RNL_E_ERROR
    
    !This E module contains procedures realted to error handeling
    
    !Dependencies:
    ! - Node

    !errno_bookAndRaise books a errno before raising it, if it was not allready 
    !booked
    PROC errno_bookAndRaise(errnum errorNumber)
        IF errorNumber=-1 BookErrNo errorNumber;
        RAISE errorNumber;
    ERROR
        RAISE ;
    ENDPROC
    
    !Raises an error if the boolean FALSE value is recived.
    !Usefull when functions return a boolean for success.
    PROC errFromBool(bool functResult,errnum errorID)
        IF NOT functResult RAISE errorID;
    ERROR
        RAISE ;
    ENDPROC

ENDMODULE
