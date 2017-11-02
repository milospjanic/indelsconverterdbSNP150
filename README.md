# indelsconverterdbSNP150


indelsconverterdbSNP150 is a script to convert a list of indels in a format: chrN:position:I or chrN:position:D to SNP rsIDs. 

indelsconverterdbSNP150 uses dbSNP150 dataset from UCSC table browser that contains both common and rare variants.

**Usage**

This script will check if the working folder ~/indelsconverterdbSNP150 is present and if not it will create ~/indelsconverterdbSNP150. Next, script will go into ~/indelsconverterdbSNP150 and check if dbSNP bed file (downloaded from UCSC Table browser, including both common and rare variants) for human genome hg19 is present or not, version 150, and in case it is not present it will download it using mySQL.


**Note - Script indelsconverterdbSNP150.sh can be placed anywhere as well as the input file, however output will be in ~/indelsconverterdbSNP150**

Your input file should be formatted as:

<pre>
chr1	201870786	rs187687095	A	G	-0.361906
chr1	201871082	chr1:201871082:D	D	I	-4.14718
chr1	201871092	chr1:201871092:D	D	I	-3.96472
chr1	201871225	rs72742100	A	G	1.20373
chr1	201871572	chr1:201871572:I	I	D	-3.8248
chr1	201871601	rs2013046	A	G	0.944278
chr1	201871833	rs4025034	C	A	1.33303
chr1	201872209	rs2820314	C	A	-4.02326
chr1	201872264	rs2820315	T	C	-4.52362

</pre>

dbSNP download will produce a file:

<pre>
mpjanic@valkyr:~/indelsconverterdbSNP150$ head snp150Common.bed
chr1	10177	10177	rs367896724
chr1	10352	10352	rs555500075
chr1	11007	11008	rs575272151
chr1	11011	11012	rs544419019
chr1	13109	13110	rs540538026
chr1	13115	13116	rs62635286
chr1	13117	13118	rs62028691
chr1	13272	13273	rs531730856
chr1	13417	13417	rs777038595
chr1	14463	14464	rs546169444

mmpjanic@valkyr:~/indelsconverterdbSNP150$ wc -l snp150Common.bed
14810671 snp150Common.bed
</pre>


**indelsconverterdbSNP150 will check if dbSNP file exists and if it is parsed into categories, and if not it will download it from mySQL and parse the file into insertion (same base pair coordinates), SNPs plus simple deletions (single base pair coordinates), and large deletions (more than 1 base pair difference in the coordinates), that will be proccessed with a separate code and at the end merged into a single output.**

<pre>
-rw-rw-r-- 1 mpjanic mpjanic 494M Nov  2 13:52 snp150Common.bed
-rw-rw-r-- 1 mpjanic mpjanic  24M Nov  2 13:52 snp150Common.bed.insertions
-rw-rw-r-- 1 mpjanic mpjanic 454M Nov  2 13:52 snp150Common.bed.snp.plus.simple.deletions
-rw-rw-r-- 1 mpjanic mpjanic  16M Nov  2 13:52 snp150Common.bed.large.deletions

mpjanic@valkyr:~/indelsconverterdbSNP150$ head snp150Common.bed.insertions
chr1	10177	10177	rs367896724
chr1	10352	10352	rs555500075
chr1	13417	13417	rs777038595
chr1	15903	15903	rs557514207
chr1	54712	54712	rs568927205
chr1	91551	91551	rs375085441
chr1	249275	249275	rs200079338
chr1	255923	255923	rs199745078
chr1	363244	363244	rs572571697
chr1	604229	604229	rs556776674
mpjanic@valkyr:~/indelsconverterdbSNP150$ head snp150Common.bed.snp.plus.simple.deletions
chr1	11007	11008	rs575272151
chr1	11011	11012	rs544419019
chr1	13109	13110	rs540538026
chr1	13115	13116	rs62635286
chr1	13117	13118	rs62028691
chr1	13272	13273	rs531730856
chr1	14463	14464	rs546169444
chr1	14603	14604	rs541940975
chr1	14672	14673	rs4690
chr1	14676	14677	rs201327123
mpjanic@valkyr:~/indelsconverterdbSNP150$ head snp150Common.bed.large.deletions
chr1	17358	17361	rs749387668
chr1	63735	63738	rs201888535
chr1	66435	66437	rs560481224
chr1	82133	82135	rs550749506
chr1	129010	129013	rs377161483
chr1	267227	267230	rs374780253
chr1	532325	532327	rs577455319
chr1	612688	612691	rs201365517
chr1	691567	691571	rs566250387
chr1	701779	701783	rs201234755

</pre>


Output file will be placed in ~/indelsconverterdbSNP150

**Running**

To run the script type:
<pre>
chmod 775 indelsconverterdbSNP150.sh 
./indelsconverterdbSNP150.sh path/to/file
</pre>

**Prerequisites**

MySQL

**Example**

<pre> 
head test
chr1	201870786	rs187687095	A	G	-0.361906
chr1	201871082	chr1:201871082:D	D	I	-4.14718
chr1	201871092	chr1:201871092:D	D	I	-3.96472
chr1	201871225	rs72742100	A	G	1.20373
chr1	201871572	chr1:201871572:I	I	D	-3.8248
chr1	201871601	rs2013046	A	G	0.944278
chr1	201871833	rs4025034	C	A	1.33303
chr1	201872209	rs2820314	C	A	-4.02326
chr1	201872264	rs2820315	T	C	-4.52362

./indelsconverterdbSNP150.sh test

head test.rsID
				
chr1	201871572	rs5780094	I	D
</pre>
