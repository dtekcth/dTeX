% vim: set ft=tex:
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{dtex}

\newif\ifincludeaddress
\includeaddresstrue
\DeclareOption{noincludeaddress}{\includeaddressfalse}

\ProcessOptions\relax

\LoadClass[11pt,a4paper]{article}

\RequirePackage[quiet]{fontspec}
\RequirePackage{parskip}
\RequirePackage{graphicx}
\RequirePackage{fancyhdr}
\RequirePackage[swedish]{babel}
\RequirePackage{lastpage}
\RequirePackage[unicode]{hyperref}
\RequirePackage[includeheadfoot, top=2.0cm, bottom=4cm]{geometry}
\RequirePackage{xparse}
\RequirePackage{collect}
\RequirePackage{etoolbox}

\RequirePackage{pdfpages}
\RequirePackage{navigator}

\RequirePackage[shortlabels]{enumitem}
\RequirePackage[titles]{tocloft}

\AtBeginDocument{
    \hypersetup{
        pdftitle = {\@title},
        pdfauthor = {\@author},
        colorlinks=true,
        citecolor=black,
        filecolor=black,
        linkcolor=black,
        urlcolor=black
    }
}

% Allows easy definition of commands
% example:
% \Title{Protokoll} -> Defines \TheTitle to be "Protokoll"

% TODO felmeddelande om man inte definierat variabeln
\NewDocumentCommand \Definer {mm} {\DeclareDocumentCommand #1 {m} {\def#2{##1}}}

%%% TITLE LOGIC %%%%%%

\Definer \Title \TheTitle
\Definer \TitleHeadLeft \TheTitleHeadLeft
\Definer \TitleHeadRight \TheTitleHeadRight


\DeclareDocumentCommand \maketitle {} {%
    {\centering \bf{\LARGE{\TheTitle}}\par}\par
}

%%% HEADER & FOOTER LOGIC %%%%%%%%%%%

% use \renewcommand{\headleft} to override and customize this
\newcommand{\headleft}{%
    % Name the logo "logga.*" in order for it to show up
    \raisebox{-3mm}{\includegraphics[width=16mm]{logga}}\hspace{1mm}
    \parbox[b]{10cm}{%
        \textbf{Datateknologsektionen}\\
        Chalmers studentkår\\
        \TheTitleHeadLeft
    }
}

% use \renewcommand{\headright} to override and customize this
\newcommand{\headright}{%
    Sida \thepage\ av \pageref{LastPage}\\
    \@date \\
    \TheTitleHeadRight
}


% use \renewcommand{\footleft} to override and customize this
\newcommand{\footleft}{%
    \flushleft Datateknologsektionen\\
    Rännvägen 8 \\
    412 58 Göteborg
}

% use \renewcommand{\footright} to override and customize this
\newcommand{\footright}{%
    \begin{flushright}
        \href{mailto:styret@dtek.se}{styret@dtek.se}\\
        \href{https://dtek.se}{www.dtek.se}
    \end{flushright}
}

\DeclareDocumentCommand \makehf {}{%
    \pagestyle{fancy}
    \fancyhf{}

    % Calculate header height
    \settototalheight\headheight{\headleft}
    \addtolength\headheight{1.0pt}

    \lhead{\headleft}
    \rhead{\headright}

    \renewcommand{\headrule}{
        \nointerlineskip
        \hskip 16mm\hrulefill
    }

    \renewcommand{\footrulewidth}{\headrulewidth}

    \ifincludeaddress
        \lfoot{\footleft}
        \rfoot{\footright}
    \fi
}

\DeclareDocumentCommand \makeheadfoot {}{\makehf}

%%%%%%% MISC Logic %%%%%%%%%%%%%%
%%
% \storeCounter
% Define a counter to track and store to main aux when first document pass is done
% @arg m Counter to trac
% @arg m Command to store count in
\DeclareDocumentCommand \storeCount {mm} {%
    \newcounter{NumberOf#1}%
    \providecommand#2{}%
    \AtEndDocument{%
        \addtocounter{NumberOf#1}{\value{#1}}%
        \immediate\write\@mainaux{%
            \string\gdef\string#2{\number\value{NumberOf#1}}%
        }%
    }%
}


%%%%%%%% Bilagor Logic %%%%%%%%%%%%%%%%%%%

\newlistof{bilagor}{bil}{Bilagor}
\storeCount{bilagor}{\AntalBilagor}

\definecollection{bilagor}
\newcommand{\InsetBilagor}{
   \clearpage
   \pagestyle{bilagor}
   \includecollection{bilagor}
}


\NewDocumentCommand \trash {m} {\edef\tmpeval{#1} \tmpeval}
\begin{collect}{bilagor}{}{}{}{}%
    \outline{1}{Bilagor}
\end{collect}%

\DeclareDocumentCommand \AddBilaga {D(){-} O{0} m m o m}{%
    \IfValueTF{#5}{%
        \collectbilaga{#1}{#2}{#3}{#4}{#5}{#6}%
    }{%
        \collectbilaga{#1}{#2}{#3}{#4}{#6}{#6}%
    }
}
\providecommand \CurrentBilaga {}

%%%
% #1 pages
% #2 angle
% #3 ref-name
% #4 filename
% #5 header-name
% #6 name
%%%
\DeclareDocumentCommand \collectbilaga {m m m m m m}{%
    \begin{collect}{bilagor}{}{}{}{}%
        \outline{2}{#6}
        \renewcommand \CurrentBilaga {#5}%
        \pagestyle{bilagor} % adds out header and stuff
        \includepdf[ pages=#1%
                   , addtolist={1,bilagor,#6,bil:#3}
                   , angle=#2
                   , width=1.2\textwidth
                   , totalheight=1.05\textheight
                   , keepaspectratio
                   , pagecommand={}
        ]{#4}%
    \end{collect}%
}

% \bilaga{kortnamn} Referera till en bilaga
\DeclareDocumentCommand \bilaga {m}{%
  \hyperref[bil:#1]{\mbox{bilaga \ref*{bil:#1}}}%
}

\fancypagestyle{bilagor}{%
    \renewcommand{\headrule}{
        \nointerlineskip
        \hrulefill
    }
    \lfoot{}
    \rfoot{}
    \cfoot{ \Large Bilaga \thebilagor\ av \AntalBilagor}
    
\lhead{
    \begin{flushleft}
    Bilaga \thebilagor: \CurrentBilaga
    \end{flushleft}%
}

\rhead{%
    \begin{flushright}
    Bilaga \thebilagor\ av \AntalBilagor \\
    Sidan \thepage\ av \pageref{LastPage}
    \end{flushright}%
}
}


