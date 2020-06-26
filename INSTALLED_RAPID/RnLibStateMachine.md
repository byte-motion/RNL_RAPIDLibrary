# RnLibStateMachine.sys

## Bruk

Gir mulighet for enkelt oppsett av 'scan'-funksjonalitet i forbindelse med multitasking.

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
...

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
    
...
```
Skriver stringen "*Dette er en kommentar." inn i loggfil sammen med timestamp. Komplett linje i logg vil se slik ut:
```
12:13:14 *Dette er en kommentar.
```
*Eksempel 2:*
```
WriteLog ["*Dette er en kommentar."," Enda mer tekst!"]\FileName:="BckGndProcess.log";
```
Dette eksempelet skriver til en egen loggfil med navn "BckGndProcess.log". Resultat i denne filen blir slik:
```
12:13:14 *Dette er en kommentar. Enda mer tekst!
```

## Argument

```
WriteLog [\Tp] Text{*} [\Filename]
```
*Tp*

Data type: switch

Angir om tekst array skal skrives til TPU i tillegg til å skrives inn i logg.

*Text{\*}*

Data type: string

Array av type string med tekst som skal skrives til logg. Ingen begrensing på hvor mye innhold som brukes. Hver string har grense på max 80, som er normalt i Rapid.

*Filename*

Data type: string

Alternativt filnavn. Eksempelvis kan egen prosess loggføre til egen fil. Det vil gjøre det mye enklere for andre programmerere å sile ut informasjon under debugging.

## Program kjøring

Ved oppkall vil *WriteLog* rutine alltid sjekke første linje i nåværende loggfil. Om den er lik dagens dato (*CDate()*) vil linjer i argument *Text{\*}* appendes til fil. Om dato er forskjellig vil fil kopieres til arkiv og ny loggfil vil påbegynnes.

Ved hver ny loggfil vil også opprydding i arkiv kjøres. Default er at eldste fil slettes helt til arkiv er under grense på 2MB.

## Error handling

Typiske feil som kan oppstå er manglende tilgang til filer eller mapper. Mulig også korrupte loggfiler.

## Mer informasjon

* Open -> Åpne fil for lesing/skriving
* Opendir -> Åpne mappe for lesing
* Write -> Skriv til fil
* NumToStr -> Konverter num programdata til string
* ValToStr -> Konverter RECORD-programdata til string

## Standardisert loggfil

Logg bør ha standardisert format. Dette vil gjøre det svært enkelt å ta i bruk eksisterende script for behandling av loggdata. Det blir også mye lettere for dine kolleger å lese loggfiler fra din installasjon.

Påbegynning av ny sekvens for robot formateres med J:<sekvens_navn>,<parameter_navn>=<parameter_verdi>,... .

*Eksempel:*
```
WriteLog ["J:PickPlaceBox,PickPos=123,giPlcCmd=",NumToStr(giPlcCmd,0)];
```

Avslutning av sekvens formateres med _t:<Sekvens_syklustid> .

*Eksempel:*
```
WriteLog [" t:",NumToStr(ClkRead(clock1\HighRes),3)];
```

Kommentarer og informasjon underveis i sekvens formateres med *<Kommentar> .
  
*Eksempel:*
```
WriteLog ["*CamPose",ValToStr(poseCamData)];
```

Start/Stop/Restart/PowerOn settes opp som eventrutiner og formateres med E:<Event> .

*Eksempel:*
```
WriteLog ["E:PowerOn"];
WriteLog ["E:Start"];
WriteLog ["E:Restart"];
WriteLog ["E:Stop"];
WriteLog ["E:QStop"];
WriteLog ["E:Reset"];
```





