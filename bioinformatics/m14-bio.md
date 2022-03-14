#   Bioinformàtica
## ADN Recombinat
L'ADN recombinat és una molècula resultat de l'unió artificial de dos fragments d'ADN.
Permet aïllar un gen en concret, per a poder-lo modificar i inserir en un altre organisme.
Això provoca que dit organisme sigui capaç de crear un proteïna aliena a ell.
<br>Normalment s'utilitzen en la producció a gran escala de proteïnes humanes: podem fer que un bacteri produeixi la insulina humana.
##  Enzims de Restricció
Els enzims de restricció tallen les cadenes d'ADN a través de l'esquelet de fosfats, sense danyar cap base.
Bàsicament `^C + ^V` d'ADN.
<br>Aquests enzims són produïts per bacteris com a defensa contra els virus, i degraden l'ADN estrany.
L'ADN bacterià està protegit contra els seus propis enzims de restricció. Algúns dels seus núcleotids tenen un grupu metil \[-CH3] adherit.
Aquests metils, són essencials per a la enginyeria genètica, ja que són la cola per enganxar bases entre si.
### Tipus de  talls
Aquuests enzims al tallar poden fer dos tipus de talls:

- Cohesius/Enganxosos: Talls escalonats/asimètrics. L'enzim talla ambdues cadenes en diferents posicions.
```fasta
gcggagaa | aacacccgagagagtgc
         --------
cgcctcttttgtggg | ctctctcacg
```
- Roms: Talls simètrics. L'enzim talla ambdues cadenes a la meteixa posició
```fasta
gcggagaaaac | acccgagagagtgc
cgcctcttttg | tgggctctctcacg
```
### Tipus d'enzims
Aquuests enzims es calssifiquen en tres tipus: `I`, `II`, `III`.
Els de tipus `I` i `III` són complexos multiproteics que reconeixen seqüencies concretes d'ADN asimètrics, i fan la digestió de l'ADN unes bases més enllà. En el cas de les de tipus `I` poden ser distàncies d'entre 50 a milers de pb. Les de tipus `III`, en canvi, fan la digestió unes 25 bases mes enllà.
<br>Les més interessants per a la enginyeria genètica però, són les del tipus `II`. Codificades per un únic gen bacterià, solen actuar en forma de [dímers](https://dlc.iec.cat/results.asp?txtEntrada=d%EDmer&OperEntrada=0).
<br>La seva característica principal és que el tall þe lloc a la mateixa zona on s'uneixen a l'ADN. Aquestes zones es denominen "dianes". Dites dianes solen tenir una longitud d'entre 4 i 8 pb. El nombre de dianes serà inversament proporcional a la longitud de la diana, ja que es és fàcil trobar en diversos llocs una cadena de 4 que una de 8.
##ADN Recombinat en els bacteris
S'utilitzen virus i plasmidis (molecules d'ADN circulars present en ceŀlules procariotes, separades de l'ADN genòmic) amb grandàries d'entre 3 i 10 quilobases.
Els plasmidi poden contenir un o més gens de resistència antibiotica, i tenen la capacitat d'autoreplicar-se, ja que contenen una seqüència d'iniciació pròpia.
Podem crear una molècula d'ADN recombinat utilitzant el plasmidi:

1. Tallem l'ADN circular, deixant extrems cohesius.
2. Tallem l'ADN d'interés, el que volem multiplicar, amb el mateix enzim de restricció per a que aquest i el circular siguin coplementaris i es puguin unir.
3. Unim el gen que volem introduïr amb el gen del plasmidi, utilitzant els metils (ADN-Ligasa). Posteriorment introduïm el plasmidi modificat en els bacteris
4. Seleccionem els bacteris que hagin incorporat el plasmidi amb l'ajuda d'un antibiòtic. Com que els plasmidis introduïts tenen un gen de restistència antibiotica, només els que hagin sobreviscut seràn els que l'han incorporat amb èxit.
##  Amplificació ADN - Polimerasa Chain Reaction (PCR)
Es basa en la separació d'ambdós brins d'ADN, la posterior unió de _primers_ a aquests. Aquests primers aniràn multiplicant de forma exponencial les mostres d'ADN.
Per a dur a terme aquesta reacció cal un enzim polimerasa que sigui capaç de treballar a altes temperatures. Aquest enzim s'extreu d'un bacteri termòfil, anomenat _Thermus Aquaticus_.
La reacció en cadena d'aquesta polimerasa (que dona nom al procés) permet amplificar la mostra de forma espectacular, generant un nombre infinit de còpies de la cadena inicial.
##Mapes de restricció
Un mapa de restricció representa una seqüencia lineal ordenada de les dianes corresponents a diferents enzims de restricció en una cadena d'adn concreta.
Els d'ADN generats amb els talls es poden veure amb electroforesi sobre un gel d'agarosa. Aixó permetra determinar el nombre de llocs de restricció i la distància entre ells segons les posicions de les bandes sobre el gel.
També es pot distingir entre ADN Lineal (eucariotes, alguns virus) i ADN Circular (procariotes, plasmidis, alguns virus):

- ADN Lineal: Nombre de fragments = nombre de dianes + 1
La suma de les bases dels fragments ha de ser igual a les bases totals de l'ADN digerit.
- ADN Circular: Nombre de fragments = nombre de dianes
Quan empleem un enzim de restricció sobre un ADN Ciruclar, el primer tall només ens revelarà el total de bases de l'ADN. Com en l'anterior, la suma dels fragments ha de ser igual a les bases de l'ADN digerit.
### Eines per seleccionar Enzims de Restricció
Hi ha diverses eines per a seleccionar enzims de restricció sobre una cadena d'ADN:

- [WatCut](http://watcut.uwaterloo.ca/watcut/watcut/template.php)
- [remap](http://www.bioinformatics.nl/cgi-bin/emboss/remap)
- [NEBcutter](http://nc2.neb.com/NEBcutter2/)
- [RestrictionMapper](http://www.restrictionmapper.org/)
