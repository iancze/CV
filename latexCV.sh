#!/bin/sh
# var=mypubs # The procesgsed library
# var2=mylibrary # The raw library downloaded from ADS

# clear old intermediate files
rm *.aux
rm *.bbl
rm *.blg
rm *.brf 
rm *.fdb_latexmk
rm *.fls
rm *.log
rm *.out

# fix Latex errors
gsed -i -re 's/(\{\\prime\})/\$\^\\prime\$/g' first_papers.bib
gsed -i -re 's/(\{\\prime\})/\$\^\\prime\$/g' all_papers.bib
gsed -i -re 's/(\{\\prime\})/\$\^\\prime\$/g' preprint_papers.bib
gsed -i -re 's/(\{\\ap\})/\$\\approx\$/g' first_papers.bib
gsed -i -re 's/(\{\\ap\})/\$\\approx\$/g' all_papers.bib
gsed -i -re 's/(\{\\ap\})/\$\\approx\$/g' preprint_papers.bib

pdflatex main.tex
bibtex first
bibtex all
bibtex preprint

# Leave all the formatting alone for now
# Remove line breaks so that gsed can always find my name
gsed -i -re '/\{Czekala\},$/{N;s/\n//;}' first.bbl
gsed -i -re '/\{Czekala\},$/{N;s/\n//;}' all.bbl
gsed -i -re '/\{Czekala\},$/{N;s/\n//;}' preprint.bbl

# Always use my full name
# make my name bold
gsed -i -re 's/(\{Czekala\},[ ]{1,}I.)/\{Czekala\}, Ian/g' first.bbl
gsed -i -re 's/(\{Czekala\},[ ]{1,}I.;)/\{Czekala\}, Ian;/g' first.bbl
gsed -i -re 's/(\{Czekala\},[ ]{1,}Ian)/\\textbf\{\1\}/g' first.bbl
gsed -i -re 's/(\{Czekala\},[ ]{1,}Ian;)/\\textbf\{\1\}/g' first.bbl

gsed -i -re 's/(\{Czekala\},[ ]{1,}I.)/\{Czekala\}, Ian/g' all.bbl
gsed -i -re 's/(\{Czekala\},[ ]{1,}I.;)/\{Czekala\}, Ian;/g' all.bbl
gsed -i -re 's/(\{Czekala\},[ ]{1,}Ian)/\\textbf\{\1\}/g' all.bbl
gsed -i -re 's/(\{Czekala\},[ ]{1,}Ian;)/\\textbf\{\1\}/g' all.bbl

gsed -i -re 's/(\{Czekala\},[ ]{1,}I.)/\{Czekala\}, Ian/g' preprint.bbl
gsed -i -re 's/(\{Czekala\},[ ]{1,}I.;)/\{Czekala\}, Ian;/g' preprint.bbl
gsed -i -re 's/(\{Czekala\},[ ]{1,}Ian)/\\textbf\{\1\}/g' preprint.bbl
gsed -i -re 's/(\{Czekala\},[ ]{1,}Ian;)/\\textbf\{\1\}/g' preprint.bbl

pdflatex main.tex
pdflatex main.tex


# update version on website
cp main.pdf ~/Documents/Professional/iancze.github.io/assets/Ian_CzekalaCV.pdf
