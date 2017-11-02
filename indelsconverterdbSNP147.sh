#!/bin/bash

FILE=~/indelsconverterdbSNP150/snp150Common.bed
DIR=~/indelsconverterdbSNP150
SNPS=$(pwd)/$1
echo Proccesing file:
echo $SNPS 

#check if working folder exist, if not, create

if [ ! -d $DIR ]
then
mkdir ~/indelsconverterdbSNP150
fi

cd ~/indelsconverterdbSNP150

#check if dbsnp file exists, if not, download from snp150Common table using mysql

if [ ! -f $FILE ]
then
mysql --user=genome --host=genome-mysql.cse.ucsc.edu -A -N -D hg19 -e 'SELECT chrom, chromStart, chromEnd, name FROM snp150Common' > snp150Common.bed
fi

#parse dbSNPs into insertions, SNPs and simple deletions, large deletions

if [ ! -f snp150Common.bed.insertions ]
then
awk '$2 == $3 {print $0}' snp150Common.bed > snp150Common.bed.insertions
fi

if [ ! -f snp150Common.bed.snp.plus.simple.deletions ]
then
awk '$3 == $2+1 {print $0}' snp150Common.bed > snp150Common.bed.snp.plus.simple.deletions
fi

if [ ! -f snp150Common.bed.large.deletions ]
then
awk '{if ($3 != $2+1 && $2 != $3) print $0}' snp150Common.bed > snp150Common.bed.large.deletions
fi


tabsep $SNPS
grep -v rs $SNPS > $SNPS.indel
cut -f3 $SNPS.indel > $SNPS.indel.col3
sed -E 's/:/\t/g' $SNPS.indel.col3 | cut -f1-2 > $SNPS.indel.col3.short


#find positions of snps from the input list by comparing to snpdb

awk 'NR==FNR {h1[$1] = $1; h2[$2]=$2; h3[$1$2]=$4; h4[$1$2]=1; next} {if(h2[$2]==$2 && h1[$1]==$1 && h4[$1$2]==1) print h3[$1$2]"\t"$0}' snp150Common.bed.insertions $SNPS.indel.col3.short > $1.rsID.nohead.insertions
awk 'NR==FNR {h1[$1] = $1; h2[$2]=$2; h3[$1$2]=$4; h4[$1$2]=1; next} {if(h2[$2]==$2 && h1[$1]==$1 && h4[$1$2]==1) print h3[$1$2]"\t"$0}' snp150Common.bed.snp.plus.simple.deletions $SNPS.indel.col3.short > $1.rsID.nohead.snp.plus.simple.deletions
awk 'NR==FNR {h1[$1] = $1; h2[$2]=$2; h3[$1$2]=$4; h4[$1$2]=1; next} {if(h2[$2]==$2 && h1[$1]==$1 && h4[$1$2]==1) print h3[$1$2]"\t"$0}' snp150Common.bed.large.deletions $SNPS.indel.col3.short > $1.rsID.nohead.large.deletions

awk 'NR==FNR {h1[$1] = $1; h2[$3]=$3; h3[$1$3]=$4; h4[$1$3]=1; next} {if(h2[$2]==$2 && h1[$1]==$1 && h4[$1$2]==1) print h3[$1$2]"\t"$0}' snp150Common.bed.insertions $SNPS.indel.col3.short >> $1.rsID.nohead.insertions
awk 'NR==FNR {h1[$1] = $1; h2[$3]=$3; h3[$1$3]=$4; h4[$1$3]=1; next} {if(h2[$2]==$2 && h1[$1]==$1 && h4[$1$2]==1) print h3[$1$2]"\t"$0}' snp150Common.bed.snp.plus.simple.deletions $SNPS.indel.col3.short >> $1.rsID.nohead.snp.plus.simple.deletions
awk 'NR==FNR {h1[$1] = $1; h2[$3]=$3; h3[$1$3]=$4; h4[$1$3]=1; next} {if(h2[$2]==$2 && h1[$1]==$1 && h4[$1$2]==1) print h3[$1$2]"\t"$0}' snp150Common.bed.large.deletions $SNPS.indel.col3.short >> $1.rsID.nohead.large.deletions

#merge insertions, SNPs and simple deletions, large deletions

cat $1.rsID.nohead.insertions $1.rsID.nohead.snp.plus.simple.deletions $1.rsID.nohead.large.deletions > $1.rsID


rm $1.mod
rm $1.mod2
rm $1.head
