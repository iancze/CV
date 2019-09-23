#!/bin/sh
# var=mypubs # The processed library
# var2=mylibrary # The raw library downloaded from ADS

# clear old intermediate files
rm *.aux
rm *.bbl
rm *.blg
rm *.log

# fix Latex errors
sed -i -re 's/(\{\\prime\})/\$\^\\prime\$/g' first_papers.bib
sed -i -re 's/(\{\\prime\})/\$\^\\prime\$/g' all_papers.bib
sed -i -re 's/(\{\\prime\})/\$\^\\prime\$/g' preprint_papers.bib
sed -i -re 's/(\{\\ap\})/\$\\approx\$/g' first_papers.bib
sed -i -re 's/(\{\\ap\})/\$\\approx\$/g' all_papers.bib
sed -i -re 's/(\{\\ap\})/\$\\approx\$/g' preprint_papers.bib

pdflatex main.tex
bibtex first
bibtex all
bibtex preprint

# Leave all the formatting alone for now
# Remove line breaks so that sed can always find my name
sed -i -re '/\{Czekala\},$/{N;s/\n//;}' first.bbl
sed -i -re '/\{Czekala\},$/{N;s/\n//;}' all.bbl
sed -i -re '/\{Czekala\},$/{N;s/\n//;}' preprint.bbl

# Always use my full name
# make my name bold
sed -i -re 's/(\{Czekala\},[ ]{1,}I.)/\{Czekala\}, Ian/g' first.bbl
sed -i -re 's/(\{Czekala\},[ ]{1,}I.;)/\{Czekala\}, Ian;/g' first.bbl
sed -i -re 's/(\{Czekala\},[ ]{1,}Ian)/\\textbf\{\1\}/g' first.bbl
sed -i -re 's/(\{Czekala\},[ ]{1,}Ian;)/\\textbf\{\1\}/g' first.bbl

sed -i -re 's/(\{Czekala\},[ ]{1,}I.)/\{Czekala\}, Ian/g' all.bbl
sed -i -re 's/(\{Czekala\},[ ]{1,}I.;)/\{Czekala\}, Ian;/g' all.bbl
sed -i -re 's/(\{Czekala\},[ ]{1,}Ian)/\\textbf\{\1\}/g' all.bbl
sed -i -re 's/(\{Czekala\},[ ]{1,}Ian;)/\\textbf\{\1\}/g' all.bbl

sed -i -re 's/(\{Czekala\},[ ]{1,}I.)/\{Czekala\}, Ian/g' preprint.bbl
sed -i -re 's/(\{Czekala\},[ ]{1,}I.;)/\{Czekala\}, Ian;/g' preprint.bbl
sed -i -re 's/(\{Czekala\},[ ]{1,}Ian)/\\textbf\{\1\}/g' preprint.bbl
sed -i -re 's/(\{Czekala\},[ ]{1,}Ian;)/\\textbf\{\1\}/g' preprint.bbl

pdflatex main.tex
pdflatex main.tex

# clear intermediate files again
rm *.aux
rm *.bbl
rm *.blg
rm *.brf 
rm *.fdb_latexmk
rm *.fls
rm *.log
rm *.out
