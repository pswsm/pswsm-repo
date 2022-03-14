# Primers
##  Eines
### Disseny
- [Primer3](https://primer3.ut.ee/)
- [NCBI (Primer3 + Blast)](https://www.ncbi.nlm.nih.gov/tools/primer-blast/index.cgi)
- [Oligo](https://eu.idtdna.com/pages/tools/oligoanalyzer)
- [OligoCalc](http://biotools.nubic.northwestern.edu/OligoCalc.html)
- [eprimer3](http://emboss.bioinformatics.nl/cgi-bin/emboss/eprimer3)
- [mfeprimer](https://mfeprimer3.igenetech.com/)
## PCR
La PCR és una tècnica per a fer moltes còpies d'una determinada regió d'ADN _in vitro_.
Aquesta depén d'una polimerasa termoestable, la _Taq Polimerasa_, i requereix l'ús de parelles d'oligonuecleòtids com a iniciadors o **primers** dissenyats específicament per a la regió d'interés.
La clau per a que una PCR tinga èxit és un primer ben dissenyat.
Com que una PCR varia de temperatura sovint duurant els difefrents cicles, s'han de tenir en compte a l'hora de dissenyar-los.
<br>Les principals variables són:

- Temperatura de fusió
- Grandària del oligonucleòtid
- Especificitat
- Complementarietat en la seqüencia dels oligonucleòtids.
### Taq Polimerasa
_**T**hermus **Aq**uaticus **polimerasa**_
<br>Aquest bacteri es pot trobar en aigües termals i fonts hidrotermals. Dita polimerasa presenta activitat prop dels 70°C. La polimerasa pròpia de l'humà no pot treballar a aquestes temperatures, i és necesssaria una temperatura alta per a desnaturalitzar (separar) les cadenes d'ADN.
### _Primers_ per PCR
Com altres aADN polimerases, la Taq Polimerasa nomes pot fer ADN si hi ha un _primer_, un seqüencia no gaire llarga d'oligonucleotids que fa de punt d'inici per a la sínstesi de l'ADN.
<br>En una reacció PCR, la regió d'ADN amplificada serà determinada per el primer que l'investigador trii.
<br>Aquests primers solen tenir no gaire més de 20 bases de longitud. A cada reacció s'agregaràn dos primers, un directe i un revers.
#### Fases de la PCR

1. Desnaturalització (96°C): Fa que els enllaços d'hidrogen entre les dues cadenes es trenquin.
2. Temperatura (55°C - 65°C): Els primers s'uneixen a les seves seqüencies complementaries, en l'ADN motlle.
3. Extensió (72°C): La Taq Polimerasa s'adhereix a les cadenes amb primers, i esten les cadenes dels primers, sintetitzant noves cadenes d'ADN completes.
El creixement d'ADN diana es exponencial, ja que les noves cadenes generades també s'utilitzen com a motlle.

#### Temperatures _Primers_
##### Temperatura de fusió
La temperatura de fusió (Tm) és la temperatura on la meitat dels fils d'ADN estan desnaturalitzats.
A l'hora de fer una PCR s'ha de tenir en compte que hi juguen dos olinuecleotids i que, per tant haurien de tenir **Tm** semblants.
Hi dues formules

- Càlcul Termodinàmic (exacte):
`Tm = ΔH [ΔS+ R ln (c/4)] – 273.15°C + 16.6 log 10 [K+]`
- Fromula de Wallace (aprox.):
`Tm oligonucleòtids = 2(A+T) + 4(G+C)`
<br>La sedüent taula mostra la temperatura de fusió segons el nombre de bases, seguint la formula de Wallace i assumint un contingut G/C del 50%:
| Tamany (bases) | Tm (°C) |
|----------------|---------|
| 4              | 12      |
| 8              | 24      |
| 10             | 30      |
| 12             | 36      |
| 14             | 42      |
| 16             | 48      |
| 18             | 54      |
| 20             | 60      |
| 22             | 66      |
| 24             | 72      |
| 26             | 78      |
| 28             | 84      |
e
#### Temperatura d'anellament
La temperatura d'anellament (Ta), a diferència de la Tm (que depèn segons la llargada i composició de l'ADN), aquesta depén exclusivament dels primers i la seva longitud i composició.
Comunament, s'utilitzen temperatures 5°C per sota la Tm més baixa dels dos primers utilitzats.
La Ta, com era d'esperar, també té una formula:

- Ta = 0,3 x Tm<sub>primer</sub> + 0,7 Tm<sub>adn</sub> – 14,9

Generalment, la Ta és entre 10 i 15°C per sota de la Tm.

### Problemes comuns amb els Primers
Hem de comprovar la probabilitat del següent:

- Self-diming: El primer s'uneix amb un altre primer igual.
- Hairpin: El primer es doblega per unir-se amb ell mateix.
- Primer dimer: El pimer no s'unirà amb un altre primer diferent que empleem.