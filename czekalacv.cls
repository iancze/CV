\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{czekalacv}[2020/08/24 Czekala CV class]

\RequirePackage[letterpaper,tmargin=0.7in,bmargin=0.7in,lmargin=0.7in,rmargin=0.7in,headheight=0in,headsep=0in,footskip=.3in]{geometry}
\RequirePackage[T1]{fontenc}
\RequirePackage{url}
\RequirePackage{longtable}
\RequirePackage{lmodern}

\RequirePackage[dvipsnames]{xcolor}
\definecolor{myblue1}{RGB}{22, 63, 130}
\definecolor{mygrey1}{RGB}{145, 145, 145}

\RequirePackage[backref,breaklinks,colorlinks,urlcolor=myblue1,citecolor=myblue1,linkcolor=myblue1]{hyperref}
\RequirePackage{etaremune}
\RequirePackage[thinlines]{easytable}
\RequirePackage{aas_macros}
\RequirePackage{multibbl}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[10pt]{article}

\renewcommand{\normalsize}{\fontsize{9}{10}\selectfont}
\setlength{\textwidth}{17.5cm}
\setlength{\textheight}{22cm}
\setcounter{secnumdepth}{0}

% Increase the spacing between rows in the tabular environment
\renewcommand{\arraystretch}{1.05}

\newcommand{\hr}{\rule{\textwidth}{0.2pt}}
\newcommand{\rowskip}{1.2mm}

\makeatletter
\renewcommand{\section}{\@startsection{section}{1}{0pt}{-\baselineskip}{0.5\baselineskip}{\scshape\color{myblue1}}}
\renewcommand{\subsection}{\@startsection{subsection}{2}{0pt}{-\baselineskip}{0.5\baselineskip}{\hspace{12pt}\itshape}}
\makeatother

\pagestyle{empty}
% \geometry{letterpaper,tmargin=0.7in,bmargin=0.7in,lmargin=0.7in,rmargin=0.7in,headheight=0in,headsep=0in,footskip=.3in}

% Change spacing of the itemize and etaremune environments
\setlength{\parindent}{0in}
\setlength{\parskip}{1em}
\setlength{\itemsep}{1em}
\setlength{\topsep}{0in}
\setlength{\tabcolsep}{0in}
