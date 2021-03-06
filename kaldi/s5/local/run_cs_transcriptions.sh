#!/bin/bash

source conf/train_conf.sh

locdata=$1; shift
locdict=$1; shift


echo "The results are stored in $locdata/vocab-full.txt"
echo "Should be utf-8 and words in CAPITALS"
echo "CHECK the ENCODING!"; echo

mkdir -p $locdict 

perl local/phonetic_transcription_cs.pl $locdata/vocab-full.txt $locdict/cs_transcription.txt


echo "--- Searching for OOV words ..."
gawk 'NR==FNR{words[$1]; next;} !($1 in words)' \
  $locdict/cs_transcription.txt $locdata/vocab-full.txt |\
  egrep -v '<.?s>' > $locdict/vocab-oov.txt

gawk 'NR==FNR{words[$1]; next;} ($1 in words)' \
  $locdata/vocab-full.txt $locdict/cs_transcription.txt |\
  egrep -v '<.?s>' > $locdict/lexicon-iv.txt

wc -l $locdict/vocab-oov.txt
wc -l $locdict/lexicon-iv.txt
