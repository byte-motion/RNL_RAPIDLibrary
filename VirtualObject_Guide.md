# Guide for Creating Virtual Objects

Virtual objects are structues used to collect data and functionality in one conspet in the RobotNorge standardised rapid Library.

Virtual objects aim to emulate objects as found in other programming languages.

When choosing to work with virtual objects, the following pros and cons were considered:  
Pros:
- Virtual objects allow us to store both data and functionality in single consepts, making it easier to make complex programs more compact, readable and standardized
- virtual objects are inherently very modular, with very strict interfacing rules, which is one of the main goals for a modular, scalable architecture
- Virtual objects, in this implementation, does not limit the use of other programming styles  

Cons:
- Virtual objects needs to be set up in a very deliberate way to work in the RAPID language, as it does not natively support "objects"
- Virtual objects have a higher performance overhead compared normal programming
- there is a learning curve to using virtual objects

## Implementation
Virtual objects are implemented in the followin way:
- Object harmonized formatting
- Local Objects
- Global Objects

**Object harmonized formatting** is ...

**Global Objects** are fully implemented, globally accessable objects that consist of data stored sentrally in a installed and shared task. The data, and therefore the object is accessed by using a reference/pointer that points to where the data is stored. This implementation is complex and potentially quite taxing, but it allows a object to be accessed from anywhere from inside, and in some cases, outside the robot controller. 
This implementation has a limitation that each object type can only have initialized a pre defined number of instances at once, but this can be easily changed in the object module.
Each object type has its own name, numerical ID, as well as a data type for the pointer to the object. all of theese pointers are alias with a master pointer type.

**Local objects** are a simpler implementation of true global virtual objects where all the data used for the objects is stored in the user program. instead of working with pointers to shared memory, the user handles the spesific data itself. The benefits of this implementation is scalability in some cases, simplicity when needed. 
Datatypes for holding the data representing the object has the dame name as the pointer to the object, but with the suffix _Data on the end


 
DuMost object have support for beeing intialized as both **global and local**, while some can only be initialized as local or global depending on the limitations of the implementation of the object.


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
