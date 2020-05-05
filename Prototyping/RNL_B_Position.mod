MODULE RNL_B_Position

    RECORD position
        bool positionValid;
        pos trans;
        orient rot;
        num transTolerance;
        num rotTolerance;
        virtualObjectPointer parent;
        string name;
        dnum encoderValue;
    ENDRECORD
    
    FUNC bool position_Matches(position posA, position posB)
        
        !If names match, return true
        IF posA.name<>"" AND posA.name=posB.name RETURN TRUE;
        
    ENDFUNC
    
    
ENDMODULE