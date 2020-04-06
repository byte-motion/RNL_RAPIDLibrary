# RnLibLog.sys

## Bruk

Skriver en linje tekst til loggfil sammen med timestamp. Automatisk håndtering av logg-arkiv og begrensing av diskbruk.

## Installasjon

1. Last inn system-modul i aktuell task.
2. Opprett mapper i HOME katalog på controller.
   * \<SYSTEM_ID>\HOME\logs
   * \<SYSTEM_ID>\HOME\logs\archive

Mappenavn kan endres om nødvendig. Eksempelvis om flere tasker har behov for å skrive til egne loggfiler.

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
WriteLog ["*Dette er en kommentar."," Enda mer tekst!"]\FileName:="BckGndProcess.log";
```
Dette eksempelet skriver til en egen loggfil med navn "BckGndProcess.log". Resultat i denne filen blir slik:
```
12:13:14 *Dette er en kommentar. Enda mer tekst!
```

## Argument

```
WriteLog Text{*} [\Filename]
```
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





