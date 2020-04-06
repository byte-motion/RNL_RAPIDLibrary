# RnLibLog.sys

## Bruk

Skriver en linje tekst til loggfil sammen med timestamp. Automatisk håndtering av logg-arkiv og begrensing av diskbruk.

## Eksempel

*Eksempel 1:*
```
WriteLog ["*Dette er en kommentar."];
```
Skriver stringen "*Dette er en kommentar." inn i loggfil sammen med timestamp. Komplett linje i logg vil se slik ut:
```
12:13:14 *Dette er en kommentar.
```
*Eksempel 2:*
```
WriteLog ["*Dette er en kommentar."," Enda mer tekst!"];
```
Resultat blir slik i loggfil:
```
12:13:14 *Dette er en kommentar. Enda mer tekst!
```

## Argument

```
WriteLog Text{*}
```
*Text{\*}*

Data type: string

Array av type string. Ingen begrensing på hvor mye innhold som brukes. Hver string har grense på max 80, som er normalt i Rapid.

## Program kjøring

Ved oppkall vil *WriteLog* rutine alltid sjekke første linje i nåværende loggfil. Om den er lik dagens dato (*CDate()*) vil linjer i argument *Text{\*}* appendes til fil. Om dato er forskjellig vil fil kopieres til arkiv og ny loggfil vil påbegynnes.

Ved hver ny loggfil vil også opprydding i arkiv kjøres. Default er at eldste fil slettes helt til arkiv er under grense på 2MB.

## Error handling

Typiske feil som kan oppstå er manglende tilgang til filer eller mapper. Mulig også korrupte loggfiler.

## Mer informasjon

- Open -> Åpne fil for lesing/skriving
- Opendir -> Åpne mappe for lesing
- Write -> Skriv til fil

## Standardisert loggfil

Logg bør ha standardisert format. Dette vil gjøre det svært enkelt å ta i bruk eksisterende script for behandling av loggdata. Det blir også mye lettere for dine kolleger å lese loggfiler fra din installasjon.

Påbegynning av ny sekvens for robot formateres med J:<sekvens_navn>,<parameter_navn>=<parameter_verdi>,... .

Eksempel:
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
WriteLog ["E:Start"];
```





