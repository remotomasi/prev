#!/bin/bash
# Remember to insert the appid parameter obtened on openweathermap.org
appid=
clear
echo "Insert weather location >>"
read paese
clear
wget -O w1.xml "http://api.openweathermap.org/data/2.5/forecast?q=$paese&mode=xml&appid=$appid" 2>/dev/null
wget -O w2.xml "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22$paese%22)&format=xml&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys" 2>/dev/null

pr1=`cat w1.xml | grep precipitation | head -1 | cut -d'"' -f2`
dir1=`cat w1.xml | tr '<' '\n' | grep windDirection | head -1 | cut -d'"' -f4`
s1=`cat w1.xml | tr '<' '\n' | grep windSpeed | head -1 | cut -d'"' -f2`
s1=$s1/1.609
t11=`cat w1.xml | grep temperature | head -1 | cut -d'"' -f6`
t12=`cat w1.xml | grep temperature | head -1 | cut -d'"' -f8`
p1=`cat w1.xml | tr '<' '\n' | grep pressure | head -1 | cut -d'"' -f4`
# p1=$p1-10
h1=`cat w1.xml | tr '<' '\n' | grep humidity | head -1 | cut -d'"' -f2`
c1=`cat w1.xml | tr '<' '\n' | grep "clouds value" | head -1 | cut -d'"' -f4`

# echo -e `echo "scale=2; $pr1" | bc -l` 'mm'
# echo -e $dir1 '\t' `echo "scale=2; $s1" | bc -l` 'kph'
# echo -e $t11 "°C" '\t' $t12 "°C"
# echo -e `echo $p1 | bc -l` "hPa"
# echo -e $h1 "%"
# echo -e $c1 "%"
# echo "--------------"

#pr2=`cat w2.xml | grep precipitation | head -1 | cut -d'"' -f2`
deg=`cat w2.xml | grep wind | head -1 | cut -d'"' -f6`

if ([ $(echo "$deg > 337.5" | bc -l) = "1" ] || [ $(echo "$deg <= 22.5" | bc -l) = "1" ]); then dir2="N"; fi
if ([ $(echo "$deg > 22.5" | bc -l) = "1" ] && [ $(echo "$deg <= 67.5" | bc -l) = "1" ]); then dir2="NE"; fi
if ([ $(echo "$deg > 67.5" | bc -l) = "1" ] && [ $(echo "$deg <= 112.5" | bc -l) = "1" ]); then dir2="E"; fi
if ([ $(echo "$deg > 112.5" | bc -l) = "1" ] && [ $(echo "$deg <= 157.5" | bc -l) = "1" ]); then dir2="SE"; fi
if ([ $(echo "$deg > 157.5" | bc -l) = "1" ] && [ $(echo "$deg <= 202.5" | bc -l) = "1" ]); then dir2="S"; fi
if ([ $(echo "$deg > 202.5" | bc -l) = "1" ] && [ $(echo "$deg <= 247.5" | bc -l) = "1" ]); then dir2="SW"; fi
if ([ $(echo "$deg > 247.5" | bc -l) = "1" ] && [ $(echo "$deg <= 292.5" | bc -l) = "1" ]); then dir2="W"; fi
if ([ $(echo "$deg > 292.5" | bc -l) = "1" ] && [ $(echo "$deg <= 337.5" | bc -l) = "1" ]); then dir2="NW"; fi

s2=`cat w2.xml | grep speed | tail -1 | cut -d'"' -f8`
s2=$s2/1.609
t21=`cat w2.xml | grep Low | head -1 | cut -d':' -f3 | cut -d'<' -f1`
t22=`cat w2.xml | grep High | head -1 | cut -d':' -f2 | cut -d'L' -f1`
t21=($t21-32)/1.8
t22=($t22-32)/1.8
p2=`cat w2.xml | grep atmosphere | head -1 | cut -d'"' -f6`
h2=`cat w2.xml | grep atmosphere | head -1 | cut -d'"' -f4`
c2=`cat w2.xml | grep BR | head -1 | cut -d',' -f1`
# echo -e `echo "scale=2; $pr1" | bc -l` 'mm'

# echo -e $dir2 # '\t' `echo "scale=2; $s" | bc -l` 'kph'
# echo -e `echo "scale=2; $t21" | bc -l` "°C" '\t' `echo "scale=2; $t22" | bc -l` "°C"
p2=$p2*33.8
# echo -e `echo $p2 | bc -l` "hPa"
# echo -e $h2 "%"
# echo -e $c2

echo "-------------------------------------"
echo "Situazione meteo attuale: $paese"
echo "-------------------------------------"

echo -e "Precipitazioni: " '\t\t' $pr1 "mm"
echo -e "Vento: " '\t\t\t' $dir1 "/" $dir2 "--" `echo "scale=2; ($s1+$s2)/2" | bc -l` "kph"
echo -e "Temperature: " '\t\t\t'  `echo "scale=2; ($t11+$t21)/2" | bc -l` "°C" "/" `echo "scale=2; ($t22+$t22)/2" | bc -l` "°C"
echo -e "Pressione: " '\t\t\t' `echo "scale=2; ($p1+$p2)/2" | bc -l` "hPa"
echo -e "Umidita': " '\t\t\t' `echo "scale=2; ($h1+$h2)/2" | bc -l` "%"
echo -e "Copertura nuvolosa/fenomeni: " '\t' $c1 "%" "/" $c2
echo
