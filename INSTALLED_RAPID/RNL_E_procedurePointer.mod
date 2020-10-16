MODULE RNL_E_procedurePointer

    !Procedure pointers

    !Dependencies:
    ! - none
    ! - 

    !Note:
    !GLOBAL late binding:
    ! %"ProcedureName"% arg1, arg2, arg3;
    !LOCAL late binding:
    ! %"Module:ProcedureName"% arg1, arg2, arg3;

    ALIAS string procedurePointer;

    VAR procedurePointer procedurePointer_NULL;

    PERS num Testnum;

    !Constructor for creating procedure Pointers
    FUNC procedurePointer procedurePointer_NEW(string procedureName,\string inModule)
        VAR string inModule_:="";
        VAR procedurePointer pointer;
        
        pointer:=procedurePointer_NULL;

        !Test if inModule is specified
        IF Present(inModule) inModule_:=inModule;

        !Add seperator
        IF inModule_<>"" inModule_:=inModule_+":";

        pointer:=inModule_+procedureName;

        RETURN pointer;
        
    ENDFUNC

    !This example illustrates how to use a procedure Pointer to call an arbitrary procedure
    LOCAL PROC procedurePointer__Example(procedurePointer procedure)

        VAR num arg1;
        VAR bool arg2;
        VAR string arg3;

        %procedure %arg1,arg2\OptionalArgument3:=arg3\OptionalSwitch;

    ENDPROC

ENDMODULE
