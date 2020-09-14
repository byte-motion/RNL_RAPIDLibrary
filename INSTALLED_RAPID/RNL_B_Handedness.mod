MODULE RNL_B_Handedness
    
    !Tested with ocellus sep 2020
    
    !Dependencies: None
    
    !assumes that X is Forward in both systems
    !assumes that Z is Up in both systems
    
    !Inverts Y between beeing Right and Left
    
    FUNC pos pos_invertHandedness(pos translation)
        RETURN [
             translation.x,
            -translation.y,
             translation.z];
    ENDFUNC

    FUNC orient orient_invertHandedness(orient rotation)
        RETURN [
             rotation.Q1,
            -rotation.Q2,
             rotation.Q3,
            -rotation.Q4];
    ENDFUNC
 
    FUNC pose pose_invertHandedness(pose position)
        VAR pose result;
        result.trans:=pos_invertHandedness(position.trans);
        result.rot:=orient_invertHandedness(position.rot);
        RETURN result;
    ENDFUNC
    
ENDMODULE
