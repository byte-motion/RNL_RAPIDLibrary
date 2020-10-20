# RnLibStateMachine.sys

## Usage

Easy start and stop functionality of statemachines. Statemachines is a convenient way of controlling several parts of a system in a manageable way. Basicly each part of a system will be in a "state", and depending on where in each sequence each part of the system is a different procedure will be scanned.

This system will call each machine's state every 1000ms. Otherwise will watch subscribes program-data and I/O, and scan corresponding statemachine upon value-changes.

Timer functionality based off unixtime. Simply number of seconds since 1970-01-01 00:00 (Resolution 1 second). For highres timers, use clock.

Statemachines, subscriptions and timers are created and destroyed using objectoriented-like syntax.

OBS! Do not use instructions that will halt the scan functionality. Ex. WaitTime, WaitIntil etc.

## Installation

1. Load modules in designated task.
* MainModule.mod
* StateMachineMod.sys
* StateExampleMod.mod

2. Define the initial statemachine(s) in MainModule/Main.

## Example Statemachine

*Example OpPanelMod (Example-statemachine):*
```
    LOCAL PROC Init(string ModName)
        ...
        Id:=NewStateMachine(ModName,"Operator Panel");
        Subscribe Id,["bAccessWanted","Id","diAccessWanted","diResetAndStart","sdoRunChainOk","sdoMotorsOnState","sdoCycleOn"];
    ENDPROC
```
Init procedure will create statemachine object and subscribe to relevant programdata and I/O.

For the example statemachine OpPanelMod, we start by initiating some programdata, then create an object for the statemachine that will control the OpPanel. Once we have a statemachine, we can subscribe to relevant I/O and programdata. Note that when subscribing we also point to the relevant statemachine pointer.


```
    LOCAL PROC Main()
        IF diAccessWanted=1 AND doOpPanelDoorLock<>0 SetState Id,"AccessWanted_10";
        IF bAccessWanted AND sdoCycleOn=0 SetState Id,"DoorUnlock_10";
        IF diResetAndStart=1 AND sdoCycleOn=0 SetState Id,"ResetAndStart_10";
    ENDPROC
```
Main will be the main entrypoint and default state when the statemachine is idle. Once any sequence becomes ready it will change state to the specified sequence.


```
    LOCAL PROC AccessWanted_10()
        bResetStart:=FALSE;
        bAccessWanted:=(NOT bAccessWanted);
        ForceUnlock_:=NewTimer(Id,5,"DoorUnlock_10");
        SetState Id,"AccessWanted_20";
    ENDPROC

    LOCAL PROC AccessWanted_20()
        IF diAccessWanted=0 THEN
            DeleteTimer ForceUnlock_;
            SetState Id,"Main";
        ENDIF
    ENDPROC
```
Typical sequence will consist one state setting some I/O and then change to the next state which will wait for something to finnish. Then return to the main state and wait for a new sequence to become ready.


## Configure initial Statemachines

*Example MainModule/Main (configuration):*
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

For the example statemachine OpPanelMod, we start by initiating some programdata, then create an object for the statemachine that will control the OpPanel. Once we have a statemachine, we can subscribe to relevant I/O and programdata. Note that when subscribing we also point to the relevant statemachine pointer.

## Performance

The statemachine will loop through each statemachine once every 1 second. Remember only the current state will be called, and most likely each state will be easy on the cpu.

The next loop will be halted by the following line:
```
           WaitUntil SubscriptionChange()\MaxTime:=1\TimeFlag:=bTimeOut;
```
The function SubscriptionChange() will allways return FALSE, however it will loop through subscribed data and see if any changes have occured. If so it will call the state of the corresponding statemachine. SubscriptionChange() will be polled every 100ms, but this can be changed by using optional argument \PollRate:=[n].

Each of these operations are also quite easy on the cpu, however since the task will be running a WaitUntil it will readily jump to the T_ROB1 task or another task if necessary.

Performancevalues from example modules running on a virtual controller:
```
    LOCAL PERS num Debug_Scan_All_Time:=0.122;
    LOCAL PERS num Debug_Scan_All_Interval:=1.143;
    LOCAL PERS num Debug_Scan_Sub_Time:=0.003;
    LOCAL PERS num Debug_Scan_Sub_Interval:=0.104;
```


## Error handling

## Mer informasjon




