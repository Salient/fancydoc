
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % Humble beginnings of some elaborate document layout and reference
% % system for use in professional environment writing specifications
% % and statements of work, etc.
% %
% % Copyright 2019, James Heller
% % All rights reserved.

%%% This is good stuff
% https://tex.stackexchange.com/questions/416260/define-global-commands-in-aux-file
% https://tex.stackexchange.com/questions/4736/what-is-the-difference-between-fragile-and-robust-commands


%\pdfcompresslevel=0
%\pdfobjcompresslevel=0

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{fancydoc}[2019/01/31 Make Overly Nice Documents]


% Setup conditional logic before processing Options
\RequirePackage{etoolbox}

% New toggles default to false
\newtoggle{hidetoplogo}
\newtoggle{hidebotlogo}
\newtoggle{hideheaderlogo}
\newtoggle{codesnips}
\newtoggle{stark}
\newtoggle{watermark}


% ---------------------------------------------------------------------------------------
% Handle Options

\DeclareOption{specification}{\OptionNotUsed}
\DeclareOption{statement}{\OptionNotUsed}
\DeclareOption{showovers}{\overfullrule=2cm}
\DeclareOption{codesnips}{\toggletrue{codesnips}}
\DeclareOption{notop}{\toggletrue{hidetoplogo}}
\DeclareOption{nobot}{\toggletrue{hidebotlogo}}
\DeclareOption{nohead}{\toggletrue{hideheaderlogo}}
\DeclareOption{mark}{\toggletrue{watermark}}
\DeclareOption{stark}{\toggletrue{stark}}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
% Based on article class mostly
\LoadClass{article}

% ---------------------------------------------------------------------------------------
% Pull in packages we know we need

\RequirePackage[dvipsnames,table]{xcolor}
\RequirePackage[printonlyused]{acronym}
\RequirePackage{multicol}
\RequirePackage{hyperref}
\RequirePackage{xspace}
\RequirePackage{titlesec}
\RequirePackage{tikz}
\usepackage{pgfplots} \pgfplotsset{compat=newest}
\RequirePackage{subfiles}
\RequirePackage{core/fancydoc}

% TODO Fix this here.....V
% \newcommand{\sharedmedia}{C:/Users/1117384/Documents/Work/Utilities/Latex}
%\newcommand{\sharedmedia}{/Users/vanquish/Work/Utilities/Latex}
\newcommand{\sharedmedia}{core}
\newcommand{\listacronyms}{\input{\sharedmedia/Acronyms/acronyms.tex}}
\RequirePackage{multicol} % Required to list acronyms nicely




% ---------------------------------------------------------------------------------------
% Handle conditionals

\iftoggle{codesnips}{
\RequirePackage{minted}
\setminted[vhdl]{fontsize=\scriptsize, linenos}
\renewcommand{\listoflistingscaption}{Logic Code Excerpts}
\newcommand{\codesref}{Code Excerpt }
\renewcommand{\listingscaption}{\ac{CDL} \codesref}
\newcommand{\coderef}[1]{\hyperref[#1]{\codesref \ref*{#1}}}
\newcommand{\codereff}[1]{\hyperref[{#1}]{\codesref \ref*{#1}, page \pageref*{#1}}}
}


\newcommand{\formatting}{\color{black}}
\iftoggle{stark}{
	\renewcommand{\formatting}{\color{red}}
}

\iftoggle{watermark}{
\RequirePackage{draftwatermark}
%\SetWatermarkText{BIO-HAZARD}
%\SetWatermarkScale{4}
%\SetWatermarkAngle{}
%\SetWatermarkColor{}
%\SetWatermarkFontSize{}
%\SetWatermarkScale{}
%\SetWatermarkHorCenter{}
%\SetWatermarkVerCenter{}

\SetWatermarkLightness{0.92} % Higher is lighter
}

% ---------------------------------------------------------------------------------------
% Configure logos for document header

% NOTE - FileExists must have correct file extension

\newlength{\maxlogoheight}
\setlength{\maxlogoheight}{1.75in}
\iftoggle{hidebotlogo}{\setlength{\maxlogoheight}{3.5in}}{}

\newcommand{\@toplogo}{\ClassError{Top logo never defined. You must call {\textbackslash}settoplogo{path/to/logo}, or disable by using option `notoplogo' in class options.}}

\newcommand{\@botlogo}{\ClassError{Bottom logo never defined. You must call {\textbackslash}setbotlogo{path/to/logo}, or disable by using option `nobotlogo' in class options.}}

\newcommand{\@headerlogo}{\ClassError{Header logo never defined. You must call {\textbackslash}setheaderlogo{path/to/logo}, or disable by using option `noheadlogo' in class options.}}

\newcommand{\setheaderlogo}[1]{
	\IfFileExists{#1}{
%	\renewcommand{\@headerlogo}{\includegraphics[width=1.25in,keepaspectratio]{#1}}
% Redefine header rule to include logo at the end
\renewcommand{\headrule}{\hrule\@height\headrulewidth\@width\headwidth\vspace{-0.4cm}
	\raggedleft\includegraphics[height=0.35cm,keepaspectratio]{#1}\hspace*{1px}\vskip-\headrulewidth}
\renewcommand{\@headerlogo}{#1}
    }{\ClassWarning{fancydoc}{Header logo set to #1, but that file does not exist!}}}

\newcommand{\settoplogo}[1]{
	\IfFileExists{#1}{
		\renewcommand{\@toplogo}{\centering\includegraphics[height=\maxlogoheight,width=\linewidth,keepaspectratio]{#1}}}
	                 {\ClassWarning{fancydoc}{Top logo set to #1, but that file does not exist!}}}

\newcommand{\setbotlogo}[1]{
   	\IfFileExists{#1}{\renewcommand{\@botlogo}{\centering\includegraphics[height=\maxlogoheight,width=\linewidth,keepaspectratio]{#1}}}
   	                 {\ClassWarning{fancydoc}{Bottom logo set to #1, but that file does not exist!}}}

\newcommand{\placetoplogo}{\nottoggle{hidetoplogo}{\@toplogo}{}}
\newcommand{\placebotlogo}{\nottoggle{hidebotlogo}{\@botlogo}{}}

\newcommand{\placeheaderlogo}{\@headerlogo
%	\begin{tikzpicture}[overlay]
%	\node[anchor=east, yshift=-0.2cm]  {\@headerlogo};
%	\end{tikzpicture}
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 		Define Marking Options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Should be a better way to set these flags, and the marking definitions, from inside the main document.

% Main file that markings should be defined in. May should be maybe part of core?

% Select the appropriate Marking Template (Must already exist....)
\input{\sharedmedia/Markings/mixed}

% Should set the following
%		Logos (top, bottom)
%		Contract name, number
%		Program Long Name, and nomenclature (Program vs. Effort vs. Team)
%		Specific Marking Statements

% TODO this should vary based on doc type

% Meta data
\newcommand{\released}{\today}
\newcommand{\distribution}{D}
\newcommand{\docnumber}{\color{orange} Uncontrolled Document}
\newcommand{\revision}{-}
\newcommand{\documentstatus}{[\textbf{RELEASE STATUS}],\newline [\textbf{VAULT STATUS}]  }


% Title/Descriptions
\providecommand{\doctype}{\textbf{Document Type [doctype]}\xspace}
\providecommand{\titlelong}{\textbf{ [titlelong] (DOCUMENT SUBJECT)}}

% Special Identifiers
\providecommand{\supplierlong}{\textbf{L3 F}uzing and \textbf{O}rdnance \textbf{S}ystems}
\providecommand{\supplier}{L3-FOS}


\providecommand{\headingcenter}{\textbf{CENTER HEADING [headingcenter]}}
\providecommand{\titleshort}{\textbf{[SHORT TITLE] - [titleshort]}}

\providecommand{\projectdesignation}{\textbf{[projectdesignation] (Program/effort/etc.)}}
\providecommand{\contractname}{\textbf{[Contract Title/Desc.] - [contractname]}}
\providecommand{\contract}{\textbf{[Contract Number] - [contract]}}

% \providecommand{\sharedmedia}{C:/Users/1117384/Documents/Work/Utilities/Latex}



% Use if draft or preview option is enabled
%\usepackage{blindtext}  % Generate test viewing text


\providecommand{\distwarning}{\textbf{\color{red}[Please set the Distribution Warning text.]}}
\providecommand{\itarwarning}{\textbf{\color{red}[Please set the ITAR Warning text.]}}
\providecommand{\raypropwarning}{\textbf{\color{red}[Please set the Proprietary Warning text.]}}
\providecommand{\fouowarning}{\textbf{\color{red}[Please set the FOUO Warning text.]}}
\providecommand{\destructwarning}{\textbf{\color{red}[Please set the Destruction Warning text.]}}
\providecommand{\copywarning}{\textbf{\color{red}[Please set the Copyright Warning text.]}}


%
%% Provide default marking definitions in case they aren't provided or set by the markings file
%\providecommand{\distwarning}{\color{red} Warning! Distribution statement not defined. Create command '\textbf{$\backslash$distwarning}' with desired text. Maybe put it in markings.tex, hmmm?}
%\providecommand{\itarwarning}{\color{red} Warning! Distribution statement not defined. Create command '\textbf{$\backslash$itarwarning}' with desired text. Maybe put it in markings.tex, hmmm?}
%\providecommand{\raypropwarning}{\color{red} Warning! Distribution statement not defined. Create command '\textbf{$\backslash$raypropwarning}' with desired text. Maybe put it in markings.tex, hmmm?}
%\providecommand{\fouowarning}{\color{red} Warning! Distribution statement not defined. Create command '\textbf{$\backslash$fouowarning}' with desired text. Maybe put it in markings.tex, hmmm?}
%\providecommand{\copywarning}{\color{red} Warning! Distribution statement not defined. Create command '\textbf{$\backslash$copywarning}' with desired text. Maybe put it in markings.tex, hmmm?}
%\providecommand{\destructwarning}{\color{red} Warning! Distribution statement not defined. Create command '\textbf{$\backslash$destructwarning}' with desired text. Maybe put it in markings.tex, hmmm?}

%%=================== End Marking Options ==========================================






\newtoggle{markingHazOp}
\newtoggle{markingDistribution}
\newtoggle{markingITAR}
\newtoggle{markingProprietary}
\newtoggle{markingDestroy}
\newtoggle{markingCopyright}
\newtoggle{markingFOUO}
\newtoggle{programWarning}
\newtoggle{markingSafetyCritical}
\newtoggle{customBumper}

% There may be a space required between these?
\togglefalse{markingHazOp}

\toggletrue{markingDistribution}

\toggletrue{markingITAR}

\toggletrue{markingProprietary}

\toggletrue{markingDestroy}

\toggletrue{markingSafetyCritical}

\togglefalse{markingCopyright}

\togglefalse{markingFOUO}

\togglefalse{customBumper}





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 		Section Level Title Styling, Document and TOC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[titles]{tocloft}

% TODO - make this selectable by options

\setcounter{secnumdepth}{5}
\setlength{\headheight}{17pt}



% Define custom colors to show in TOC
\definecolor{sectcolor}{rgb}{0,0,0.2}
\definecolor{secpcolor}{rgb}{0,0,0.2}


% % Table of Contents Entries
% Make Entries in the ToC in Small Caps
\renewcommand{\cftsecfont}{\scshape\sffamily\larger}
\renewcommand{\cftsecaftersnumb}{: \bfseries\sffamily\color{sectcolor}}
%\renewcommand{\cftsecaftersnumb}{\bfseries\hfill}

\renewcommand{\cftsecleader}{\hfill}

% Since we are modifying Section Titles, we have to adjust where the title text starts
% Only matters if left justifying text

\settowidth{\cftsecnumwidth}{Section XX}
%\settowidth{\cftsecnumwidth}{}
\renewcommand{\cftsecpresnum}{\color{secpcolor}\bfseries Section }
%\renewcommand{\cftsecpresnum}{\bfseries Section }



%\renewcommand\cftsubsecfont{\scshape}

% Document Section Title Formatting

\titleformat*{\section}{\Large\bfseries\sffamily\scshape}
\titleformat*{\subsection}{\large\bfseries\sffamily\scshape}
%\titleformat*{\subsubsection}{\bfseries\scshape}
%\titleformat*{\paragraph}{\bfseries\scshape}
%\titleformat*{\subparagraph}{\bfseries\scshape}
% \titleformat{\paragraph}[hang]{\bfseries}{}{0pt}{\uline}



%\setcounter{tocdepth}{4}
%\setcounter{secttocdepth}{4}
%
%\setlength{\stcindent}{24pt}
%\renewcommand{\stcfont}{\small\rm}
%\renewcommand{\stcSSfont}{\small\bf}


%\titleformat{\paragraph}
%{\scshape\bfseries}
%{\theparagraph}
%{0pt}
%{ -- }

%=================== End Section Level Title Styling, Document and TOC ============


%\newlength{\charwidth}
%\setlength{\charwidth}{\widthof{\S}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 		Special Look and Feel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\hypersetup{colorlinks, linktoc=all, linkcolor={blue!20!black}, citecolor={red!50!black}, urlcolor={red!80!black}, pdftitle=\titlelong, pdfauthor=James Heller, pdfsubject=\doctype, pdfkeywords=}

%\setlength{\abovecaptionskip}{0pt}


% Select look and feel of captions
\RequirePackage[textfont={footnotesize,sl},labelfont=footnotesize, labelsep=endash]{caption}


\RequirePackage[left=1.25in,right=1.25in,top=1.25in, bottom=1.25in, marginparsep=7pt]{geometry}

\newcommand{\HRule}{\rule{\linewidth}{0.5mm}}

\newcommand{\raisedrule}[2][0em]{\leavevmode\leaders\hbox{\rule[#1]{1pt}{#2}}\hfill\kern0pt}

\newcommand{\email}[1]{\href{mailto:#1}{\nolinkurl{#1}}}


% Making \cellwidth the width of the tabularx cell we are currently in
\RequirePackage{array}
\newcolumntype{B}{>{\let\newline\\\arraybackslash\hspace{0pt}\arraybackslash\bfseries}r}
\makeatletter
\newcommand{\cellwidth}{\TX@col@width}
\makeatother

% Frequent Keyword aliases
\newcommand{\gsw}{SM-3 BLK IIA G-Switch\xspace}
\newcommand{\eisd}{ESSM EISD\xspace}
\newcommand{\esad}{ESSM BLK II ESAD\xspace}
\newcommand{\lfos}{L-3 FOS\xspace}




% Default to margin notes on left margin
\reversemarginpar

% Footnote grouping / save environments
%\RequirePackage{footnote}
%\makesavenoteenv{tabular}
%\makesavenoteenv{table}
%\RequirePackage{tablefootnote}
\RequirePackage{threeparttable}

\RequirePackage{enumitem}[itemsep = 1cm]
% Adjust indents/margins of lists. Provided by [enumitem]
\newlength\listindent
\setlength\listindent{\parindent}
\setlist[enumerate]{leftmargin=3\listindent, label=\emph{\alph*})}
\setlist[itemize]{leftmargin=3\listindent, rightmargin=\parindent} %, itemsep=0.2cm}
\setlist[description]{leftmargin=3\listindent, labelwidth=0.45in, labelindent=\parindent}

%  leave space around whole list
\setlist{noitemsep} %

%\def\arraystretch{1.5}%  1 is the default, change whatever you need
%\setlength\tabcolsep{0.1cm}



% Spacing around wrapfigs
%\setlength{\intextsep}{4pt}
%\setlength{\columnsep}{0pt}%



%=================== End Special Look and Feel ======================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 		Header and Footer Styling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Requires etoolbox package
\RequirePackage{fancyhdr}
\renewcommand{\headrulewidth}{1pt}

\RequirePackage{pdfpages}
\RequirePackage[title, titletoc,toc,page]{appendix}
%\RequirePackage{lastpage}
\RequirePackage{pageslts}

\newcommand{\topfooterleft}{\textsc{For \textbf{\contractname} \projectdesignation\xspace Only}}
\newcommand{\cornermark}{
	\tikz[remember picture, overlay, anchor=west]\node at (current page.135)
	[xshift=0.65cm, yshift=-2.75cm, rotate=90]{\scriptsize \docnumber, Rev. (\revision)};
%\marginnote{\rotatebox{90}{\raisebox{0.5in}{\qquad\scriptsize\textbf{\docnumber (\revision)}}}}
}

\RequirePackage{rotating}


\fancypagestyle{firststyle} {

	\fancyhead[R]{
%\placeheaderlogo
	}

	%	\fancyhead[L]{{\textsc{\docnumber}}\newline\newline}
	\fancyhead[L]{\cornermark}

	\fancyfoot[L]{
		\scriptsize\topfooterleft\vspace{0.1cm}\hrule\vspace{0.1cm}
		\ifboolexpr{togl{markingITAR}}{\textsc{Export Controlled}}{}
		\ifboolexpr{ togl{markingDistribution} and togl{markingITAR}}{ \textbf{ // } }{}
		\ifboolexpr{togl{markingDistribution}}{\textsc{Distribution} \distribution}{}
	}

	\fancyfoot[C]{
		~\vspace{0.15cm}\\
		\iftoggle{markingProprietary}{\scriptsize\textsc{Raytheon Proprietary}\\[0.2cm]}~
		\iftoggle{markingHazOp}{ \small\color{red}\textbf{PROCEDURE CONTAINS HAZARDOUS OPERATIONS }}
	}

	\fancyfoot[R]{
		\iftoggle{markingSafetyCritical}{\scriptsize\textbf{\formatting\textsc{Safety Critical Item}}}
		~\vspace{0.15cm}\\
		\scriptsize\textbf{UNCLASSIFIED}
		\iftoggle{markingFOUO}{\textbf{ // ~FOUO}}
	}

	%	\fancyhead[C]{\iftoggle{markingHazOp}{ \small\color{red}\textbf{HAZARDOUS OPERATIONS PROCEDURE}} }
	%	\fancyfoot[C]{\vspace{0.1cm}\HRule \\[0.1cm] \scriptsize
	%	FOR U.S./JAPAN SM-3 BLK IIA PROJECT ONLY
}

\fancypagestyle{default}{
	\renewcommand{\headrulewidth}{1pt}
	%
	%\fancyfoot[C]{\vspace{0.1cm}\HRule \\[0.1cm] \scriptsize
	%	FOR U.S./JAPAN SM-3 BLK IIA PROJECT ONLY\\
	%	UNCLASSIFIED // FOR OFFICIAL USE ONLY\\
	%	{\color{red}\colorbox{yellow}{\textbf{NOT RELEASABLE TO JAPAN}}}}


	\fancyhead[L]{\cornermark\raggedright\small\rightmark}
	\fancyhead[C]{{\textsc{\small\headingcenter}}}
	%	\expandafter\fancyhead[R]{\includegraphics[scale=0.4]{\headerlogo}}
	\fancyhead[R]{}
	%
	\fancyfoot[L]{
		\scriptsize
		\topfooterleft
		\vspace{0.1cm}\hrule\vspace{0.1cm}
		\ifboolexpr{togl{markingITAR}}{\textsc{Export Controlled}}{}
		\ifboolexpr{ togl{markingDistribution} and togl{markingITAR}}{ \textbf{ // } }{}
		\ifboolexpr{togl{markingDistribution}}{\textsc{Distribution} \distribution}{}
		\ifboolexpr{ togl{markingDistribution} or togl{markingITAR}}{{\newline}\textsc{\textbf{See Cover Page}}}{}
	}


	\fancyfoot[C]{
		\iftoggle{markingSafetyCritical}{\scriptsize\textbf{\formatting\textsc{Safety Critical Item}}}
		~\vspace{0.15cm}\\
		\iftoggle{markingProprietary}{\scriptsize\color{black}\textsc{Raytheon Proprietary}\\[0.2cm]}~
		\iftoggle{markingHazOp}{ \small\color{red}\textbf{PROCEDURE CONTAINS HAZARDOUS OPERATIONS}}
	}
	%
	\fancyfoot[R]{
		\thepage\ of \pageref{LastPage}\vspace{0.15cm}\\
		\scriptsize\textbf{UNCLASSIFIED}
		\iftoggle{markingFOUO}{\textbf{ // ~FOUO}}
	}
}

\fancypagestyle{appendices}{
	\fancyfoot[R]{
		%		\iflabelexists{endOf\thesection}
		%	{\setcounter{lappage}{\getpagerefnumber{endOf\thesection}-\arabic{sappage}}}
		%					  {\setcounter{lappage}{\getpagerefnumber{LastPage}-\arabic{sappage}+1}}
		%		\setcounter{lappage}{\getpagerefnumber{endOf\thesection}-\arabic{sappage}}
		\setcounter{appage}{\theCurrentPage-\arabic{sappage}+1}
		%		\newcommand{\tempddd}{endOf\thesection}
		%		I chooose YOU \tempddd
		%		\setcounter{lappage}{\tempddd}-\arabic{sappage}}
		(Appendix \thesection, \thesection-\arabic{appage}) \thepage~of \pageref{LastPage}
		%			\vspace{0.15cm}\\[0.1cm] \scriptsize
		%			\textbf{\color{black}UNCLASSIFIED // FOUO} \\
		%			boom \thepage~\arabic{sappage} \arabic{lappage} \arabic{appage} !!\getpagerefnumber{endofdoc}\\
		%			section \thesection\\
		%			I'm looking for endOf\thesection: \arabic{\value{endOf\thesection}}
	}
}
%=================== End Header and Footer Styling ================================



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 		General Dynamic Referencing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%\setrefcountdefault{-2}
\newcounter{appage}
%\newcounter{lappage}
\newcounter{sappage}
%\newcommand{\scratch}{}
%\newtoggle{footerfirst}
%\newtoggle{sectionfirst}

\newcommand{\appendixpagenumbering}{
	\break
	\pagenumbering{arabic}
	\renewcommand{\thepage}{\thesection-\arabic{page}}
	%		\label{endOf\thesection}
}


\AtBeginEnvironment{appendices}{
	\renewcommand{\cftsecaftersnumb}{\color{secpcolor}\bfseries xx}
	\renewcommand{\cftsecpresnum}{\color{secpcolor}\bfseries xx!!!!!}

	
	\preto{\section}{
		\newcounter{endOf\thesection}
		\setcounter{endOf\thesection}{\theCurrentPage}
		\setcounter{sappage}{\theCurrentPage}
	}
	\label{LastMainPage}
}
%	\setcounter{sappage}{\theCurrentPage}

\AtEndEnvironment{appendices}{
	\setcounter{sappage}{\theCurrentPage}
}

%=================== End General Dynaimc Referencing ==============================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 		Particular Annotations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\fouofig}[1]{
%	\tikzstyle{background grid}=[draw, black!50,step=.5cm]
	\begin{tikzpicture}[red] %[show background grid]
		\node [anchor=north east, inner sep=0pt]  {#1};
		\node (t1)[anchor=south] at (current bounding box.north west) {\scriptsize \textbf{(FOUO)}};
		\node (t2)[anchor=north] at (current bounding box.south east) {\scriptsize \textbf{(FOUO)}};
		%	\node (c1) at (current bounding box.north east) {};
		%	\node (c2) at (current bounding box.south west) {};
		\draw (current bounding box.north east) -- (current bounding box.north);
		\draw (current bounding box.north east) -- (current bounding box.east);
		\draw (current bounding box.south west) -- +(0,1);
		\draw (current bounding box.south west) -- +(1,0);
	\end{tikzpicture}
}

\newcommand{\tbd}{{\color{red}\textbf{TBD}\xspace}}

% Classification Markings

\newcommand{\fouofigleft}{
	{\raggedright \scriptsize\textbf{\formatting(FOUO)}\\}
}
\newcommand{\fouofigright}{
	\begin{minipage}{\linewidth}
		\vspace{0.3em}	\raggedleft\scriptsize\textbf{\formatting(FOUO)}
	\end{minipage}%\vspace{-0.25cm}
}

\newcommand{\stdquote}[3]{{
		\smallskip
\smaller	\textbf{#1 ~~\S#2}	\hfill \parbox{0.7\linewidth}{{\raggedright
	\fontfamily{lmtt}\selectfont{\begin{flushright}``#3''\end{flushright}}}}
}}


% Add NOTE marker in margin
\RequirePackage{marginnote}

\newcommand{\fouo}{{\marginnote{\textbf{\small\formatting(FOUO)}}}}

\newcommand{\note}[1]{~\\\marginnote{\textbf{NOTE:}}\noindent{#1}\\}

\newcommand{\tbr}[1]{\marginnote{\textbf{\small\color{orange}~~TBR:\\} #1}}

\newcommand{\cfbox}[2]{%
	\colorlet{currentcolor}{.}%
	{\color{#1}%
		\fbox{\color{currentcolor}#2}}%
}
\newcommand{\todo}[1]{
	\noindent
	\cfbox{red}{\parbox{\dimexpr\linewidth-2\fboxsep-2\fboxrule}{TODO: #1}}
}

\colorlet{shadecolor}{gray!8}
\newenvironment{starkpoints}{
\begin{snugshade}
	\begin{leftbar}
		\bigskip
		\begin{itemize}[rightmargin=\parindent]
}{
\end{itemize}
\end{leftbar}
\end{snugshade}}


%=================== End Particular Annotations ===================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 		Chart Default Styles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{tikz}
%\usepackage{pgfplots}

%\pgfplotsset{compat=1.14}
\tikzset{
	basic/.style  = {draw, text width=2cm, drop shadow, align=center, font=\sffamily, rectangle},
	root/.style   = {basic, rounded corners=2pt, thin,
			fill=gray!30, font=\Large},
	level 2/.style = {basic, rounded corners=6pt, thin, fill=blue!20,
			text width=1.4in, font=\scshape\large},
	level 3/.style = {basic, thin, align=center, fill=yellow!40, text width=1.5in, node distance = 1.4cm and 2cm},
	level 4s/.style = {basic, thin, align=right, fill=green!40, text width=1in, node distance=1cm},
	level 4r/.style = {basic, thin, align=left, fill=red!40, text width=1in, node distance=1cm},
	doubt/.style = {fill=green!40},
	plaus/.style = {fill=yellow!40},
	prob/.style = {fill=red!40},
	good/.style = {fill=green!40},
	bad/.style = {fill=red!40},
	%  supp/.style= {basic,cloud, cloud puffs=13, cloud puff arc=190,fill=green!40,node distance=2in, text width=1in, font=\tiny\bfseries, aspect=4, yshift=-0.5in}
	supp/.style= {basic,signal,fill=gray!20, node distance=1in, text width=2in, inner xsep=0pt, thin, aspect=4, signal to=west, anchor=west},
	weak refute/.style  = {blue!40!green, thin},
	weak support/.style  = {blue!20!red, thin},
	strong refute/.style  = {blue!40!green, ultra thick},
	strong support/.style  = {blue!20!red, ultra thick}
}


%%% Custom tikz symbols
%%\pgfplotsset{compat=1.15}
%\tikzset{middlearrow/.style={
%		decoration={markings,
%			mark= at position 0.65 with {\arrow{#1}} ,
%		},
%		postaction={decorate}
%	}
%}

%=================== End Chart Default Sytles ===================================






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 		Image Annotation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\definecolor{1c1}{RGB}{188,162,6}
\definecolor{1c2}{RGB}{137,129,80}
\definecolor{1c3}{RGB}{239,167,31}
\definecolor{1c4}{RGB}{88,194,241}
\definecolor{1c5}{RGB}{6,180,188}

% stiles used
\tikzset{mynode/.style={draw=black,solid,circle,fill=white,inner sep=2pt, thick, text=black}}
%draw=black to get a black circle, fill=white so it actually has a
%background and text=black to not get that rendered in the specified color
\tikzset{arrow line/.style={dashed, line width= 2.5pt, color=#1}}
%color is given as a paramter so one can put these two styles in the
%preamble and easily use throughout the document, line width as it was to small on my images on a page

%\begin{figure}[tbph]
%	\hspace{5mm}\subfloat[figure a]{%
%		\begin{minipage}[b][1\totalheight][c]{0.4\columnwidth}%
%			\noindent \begin{center}
%				\includegraphics[width=1\columnwidth]{path/to/image_a}
%				\par\end{center}%
%		\end{minipage}
%
%
%
%	}\hfill{}\subfloat[description of figure a]{\noindent \centering%
%		\begin{minipage}[b][5cm][c]{0.4\columnwidth}%
%			\noindent \begin{center}
%				\centering
%				\begin{tikzpicture}
%				\node[anchor=south west,inner sep=0] (image) at (0,0,0) {\includegraphics[width=0.7\columnwidth]{path/to/image}};
%				\begin{scope}[x={(image.south east)},y={(image.north west)}]
%				% uncomment the 4 lines for a grid to help with positioning
%				% \draw[help lines,xstep=.1,ystep=.1] (0,0) grid (1,1);
%				% \draw[help lines,xstep=.05,ystep=.05] (0,0) grid (1,1);
%				% \foreach \x in {0,1,...,9} { \node [anchor=north] at (\x/10,0) {0.\x}; }
%				% \foreach \y in {0,1,...,9} { \node [anchor=east] at (0,\y/10) {0.\y};}
%
%				% uncomment until line above
%				\draw[arrow line=1c1] (0.8,0.8) -- +(0.275,0)node[mynode,anchor=west] {\Large 1};
%				%1c1 is the code for the color, you can enter 1c2 here, too
%				\draw[arrow line=1c1] (0.6,0.55) -- +(0.475,0)node[mynode,anchor=west] {\Large 2};
%				\draw[arrow line=1c1] (0.35,0.45) -- +(-0.425,0)node[mynode,anchor=east] {\Large 3};
%				\draw[arrow line=1c1] (0.375,0.275) -- +(-0.45,-.15)node[mynode,anchor=east] {\Large 4};
%				\end{scope}
%				\end{tikzpicture}
%				\par\end{center}%
%		\end{minipage}
%
%	}\hspace{5mm}
%
%	\protect\caption{outside caption}
%
%
%\end{figure}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 		Font Configuration (Optional)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Nice balance between sans and serif. Good weight, full support
\RequirePackage{fourier}

% Blocky, clear, full support. One of the top three
%\usepackage{txfonts}
% Almost exactly the same as txfonts, except in certain places?
%\usepackage{mathptmx}

% Sorta like source serif, but a little lighter. Pretty close to default, but heavier
%\usepackage{tgpagella}


% Sorta like libertine, but less dense
%\usepackage[default,regular,black]{sourceserifpro}


% Nice serif font, a little denser, full support of types - not noticeably special
%\usepackage{libertine}
%\usepackage{libertinust1math}


% Similar to default - Basic nothing special but a little clearer
%\usepackage{beton}
%\usepackage{euler}


% Not terrible sans font.
%\usepackage[T1]{fontenc}
%\usepackage[default]{gillius}


% Nice legal type font, no small caps support
%\usepackage{venturis2}

%\RequirePackage[T1]{fontenc}
\RequirePackage{microtype}


% Cute utility function
\newcommand{\showfont}{encoding: \f@encoding{},
	family: \f@family{},
	series: \f@series{},
	shape: \f@shape{},
	size: \f@size{}
}

\RequirePackage{relsize}
\newcommand{\signalfont}{\fontfamily{NotoSans-TLF}\selectfont\smaller\smaller\bfseries}
%\newcommand{\sig}[1]{{\fontfamily{\signalfont}\selectfont #1}}
\newcommand{\sig}[1]{{\signalfont #1}}

\newcommand{\connfont}{\fontfamily{NotoSans-TLF}\selectfont}



%\newcommand{\ittysig}[1]{{\signalfont{\scriptsize #1}}}5
%=================== End Font Configuration =======================================




%	\ifx\traceon\undefined \tracingall \else \traceon \fi
%		\relscale{0.95} % or whatever scaling is desired.
\pagenumbering{arabic}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 		Title Page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\renewcommand{\titlepage}{
\thispagestyle{firststyle}\vspace*{-1.25cm}
%\begin{center}

\noindent\Large\textsc{\textbf{\fontfamily{qhv}\selectfont\titlelong}}

\noindent\Large\textsc{\fontfamily{qhv}\selectfont\doctype}\smallskip

%		\small~\\
%	\\[0.25cm]

%	{	\large\textit{for}}
%	~\\[0.15cm]
%\noindent	\Large\textsc{\contractname System (BMNS)}
%\begin{minipage}{0.75\linewidth}

%\smallskip
%	{	\Large \textsc{\contractname}}
%	{\Large\textsc{some purpose here}},\\

%		\end{minipage}
%\\[0.15cm]~

\vspace*{0.25cm}
\noindent\hrule
\vfill
\small~\\[0.15cm]
\normalsize
%\end{center}
%	\vspace{1cm}

\begin{minipage}{0.45\linewidth}
	% Place top logo, unless disabled
%\nottoggle{hidetoplogo}{\includegraphics[width=\linewidth]
\begin{center}
{\placetoplogo}
{\placebotlogo}
\end{center}

\end{minipage}
\hfill
\begin{minipage}{0.5\linewidth}
%	\centering
	%	\textsc{
	%		\textbf{
	%			{\large Record {\fontfamily{cmr}\selectfont\textnumero}:}
	%			%				$\textnumero$
	%			\LARGE
	%			%			\underline{\docnumber}
	%			\docnumber
	%	}}
	%	\\[0.25cm]
	%		\small \vspace{0.5cm}
	%		\vfill
	\def\arraystretch{1}%  1 is the default, change whatever you need
	\begin{tabular}{r @{ : } >{\raggedright\arraybackslash}p{1.3in}}
		\textsc{\large Document {\fontfamily{cmr}\selectfont\textnumero}}
                                            & \docnumber  \newline                                            \\
		\textsc{{\newline}Current Revision} & \revision                                                           \\
		\textsc{Total Pages}                & \pageref{LastPage}                                                  \\
		\textsc{Status}                     & \documentstatus   \newline                                         \\
		\textsc{Release Date}               & \released                                                              \\
		\textsc{Prepared By}                & James Heller\newline {Fuzing, Initiator Safety}\newline                    \\
		\textsc{Classification}             & UNCLASSIFIED\iftoggle{markingFOUO}{, FOUO \\}		\\
		\iftoggle{markingDistribution}{\textsc{Distribution}&\distribution\\}
\newline{\scshape\projectdesignation}        & \textsc{\contractname}                                                       \\
		\textsc{Contract \#}                & \textsc{\contract}
		{\newline}                                                                                                \\

		\textsc{Originating Facility}       & Raytheon Missile\newline~Systems Company                   \\
		\textsc{Located}                    &
		1151 E. Hermans Rd\newline
		Tucson, AZ 85756                                                                                          \\
		\textsc{CAGE Code}                  & 15090                                                               \\
	\end{tabular}
	\vfill
    %\def\arraystretch{1.5}%  1 is the default, change whatever you need
\end{minipage}
%
%\vspace{0.25cm}
\vfill

\footnotesize

\noindent

\noindent\iftoggle{markingDistribution}{\distwarning}


\noindent\iftoggle{markingITAR}{\itarwarning}


\noindent\iftoggle{markingProprietary}{\raypropwarning}


\noindent\iftoggle{markingFOUO}{\fouowarning}


\noindent\iftoggle{markingDestroy}{\destructwarning}


\noindent\iftoggle{programWarning}{\programwarning}


\noindent\iftoggle{markingCopyright}{\copywarning}

}

\providecommand{\codelistings}{}

\newcommand{\metapages}{
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%% 		Table of Contents
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	\normalsize
	\newpage
	\pagestyle{default}

	\renewcommand{\sectionmark}[1]{\markright{\MakeUppercase{##1}}}

	\pagenumbering{arabic}
	\setcounter{page}{2}
	%\dosecttoc

	\tableofcontents
	%\addtocontents{toc}{~\hfill\textbf{Page}\par}
	%\addtocontents{lof}{~\hfill\textbf{Page}\par}
	%\addtocontents{lot}{~\hfill\textbf{Page}\par}

	%\newpage
	\listoftables
    \iftoggle{codesnips}{\listoflistings}
	\listoffigures

	\vfill

	\section*{Revision History}
	\begin{center}
		\begin{tabularx}{\linewidth}{ c | c | X }
			\textbf{Revision} & \textbf{Effective Date} & \textbf{Description of Change} \\ \hline
			\textbf{-}        & \today                  & Initial Release -- \tbd        \\
			%			\textbf{A}		  & August 30, 2017	& Added section ``Review of Facts Known To-Date'', Appendix ``L-3 Reflow Oven Profile'', and associated figures. \\
			%			\textbf{B} & August 31, 2017 & Updated Developments, call with L-3 and TTM. \\
			%			\textbf{C} & September 12, 2017 & Added Fault Tree and supporting evidence for each branch. \\
			% \textbf{D} & & \\ \hline
		\end{tabularx}
	\end{center}

	\newpage
}
