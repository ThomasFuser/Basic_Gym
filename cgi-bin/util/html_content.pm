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
