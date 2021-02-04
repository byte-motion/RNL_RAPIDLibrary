# RNL_B_FestoServoMod.sys

## Usage

Move and Search functionality for Festo servo controller. Handles enable on/off automaticly.

## Installation

1. Load modules in designated task.
* RNL_B_FestoServoMod.sys

2. Use MoveFesto or SearchFesto in your main program.

## Example Statemachine

*Example MoveFesto:*
```
    LOCAL PROC Routine()
        ...
        MoveFesto 465,100;
        ...
    ENDPROC
```
Will move servo to position 465 using speed 100.

*Example MoveFesto 2:*
```
    LOCAL PROC Routine()
        ...
        ! Enable on, set position and speed.
        MoveFesto 465,100\NoStart;
        ...
        ! Start movement.
        PulseDO\High\PLength:=0.1,doFestoUnit_9_Start
        ...
    ENDPROC
```
The \NoStart switch can be used to set enable, position and speed. When ready to move, response will be faster.

*Example MoveFesto 3:*
```
    LOCAL PROC Routine()
        ...
        ! Enable on, set position and speed.
        MoveFesto 465,100\NoWait;
        ! More actions
        ...
        ! Wait until servo is in position
        WaitUntil giFestoUnit_Position=465;
        ...
    ENDPROC
```
The \NoWait switch can be used to perform additional instructions while the servo is moving.



## Functions / Instructions

**PROC MoveFesto(num Point, num Speed, \switch NoWait, \switch NoStart)**

Move servo to a given position using given speed.

**FUNC bool SearchFesto(VAR signaldi Signal,INOUT num SearchPoint,num Point,num Speed,\switch NoRegain,\switch NoWait)**

Search to a given position using given speed. Stop on input trigg.



## Error handling

No errorhandling has been added. If procedures time out, it will raise ERR_WAIT_MAXTIME.

## Mer informasjon




