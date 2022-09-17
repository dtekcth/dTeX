% vim: set ft=tex:
\ProvidesClass{dtek}

\ProcessOptions\relax

\LoadClass[11pt,a4paper]{article}

\RequirePackage[quiet]{fontspec}
\RequirePackage[swedish]{babel}
\RequirePackage{parskip}
\RequirePackage{graphicx}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\RequirePackage[unicode]{hyperref}
\RequirePackage[includeheadfoot, top=2.0cm, bottom=4cm]{geometry}
\RequirePackage{collect}
\RequirePackage{xparse}
\RequirePackage{etoolbox}
%\RequirePackage{pdfpages}
\RequirePackage{navigator}
\RequirePackage[shortlabels]{enumitem}
\RequirePackage[titles]{tocloft}
\RequirePackage{csquotes}

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
  \makeheadfoot
}

% Allows easy definition of commands
% example:
% \Title{Protokoll} -> Defines \TheTitle to be "Protokoll"

% TODO felmeddelande om man inte definierat variabeln
\NewDocumentCommand \Definer {mm} {\DeclareDocumentCommand #1 {m} {\def#2{##1}}}

%%% TITLE LOGIC %%%%%%

\Definer \Title \TheTitle
\Definer \Subtitle \TheSubtitle
\Definer \TitleHeadLeft \TheTitleHeadLeft
\TitleHeadLeft{\TheTitle}
\Definer \TitleHeadRight \TheTitleHeadRight


\DeclareDocumentCommand \maketitle {} {%
    {\centering \bf{\LARGE{\TheTitle}}\par}\par
    {\centering \large{\TheSubtitle}\par}\par
}

\DeclareDocumentCommand \makewholepagetitle {} {%
  \vspace*{\fill}
  \begin{center}
  {\Huge \textbf{\TheTitle}}
  \par\bigskip
  \includegraphics[width=300pt]{logo}
  \par\bigskip
  {\LARGE \TheSubtitle }
  \end{center}
  \vspace*{\fill}

  \newpage
}


%%% HEADER & FOOTER LOGIC %%%%%%%%%%%

\Definer \FooterMail \TheFooterMail
\FooterMail{styret@dtek.se}
\Definer \FooterWebsite \TheFooterWebsite
\FooterWebsite{www.dtek.se}

% use \renewcommand{\headleft} to override and customize this
\newcommand{\headleft}{%
    % Name the logo "logga.*" in order for it to show up
    \raisebox{-3mm}{\includegraphics[width=16mm]{logo}}\hspace{1mm}
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
        \TheFooterMail \\
        \TheFooterWebsite 
    \end{flushright}
}

\DeclareDocumentCommand \makehf {}{%
    \pagestyle{fancy}
    \fancyhf{}

    % Calculate header height
    \addtolength\headheight{16mm}

    \lhead{\headleft}
    \rhead{\headright}

    \renewcommand{\headrule}{
        \nointerlineskip
        \hskip 16mm\hrulefill
    }

    \renewcommand{\footrulewidth}{\headrulewidth}

    \lfoot{\footleft}
    \rfoot{\footright}
}

\DeclareDocumentCommand \makeheadfoot {}{\makehf}

%%%%%%% Attsatser %%%%%%%%%%%%%%5

\NewDocumentEnvironment{attsatser} {} {
  \begin{itemize}
  \DeclareDocumentCommand{\att} {}{\item \textbf{att }}
}{
  \end{itemize}
}

\NewDocumentEnvironment{arrlista} {} {
  \section{Arrangemangslista}
  \DeclareDocumentCommand{\arr} {m m}{#1 & #2 \\}
  \begin{tabular}{rl}
}{
  \end{tabular}
}

\newlength{\mylength}
\DeclareDocumentCommand \StatusWord { mm } {
    \DeclareDocumentCommand #1 {
        \par\medbreak\noindent
        {\normalsize
            \settowidth{\mylength}{#2}
            \hspace{-\mylength}\hspace{-1em}#2
            \hspace{1em}##2
        }%
        \ifx##1\EmptyLineOptionalArg\medbreak\noindent\fi
    }
}

\StatusWord \Avslutat {Avslutat}
\StatusWord \Kasserat {Kasserat}
\StatusWord \Vilande {Väntar}
\StatusWord \IFas {I Fas}
\StatusWord \UrFas {Släpande}
\StatusWord \klar {Klar}
\StatusWord \pagar {Pågår}
\StatusWord \kommande {Kommande}


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


