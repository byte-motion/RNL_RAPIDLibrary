MODULE RNL_B_Vector
    ! MODULE Vector - 
    !Implements functionaliy concerning vectors of 2 and 3 dimentions

    !RECORD vector2D - DataType used to represent a 2 dimentional vector
    RECORD vector2D
        num x;
        num y;
    ENDRECORD

    !RECORD vector3D - DataType used to represent a 3 dimentional vector
    !    RECORD vector3D
    !        num x;
    !        num y;
    !        num z;
    !    ENDRECORD
    ALIAS pos vector3D;

    !FUNC vector2D_Add - Takes two vector2D and adds them together
    FUNC vector2D vector2D_Add(vector2D V,vector2D U)
        VAR vector2D returnVector;
        returnVector.x:=V.x+U.x;
        returnVector.y:=V.y+U.y;
        RETURN returnVector;
    ENDFUNC

    !FUNC vector3D_Add - Takes two vector3D and adds them together
    FUNC vector3D vector3D_Add(vector3D V,vector3D U)
        VAR vector3D returnVector;
        returnVector.x:=V.x+U.x;
        returnVector.y:=V.y+U.y;
        returnVector.z:=V.z+U.z;
        RETURN returnVector;
    ENDFUNC

    !FUNC vector2D_Sub - Takes two vector2D and subtracts the last from the first
    FUNC vector2D vector2D_Sub(vector2D V,vector2D U)
        VAR vector2D returnVector;
        returnVector.x:=V.x-U.x;
        returnVector.y:=V.y-U.y;
        RETURN returnVector;
    ENDFUNC

    !FUNC vector3D_Sub - Takes two vector3D and subtracts the last from the first
    FUNC vector3D vector3D_Sub(vector3D V,vector3D U)
        VAR vector3D returnVector;
        returnVector.x:=V.x-U.x;
        returnVector.y:=V.y-U.y;
        returnVector.z:=V.z-U.z;
        RETURN returnVector;
    ENDFUNC

    !FUNC vector2D_Mean - Takes two vector2D and returns the mean/average vector2D
    FUNC vector2D vector2D_Mean(vector2D V,vector2D U)
        VAR vector2D returnVector;
        returnVector.x:=V.x*U.x*0.5;
        returnVector.y:=V.y*U.y*0.5;
        RETURN returnVector;
    ENDFUNC

    !FUNC vector2D_Average - Alternative name for vector2D_Mean
    FUNC vector2D vector2D_Average(vector2D V,vector2D U)
        RETURN vector2D_Mean(V,U);
    ENDFUNC

    !FUNC vector3D_Mean - Takes two vector3D and returns the mean/average vector3D
    FUNC vector3D vector3D_Mean(vector3D V,vector3D U)
        VAR vector3D returnVector;
        returnVector.x:=V.x*U.x*0.5;
        returnVector.y:=V.y*U.y*0.5;
        returnVector.z:=V.z*U.z*0.5;
        RETURN returnVector;
    ENDFUNC

    !FUNC vector3D_Average - Alternative name for vector3D_Mean
    FUNC vector3D vector3D_Average(vector3D V,vector3D U)
        RETURN vector3D_Mean(V,U);
    ENDFUNC

    !FUNC vector2D_Scale - Takes a vector2D and scalar and scales the vector
    FUNC vector2D vector2D_Scale(vector2D V,num scalar)
        VAR vector2D returnVector;
        returnVector.x:=v.x*scalar;
        returnVector.y:=v.y*scalar;
        RETURN returnVector;
    ENDFUNC

    !FUNC vector3D_Scale - Takes a vector3D and scalar and scales the vector
    FUNC vector3D vector3D_Scale(vector3D V,num scalar)
        VAR vector3D returnVector;
        returnVector.x:=v.x*scalar;
        returnVector.y:=v.y*scalar;
        returnVector.z:=v.z*scalar;
        RETURN returnVector;
    ENDFUNC

    !FUNC vector2D_Lengt - Takes a vector2D and returns its lenght/magnitude
    FUNC num vector2D_Lengt(vector2D V)
        VAR pos retrunPos;
        retrunPos.x:=V.x;
        retrunPos.y:=V.y;
        retrunPos.z:=0;
        RETURN VectMagn(retrunPos);
    ENDFUNC
    
    !FUNC vector2D_Magnitude - alternative name for vector2D_Lengt
    FUNC num vector2D_Magnitude(vector2D V)
        RETURN vector2D_Lengt(V);
    ENDFUNC

    !FUNC vector3D_Lengt - Takes a vector3D and returns its lenght/magnitude
    FUNC num vector3D_Lengt(vector3D V)
        RETURN VectMagn(V);
    ENDFUNC
    
    !FUNC vector3D_Magnitude - alternative name for vector3D_Lengt
    FUNC num vector3D_Magnitude(vector3D V)
        RETURN vector3D_Lengt(V);
    ENDFUNC

    !FUNC vector2D_angle - Takes a vector2D and returns its angle (in degrees)
    FUNC num vector2D_Angle(vector2D V)

        IF V.y=0 THEN
            IF V.x>0 THEN
                RETURN 180;
            ELSE
                RETURN 0;
            ENDIF
        ENDIF

        IF V.x=0 THEN
            IF V.y>0 THEN
                RETURN 90;
            ELSEIF V.y<0 THEN
                RETURN -90;
            ELSE
                RETURN 0;
            ENDIF
        ENDIF

        RETURN (ATan(V.y/V.x));

    ENDFUNC

    !FUNC vector3D_angle - Takes a vector3D and returns its angle
    FUNC orient vector3D_Angle(vector3D V)

        !To be implemented - does this have a use?

    ENDFUNC


    !FUNC vector2D_Normalize - Takes a vector2D and returns a normalized vector2D
    FUNC vector2D vector2D_Normalize(vector2D V)
        VAR vector2D returnVector;
        VAR num lenght;
        lenght:=vector2D_Lengt(V);
        returnVector.x:=V.x/lenght;
        returnVector.y:=V.y/lenght;
        RETURN returnVector;
    ENDFUNC

    !FUNC vector3D_Normalize - Takes a vector3D and returns a normalized vector2D
    FUNC vector3D vector3D_Normalize(vector3D V)
        VAR vector3D returnVector;
        VAR num lenght;
        lenght:=vector3D_Lengt(V);
        returnVector.x:=V.x/lenght;
        returnVector.y:=V.y/lenght;
        returnVector.z:=V.z/lenght;
        RETURN returnVector;
    ENDFUNC
    
    !FUNC vector2D_DotProd - Takes two vector2D and returns their dot product
    FUNC num vector2D_DotProd(vector2D V, vector2D U)
        VAR pos VPos;
        VAR pos UPos;
        
        VPos.x := V.x;
        VPos.y := V.y;
        UPos.x := U.x;
        UPos.y := U.y;
        
        RETURN DotProd(VPos,UPos);
    ENDFUNC    
    
    !FUNC vector3D_DotProd - Takes two vector3D and returns their dot product
    FUNC num vector3D_DotProd(vector3D V, vector3D U)
        RETURN DotProd(V,U);
    ENDFUNC
  
      !FUNC vector2D_CrossProd - Takes two vector2D and returns their cross product
    FUNC vector2D vector2D_CrossProd(vector2D V, vector2D U)
        VAR pos VPos;
        VAR pos UPos;
        VAR pos XPos;
        VAR vector2D returnVector;
        
        VPos.x := V.x;
        VPos.y := V.y;
        UPos.x := U.x;
        UPos.y := U.y;
        
        XPos := CrossProd(VPos,UPos);
        
        returnVector.x := XPos.x;
        returnVector.y := XPos.y;
        
        RETURN returnVector;
    ENDFUNC

    !FUNC vector3D_CrossProd - Takes two vector3D and returns their cross product
    FUNC vector3D vector3D_CrossProd(vector3D V, vector3D U)
        RETURN CrossProd(V,U);
    ENDFUNC

    !FUNC vector2D_Rotate - Takes a vector2D and a number of degrees
    !and returns vector2D rotated by degrees
    FUNC vector2D vector2D_Rotate(vector2D V,num degrees)
        VAR num cosTheta;
        VAR num sinTheta;
        VAR vector2D ReturnV;
        cosTheta:=Cos(degrees);
        sinTheta:=Sin(degrees);
        ReturnV.x:=V.x*cosTheta-V.y*sinTheta;
        ReturnV.y:=V.x*sinTheta+V.y*cosTheta;
        RETURN ReturnV;
    ENDFUNC



ENDMODULE
