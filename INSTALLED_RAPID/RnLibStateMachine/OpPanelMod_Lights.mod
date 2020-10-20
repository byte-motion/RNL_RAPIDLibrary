MODULE OpPanelMod_Lights

    ! Id will hold pointer to statemachine object
    LOCAL VAR num Id:=0;
    LOCAL VAR num TimeOutId:=0;

    LOCAL VAR intnum intBlink500;
    LOCAL VAR intnum intBlink200;
    LOCAL PERS bool bBlink200:=FALSE;
    LOCAL PERS bool bBlink500:=FALSE;

    LOCAL PROC Init(string ModName)
        ! Sett opp interrupt for lysblink, disse brukes i StatePreRun() for å sette lys til passende blink interval.
        IDelete intBlink200;
        CONNECT intBlink200 WITH trBlink200;
        ITimer 0.2,intBlink200;
        IDelete intBlink500;
        CONNECT intBlink500 WITH trBlink500;
        ITimer 0.5,intBlink500;
        Id:=NewStateMachine(ModName,"OpPanel Lights");
        Subscribe Id,["sdoCycleOn","doLightBtnAccessWanted","doLightBtnStart","bAccessWanted","bResetStart","bResetStart_Err"];
    ENDPROC

    LOCAL PROC Main()
        !
        ! Light for buttons
        IF sdoCycleOn=1 AND bAccessWanted THEN
            SetDO doLightBtnAccessWanted,BoolToNum(bBlink500);
        ELSEIF sdoCycleOn=1 OR bResetStart THEN
            SetDO doLightBtnAccessWanted,0;
        ELSE
            SetDO doLightBtnAccessWanted,1;
        ENDIF
        !
        IF sdoCycleOn=0 AND bResetStart THEN
            SetDO doLightBtnStart,BoolToNum(bBlink500);
        ELSEIF sdoCycleOn=0 AND bResetStart_Err THEN
            SetDO doLightBtnStart,BoolToNum(bBlink200);
        ELSEIF sdoCycleOn=0 THEN
            SetDO doLightBtnStart,0;
        ELSE
            SetDO doLightBtnStart,1;
        ENDIF
        !
    ENDPROC

    LOCAL TRAP trBlink200
        BoolInvert bBlink200;
    ENDTRAP

    LOCAL TRAP trBlink500
        BoolInvert bBlink500;
    ENDTRAP

    LOCAL PROC BoolInvert(INOUT bool Val)
        Val:=NOT Val;
    ENDPROC

    FUNC num BoolToNum(bool Val)
        IF Val RETURN 1;
        RETURN 0;
    ENDFUNC

ENDMODULE
