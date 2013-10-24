Building acoustic models using HTK
----------------------------------

In this document, we describe building of acoustic models using the HTK toolkit using the provided scripts.
These acoustic models can be used with the OpenJulius_ ASR decoder.

The scripts are designed to train a different acoustic model for each 
(RCOND, LANG) pair, where RCOND identifies the acoustic conditions for 
audio recording, and LANG the language.  For the original Vystadial 2013 
dataset, RCOND is always "voip" and LANG either "cs" or "en".

For each (RCOND, LANG) pair, there are three general, 
model-settings-specific scripts:

``./env_$RCOND_$LANG.sh``
  sets all training parameters: e.g. the train and test data directories, 
  whether cross-word or word-internal triphones should be trained, language 
  model weights, number of processes to parallelize between etc.
``./train_$RCOND_$LANG.sh``
  the main script; runs scripts for smaller tasks to perform training and 
  evaluation of the models
``./nohup_train_$RCOND_$LANG.sh``
  calls the training script using ``nohup``, redirecting the output into 
  ``.log_$RCOND_$LANG``

The main script saves configuration files, intermediate files, final models 
and their evaluation to the ``model_$RCOND_$LANG`` directory. Important 
files in that directory include:

``model_$RCOND_$LANG/config``
  This directory will contain copies of language- or 
  acoustic-conditions-specific configuration files.
``model_$RCOND_$LANG/log``
  This directory contains logs from HTK tools and scripts run during the 
  training.
``model_$RCOND_$LANG/{train,test}``
  In these directories are MFCC-coded versions of the recordings. The 
  ``train`` directory contains the training data, the ``test`` directory 
  may contain the development or evaluation set, depending on the 
  ``TEST_DATA_SOURCE`` settings in ``env_$RCOND_$LANG.sh``.
``export_models``
  Here are files that define the last acoustic model trained in a format 
  that can be used with the Julius_ decoder.
``hresults_test_*``
  These files contain evaluation reports for every acoustic model trained 
  (the last number in the file name denotes the number of Gaussians per 
  state), when used for decoding the test set with an n-gram model as 
  indicated in the file name.
``recout_test_*``
  These files give the decoded sentences for the test set using an acoustic 
  model-language model combination as indicated by the file name.

Training models for a new language
----------------------------------

Scripts for Czech and English are already written. If you need models for a
new language, you can start by copying all the original scripts and renaming
them so as to reflect the new language in their name (substitute `_en` or
`_cs` with your new language code). You can do this by issuing the following
command (we assume ``$OLDLANG`` is set to either `en` or `cs` and
``$NEWLANG`` to your new language code):

::

  bash htk $ find . -name "*_$OLDLANG*" |
             xargs -n1 bash -c "cp -rvn \$1 \${1/_$OLDLANG/_$NEWLANG}" bash

Having done this, references to the new files' names have to be updated, too:

::

  bash htk $ find . -name "*_$NEWLANG*" -type f -execdir \
             sed --in-place s/_$OLDLANG/_$NEWLANG/g '{}' \;

Furthermore, you need to adjust language-specific resources to the new 
language in the following ways:

  ``htk/model_voip_$NEWLANG/monophones0``
    List all the phones to be recognised, and the special `sil` phone.

  ``htk/model_voip_$NEWLANG/monophones1``
    List all the phones to be recognised, and the special `sil` and 
    `sp` phones.

  ``htk/model_voip_$NEWLANG/tree_ques.hed``
    Specify phonetic questions to be used for building the decision 
    tree for phone clustering (see [HTKBook]_, Section 10.5).

  ``htk/bin/PhoneticTranscriptionCS.pl``
    You can start from this script or use a custom one. The goal is to 
    implement the orthography-to-phonetics mapping to obtain sequences of 
    phones from transcriptions you have.

  ``htk/common/cmudict.0.7a`` and ``htk/common/cmudict.ext``
    This is an alternative approach to the previous point – instead of 
    programming the orthography-to-phonetics mapping, you can list it 
    explicitly in a pronouncing dictionary.

    Depending on the way you want to implement the mapping, you want to set
    ``$OLDLANG`` to either `cs` or `en`.

To make the scripts work with your new files, you will have to update
references to scripts you created. All scripts are stored in the ``htk/bin``,
``htk/common``, and ``htk`` directories as immediate children, so you can make
the substitutions only in these files.

Credits and the licence
-----------------------
The scripts are based on the HTK Wall Street Journal Training Recipe 
written by Keith Vertanen (http://www.keithv.com/software/htk/).
His code is released under the new BSD licence. The licence note is at 
http://www.keithv.com/software/htk/.
As a result, we can re-license the code under the Apache 2.0 license, and 
we do so. The full text of the Apache 2.0 license is available in 
``LICENSE-APACHE-2.0.TXT``.

The results
-----------
- Training data for ``voip_en`` total about 20 hours.
- Training data for ``voip_cs`` total about 8 hours.
- 16 Gaussians per state give slightly better results than 8 Gaussians per 
  state for the ``voip_en`` data.
- There is no significant difference in alignment of transcriptions with 
  ``-t 150`` and ``-t 250``.
- The Julius ASR performance is about the same as of HDecode.
- When cross-word triphones are trained, HDecode works well whereas the
  performance of HVite decreases significantly.
- When word-internal triphones are trained, HDecode works but its 
  performance is worse than HVite's with a bigram LM.
- Word-internal triphones work well with Julius ASR; do not forget disable 
  CCD (it does not need context handling – even though it still uses 
  triphones).
- There is not much gain using the trigram LM in the CamInfo domain (about 
  1%).


.. [HTKBook] The HTK Book, version 3.4
.. _OpenJulius: http://julius.sourceforge.jp/en_index.php
.. _Julius: http://julius.sourceforge.jp/en_index.php
