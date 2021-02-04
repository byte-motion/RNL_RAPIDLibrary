# RNL_B_SmsSender.sys

## Usage

Enkel tilgang til å sende SMS fra RAPID.



## Installation

1. Load modules in designated task.
* RNL_B_SmsSender.sys



## Example

*Example send SMS:*
```
    PROC Routine()
        ...
        IF SendSMS("91549567","Teststring1"\stSmsText2:="\0d/Sent from ABB IRB120") THEN
            TPWrite "SUCCESS!";
        ELSE
            TPWrite "FAIL!";
        ENDIF
        ...
    ENDPROC
```

## Functions / Instructions

**FUNC bool SendSMS(string stSmsNumber,string stSmsText1\string stSmsText2)**

Send a SMS using provided phone number and text. Returns TRUE if message was sent successfully.



## Error handling

Not implemented. Use returnvalue for statuscheck.



## Mer informasjon




