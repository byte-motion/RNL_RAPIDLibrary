MODULE MainModule
    
    VAR gripper gripper1;

    
    PROC config()
        
        gripper_set_OpenCloseData \Pointer:=gripper1
        \DO_Normal_name:="doOpen" 
        \DO_Inverted_name:="doClose"
        \maxWaitTime:=2
        ;
        
    ENDPROC

    PROC main()
        <SMT>
    ENDPROC

    PROC init()
        <SMT>
    ENDPROC
    
    PROC pick()
        <SMT>
    ENDPROC
    
    PROC place()
        <SMT>
    ENDPROC

ENDMODULE