#! /bin/sh
# Author: Idris Raja
# Email : idris.raja@gmail.com
# Reply to Quora question http://www.quora.com/Which-animal-has-been-used-most-frequently-for-a-band-name
# Which animal has been used most frequently for a band name?
# Much thanks to Erik Frey for his ingenious approach from which I borrowed heavily

# You may need to update the date part of this link 
wget ftp://ftp.musicbrainz.org/pub/musicbrainz/data/fullexport/20110126-000001/mbdump.tar.bz2
tar xvjf mbdump.tar.bz2
awk -F'\t' '{print $2}' mbdump/artist | tr '[:upper:]' '[:lower:]' > artist_names

#  You may also need to update the date part of this link
curl -s http://download.freebase.com/datadumps/2011-01-20/browse/biology/animal.tsv | awk -F'\t' '{print $1}' | tr '[:upper:]' '[:lower:]' > animal_names

LC_ALL='C'
exec< animal_names
while read -r sing
do
    #link uses algorithm to generate plural forms of nouns based on work by Damian Conway
    plural=`wget -qO- http://english-utilities.freebaseapps.com/pluralize?text="$sing"`

    #avoids double count when singular is same as plural
    if [ "$sing" = "$plural" ]
    then
    plural=""
    fi

    s_count=`grep -ow "$sing" artist_names | wc -l`
    p_count=`grep -ow "$plural" artist_names | wc -l`
    sum=$(($s_count + $p_count))
    printf "%i %s:%i %s:%i\n" "$sum" "$sing" $s_count "$plural" $p_count
done >> totals 

sort -nrk1,1 totals | head -n20
