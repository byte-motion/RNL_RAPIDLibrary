# RnLibStateMachine.sys

## Bruk

Gir mulighet for enkelt oppsett av 'scan'-funksjonalitet i forbindelse med multitasking.

Hver modul får en State-variabel som forteller hvilken rutine som skal kjøres. Det blir da enkelt å sette opp kompleks logikk. Hver enkelt del av prosess får egen rutine, og når state blir satt til rutine-navn, så er det kun denne som kjøres.

PROC StatePreRun() og PROC StatePostRun() er også tilgjengelig for kode som ønskes kjørt uansett hvilken state som er satt.

Timeout-funksjonalitet er inkludert, slik at prosesser automatisk kan returnere til idle samt at operatør kan få relevante feilmeldinger.

Alle state endringer blir loggført så debugging blir enkel.

Prinsippskisse:
![image](https://user-images.githubusercontent.com/45029038/94258098-a0d24480-ff2c-11ea-9ba4-7bec61bd1fdf.png)

## Installasjon

1. Last inn moduler i aktuell task.
* MainModule.mod
* StateMachineMod.sys
* StateExampleMod.mod

2. Endre array deklarasjon i StateMachineMod.sys til å definere alle state-moduler og start-state for disse.

3. Hver enkelt state-modul må også få eget unikt navn på bStateChange. Denne er cyclic-bool og må være non-array, global og pers (ref. Rapid manual).

## Eksempel

OBS! I en scan-task er det viktig å unngå instruksjoner som WaitTime og lignende.

*Eksempel 1:*
```
    ! ...USER CODE START...

    LOCAL PROC Init()
        ! Init process
        SetState "Main";
    ENDPROC

    LOCAL PROC Main()
        TimeOutDelete;
        ! Check for available sequences
        IF diTest1=1 SetState "Example_10";
        IF diTest2=1 SetState "State_20";
        IF diTest3=1 SetState "State_30";
    ENDPROC

    LOCAL PROC Example_10()
        ! Set timeout, startactions, and then change state.
        TimeOutSetup 60;
        !SetDO doDoSomething,1;
        !SetDO doDoSomething,1;
        SetState "Example_20";
    ENDPROC

    LOCAL PROC Example_20()
        IF diTest2=1 SetState "Main";
    ENDPROC
    
    ! ...USER CODE END...
```
I eksempelet over vil kun PROC Init() kjøres først. Der settes også state til "Main", som gjør at neste scan vil kjøre PROC Main(). Her sjekkes om en sekvens er klar, og i såfall settes state til aktuell sekvens.

*Eksempel 2:*
```
    ! ...USER CODE START...

    LOCAL VAR intnum intBlink500;
    LOCAL VAR intnum intBlink200;
    LOCAL PERS bool bBlink200:=FALSE;
    LOCAL PERS bool bBlink500:=FALSE;
    PERS bool bAccessWanted:=FALSE;
    PERS bool bResetStart:=FALSE;
    PERS bool bResetStart_Err:=FALSE;
    VAR clock clResetStart_Err;
    VAR clock clAccessWanted;

    LOCAL PROC Init()
        !
        ! Sett opp interrupt for lysblink, disse brukes i StatePreRun() for å sette lys til passende blink interval.
        IDelete intBlink200;
        CONNECT intBlink200 WITH trBlink200;
        ITimer 0.2,intBlink200;
        IDelete intBlink500;
        CONNECT intBlink500 WITH trBlink500;
        ITimer 0.5,intBlink500;
        !
        bAccessWanted:=FALSE;
        bResetStart:=FALSE;
        bResetStart_Err:=FALSE;
        !
        SetState "Main";
    ENDPROC

    LOCAL PROC Main()
        ! Alle timeouts blir resatt i main.
        TimeOutDelete;
        ! Check for available sequences
        IF diAccessWanted=1 AND doOpPanelDoorLock<>0 SetState "AccessWanted_10";
        IF bAccessWanted AND sdoCycleOn=0 SetState "DoorUnlock_10";
        IF diResetAndStart=1 SetState "ResetAndStart_10";
    ENDPROC

    LOCAL PROC AccessWanted_10()
        ! Inverter bAccessWanted. Operatør kan da "skru av" funksjon mens robot fullfører syklus.
        ! bAccessWanted er delt med T_ROB og robot stopper når denne er TRUE.
        bAccessWanted:=(NOT bAccessWanted);
        ClkReset clAccessWanted;
        ClkStart clAccessWanted;
        SetState "AccessWanted_20";
    ENDPROC

    LOCAL PROC AccessWanted_20()
        IF ClkRead(clAccessWanted)>3 THEN
            ! Tving dør til å låse opp om knapp holdes inne.
            DoorUnlock_10;
        ELSEIF diAccessWanted=0 THEN
            ! Vent til operatør slipper knapp.
            SetState "Main";
        ENDIF
    ENDPROC

    LOCAL PROC DoorUnlock_10()
        ! Lås opp dør og resett I/O
        SetDO sdoMotorsOn,0;
        SetDO sdoStart,0;
        SetDO doOpPanelDoorLock,0;
        bAccessWanted:=FALSE;
        SetState "Main";
    ENDPROC

    LOCAL PROC ResetAndStart_10()
        IF sdoCycleOn=1 THEN
            SetState "State_OpPanel_Main";
            RETURN ;
        ENDIF
        TimeOutSetup 10,\ProcTimeOut:="ResetAndStart_Err_10";
        bAccessWanted:=FALSE;
        bResetStart:=TRUE;
        SetDO sdoMotorsOn,0;
        SetDO sdoStart,0;
        SetDO doOpPanelDoorLock,1;
        SetState "ResetAndStart_20";
    ENDPROC

    LOCAL PROC ResetAndStart_20()
        IF diAccessWanted=1 THEN
            DoorUnlock_10;
        ELSEIF sdoRunChainOk=1 THEN
            SetDO sdoMotorsOn,1;
            SetState "ResetAndStart_30";
        ENDIF
    ENDPROC

    LOCAL PROC ResetAndStart_30()
        IF diAccessWanted=1 THEN
            DoorUnlock_10;
        ELSEIF sdoMotorsOnState=1 THEN
            SetDO sdoStart,1;
            SetState "ResetAndStart_40";
        ENDIF
    ENDPROC

    LOCAL PROC ResetAndStart_40()
        IF diAccessWanted=1 THEN
            DoorUnlock_10;
        ELSEIF sdoCycleOn=1 THEN
            SetDO sdoMotorsOn,0;
            SetDO sdoStart,0;
            SetState "Main";
        ENDIF
    ENDPROC

    LOCAL PROC ResetAndStart_Err_10()
        bResetStart_Err:=TRUE;
        ClkReset clResetStart_Err;
        ClkStart clResetStart_Err;
        SetState "ResetAndStart_Err_20";
    ENDPROC

    LOCAL PROC ResetAndStart_Err_20()
        IF ClkRead(clResetStart_Err)>3 THEN
            ClkStop clResetStart_Err;
            bResetStart_Err:=FALSE;
            SetState "Main";
        ENDIF
    ENDPROC

    LOCAL PROC StatePreRun()
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

    LOCAL PROC StatePostRun()
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

    ! ...USER CODE END...
```
Fullt funksjonell kode for håndtering av dørlås.

* Lys for adgang eller produksjon.
* Blink for adgang-ønskes, og reset-start.
* Hurtigblink for evt. feil
* Tving opp dør funksjon.

## Argument

N/A

## Program kjøring

Ved programkjøring vil hver modul som opprettes få egen state-variabel. Denne avgjør hvilken PROC (rutine) som skal kjøres.

## Error handling

N/A

Generelle feilmeldinger vil vises til operatør, men programmerer må opprette prosess relaterte feilmeldinger selv.

* Om rutine angitt i state ikke eksisterer, så vil dette indikeres i ELOG, sammen med modul navn og state.
* Om en modul går i egensvingning, altså at en state endres til en annen som deretter endres tilbake osv., så vil det skriver en CPU-warning til ELOG.

## Mer informasjon

N/A


