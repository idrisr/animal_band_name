#! /bin/sh

wget ftp://ftp.musicbrainz.org/pub/musicbrainz/data/fullexport/20110126-000001/mbdump.tar.bz2
tar xvjf mbdump.tar.bz2
cut -f2 -d"     " mbdump/artist | tr '[:upper:]' '[:lower:]' > artist_names
curl http://download.freebase.com/datadumps/2011-01-20/browse/biology/animal.tsv | awk -F'\t' '{print $1}' | tr '[:upper:]' '[:lower:]' > animal_names

rm -f test_animals_names
rm -f animals_names
LC_ALL='C'
exec< animal_names
while read -r sing
do
    plural=`wget -qO- http://english-utilities.freebaseapps.com/pluralize?text="$sing"`
    if [ "$sing" = "$plural" ]
    then
    plural=""
    fi
    s_count=`grep -ow "$sing" artist_names | wc -l`
    p_count=`grep -ow "$plural" artist_names | wc -l`
    sum=$(($s_count + $p_count))
    printf "%i %s:%i %s:%i\n" "$sum" "$sing" $s_count "$plural" $p_count
done >> animals_names 

sort -nrk1,1 animals_names | head -n20



