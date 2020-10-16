MODULE RNL_E_dataPointer

    !dataPointer is a module that enables the late binding of data through generic, universal data pointers
    !data pointers allow us to access and pass data without having to specify a data type.
    !data pointers are therefore essential for creating complex patterns in RAPID, like
    !objects, object inheritance, events, state machines and so on.

    !Dependencies:
    ! - none
    
    ALIAS string dataType;
    ALIAS string dataName;
    ALIAS string dataValue;

    !dataPointer contains the nessesary infromation to late bind to data.
    RECORD dataPointer
        dataType type;
        dataName name;
        dataValue value;
        dataName inheritanceParent;
        num id;
    ENDRECORD

    !Null values
    CONST dataPointer dataPointer_NULL:=["","","","",0];

    !Error data
    VAR errnum ERR_BAD_DATA_POINTER:=-1;
    
    CONST dataType dataType_signaldi:="signaldi";
    CONST dataType dataType_signaldo:="signaldo";
    CONST dataType dataType_signalgi:="signalgi";
    CONST dataType dataType_signalgo:="signalgo";
    CONST dataType dataType_signalai:="signalai";
    CONST dataType dataType_signalao:="signalao";

    !ref() Generates a data pointer that points to the supplied data symbol
    !it is designed to be short, easy to remember, and universal
    !You can feed it one of the buildt in data types, or feed it 
    !a custom data type manually through A_name, A_Type, and A_Value.
    !If the \global optional argument is included then it will force the 
    ! pointer to be a reference to the orignial object
    FUNC dataPointer ref(
        \num num_
        |dnum dnum_
        |string string_
        |bool bool_
        |byte byte_

        |pos pos_
        |pose pose_
        |orient orient_

        |confdata confdata_
        |extjoint extjoint_

        |robtarget robtarget_
        |jointtarget jointtarget_
        |jointtarget robjoint_

        |tooldata tooldata_
        |loaddata loaddata_
        |wobjdata wopbjdata_
        |speeddata speeddata_
        |zonedata zonedata_
        
        |var signaldi signaldi_
        |var signaldo signaldo_
        |var signalgi signalgi_
        |var signalgo signalgo_
        |var signalai signalai_
        |var signalao signalao_

        |dataPointer dataPointer_
        |event event_

        \switch global

        \string A_name
        \string A_type
        \string A_value
        )

        VAR dataPointer pointer;

        IF Present(num_) pointer.type:=Type(num_);
        IF Present(num_) pointer.name:=ArgName(num_);
        IF Present(num_) pointer.value:=ValToStr(num_);

        IF Present(dnum_) pointer.type:=Type(dnum_);
        IF Present(dnum_) pointer.name:=ArgName(dnum_);
        IF Present(dnum_) pointer.value:=ValToStr(dnum_);
        
        IF Present(string_) pointer.type:=Type(string_);
        IF Present(string_) pointer.name:=ArgName(string_);
        IF Present(string_) pointer.value:=ValToStr(string_);

        IF Present(bool_) pointer.type:=Type(bool_);
        IF Present(bool_) pointer.name:=ArgName(bool_);
        IF Present(bool_) pointer.value:=ValToStr(bool_);

        IF Present(byte_) pointer.type:=Type(byte_);
        IF Present(byte_) pointer.name:=ArgName(byte_);
        IF Present(byte_) pointer.value:=ValToStr(byte_);

        IF Present(pos_) pointer.type:=Type(pos_);
        IF Present(pos_) pointer.name:=ArgName(pos_);
        IF Present(pos_) pointer.value:=ValToStr(pos_);

        IF Present(pose_) pointer.type:=Type(pose_);
        IF Present(pose_) pointer.name:=ArgName(pose_);
        IF Present(pose_) pointer.value:=ValToStr(pose_);

        IF Present(orient_) pointer.type:=Type(orient_);
        IF Present(orient_) pointer.name:=ArgName(orient_);
        IF Present(orient_) pointer.value:=ValToStr(orient_);

        IF Present(confdata_) pointer.type:=Type(confdata_);
        IF Present(confdata_) pointer.name:=ArgName(confdata_);
        IF Present(confdata_) pointer.value:=ValToStr(confdata_);

        IF Present(extjoint_) pointer.type:=Type(extjoint_);
        IF Present(extjoint_) pointer.name:=ArgName(extjoint_);
        IF Present(extjoint_) pointer.value:=ValToStr(extjoint_);

        IF Present(robtarget_) pointer.type:=Type(robtarget_);
        IF Present(robtarget_) pointer.name:=ArgName(robtarget_);
        IF Present(robtarget_) pointer.value:=ValToStr(robtarget_);

        IF Present(jointtarget_) pointer.type:=Type(jointtarget_);
        IF Present(jointtarget_) pointer.name:=ArgName(jointtarget_);
        IF Present(jointtarget_) pointer.value:=ValToStr(jointtarget_);

        IF Present(robjoint_) pointer.type:=Type(robjoint_);
        IF Present(robjoint_) pointer.name:=ArgName(robjoint_);
        IF Present(robjoint_) pointer.value:=ValToStr(robjoint_);

        IF Present(tooldata_) pointer.type:=Type(tooldata_);
        IF Present(tooldata_) pointer.name:=ArgName(tooldata_);
        IF Present(tooldata_) pointer.value:=ValToStr(tooldata_);

        IF Present(loaddata_) pointer.type:=Type(loaddata_);
        IF Present(loaddata_) pointer.name:=ArgName(loaddata_);
        IF Present(loaddata_) pointer.value:=ArgName(loaddata_);

        IF Present(wopbjdata_) pointer.type:=Type(wopbjdata_);
        IF Present(wopbjdata_) pointer.name:=ArgName(wopbjdata_);
        IF Present(wopbjdata_) pointer.value:=ValToStr(wopbjdata_);

        IF Present(speeddata_) pointer.type:=Type(speeddata_);
        IF Present(speeddata_) pointer.name:=ArgName(speeddata_);
        IF Present(speeddata_) pointer.value:=ValToStr(speeddata_);

        IF Present(zonedata_) pointer.type:=Type(zonedata_);
        IF Present(zonedata_) pointer.name:=ArgName(zonedata_);
        IF Present(zonedata_) pointer.value:=ValToStr(zonedata_);

        IF Present(signaldi_) pointer.type:=Type(signaldi_);
        IF Present(signaldi_) pointer.name:=ArgName(signaldi_);
        
        IF Present(signaldo_) pointer.type:=Type(signaldo_);
        IF Present(signaldo_) pointer.name:=ArgName(signaldo_);
        
        IF Present(signalgi_) pointer.type:=Type(signalgi_);
        IF Present(signalgi_) pointer.name:=ArgName(signalgi_);
        
        IF Present(signalgo_) pointer.type:=Type(signalgo_);
        IF Present(signalgo_) pointer.name:=ArgName(signalgo_);
        
        IF Present(signalai_) pointer.type:=Type(signalai_);
        IF Present(signalai_) pointer.name:=ArgName(signalai_);
        
        IF Present(signalao_) pointer.type:=Type(signalao_);
        IF Present(signalao_) pointer.name:=ArgName(signalao_);
        
        IF Present(dataPointer_) pointer.type:=Type(dataPointer_);
        IF Present(dataPointer_) pointer.name:=ArgName(dataPointer_);
        IF Present(dataPointer_) pointer.value:=ValToStr(dataPointer_);

        IF Present(event_) pointer.type:=Type(event_);
        IF Present(event_) pointer.name:=ArgName(event_);
        IF Present(event_) pointer.value:=ValToStr(event_);
        

        !If data is set both automatically and manually, error
        IF pointer<>dataPointer_NULL
        AND (Present(A_name) OR Present(A_type) OR Present(A_value)) THEN
            !ERROR
            ErrWrite "ref() - Conflicting Arguments","";
            stop;
        ENDIF

        !Set name and type manually
        IF Present(A_name) pointer.name:=A_name;

        !Set type manually
        IF Present(A_type) pointer.type:=A_type;

        !Set Value manually
        IF Present(A_value) pointer.value:=A_value;

        !determine if pointer should be a named reference,
        !or a nameless value
        IF Present(A_name) or Present(global) THEN
            pointer.value:="";
        ELSE
            pointer.name:="";
        ENDIF

        !Check completeness
        IF pointer.type="" THEN
            !ERROR
            ErrWrite "ref() - Missing Type","";
            stop;
        ENDIF

        IF pointer.name="" AND pointer.value="" THEN
            !ERROR
            
            !This is actually allowed in certain situations. 
            
            !ErrWrite "ref() - Missing Data","";
            !stop;
        ENDIF

        RETURN pointer;

    ERROR

        IF ERRNO=ERR_ARGNAME TRYNEXT;
        RAISE ;

    ENDFUNC

    !Returns true if data pointer contains a global reference pointer
    FUNC bool dataPointer_isReference(dataPointer pointer)
        RETURN NOT pointer.name="";
    ENDFUNC

    !Returns true if data pointer contains a local string value
    FUNC bool dataPointer_isValue(dataPointer pointer)
        RETURN NOT pointer.value="";
    ENDFUNC
    
    !Returns true if data pointer contains a reference to a semi-value IO signal
    !(semi-value IO signal can be connected via alias)
    FUNC bool dataPointer_isIO(dataPointer pointer)
        RETURN pointer.type=dataType_signaldi
        OR pointer.type=dataType_signaldo
        OR pointer.type=dataType_signalgi
        OR pointer.type=dataType_signalgo
        OR pointer.type=dataType_signalai
        OR pointer.type=dataType_signalao;
    ENDFUNC

ENDMODULE
