MODULE RNL_B_List
    
    ALIAS dnum list;
    
    VAR rawbytes masterList{52};

    
    FUNC list list_New()    
    ENDFUNC
    
    PROC list_Erase(list l)    
    ENDPROC
    
    PROC List_addString()
        <SMT>
    ENDPROC
    
    PROC List_addRawbytes()
        <SMT>
    ENDPROC
    
    PROC List_getString()
        <SMT>
    ENDPROC
    
    PROC List_getRawbytes()
        <SMT>
    ENDPROC
    
    PROC List_popString()
        <SMT>
    ENDPROC
    
    PROC List_popRawbytes()
        <SMT>
    ENDPROC
    
    
    
    
ENDMODULE