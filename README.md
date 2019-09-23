# Curriculum Vitae

You can find the latest PDF version of my CV available on my [website](https://iancze.github.io), [here](https://iancze.github.io/assets/Ian_CzekalaCV.pdf).

This is the source code for generating my curriculum vitae. Build everything by running 

    $ ./latexCV.sh 

You'll need ``pdflatex`` installed. Appropriately formatting my name in various places relies upon hacking the `.bbl` outputs with `sed`, so unfortunately you can't (yet) use more modern tex implementations like [`tectonic`](https://tectonic-typesetting.github.io/).