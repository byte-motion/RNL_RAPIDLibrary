MODULE RNL_B_Geometry

    !===========================================================================
    !Generic
    !===========================================================================

    ALIAS num shapeType;

    RECORD shape
        pos trans;
        orient rot;
        shapeType type;
        num num1;
        num num2;
        num num3;
    ENDRECORD

    !===========================================================================
    !0 Dimentional Shapes
    !===========================================================================

    ALIAS pos point;

    !===========================================================================
    !1 Dimentional Shapes
    !===========================================================================

    RECORD line
        point PointX1;
        point PointX2;
    ENDRECORD

    !===========================================================================
    !2 Dimentional Shapes
    !===========================================================================

    RECORD plane
        pos trans;
        orient rot;
    ENDRECORD

    !===========================================================================
    !3 Dimentional Shapes
    !===========================================================================

    RECORD cylinder
        line axis;
        num r;
    ENDRECORD

    RECORD cone
        line axis;
        num r;
    ENDRECORD

    RECORD capsule
        line axis;
        num r;
    ENDRECORD

    RECORD cube
        pose origin;
        num size;
    ENDRECORD

    !Cuboid
    RECORD box
        Plane planeXY;
        pos dim;
    ENDRECORD

    !CONSTANTS
    LOCAL CONST shapeType SHAPE_TYPE_NULL:=0;
    LOCAL CONST shapeType SHAPE_TYPE_BOX:=1;
    LOCAL CONST shapeType SHAPE_TYPE_SPHERE:=2;
    LOCAL CONST shapeType SHAPE_TYPE_CYLINDER:=3;

    FUNC Shape Geometry_Shape_Box(
        \num Lenght|num DimX
        \num Width|num DimY
        \num Height|num DimZ
        \num OffForwards|num OffX
        \num OffRight|num OffY
        \num OffUp|num OffZ
        \num Roll|num RotX
        \num Pitch|num RotY
        \num Yaw|num RotZ)

        VAR num DimX_;
        VAR num DimY_;
        VAR num DimZ_;
        VAR num OffX_;
        VAR num OffY_;
        VAR num OffZ_;
        VAR num RotX_;
        VAR num RotY_;
        VAR num RotZ_;

        VAR box b;

        !Dimensions
        IF Present(Lenght) DimX_:=Lenght;
        IF Present(DimX) DimX_:=DimX;

        IF Present(Width) DimY_:=Width;
        IF Present(DimY) DimY_:=DimY;

        IF Present(Height) DimZ_:=Height;
        IF Present(DimZ) DimZ_:=DimZ;

        !offset/origin position
        IF Present(OffForwards) OffX_:=OffForwards;
        IF Present(OffX) OffX_:=OffX;

        IF Present(OffRight) OffY_:=OffRight;
        IF Present(OffY) OffY_:=OffY;

        IF Present(OffUp) OffZ_:=OffUp;
        IF Present(OffZ) OffZ_:=OffZ;

        !Rotation
        IF Present(Roll) RotX_:=Lenght;
        IF Present(rotX) RotX_:=rotX;

        IF Present(Pitch) RotY_:=Width;
        IF Present(rotY) RotY_:=rotY;

        IF Present(Yaw) RotZ_:=Height;
        IF Present(rotZ) RotZ_:=rotZ;

        b:=Geometry_box(
        \DimX:=DimX_
        \DimY:=DimY_
        \DimZ:=DimZ_
        \OffX:=OffX_
        \OffY:=OffY_
        \OffZ:=OffZ_
        \RotX:=RotX_
        \RotY:=RotY_
        \RotZ:=RotZ_
        );

        RETURN Geometry_BoxToShape(b);

    ENDFUNC


    FUNC box Geometry_box(
        \num Lenght|num DimX
        \num Width|num DimY
        \num Height|num DimZ
        \num OffForwards|num OffX
        \num OffRight|num OffY
        \num OffUp|num OffZ
        \num Roll|num RotX
        \num Pitch|num RotY
        \num Yaw|num RotZ)
        VAR box b;
        VAR pos EulerAngles;
        VAR pos offset;


        !Dimensions
        IF Present(Lenght) b.dim.x:=Lenght;
        IF Present(DimX) b.dim.x:=DimX;

        IF Present(Width) b.dim.y:=Width;
        IF Present(DimY) b.dim.y:=DimY;

        IF Present(Height) b.dim.z:=Height;
        IF Present(DimZ) b.dim.z:=DimZ;

        !offset/origin position
        IF Present(OffForwards) b.dim.x:=OffForwards;
        IF Present(OffX) b.dim.x:=OffX;

        IF Present(OffRight) b.dim.y:=OffRight;
        IF Present(OffY) b.dim.y:=OffY;

        IF Present(OffUp) b.dim.z:=OffUp;
        IF Present(OffZ) b.dim.z:=OffZ;

        !Rotation
        IF Present(Roll) EulerAngles.x:=Lenght;
        IF Present(rotX) EulerAngles.x:=rotX;

        IF Present(Pitch) EulerAngles.y:=Width;
        IF Present(rotY) EulerAngles.y:=rotY;

        IF Present(Yaw) EulerAngles.z:=Height;
        IF Present(rotZ) EulerAngles.z:=rotZ;

        b.planeXY.rot:=OrientZYX(EulerAngles.z,EulerAngles.y,EulerAngles.x);

        RETURN b;
    ENDFUNC

    FUNC shape Geometry_BoxToShape(box b)
        VAR shape s;

!        s.trans:=b.planeXY.trans;
!        s.rot:=b.planeXY.rot;
!        s.pointA:=b.dim;

        s.type:=SHAPE_TYPE_BOX;

        RETURN s;

    ENDFUNC

    FUNC box Geometry_ShapeToBox(shape s)
        VAR box b;

        IF NOT s.type=SHAPE_TYPE_BOX THEN
            !ERROR
            ErrWrite "Geometry_ShapeToBox: Argument Error","shape is not box";
            stop;
            RETURN b;
        ENDIF

!        b.planeXY.trans:=s.trans;
!        b.planeXY.rot:=s.rot;
!        b.dim:=s.pointA;

        RETURN b;

    ENDFUNC

ENDMODULE