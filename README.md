# Curriculum Vitae

You can find the latest PDF version of my CV available on my [website](http://www.personal.psu.edu/ipc5094/Czekala_Ian_CV.pdf).

This is the source code for generating my curriculum vitae. Build everything by running 

    $ ./latexCV.sh 

You'll need ``pdflatex`` installed. Appropriately formatting my name in various places relies upon hacking the `.bbl` outputs with `sed`, so unfortunately you can't (yet) use more modern tex implementations like [`tectonic`](https://tectonic-typesetting.github.io/).

`Sed` edits credited to Vanessa Bailey.

The scripts compile three versions of the CV, for various forms of consumption.

* `full.pdf`, or the full CV including appointment information and full publication list
* `cv-only.pdf`, an abbreviated CV with only appointment information
* `pub-only.pdf` a publications list

These are separated out into a header class defining the page layout and separate `full.tex`, `cv-only.tex`, and `pub-only.tex` files which include the appropriate source lists. To update the CV, you should update the source lists contained in `src/`.

## Updating bibliographies

All bibtex files are created using ADS. To update the local copies, download the following ADS libraries

* `CV: IPC First/Selected` -> `first_papers.bib`
* `CV: IPC refereed non-first` -> `all_papers.bib`
* `CV: Preprints` -> `preprint_papers.bib`