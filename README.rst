Introduction
============

This is a preliminary version of the `Vystadial 2013` acoustic data 
& scripts dataset. This version is not an official release, it serves only 
as a support for the paper submission for `LREC 2014`_.

The abstract of the paper describing the data and related scripts is in the 
file ``paper.pdf``.

The data and scripts are found in directories as follows:

  ``data_voip_cs/{train,dev,test}``
    the Czech data

  ``data_voip_en/{train,dev,test}``
    the English data

  ``htk``
    scripts for HTK

  ``kaldi``
    scripts for Kaldi


.. TODO: Where are the trained models?


Data statistics
===============

Latest statistics for the data are as follows:

    ===========  ==========  ==========  ===========
    **dataset**  **audio**   **#sents**  **#words**
    ===========  ==========  ==========  ===========
    **English**                        
        train      19:52       22,933      103,136  
        dev         1:44        2,000        9,174  
        test        1:43        2,000        8,970  
    **Czech**
        train      10:57       15,319       93,177  
        dev         1:24        2,000       11,854  
        test        1:24        2,000       11,841  
    ===========  ==========  ==========  ===========


Licence for the data
====================

See ``LICENSE-CC-BY-SA-3.0.TXT``.


Licence for the training scripts
================================

See ``LICENSE-APACHE-2.0.TXT``.


Authors
=======

- Matěj Korvas
- Ondřej Plátek
- Ondřej Dušek
- Lukáš Žilka
- Filip Jurčíček


.. `LREC 2014`_: http://lrec2014.lrec-conf.org/en/
