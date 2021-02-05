MODULE RNL_B_ErrorHandlingTest



    PROC MainTest()
        Init;
        WHILE TRUE DO
            ! Somecode...
        ENDWHILE
    ENDPROC



    LOCAL PROC Init()
        ! Each call to InitErrorHandling will negate previous ones.
        ! Only one should be sufficient. Once it triggers we can check type etc. in catch routine.

        ! Catch all errors
        InitErrorHandling "ElogErrorCatcher";

        ! Catch only COMMON errors
        InitErrorHandling\ErrorDomain:=COMMON_ERR,"ElogErrorCatcher";

        ! Catch only WARNINGS
        InitErrorHandling\ErrorType:=TYPE_WARN,"ElogErrorCatcher";

        ! Catch only ERRORS within the OPERATOR_ERR domain
        InitErrorHandling\ErrorDomain:=OPERATOR_ERR\ErrorType:=TYPE_WARN,"ElogErrorCatcher";

    ENDPROC



    PROC ElogErrorCatcher(errdomain ErrorDomain,num ErrorNr,errtype ErrorType)

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

    
    
ENDMODULE
