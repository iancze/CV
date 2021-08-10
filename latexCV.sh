#!/bin/sh

# produces three files 
# full : the complete CV + publications in one file 
# cv-only : only the CV 
# pub-only : only the publications

# clear old intermediate files
rm *.aux
rm *.bbl
rm *.blg
rm *.brf 
rm *.fdb_latexmk
rm *.fls
rm *.log
rm *.out

# make the cv-only document first, since it doesn't require bibtex 
pdflatex cv-only.tex 

# download the following ADS libraries
# CV: IPC First/Selected -> first.bib
# CV: IPC refereed non-first -> all.bib
# CV: Preprints -> preprint.bib

# fix Latex errors
gsed -i -re 's/(\{\\prime\})/\$\^\\prime\$/g' first_papers.bib
gsed -i -re 's/(\{\\prime\})/\$\^\\prime\$/g' all_papers.bib
gsed -i -re 's/(\{\\prime\})/\$\^\\prime\$/g' preprint_papers.bib
gsed -i -re 's/(\{\\ap\})/\$\\approx\$/g' first_papers.bib
gsed -i -re 's/(\{\\ap\})/\$\\approx\$/g' all_papers.bib
gsed -i -re 's/(\{\\ap\})/\$\\approx\$/g' preprint_papers.bib

pdflatex full.tex
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

pdflatex full.tex
pdflatex full.tex

pdflatex pub-only.tex 
pdflatex pub-only.tex

# version for website
cp full.pdf Czekala_Ian_CV.pdf
