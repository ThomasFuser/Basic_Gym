#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);#DA TOGLIERE PRIMA DELLA CONSEGNA SERVE A VEDERE GLI ERRORI DA BROWSER
use CGI::Session;
use XML::LibXML;
use Encode qw(encode);


use Exporter qw(import);
our @EXPORT = qw(enc stampaIndex stampaPrezzi stampaPrezziAcquistabili stampaStaff);

package util::htm_content;

#--------------------- STAMPA IL CONTENUTO DELLA PAGINA IDEX ----------------
sub stampaIndex{
  print "
  <div id=\"content\">

 <div class=\"packages boxa\">

            <ul class=\"package home\">
                <li class=\"title cont\"><span xml:lang=\"en\">NEWS</span></li>

                <li class=\"description rev\">Porta un amico e, solo per il mese di dicembre, avrai diritto ad uno sconto del 30% sul tuo abbonamento!
    Cosa Aspetti!?</li>
           <li> <a href=\"prezzi.html\"> Vai a Prezzi </a> </li>
            <li class=\"imgDesc\"><img class=\"IMMBOX\" src=\"../images/news.jpg\" alt=\"parola news scritta con i dadi\"/></li>
            </ul>

               <ul class=\"package home\">
                <li class=\"title cont\">OFFERTE</li>

                <li class=\"description rev\"> Palestra rinnovata con nuovi macchinari specifici per tutte le tipologie di allenamento vieni a scoprirli!</li>
                <li> <a href=\"prezzi.html\"> Vai a Corsi </a> </li>
                <li class=\"imgDesc\"><img class=\"IMMBOX\" src=\"../images/Offert.png\" alt=\"Scritta Offert\"/></li>
            </ul>

              <ul class=\"package home\">
                <li class=\"title cont\"><span xml:lang=\"en\">BASIC GYM</span></li>

                <li class=\"description rev\">Una palestra che mette al centro il benessere proprio a poca distanza dal centro storico di Casteminio.
Disponiamo di aree attrezzate per lezioni a corpo libero che definiscono un nuovo standard di tonificazione muscolare al vostro corpo.</li>
<li> <a href=\"corsi.html\"> Vai a Corsi </a> </li>
<li class=\"imgDesc\"><img class=\"IMMBOX\" src=\"../images/fitMot.jpg\" alt=\"sequenza di immagini di esercizi crossfit\"/></li>
            </ul>

</div> </div>";

}

#------------------- PAGINA PREZZI DA STAMPARE QUANDO NON SI E' LOGGATI --------------------
sub stampaPrezzi{

    #my $q = new CGI;
    #my ($user,$path)= @_;
    my $valuta = "€";
    my $doc = util::db_util::caricamentoLibXML();

    my $query = "listaAbbonamenti/categoria";

    print "
    <div id=\"content\">
        <h1>Prezzi e Offerte</h1>
    ";

    foreach my $titArea($doc->findnodes($query))
    {
        my $area = enc($titArea->findnodes("./titolo"));
         ($area) = ($area =~ /<titolo>(.*)<\/titolo>/);

         print"
         <div class=\"packages\"><h2> $area </h2> ";

        foreach my $partAbb($titArea->findnodes("./abbonamento"))
        {
            my $durata = enc($partAbb->findnodes("./durata"));
            ($durata)=($durata=~ /<durata>(.*)<\/durata>/);

            my $prezzo = enc($partAbb->findnodes("./prezzo"));
            ($prezzo)=($prezzo=~ /<prezzo>(.*)<\/prezzo>/);

            my $desc = enc($partAbb->findnodes("./descrizione"));
            ($desc)=($desc=~ /<descrizione>(.*)<\/descrizione>/);

            print"
            <ul class=\"package\">
            <li class=\"title\"> $durata </li>
            <li class=\"price\"> $prezzo $valuta </li>
            <li class=\"description\"> $desc </li>
            </ul>
            ";

            }
        print "</div>";
    }# CHIUSURA FOREACH TITOLI

    print "</div>";
}

#--------------- PAGINA PREZZI DA STAMPARE QUANDO SI E' LOGGATI COME UTENTI ---------------
sub stampaPrezziAcquistabili{

    #my $q = new CGI;
    #my ($user,$path)= @_;
    my $valuta = "€";
    my $doc = util::MyLib::caricamentoLibXML();

    my $query = "listaAbbonamenti/categoria";


    print "
    <div id=\"content\">
        <h1>Prezzi e Offerte</h1>
    ";


    foreach my $titArea($doc->findnodes($query))
    {
        my $area = enc($titArea->findnodes("./titolo"));
         ($area) = ($area =~ /<titolo>(.*)<\/titolo>/);

         print"
         <div class=\"packages\"><h2> $area </h2> ";

        foreach my $partAbb($titArea->findnodes("./abbonamento"))
        {
            my $durata = enc($partAbb->findnodes("./durata"));
            ($durata)=($durata=~ /<durata>(.*)<\/durata>/);

            my $prezzo = enc($partAbb->findnodes("./prezzo"));
            ($prezzo)=($prezzo=~ /<prezzo>(.*)<\/prezzo>/);

            my $desc = enc($partAbb->findnodes("./descrizione"));
            ($desc)=($desc=~ /<descrizione>(.*)<\/descrizione>/);

            print"
            <ul class=\"package\">
            <li class=\"title\"> $durata </li>
            <li class=\"price\"> $prezzo $valuta </li>
            <li class=\"description\"> $desc </li>
            <li> <a href=\"Acquista.html\" > Acquista </a>  </li>

            </ul>
            ";

            }
        print "</div>";
    }# CHIUSURA FOREACH TITOLI

    print "</div>";

}

#---------------- STAMPA  DESCRIZIONE DEI CORSI ---------------------
sub stampaCorsi{
print"  <div id=\"content\">

     <h1>Offerta Corsi</h1>
      <!--<img class=\"areaIM\" src=\"corsi.jpg\" alt=\"ragazza che pedala in palestra\"/>-->
     <!--<p>per un benessere che non trascura nulla...</p>-->
<div class=\"sez\" id=\"area1\" >
      <h2>Area <span lang=\"en\">Soft Fitness</span></h2>

            <ul>
             <li><a href=\"soft.html#yoga\">Yoga</a></li>
             <li><span lang=\"en\"><a href=\"soft.html#pilates\">Pilates</a></span></li>
             <li><span lang=\"en\"><a href=\"soft.html#bbalance\">Body Balance</a></span></li>
            </ul>
        <a class=\"button\" href=\"soft.html\">Approfondisci</a>


 </div>
<div class=\"sez\" id=\"area2\">
  <h2>Area Cardio Fitness</h2>

         <ul>
             <li><span lang=\"en\"><a href=\"cardio.html#spinning\">Spinning</a></span></li>
             <li><span lang=\"en\"><a href=\"cardio.html#walking\">Walking</a></span></li>
             <li><span lang=\"en\"><a href=\"cardio.html#totalb\">Total Body</a></span></li>
         </ul>
         <a class=\"button\" href=\"cardio.html\">Approfondisci</a>


     </div>
      <div class=\"sez\" id=\"area3\">

             <h2>Area <span xml:lang=\"en\">Cross Fitness</span></h2>

         <ul>
             <li><span lang=\"en\"><a href=\"cross.html#intervalt\">Interval Training</a></span></li>
             <li><span lang=\"en\"><a href=\"cross.html#bcombat\">Body Combat</a></span></li>
             <li><span lang=\"en\"><a href=\"cross.html#bpump\">Body Pump</a></span></li>
             <li><span lang=\"en\"><a href=\"cross.html#crossf\">CrossFit</a></span></li>
         </ul>
         <a class=\"button\" href=\"cross.html\">Approfondisci</a>

 </div>
  </div>";
}

#---------------- FUNZONE DI STAMPA PAGINA SOFT --------------------
sub stampaSoft{
  print "
  <div id=\"content\">

      <div class=\"text\"> <h1>Area <span lang=\"en\">Soft Fitness</span></h1>
              <dl>
                  <dt id=\"yoga\">Yoga</dt>
                  <dd >Lo yoga è una disciplina antica che aiuta a riscoprire il proprio essere. Si tratta di un'attività intensa che tuttavia rispetta il tuo organismo e le sue esigenze. Adatta a tutti.
  Scopri tutti i benefici dello yoga e scopri i particolari e la storia di questa antica disciplina su <a href=\"http://yoganride.com/12-benefici-dello-yoga-sul-corpo-e-sulla-mente/\" accesskey=\"l\" tabindex=\"1\">yoganride.com[link esterno]</a> </dd>
                  <dt id=\"pilates\"><span xml:lang=\"en\">Pilates</span></dt>
                  <dd>		Il   <span xml:lang=\"en\">Pilates</span> ha lo scopo di rafforzare il corpo senza aumentare eccessivamente la massa muscolare, di sviluppare fluidità e precisione dei movimenti, di migliorare o correggere la postura con un lavoro centrato sulle regioni addominale e dorsale.
  		Questi obiettivi sono raggiunti con movimenti lenti, mantenendo una grande concentrazione e attenzione alla respirazione, in modo che l’attività fisica risulti in una maggiore consapevolezza del proprio corpo e dei movimenti che si compiono.
  		</dd>
                  <dt id=\"bbalance\" ><span xml:lang=\"en\">Body Balance</span></dt>
                  <dd>Il<span xml:lang=\"en\"> body balance </span> è una disciplina sportiva nuovissima che unisce yoga, <span xml:lang=\"en\">pilates</span> e <span xml:lang=\"ja\">tai chi</span>, ed è utilissima per combattere stati d'animo ansiosi e depressivi. Vieni a provare questa nuova disciplina e assporane tutti i benefici.
  </dd>
      </dl>
         </div>
              <img class=\"lateral\" src=\"images/yoga.jpg\" alt=\"persona seduta a terra durante la meditazione yoga\" longdesc=\"orario2.html#yoga\" />
         </div>";
}

#----------------- FUNZIONE STAMPA  SOFT -----------------
sub stampaCross{
  print "
  <div id=\"content\">
      <div class=\"text\">
               <h1>Area<span lang=\"en\" >CrossFitness</span></h1>
       <dl>
              <dt><span lang=\"en\">Interval Training</span></dt>
              <dd> Disciplina innovativa famosa per la sua efficacia.
  Strutturata in un'alternanza \"intervalli\" di attività  aerobica e anaerobica  che miglioreranno le vostre prestazioni cardiovascolari e la vostra resistenza fisica.
</dd>
              <dt id=\"bcombat\"><span lang=\"en\">Body Combat</span></dt>
              <dd>		Il <span lang=\"en\">Body Combat</span> è un allenamento cardiovascolare energico e potente capace di liberare dallo stress. Il programma all'insegna dell'energia è Ispirato dalle arti marziali e attinge da diverse discipline come: <span lang=\"ja\">Karate</span>, , <span lang=\"ja\">Tae Kwon Do, Tai Chi e Muay Thais</span>. Grande supporto è offerto dalla musica motivante e dal lavoro degli istruttori, all'insegna del dispendio energetico verso un livello superiore di resistenza cardio-vascolare. 
</dd>
              <dt id=\"bpump\"><span lang=\"en\">Body Pump</span></dt>
              <dd>		Un circuito che mescola in modo efficace attività aerobica e anaerobica per aumentare la massa muscolare, tonificare tutto il corpo e aumentare la resistenza delle articolazioni. Produce inoltre grossi benefici sul metabolismo, favorendo l'eliminazione delle tossine: per un complessivo benessere generale.
</dd>
              <dt id=\"crossf\"><span lang=\"en\">Cross Fit</span></dt>
              <dd>Il <span lang=\"en\">crossfit</span> è una nuova disciplina emergente che migliora forza, flessibilità, resistenza e coordinazione. Gli allenaementi brevi ma intensi, sviluppano in breve tempo un fisico tonico e snello. Se iniziate non potrete più farne a meno!
</dd>
          </dl>
  </div>

 <img class=\"lateral\" src=\"images/Cross-Train.jpg\" alt=\"donna che solleva peso\"/>
</div>";
}

#------------------ FUNZIONE STAMPA CARDIO --------------------
sub stampaCardio{
  print"
  <div id=\"content\">
      <div class=\"text\"> <h1>Area Cardio<span lang=\"en\">Fitness</span></h1>
              <dl id=\"corsicardio\">
                  <dt id=\"walking\"><span lang=\"en\">Walking</span></dt>
                  <dd>		E’ un idea tanto semplice quanto rivoluzionaria, una camminata virtuale su un tappeto meccanico, a ritmo di musica. Più che un attrezzo è un programma di <span lang=\"en\">fitness</span>. L’esercizio è aerobico, cioè graduale ma costante e prolungato, potenzia cuore e polmoni e permette di dimagrire.

  L’insegnante guida il ritmo dei passi, inizia con il riscaldamento, poi si passa ad una fase centrale della lezione, infine al defaticamento e allo <span xml:lang=\"en\">stretching </span> finale. La vera natura dell’<span lang=\"en\">Indoor Walking</span> è il vostro gruppo. La musica rende la lezione ancora più divertente ! </dd>
                  <dt id=\"spinning\"><span lang=\"en\">Spinning</span></dt>
                  <dd>		Lo <span lang=\"en\">spinning</span> (o <span lang=\"en\">indoor cycling</span>) è un'attività aerobica di gruppo su una bicicletta stazionaria. Adatto per migliorare le capacità cardiovascolari,  coniuga i benefici della bicicletta con i vantaggi di un'attività gruppo a ritmo di musica. Un istruttore vi guiderà in tutte le fasi dell'allenamento per sfruttare appieno i benefici di questa disciplina.
  </dd>
                  <dt id=\"totalb\"><span lang=\"en\">Total Body</span></dt>
                  <dd>		Il <span lang=\"en\">total body circuit</span> è un tipo di allenamento che ha lo scopo di allenare la muscolatura di tutto il corpo. Rappresenta l’evoluzione delle lezioni a corpo libero e consente di migliorare il tono dei muscoli di spalle, braccia, addome, glutei e gambe.
  		Grazie all’utilizzo di attrezzi <span xml:lang=\"en\">fitness</span> quali<span lang=\"en\">step</span>, manubri, cavigliere, elastici e <span lang=\"en\">body bar</span>, il <span lang="en">total body circuit</span> punta a migliorare l’efficienza del sistema cardiorespiratorio, la flessibilità, la coordinazione, l’equilibrio e la postura. Il tutto rigorosamente a ritmo di musica.
  </dd>
              </dl>


      </div>
          <img class=\"lateral\" src=\"images/cycle.jpg\" alt=\"ragazza che si allena con la cyclette\"/>
  </div>
  ";
}

#---------------------- FUNZIONE STAMPA ORARIO ----------------
sub stampaOrario{
  print"
  <div id=\"content\">
    	<h1>Orari e Sale</h1>
   		<div class=\"tipo_area\">
        <table id=\"softfit\" summary=\"\">
          <caption>Orario <span xml:lang=\"en\">Soft Fitness</span></caption>
		<thead>
			<tr>
                <th id=\"a0\" scope=\"col\">Fasce Orarie </th>
				<th id=\"a1\" abbr=\"Lun\" scope=\"col\">Lunedì</th>
				<th id=\"a2\" abbr=\"Mar\" scope=\"col\">Martedì</th>
				<th id=\"a3\" abbr=\"Mer\" scope=\"col\">Mercoledì</th>
				<th id=\"a4\" abbr=\"Gio\" scope=\"col\">Giovedì</th>
				<th id=\"a5\" abbr=\"Ven\" scope=\"col\">Venerdì</th>
				<th id=\"a6\" abbr=\"Sab\" scope=\"col\">Sabato</th>
				<th id=\"a7\" abbr=\"Dom\" scope=\"col\">Domenica</th>
			</tr>
		</thead>
        <tfoot>
           <tr>
               <th id=\"b0\" scope=\"col\">Fasce Orarie </th>
				<th id=\"b1\" abbr=\"Lun\" scope=\"col\">Lunedì</th>
				<th id=\"b2\" abbr=\"Mar\" scope=\"col\">Martedì</th>
				<th id=\"b3\" abbr=\"Mer\" scope=\"col\">Mercoledì</th>
				<th id=\"b4\" abbr=\"Gio\" scope=\"col\">Giovedì</th>
				<th id=\"b5\" abbr=\"Ven\" scope=\"col\">Venerdì</th>
				<th id=\"b6\" abbr=\"Sab\" scope=\"col\">Sabato</th>
				<th id=\"b7\" abbr=\"Dom\" scope=\"col\">Domenica</th>
            </tr>
          </tfoot>
          <tbody>

    <tr>
        <th id=\"mattino_a\" headers=\"c0\"><span>Mattino</span><span>10:00-11:00</span></th>
         <td class=\"Lunedì\" headers=\"a1 mattino_a\">Yoga</td>
         <td class=\"Martedì\" headers=\"a2 mattino_a\"><span lang=\"en\">Body Balance</span></td>
         <td class=\"Mercoledì\" headers=\"a3 mattino_a\">Yoga </td>
         <td class=\"Giovedì\" headers=\"a4 mattino_a\"><span lang=\"en\">Body Balance</span></td>
         <td class=\"Venerdì\" headers=\"a5 mattino_a\">Yoga</td>
         <td class=\"Sabato\" headers=\"a6 mattino_a\"></td>
         <td class=\"Domenica\" headers=\"a7 mattino_a\"></td>

    </tr>
    <tr>
         <th id=\"pranzo_a\" headers=\"a0\"><span>Pausa Pranzo</span><span>12:00-13:00</span></th>
         <td class=\"Lunedì\" headers=\"a1 pranzo_a\"></td>
         <td class=\"Martedì\" headers=\"a2 pranzo_a\"><span lang=\"en\">Body Balance</span></td>
         <td class=\"Mercoledì\" headers=\"a3 pranzo_a\"></td>
         <td class=\"Giovedì\" headers=\"a4 pranzo_a\"><span lang=\"en\">Body Balance</span></td>
         <td class=\"Venerdì\" headers=\"a5 pranzo_a\"></td>
         <td class=\"Sabato\" headers=\"a7 pranzo_a\"><span lang=\"en\">Body Balance</span></td>
         <td class=\"Domenica\" headers=\"a7 pranzo_a\"></td>
    </tr>
    <tr>
        <th id=\"pomeriggio_a\" headers=\"a0\"><span>Pomeriggio</span><span>16:00-17:00</span></th>
        <td class=\"Lunedì\" headers=\"a1 pomeriggio_a\"><span lang=\"en\">Body Balance</span></td>
        <td class=\"Martedì\" headers=\"a2 pomeriggio_a\">Yoga </td>
        <td class=\"Mercoledì\" headers=\"a3 pomeriggio_a\"><span lang=\"en\">Body Balance</span></td>
        <td class=\"Giovedì\" headers=\"a4 pomeriggio_a\">Yoga </td>
        <td class=\"Venerdì\" headers=\"a5 pomeriggio_a\"><span lang=\"en\">Body Balance</span></td>
        <td class=\"Sabato\" headers=\"a6 pomeriggio_a\">chiuso</td>
        <td class=\"Domenica\" headers=\"a7 pomeriggio_a\">chiuso</td>

    </tr>
    <tr>
         <th id=\"sera_a\" headers=\"a0\"><span>Sera</span><span>19:00-20:00</span></th>
         <td class=\"Lunedì\" headers=\"a1 sera_a\"><span lang=\"en\">Pilates</span></td>
         <td class=\"Martedì\" headers=\"a2 sera_a\">Yoga</td>
         <td class=\"Mercoledì\" headers=\"a3 sera_a\"><span lang=\"en\">Body Balance</span></td>
         <td class=\"Giovedì\" headers=\"a4 sera_a\">Yoga </td>
         <td class=\"Venerdì\" headers=\"a5 sera_a\"><span lang=\"en\">Body Balance</span></td>
         <td class=\"Sabato\" headers=\"a6 sera_a\">chiuso</td>
         <td class=\"Domenica\" headers=\"a7 sera_a\">chiuso</td>
    </tr>
    </tbody>
    </table>
    </div>
    <div class=\"tipo_area\"><!--<h2>Sala Cardio<span lang=\"en\"> Fitness</span></h2>

    <p>Un ambiente spazioso e dinamico per accogliere anche chi, dopo una giornata di lavoro, pensa di non avere le energie necessarie per una lezione di cardiofitness. Colori e ambienti sono studiati per far emergere e convogliare l'energia nel movimento.</p>  -->
    <table id=\"cardiofit\" summary=\"\">
    <caption>Orario Cardio<span lang=\"en\"> Fitness</span></caption>
    <thead>
      <tr>
                <th headers=\"b0\" scope=\"col\">Fasce Orarie </th>
        <th headers=\"b1\" abbr=\"Lun\" scope=\"col\">Lunedì</th>
        <th headers=\"b2\" abbr=\"Mar\" scope=\"col\">Martedì</th>
        <th headers=\"b3\" abbr=\"Mer\" scope=\"col\">Mercoledì</th>
        <th headers=\"b4\" abbr=\"Gio\" scope=\"col\">Giovedì</th>
        <th headers=\"b5\" abbr=\"Ven\" scope=\"col\">Venerdì</th>
        <th headers=\"b6\" abbr=\"Sab\" scope=\"col\">Sabato</th>
        <th headers=\"b7\" abbr=\"Dom\" scope=\"col\">Domenica</th>
      </tr>
    </thead>
        <tfoot>
            <tr>
                <th headers=\"b0\" scope=\"col\">Fasce Orarie </th>
        <th headers=\"b1\" abbr=\"Lun\" scope=\"col\">Lunedì</th>
        <th headers=\"b2\" abbr=\"Mar\" scope=\"col\">Martedì</th>
        <th headers=\"b3\" abbr=\"Mer\" scope=\"col\">Mercoledì</th>
        <th headers=\"b4\" abbr=\"Gio\" scope=\"col\">Giovedì</th>
        <th headers=\"b5\" abbr=\"Ven\" scope=\"col\">Venerdì</th>
        <th headers=\"b6\" abbr=\"Sab\" scope=\"col\">Sabato</th>
        <th headers=\"b7\" abbr=\"Dom\" scope=\"col\">Domenica</th>
            </tr>


    </tfoot>
    <tbody>
     <tr>
         <th id=\"mattino_b\" headers=\"c0\"><span>Mattino</span><span>10:00-11:00</span></th>
         <td class=\"Lunedì\" headers=\"b1 mattino_b\"><span lang=\"en\">Interval Training</span></td>
         <td class=\"Martedì\" headers=\"b2 mattino_b\"></td>
         <td class=\"Mercoledì\" headers=\"b3 mattino_b\"><span lang=\"en\">Interval Training</span></td>
         <td class=\"Giovedì\" headers=\"b4 mattino_b\"></td>
         <td class=\"Venerdì\" headers=\"b5 mattino_b\"><span lang=\"en\">Interval Training</span></td>
         <td class=\"Sabato\" headers=\"b6 mattino_b\"></td>
         <td class=\"Domenica\" headers=\"b7 mattino_b\"></td>

    </tr>
    <tr>
         <th id=\"pranzo_b\" headers=\"a0\"><span>Pausa Pranzo</span><span>12:00-13:00</span></th>
         <td class=\"Lunedì\" headers=\"b1 pranzo_b\"><span lang=\"en\">Spinning</span></td>
         <td class=\"Martedì\" headers=\"b2 pranzo_b\"><span lang=\"en\">Walking</span></td>
         <td class=\"Mercoledì\" headers=\"b3 pranzo_b\"><span lang=\"en\">Spinning</span></td>
         <td class=\"Giovedì\" headers=\"b4 pranzo_b\"><span lang=\"en\">Walking</span></td>
         <td class=\"Venerdì\" headers=\"b5 pranzo_b\"><span lang=\"en\">Spinning</span></td>
         <td class=\"Sabato\" headers=\"b7 pranzo_b\"><span lang=\"en\">Walking</span></td>
         <td class=\"Domenica\" headers=\"b7 pranzo_b\">chiuso</td>
    </tr>
    <tr>
        <th id=\"pomeriggio_b\" headers=\"a0\"><span>Pomeriggio</span><span>16:00-17:00</span></th>
        <td class=\"Lunedì\" headers=\"b1 pomeriggio_b\"><span lang=\"en\">Total Body</span></td>
      <td class=\"Martedì\" headers=\"b2 pomeriggio_b\"><span lang=\"en\">Interval Training</span></td>
      <td class=\"Mercoledì\" headers=\"b3 pomeriggio_b\"><span lang=\"en\">Total Body</span></td>
      <td class=\"Giovedì\" headers=\"b4 pomeriggio_b\"><span lang=\"en\">Inteval Training</span></td>
      <td class=\"Venerdì\" headers=\"b5 pomeriggio_b\"><span lang=\"en\">Total Body</span></td>
      <td class=\"Sabato\" headers=\"b6 pomeriggio_b\">chiuso</td>
      <td class=\"Domenica\" headers=\"b7 pomeriggio_b\">chiuso</td>

    </tr>
    <tr>
         <th id=\"sera_b\" headers=\"a0\"><span>Sera</span><span>19:00-20:00</span></th>
        <td class=\"Lunedì\" headers=\"b1 sera_b\"><span lang=\"en\">Spinning</span></td>
         <td class=\"Martedì\" headers=\"b2 sera_b\"><span lang=\"en\">Total Body</span></td>
         <td class=\"Mercoledì\" headers=\"b3 sera_b\"><span lang=\"en\">Spinning</span></td>
         <td class=\"Giovedì\" headers=\"b4 sera_b\"><span lang=\"en\">Total Body</span></td>
         <td class=\"Venerdì\" headers=\"b5 sera_b\"><span lang=\"en\">Spinning</span></td>
         <td class=\"Sabato\" headers=\"b6 sera_b\">chiuso</td>
         <td class=\"Domenica\" headers=\"b7 sera_b\">chiuso</td>
    </tr>
    </tbody>
    </table>
    </div>
    <div class=\"tipo_area\"><!--<h2>Sala <span lang=\"en\">Cross Fitness</span></h2>
    <p>Attrezzatura all'avanguardia e ambienti che si conformano con le esigenze di ognuna di queste discipline. Il tutto per ottenere sempre la migliore prestazione in ogni momento e migliorare in modo piacevole e costante.</p> -->
    <table id=\"crossfit\" summary=\"\">

    <caption>Orario <span lang=\"en\">Cross Fitness</span></caption>
    <thead>
      <tr>
                <th id=\"c0\" scope=\"col\">Fasce Orarie </th>
        <th id=\"c1\" abbr=\"Lun\" scope=\"col\">Lunedì</th>
        <th id=\"c2\" abbr=\"Mar\" scope=\"col\">Martedì</th>
        <th id=\"c3\" abbr=\"Mer\" scope=\"col\">Mercoledì</th>
        <th id=\"c4\" abbr=\"Gio\" scope=\"col\">Giovedì</th>
        <th id=\"c5\" abbr=\"Ven\" scope=\"col\">Venerdì</th>
        <th id=\"c6\" abbr=\"Sab\" scope=\"col\">Sabato</th>
        <th id=\"c7\" abbr=\"Dom\" scope=\"col\">Domenica</th>
      </tr>
    </thead>
        <tfoot>
            <tr>
                <th headers=\"b0\" scope=\"col\">Fasce Orarie </th>
        <th headers=\"b1\" abbr=\"Lun\" scope=\"col\">Lunedì</th>
        <th headers=\"b2\" abbr=\"Mar\" scope=\"col\">Martedì</th>
        <th headers=\"b3\" abbr=\"Mer\" scope=\"col\">Mercoledì</th>
        <th headers=\"b4\" abbr=\"Gio\" scope=\"col\">Giovedì</th>
        <th headers=\"b5\" abbr=\"Ven\" scope=\"col\">Venerdì</th>
        <th headers=\"b6\" abbr=\"Sab\" scope=\"col\">Sabato</th>
        <th headers=\"b7\" abbr=\"Dom\" scope=\"col\">Domenica</th>
            </tr>


    </tfoot>
    <tbody>
    <tr>
        <th id=\"pranzo_c\" headers=\"a0\"><span>Pausa Pranzo</span><span>12:00-13:00</span></th>
        <td class=\"Lunedì\" headers=\"c1 pranzo_c\"><span lang=\"en\">Body Pump</span></td>
             <td class=\"Martedì\" headers=\"c2 pranzo_c\"><span lang=\"en\">Body Step</span></td>
        <td class=\"Mercoledì\" headers=\"c3 pranzo_c\"><span lang=\"en\">Body Pump</span></td>
         <td class=\"Giovedì\" headers=\"c4 pranzo_c\"><span lang=\"en\">Body Step</span></td>
        <td class=\"Venerdì\" headers=\"c5 pranzo_c\"><span lang=\"en\">Body Pump</span></td>
         <td class=\"Sabato\" headers=\"c6 pranzo_c\"><span lang=\"en\">Body Pump</span></td>
         <td class=\"Domenica\" headers=\"c7 pranzo_c\"></td>
    </tr>
    <tr>
        <th id=\"pomeriggio_c\" headers=\"a0\"><span>Pomeriggio</span><span>16:00-17:00</span></th>
        <td class=\"Lunedì\" headers=\"c1 pomeriggio_c\"><span lang=\"en\">Body Combat</span></td>
        <td class=\"Martedì\" headers=\"c2 pomeriggio_c\"><span lang=\"en\">Body Pump</span></td>
        <td class=\"Mercoledì\" headers=\"c3 pomeriggio_c\"><span lang=\"en\">Body Combat</span></td>
        <td class=\"Giovedì\" headers=\"c4 pomeriggio_c\"><span lang=\"en\">Body Pump</span></td>
        <td class=\"Venerdì\" headers=\"c5 pomeriggio_c\"><span lang=\"en\">Body Combat</span></td>
        <td class=\"Sabato\" headers=\"c6 pomeriggio_c\">chiuso</td>
        <td class=\"Domenica\" headers=\"c7 pomeriggio_c\">chiuso</td>

    </tr>
    <tr>
        <th id=\"sera_c\" headers=\"a0\"><span>Sera</span><span>19:00-20:00</span></th>
        <td class=\"Lunedì\" headers=\"c1 sera_c\"><span lang=\"en\">Cross Training</span></td>
        <td class=\"Martedì\" headers=\"c2 sera_c\"><span lang=\"en\">Body Combat</span></td>
        <td class=\"Mercoledì\" headers=\"c3 sera_c\"><span lang=\"en\">Cross Training</span></td>
        <td class=\"Giovedì\" headers=\"c4 sera_c\"><span lang=\"en\">Body Combat</span></td>
        <td class=\"Venerdì\" headers=\"c5 sera_c\"><span lang=\"en\">Cross Training</span></td>
        <td class=\"Sabato\" headers=\"c6 sera_c\">chiuso</td>
        <td class=\"Domenica\" headers=\"c7 sera_c\">chiuso</td>
    </tr>
    </tbody>
    </table>
    </div>

    </div>

  ";
}

#----------------- CODIFICA STRINGHE ------------------
#FUNZIONE PER LA CONVERSIONE DELLE STRINGHE IN UTF-8 PER STRINGA PRELEVATA DA XML
sub enc{
    return Encode::encode('UTF-8', $_[0]);
}

#--------------- STAMPA DELLA PAGINA STAFF --------------------
sub stampaStaff{
print"
<div id=\"content\">
       <h1 id=\"TitoloStaff\"> Il nostro <span xml:lang=\"en\">staff</span> </h1>

        <div class=\"sez\">  <!-- class sez -->
        <h2> <span xml:lang=\"en\">Soft Fitness</span></h2>
    <dl class=\"contenitorePT\">
            <dt class=\"nomePT\"> Vanessa </dt>
       <dd class=\"PTcont\">
                <p>
                    <img class=\"PT\" src=\"../images/vanessa.png\" alt=\"Foto di Vanessa\" />
                    Sono un&rsquo;insegnante qualificata di Pilates e <span xml:lang=\"en\">Body balance</span> da 10 anni; dopo aver conseguito la laurea in scienze motorie mi sono dedicata a questa disciplina. Con me imparerai le tecniche base ed avanzate in modo da ricevere, nel minor tempo possibile, tutti i benefici.
                </p>
                <p class=\"contattiPT\">CONTATTI :</p>

                 <p class=\"contTel\">
                     3476471331
                 </p>
                 <p class=\"contEmail\">
                     vanessa\@gym.com
                 </p>

            </dd>

             <dt class=\"nomePT\"> Sara </dt>
  <dd class=\"PTcont\">

                <p>
                    <img class=\"PT\" src=\"../images/sara1.png\" alt=\"Foto di Sara che esegue esercizio\" />
                    Fin dalla tenera et&agrave; sono stata un&rsquo;appassionata di yoga fino a farne la mia professione. La mia passione mi ha spinta a visitare tutto l&rsquo;oriente con lo scopo di apprendere le tecniche tradizionali di questa disciplina. Ho conseguito diverse certificazioni ed abilitazioni che fanno di me la migliore scelta per l&rsquo;apprendimento di questa antica arte.
                </p>
                <p class=\"contattiPT\">CONTATTI :</p>

                 <p class=\"contTel\">
                     3466445331
                 </p>
                 <p class=\"contEmail\">
                     sara\@gym.com
                 </p>
            </dd>
        </dl>
                                                             <!-- Attività aerobica -->
         </div>
        <div class=\"sez\">
        <h2> <span xml:lang=\"en\">Cardio Fitness</span> </h2>
        <dl class=\"contenitorePT\">
            <dt class=\"nomePT\"> Federico </dt>
            <dd class=\"PTcont\">
                <img class=\"PT\" src=\"../images/federico.png\" alt=\"Foto di Federico\" />
                <p>
                    Sono Federico, mi occupo di <span xml:lang=\"en\"> fitness </span> da 15 anni. Lavoro come <span xml:lang=\"en\"> personal trainer </span> e <span xml:lang=\"en\"> fitness manager </span>, scrivo articoli di settore per importanti riviste e giornali nazionali, curo le <span xml:lang=\"en\"> newsletter </span> di importati aziende del settore <span xml:lang=\"en\"> fitness </span>/<span xml:lang=\"en\"> wellness </span> e mi occupo di formazione per gli istruttori e <span xml:lang=\"en\"> personal trainer</span>.
                </p>
                <p class=\"contattiPT\">CONTATTI :</p>

                <p class=\"contTel\">
                     3476071451
                 </p>
                 <p class=\"contEmail\">
                     federico\@gym.com
                 </p>
            </dd>

             <dt class=\"nomePT\"> Francesco </dt>
            <dd class=\"PTcont\">
                <img class=\"PT\" src=\"../images/francesco.png\" alt=\"francesco in posa\" />
                <p>
                    Da sempre amante dell&rsquo;attivit&agrave; sportiva, ho praticato tanti sport come il <span xml:lang=\"en\"> triathlon </span>, ciclismo, arti marziali e <span xml:lang=\"en\"> boxe </span>oltre che sport di squadra e ovviamente la pesistica, una delle mie pi&ugrave; grandi passioni.Ho vinto anche una serie di titoli molto importanti tra i quali: primo posto al <span xml:lang=\"en\">\"Musclemania World\"</span> di <span xml:lang=\"en\">Manhattan Beach(Los Angeles)</span> nel novembre 2002.
            </p>
            <p class=\"contattiPT\">CONTATTI :</p>

                <p class=\"contTel\">
                     3471231331
                 </p>
                 <p class=\"contEmail\">
                     francesco\@gym.com
                 </p>
            </dd>
            </dl>
       </div>
                                                  <!-- Streight training -->
      <div class=\"sez\">                                        <!-- Streight training -->
      <h2> <span xml:lang=\"en\">Cross Fitness</span> </h2>
  <dl class=\"contenitorePT\">
            <dt class=\"nomePT\"> Matteo </dt>
   <dd class=\"PTcont\">
                <img class=\"PT\" src=\"../images/matteo.png\" alt=\"Foto di Matteo\" />
        <p>
                    Sono Matteo, campione nazionale assoluto di <span xml:lang=\"en\"> body fitness </span>, molte sono le persone che grazie ai miei consigli hanno raggiunto la forma fisica desiderata. Se volete aumentare la vostra massa muscolare e migliorare le vostre <span xml:lang=\"en\"> performance </span> per il vostro sport preferito io sono la persona giusta.
                </p>
                <p class=\"contattiPT\">CONTATTI :</p>

                <p class=\"contTel\">
                     3123451331
                </p>
                <p class=\"contEmail\">
                     matteo\@gym.com
                </p>
            </dd>

             <dt class=\"nomePT\"> Simone </dt>
   <dd class=\"PTcont\">
                <img class=\"PT\" src=\"../images/simone.png\" alt=\"Foto di Simone\" />
        <p>
                    Sono un <span xml:lang=\"en\"> personal trainer </span> Certificato. In passato ho praticato vari sport tra i quali calcio, pallavolo<span xml:lang=\"en\"> beach volley </span> e pesistica. Ho quindi deciso di conseguire la certificazione CFT 1 dell&rsquo;ISSA (<span xml:lang=\"en\"> International Sport Science Association </span>) cosi da poter intrapprendere con seriet&agrave; questa carriera.
                </p>
                <p class=\"contattiPT\">CONTATTI :</p>

                <p class=\"contTel\">
                     3496412391
                </p>
                <p class=\"contEmail\">
                     simone\@gym.com
                </p>
            </dd>

             <dt class=\"nomePT\"> Leonardo </dt>

   <dd class=\"PTcont\">
                <img class=\"PT\" src=\"../images/leonardo.png\" alt=\"Foto di Leonardo\" />
        <p>
                    Ho conseguito un <span xml:lang=\"en\"> Master </span> in <span xml:lang=\"en\"> Wellness Management </span> presso l&rsquo;ALMA <span xml:lang=\"en\"> Graduate School </span> di Bologna in collaborazione con  <span xml:lang=\"en\"> Virgin Active </span> e <span xml:lang=\"en\"> Technogym </span>. Amo aiutare la persone a raggiungere obiettivi di forma fisica che sembravano all&rsquo;inizio impossibili.
                </p>
             <p class=\"contattiPT\"> CONTATTI :</p>

                <p class=\"contTel\">
                     3206479876
                 </p>
                 <p class=\"contEmail\">
                     leonardo\@gym.com
                 </p>
            </dd>
        </dl>

           </div>

 </div> <!-- fine descrizione personal trainers --> ";
}


1;
