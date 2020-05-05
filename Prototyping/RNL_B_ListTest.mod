MODULE RNL_B_ListTest
!!This module enables using lists of dynamic lenght
!!With a predefined set of DataTypes
    
!    !The list record
!    RECORD list
!        string type;
!        num ID;
!    ENDRECORD

!    !ERROR
!    CONST errnum ERR_ListArgumentError:=0;
!    CONST errnum ERR_ListTypeMissmatch:=0;
!    CONST errnum ERR_ListFull:=0;

!    !Constants for refering to list types
!    CONST string LIST_EMPTY:="empty";
!    CONST string LIST_BOOL:="bool";
!    CONST string LIST_NUM:="num";
!    CONST string LIST_DNUM:="dnum";
!    CONST string LIST_STRING:="string";
!    CONST string LIST_POS:="pos";
!    CONST string LIST_ORIENT:="orient";
!    CONST string LIST_POSE:="pose";
!    CONST string LIST_CAMERATARGET:="cameratarget";
!    CONST string LIST_ROBTARGET:="robtarget";

!    !Null Values
!    LOCAL CONST bool bool_Null:=FALSE;
!    LOCAL CONST num num_Null:=0;
!    LOCAL CONST dnum dnum_Null:=0;
!    LOCAL CONST string string_Null:="";
!    LOCAL CONST pos pos_Null:=[0,0,0];
!    LOCAL CONST orient orient_Null:=[1,0,0,0];
!    LOCAL CONST pose pose_Null:=[[0,0,0],[1,0,0,0]];
!    LOCAL CONST cameratarget cameratarget_Null:=["",[[0,0,0],[1,0,0,0]],0,0,0,0,0,"","",0,"",0];
!    LOCAL CONST robtarget robtarget_Null:=[[0,0,0],[1,0,0,0],[0,0,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];

!    !Lists of the different types
!    PERS bool modList_bool{20,200};
!    PERS num modList_num{20,200};
!    PERS dnum modList_dnum{20,200};
!    PERS string modList_string{20,200};
!    PERS pos modList_pos{20,200};
!    PERS orient modList_orient{20,200};
!    PERS pose modList_pose{20,200};
!    PERS cameratarget modList_cameratarget{20,200};
!    PERS robtarget modList_robtarget{20,200};

!    !Lenght of lists
!    LOCAL PERS num modList_bool_Lenght{20}:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
!    LOCAL PERS num modList_num_Lenght{20}:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
!    LOCAL PERS num modList_dnum_Lenght{20}:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
!    LOCAL PERS num modList_string_Lenght{20}:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
!    LOCAL PERS num modList_pos_Lenght{20}:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
!    LOCAL PERS num modList_orient_Lenght{20}:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
!    LOCAL PERS num modList_pose_Lenght{20}:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
!    LOCAL PERS num modList_cameratarget_Lenght{20}:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
!    LOCAL PERS num modList_robtarget_Lenght{20}:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];


!    PROC list_Append(list list_arg,
!    \bool bool_arg,
!    \num num_arg,
!    \dnum dnum_arg,
!    \pos pos_arg,
!    \orient orient_arg,
!    \pose pose_arg,
!    \cameratarget cameratarget_arg,
!    \robtarget robtarget_arg
!    )

!        !Removes a single element from the end of a list and returns it

!        IF Present(bool_arg) THEN
!            IF list_arg.type<>list_bool AND list_arg.type<>list_empty THEN
!                RAISE ERR_ListTypeMissmatch;
!                RETURN ;
!            ENDIF
!            IF list_Lenght(list_arg)>=dim(modList_bool,2) THEN
!                RAISE ERR_ListFull;
!                RETURN ;
!            ENDIF
!            modList_bool{list_arg.ID,list_Lenght(list_arg)+1}:=bool_arg;
!            list_Lenght_Increment list_arg;

!        ELSEIF Present(num_arg) THEN
!            IF list_arg.type<>list_num AND list_arg.type<>list_empty THEN
!                RAISE ERR_ListTypeMissmatch;
!                RETURN ;
!            ENDIF
!            IF list_Lenght(list_arg)>=dim(modList_num,2) THEN
!                RAISE ERR_ListFull;
!                RETURN ;
!            ENDIF
!            modList_num{list_arg.ID,list_Lenght(list_arg)+1}:=num_arg;
!            list_Lenght_Increment list_arg;

!        ELSEIF Present(dnum_arg) THEN
!            IF list_arg.type<>list_dnum AND list_arg.type<>list_empty THEN
!                RAISE ERR_ListTypeMissmatch;
!                RETURN ;
!            ENDIF
!            IF list_Lenght(list_arg)>=dim(modList_dnum,2) THEN
!                RAISE ERR_ListFull;
!                RETURN ;
!            ENDIF
!            modList_dnum{list_arg.ID,list_Lenght(list_arg)+1}:=dnum_arg;
!            list_Lenght_Increment list_arg;

!        ELSEIF Present(pos_arg) THEN
!            IF list_arg.type<>list_pos AND list_arg.type<>list_empty THEN
!                RAISE ERR_ListTypeMissmatch;
!                RETURN ;
!            ENDIF
!            IF list_Lenght(list_arg)>=dim(modList_pos,2) THEN
!                RAISE ERR_ListFull;
!                RETURN ;
!            ENDIF
!            modList_pos{list_arg.ID,list_Lenght(list_arg)+1}:=pos_arg;
!            list_Lenght_Increment list_arg;

!        ELSEIF Present(orient_arg) THEN
!            IF list_arg.type<>list_orient AND list_arg.type<>list_empty THEN
!                RAISE ERR_ListTypeMissmatch;
!                RETURN ;
!            ENDIF
!            IF list_Lenght(list_arg)>=dim(modList_orient,2) THEN
!                RAISE ERR_ListFull;
!                RETURN ;
!            ENDIF
!            modList_orient{list_arg.ID,list_Lenght(list_arg)+1}:=orient_arg;
!            list_Lenght_Increment list_arg;

!        ELSEIF Present(pose_arg) THEN
!            IF list_arg.type<>list_pose AND list_arg.type<>list_empty THEN
!                RAISE ERR_ListTypeMissmatch;
!                RETURN ;
!            ENDIF
!            IF list_Lenght(list_arg)>=dim(modList_pose,2) THEN
!                RAISE ERR_ListFull;
!                RETURN ;
!            ENDIF
!            modList_pose{list_arg.ID,list_Lenght(list_arg)+1}:=pose_arg;
!            list_Lenght_Increment list_arg;

!        ELSEIF Present(cameratarget_arg) THEN
!            IF list_arg.type<>list_cameratarget AND list_arg.type<>list_empty THEN
!                RAISE ERR_ListTypeMissmatch;
!                RETURN ;
!            ENDIF
!            IF list_Lenght(list_arg)>=dim(modList_cameratarget,2) THEN
!                RAISE ERR_ListFull;
!                RETURN ;
!            ENDIF
!            modList_cameratarget{list_arg.ID,list_Lenght(list_arg)+1}:=cameratarget_arg;
!            list_Lenght_Increment list_arg;

!        ELSEIF Present(robtarget_arg) THEN
!            IF list_arg.type<>list_robtarget AND list_arg.type<>list_empty THEN
!                RAISE ERR_ListTypeMissmatch;
!                RETURN ;
!            ENDIF
!            IF list_Lenght(list_arg)>=dim(modList_robtarget,2) THEN
!                RAISE ERR_ListFull;
!                RETURN ;
!            ENDIF
!            modList_robtarget{list_arg.ID,list_Lenght(list_arg)+1}:=robtarget_arg;
!            list_Lenght_Increment list_arg;

!        ENDIF

!    ENDPROC
    
!    PROC list_Pop(list list_arg,
!    \INOUT bool bool_arg,
!    \INOUT num num_arg,
!    \INOUT dnum dnum_arg,
!    \INOUT pos pos_arg,
!    \INOUT orient orient_arg,
!    \INOUT pose pose_arg,
!    \INOUT cameratarget cameratarget_arg,
!    \INOUT robtarget robtarget_arg
!    )

!        !Removes a single element from the end of a list and returns it

!        IF Present(bool_arg) THEN
!            IF list_arg.type<>list_bool AND list_arg.type<>list_empty THEN
!                RAISE ERR_ListTypeMissmatch;
!                RETURN ;
!            ENDIF
!            IF list_Lenght(list_arg)>=dim(modList_bool,2) THEN
!                RAISE ERR_ListFull;
!                RETURN ;
!            ENDIF
!            modList_bool{list_arg.ID,list_Lenght(list_arg)+1}:=bool_arg;
!            list_Lenght_Increment list_arg;

!        ELSEIF Present(num_arg) THEN
!            IF list_arg.type<>list_num AND list_arg.type<>list_empty THEN
!                RAISE ERR_ListTypeMissmatch;
!                RETURN ;
!            ENDIF
!            IF list_Lenght(list_arg)>=dim(modList_num,2) THEN
!                RAISE ERR_ListFull;
!                RETURN ;
!            ENDIF
!            modList_num{list_arg.ID,list_Lenght(list_arg)+1}:=num_arg;
!            list_Lenght_Increment list_arg;

!        ELSEIF Present(dnum_arg) THEN
!            IF list_arg.type<>list_dnum AND list_arg.type<>list_empty THEN
!                RAISE ERR_ListTypeMissmatch;
!                RETURN ;
!            ENDIF
!            IF list_Lenght(list_arg)>=dim(modList_dnum,2) THEN
!                RAISE ERR_ListFull;
!                RETURN ;
!            ENDIF
!            modList_dnum{list_arg.ID,list_Lenght(list_arg)+1}:=dnum_arg;
!            list_Lenght_Increment list_arg;

!        ELSEIF Present(pos_arg) THEN
!            IF list_arg.type<>list_pos AND list_arg.type<>list_empty THEN
!                RAISE ERR_ListTypeMissmatch;
!                RETURN ;
!            ENDIF
!            IF list_Lenght(list_arg)>=dim(modList_pos,2) THEN
!                RAISE ERR_ListFull;
!                RETURN ;
!            ENDIF
!            modList_pos{list_arg.ID,list_Lenght(list_arg)+1}:=pos_arg;
!            list_Lenght_Increment list_arg;

!        ELSEIF Present(orient_arg) THEN
!            IF list_arg.type<>list_orient AND list_arg.type<>list_empty THEN
!                RAISE ERR_ListTypeMissmatch;
!                RETURN ;
!            ENDIF
!            IF list_Lenght(list_arg)>=dim(modList_orient,2) THEN
!                RAISE ERR_ListFull;
!                RETURN ;
!            ENDIF
!            modList_orient{list_arg.ID,list_Lenght(list_arg)+1}:=orient_arg;
!            list_Lenght_Increment list_arg;

!        ELSEIF Present(pose_arg) THEN
!            IF list_arg.type<>list_pose AND list_arg.type<>list_empty THEN
!                RAISE ERR_ListTypeMissmatch;
!                RETURN ;
!            ENDIF
!            IF list_Lenght(list_arg)>=dim(modList_pose,2) THEN
!                RAISE ERR_ListFull;
!                RETURN ;
!            ENDIF
!            modList_pose{list_arg.ID,list_Lenght(list_arg)+1}:=pose_arg;
!            list_Lenght_Increment list_arg;

!        ELSEIF Present(cameratarget_arg) THEN
!            IF list_arg.type<>list_cameratarget AND list_arg.type<>list_empty THEN
!                RAISE ERR_ListTypeMissmatch;
!                RETURN ;
!            ENDIF
!            IF list_Lenght(list_arg)>=dim(modList_cameratarget,2) THEN
!                RAISE ERR_ListFull;
!                RETURN ;
!            ENDIF
!            modList_cameratarget{list_arg.ID,list_Lenght(list_arg)+1}:=cameratarget_arg;
!            list_Lenght_Increment list_arg;

!        ELSEIF Present(robtarget_arg) THEN
!            IF list_arg.type<>list_robtarget AND list_arg.type<>list_empty THEN
!                RAISE ERR_ListTypeMissmatch;
!                RETURN ;
!            ENDIF
!            IF list_Lenght(list_arg)>=dim(modList_robtarget,2) THEN
!                RAISE ERR_ListFull;
!                RETURN ;
!            ENDIF
!            modList_robtarget{list_arg.ID,list_Lenght(list_arg)+1}:=robtarget_arg;
!            list_Lenght_Increment list_arg;

!        ENDIF

!    ENDPROC


!    PROC list_Insert(list list_arg,
!    \bool bool_arg,
!    \num num_arg,
!    \dnum dnum_arg,
!    \pos pos_arg,
!    \orient orient_arg,
!    \pose pose_arg,
!    \cameratarget cameratarget_arg,
!    \robtarget robtarget_arg,
!    num Index
!    )

!        !Add a single element to a list at Index, shifting the rest
!        <SMT>
!    ENDPROC

!    PROC list_Change(list list_arg,
!    \bool bool_arg,
!    \num num_arg,
!    \dnum dnum_arg,
!    \pos pos_arg,
!    \orient orient_arg,
!    \pose pose_arg,
!    \cameratarget cameratarget_arg,
!    \robtarget robtarget_arg,
!    num Index
!    )

!        !changes a single element in a list at Index, not affecting the rest
!        <SMT>
!    ENDPROC

!    PROC list_Remove(list list_arg,
!    \bool bool_arg,
!    \num num_arg,
!    \dnum dnum_arg,
!    \pos pos_arg,
!    \orient orient_arg,
!    \pose pose_arg,
!    \cameratarget cameratarget_arg,
!    \robtarget robtarget_arg,
!    num Index
!    )

!        !Remove a single element from a list at Index
!        <SMT>
!    ENDPROC

!    PROC list_Combine(list list_arg)
!        !adds the list B to the end of list A
!        <SMT>
!    ENDPROC

!    FUNC num list_Lenght(list list_arg)
!        !Returns the lenght of the list

!        TEST list_arg.type
!        CASE list_empty:
!            RETURN 0;
!        CASE list_bool:
!            RETURN modList_bool_Lenght{list_arg.ID};
!        CASE list_num:
!            RETURN modList_num_Lenght{list_arg.ID};
!        CASE list_dnum:
!            RETURN modList_dnum_Lenght{list_arg.ID};
!        CASE list_string:
!            RETURN modList_string_Lenght{list_arg.ID};
!        CASE list_pos:
!            RETURN modList_pos_Lenght{list_arg.ID};
!        CASE list_pose:
!            RETURN modList_pose_Lenght{list_arg.ID};
!        CASE list_cameratarget:
!            RETURN modList_cameratarget_Lenght{list_arg.ID};
!        CASE list_robtarget:
!            RETURN modList_robtarget_Lenght{list_arg.ID};
!        DEFAULT:
!            RAISE ERR_ListArgumentError;
!        ENDTEST

!    ENDFUNC

!    LOCAL PROC list_Lenght_Increment(list list_arg)
!        !Increases the lenght of the list by 1

!        TEST list_arg.type
!        CASE list_empty:
!            RAISE ERR_ListArgumentError;
!        CASE list_bool:
!            Incr modList_bool_Lenght{list_arg.ID};
!        CASE list_num:
!            Incr modList_num_Lenght{list_arg.ID};
!        CASE list_dnum:
!            Incr modList_dnum_Lenght{list_arg.ID};
!        CASE list_string:
!            Incr modList_string_Lenght{list_arg.ID};
!        CASE list_pos:
!            Incr modList_pos_Lenght{list_arg.ID};
!        CASE list_pose:
!            Incr modList_pose_Lenght{list_arg.ID};
!        CASE list_cameratarget:
!            Incr modList_cameratarget_Lenght{list_arg.ID};
!        CASE list_robtarget:
!            Incr modList_robtarget_Lenght{list_arg.ID};
!        DEFAULT:
!            RAISE ERR_ListArgumentError;
!        ENDTEST

!    ENDPROC

!    LOCAL PROC list_Lenght_Decrement(list list_arg)
!        !Decreases the lenght of the list by 1

!        TEST list_arg.type
!        CASE list_empty:
!            RAISE ERR_ListArgumentError;
!        CASE list_bool:
!            Decr modList_bool_Lenght{list_arg.ID};
!        CASE list_num:
!            Decr modList_num_Lenght{list_arg.ID};
!        CASE list_dnum:
!            Decr modList_dnum_Lenght{list_arg.ID};
!        CASE list_string:
!            Decr modList_string_Lenght{list_arg.ID};
!        CASE list_pos:
!            Decr modList_pos_Lenght{list_arg.ID};
!        CASE list_pose:
!            Decr modList_pose_Lenght{list_arg.ID};
!        CASE list_cameratarget:
!            Decr modList_cameratarget_Lenght{list_arg.ID};
!        CASE list_robtarget:
!            Decr modList_robtarget_Lenght{list_arg.ID};
!        DEFAULT:
!            RAISE ERR_ListArgumentError;
!        ENDTEST

!    ENDPROC

!    LOCAL PROC list_Lenght_Clear(list list_arg)
!        !Sets the lengt of a list to 0 

!        TEST list_arg.type
!        CASE list_empty:
!            RAISE ERR_ListArgumentError;
!        CASE list_bool:
!            modList_bool_Lenght{list_arg.ID}:=0;
!        CASE list_num:
!            modList_num_Lenght{list_arg.ID}:=0;
!        CASE list_dnum:
!            modList_dnum_Lenght{list_arg.ID}:=0;
!        CASE list_string:
!            modList_string_Lenght{list_arg.ID}:=0;
!        CASE list_pos:
!            modList_pos_Lenght{list_arg.ID}:=0;
!        CASE list_pose:
!            modList_pose_Lenght{list_arg.ID}:=0;
!        CASE list_cameratarget:
!            modList_cameratarget_Lenght{list_arg.ID}:=0;
!        CASE list_robtarget:
!            modList_robtarget_Lenght{list_arg.ID}:=0;
!        DEFAULT:
!            RAISE ERR_ListArgumentError;
!        ENDTEST

!    ENDPROC

!    FUNC list list_Copy(list list_arg)
!        !Copies the List, returns the new list
!        <SMT>
!    ENDFUNC

!    PROC list_Clear(list list_arg)
!        !Erases all elements in the list
!        <SMT>
!    ENDPROC

!    PROC list_ClearAll(list list_arg)
!        !Erases all elements in all lists
!        <SMT>
!    ENDPROC

!    PROC list_Reverse(list list_arg)
!        !Reverses the list
!        <SMT>
!    ENDPROC

!    PROC list_Sort(list list_arg)
!        !Sorts the list, High to Low
!        <SMT>
!    ENDPROC

!    PROC list_Min(list list_arg)
!        !Returns the minimum value of the list
!        <SMT>
!    ENDPROC

!    PROC list_Max(list list_arg)
!        !Returns the maximum value of the list
!        <SMT>
!    ENDPROC
    
!    PROC list_Range(list list_arg)
!        !Returns the range value of the list
!        <SMT>
!    ENDPROC
    
!    PROC list_Mode(list list_arg)
!        !Returns the Mode value of the list
!        <SMT>
!    ENDPROC

!    PROC list_Median(list list_arg)
!        !Returns the Median/Average value of the list
!        <SMT>
!    ENDPROC

!    PROC list_Mean(list list_arg)
!        !Returns the Mean value of the list
!        <SMT>
!    ENDPROC

!    PROC list_StdDev(list list_arg)
!        !Returns the Standard Deviation of the list
!        <SMT>
!    ENDPROC

!    PROC list_Count(list list_arg)
!        !Returns the number of spesified value in the list
!        <SMT>
!    ENDPROC

!    FUNC num list_getType(list list_arg)
!        !Returns the constant representing the type of the list
!        <SMT>
!    ENDFUNC

!    PROC list_setType(list list_arg)
!        !Sets the type of a list
!        <SMT>
!    ENDPROC

ENDMODULE