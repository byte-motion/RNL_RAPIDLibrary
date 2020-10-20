# RnLibStateMachine.sys

## Usage

Easy start and stop functionality of statemachines.

Will scan each machines state each 1000ms. Otherwise will watch subscribes program-data and I/O, and scan corresponding statemachine upon value-changes.

Timer functionality based off unixtime. Simply number of seconds since 1970-01-01 00:00 (Resolution 1 second). For highres timers, use clock.

Statemachines, subscriptions and timers are created and destroyed using objectoriented-like syntax.

## Installasjon

1. Load modules in designated task.
* MainModule.mod
* StateMachineMod.sys
* StateExampleMod.mod

2. Define the initial statemachine(s) in MainModule/Main.

## Eksempel

OBS! Do not use instructions that will halt the scan functionality. Ex. WaitTime, WaitIntil etc.

*Example MainModule/Main:*
```
    PROC Main()
        ! Statemachine Init
        %"StateMachineMod:Init"%;
        
        ! Call the Init procedure for statemachine.
        %"OpPanelMod:Init"%"OpPanelMod";
        %"OpPanelMod_Lights:Init"%"OpPanelMod_Lights";
        
        ! Start
        StateMachineStart;
    ENDPROC

```
This will call OpPanelMod:Init with modulename as argument. Late binding is used, and we can set everything as LOCAL in each statemachine.

*Example OpPanelInit:*
```
    LOCAL PROC Init(string ModName)
        bAccessWanted:=FALSE;
        bResetStart:=FALSE;
        bResetStart_Err:=FALSE;
        Id:=NewStateMachine(ModName,"Operator Panel");
        Subscribe Id,["bAccessWanted","Id","diAccessWanted","diResetAndStart","sdoRunChainOk","sdoMotorsOnState","sdoCycleOn"];
    ENDPROC
```
For the example statemachine OpPanelMod, we start by initiating some programdata, then create an object for the statemachine that will control the OpPanel. Once we have a statemachine, we can subscribe to relevant I/O and programdata. Note that when subscribing we also point to the relevant statemachine pointer.

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


