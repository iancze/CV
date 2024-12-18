# Dr. Ian Czekala Curriculum Vitae 

**You can find a [PDF of my CV](https://iancze.github.io/Czekala_CV.pdf) on my [research website](https://iancze.github.io/)**

This repository contains the source code for building the CV.

Publication lists are directly sourced from two ADS libraries:
* [All refereed papers](https://ui.adsabs.harvard.edu/user/libraries/G0Ow9TGTRyuVT7hbhzailA) 
* [Preprints and unrefereed papers](https://ui.adsabs.harvard.edu/user/libraries/7EG2_mB3Qaq6bVkrUnsvBQ)

To update CV:

* go to ADS and add any new publications to the above ADS libraries
* install requirements with `pip install -r requirements.txt`
* make sure ADS token and library ids are available in `credentials.toml` 
* run `snakemake -c 1 all`
* output will be in `build/`
* if you need to update the local copy of the library, run `snakemake -c 1 -R dl_json_all`

Credit to https://github.com/dfm/cv for some aspects of the build process.