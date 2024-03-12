# Curriculum Vitae

Publication lists are directly sourced from two ADS libraries:
* [All refereed papers](https://ui.adsabs.harvard.edu/user/libraries/G0Ow9TGTRyuVT7hbhzailA) 
* [Preprints and unrefereed papers](https://ui.adsabs.harvard.edu/user/libraries/7EG2_mB3Qaq6bVkrUnsvBQ)

To update CV:

* go to ADS and add any new publications to the above ADS libraries
* install requirements with `pip install -r requirements.txt`
* make sure ADS token and library ids are available in `credentials.toml` 
* run `snakemake -c 1 all`
* output will be in `build/`

Credit to https://github.com/dfm/cv for some aspects of the build process.

## Future development
* change font to something like Helvetica
* automatically update publication summary from ADS stats
* update color scheme