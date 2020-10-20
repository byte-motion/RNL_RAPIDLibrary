MODULE MainModule

    PROC Main()
        ! Statemachine Init
        %"StateMachineMod:Init"%;
        
        ! Call the Init procedure for statemachine.
        %"OpPanelMod:Init"%"OpPanelMod";
        %"OpPanelMod_Lights:Init"%"OpPanelMod_Lights";
        
        ! Start
        StateMachineStart;
    ENDPROC

ENDMODULE
