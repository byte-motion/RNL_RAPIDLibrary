# Guide for Creating Virtual Objects


Virtual objects are structues used to collect data and functionality in one conspet in the RobotNorge standardised rapid Library.

Virtual objects aim to emulate objects as found in other programming languages.

When choosing to work with virtual objects, the following pros and cons were considered:  
Pros:
- Virtual objects allow us to store both data and functionality in single consepts, making it easier to make complex programs more compact, readable and standardized
- virtual objects are inherently very modular, with very strict interfacing rules, which is one of the main goals for a scalable architecture
- Virtual objects does not limit the use of other programming styles
Cons:
- Virtual objects needs to be set up in a very deliberate way to work in the RAPID language, as it does not natively support objects
- Virtual objects have a higher performance overhead compared normal programming
- there is a learning curve to using virtual objects


## modifying an existing virtual object
To modify the behaviour of an exisiting virtual object that is installed on a robot do the following:

- Do a backup
- Edit the program module file for the virtual object in the robot file system
- Save the robot program for all tasks
- Reboot the robot in reset RAPID mode
- load the program
- the modified virtual object should now be live

## Creating a new virtual object

To create a new virtual object, 

A range 1001-1999
B range 2001-2999
C range 3001-3999
D range 4001-4999
E range 5001-5999


## Naming

When working with virtual objects, the following naming convention must be respected:

Each virtual object has an numeric index, and a name.

The index and name must be set in the Constants at the top of the module:

```
CONST virtualObjectType OBJECT_TYPE_EXAMPLEDRIVER:=2;  
CONST virtualObjectTypeName OBJECT_TYPE_2 := "ExampleDriver";
```

Please note that OBJECT_TYPE_**EXAMPLEDRIVER**:=2; must match OBJECT_TYPE_2 := "**ExampleDriver**";  
and that OBJECT_TYPE_EXAMPLEDRIVER:=**2**; must match OBJECT_TYPE_**2** := "ExampleDriver";
