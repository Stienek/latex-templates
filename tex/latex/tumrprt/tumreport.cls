% This Class File has been designed for sientific Reports throughout my 
% Career at the Technical University of Munich. You are free to use this
% Class as you please and without immeadeate Reference in your Work, but
% when asked about it, please do not claim this Class as your own.
%
% Usage and Options will be explained below.
%
% TODO:
%	o Pagestyles
%		o Optional: Upgrade default plain Pagestyle
%		o Create custom Pagestyle
%			o Add Footer 
%	o Pass Class Options to scrreport
%
% Version: 1.0
% Creator: Laurin Weitzel (laurin.weitzel@gmail.com or laurin.weitzel@tum.de)

\NeedsTeXFormat{LaTeX2e}[1995/12/01] % Required LaTeX Version. TODO: Change Date if required.
\ProvidesClass{tumreport}[2024/03/17 v1.0 TUM Report Class Style] % Define Name, Date and Comment.


\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrreport}} % Passes all unhandled Options to scrreport.
\ProcessOptions\relax % Execute Code form all \DeclareOption.
\LoadClass{scrreport} % Load Koma-Script Report Class as Base.

%%%%%%%%%%%
% General %
%%%%%%%%%%%

% Document Information Definition.
\makeatletter
\DeclareRobustCommand{\tumauthor}[2][]{%
	\def\shorttumauthor{#1}%
	\def\tumauthor{#2}%
}
\DeclareRobustCommand{\tumtitle}[2][]{%
	\def\shorttumtitle{#1}%
	\def\tumtitle{#2}%
}
\DeclareRobustCommand{\tumdate}[1]{%
	\def\tumdate{#1}%
}
\makeatother

% Handle Defaults.
\makeatletter
\providecommand{\shorttumauthor}{}
\providecommand{\tumauthor}{}
\providecommand{\shorttumtitle}{}
\providecommand{\tumtitle}{}
\providecommand{\tumdate}{}
\makeatother

%%%%%%%%%%%%%%%%%
% Color Options %
%%%%%%%%%%%%%%%%%

\RequirePackage[table]{xcolor} % Advanced Color Control and Table coloring.

\makeatletter
% Define Color Palette (Official TUM has more Colors, but we won't use those for now)
\definecolor{dark-grey}{cmyk}{0, 0, 0, 0.8}
\definecolor{grey}{cmyk}{0, 0, 0, 0.5}
\definecolor{light-grey}{cmyk}{0, 0, 0, 0.2}

% "Borrowed" from https://portal.mytum.de/corporatedesign/vorlagen/index_html/vorlagen/index_farben
\definecolor{primary}{cmyk}{1, 0.43, 0, 0}
\definecolor{secondary}{cmyk}{1, 0.54, 0.04, 0.19}
\definecolor{tertiary}{cmyk}{1, 0.57, 0.12, 0.7}
\makeatother

%%%%%%%%%%%%%%%%%%%%%%
% Spacing and Layout %
%%%%%%%%%%%%%%%%%%%%%%

% Set Sizes for the Page Text Area.
\makeatletter
\newlength{\pagetopmargin}
\newlength{\pagebottommargin}
\newlength{\pageleftmargin}
\newlength{\pagerightmargin}

\setlength{\pagetopmargin}{2cm} % Customize the top Margin.
\setlength{\pagebottommargin}{2cm} % Customize the bottom Margin.
\setlength{\pageleftmargin}{3cm} % Customize the left Margin.
\setlength{\pagerightmargin}{3cm} % Customize the right Margin.
\makeatother

% Set Page Layout based on defined Margins.
\RequirePackage[a4paper, % We need to change this if a4paper isn't desired.
	top=\pagetopmargin,
	bottom=\pagebottommargin,
	left=\pageleftmargin,
	right=\pagerightmargin,
	includeheadfoot,
	bindingoffset=0cm]{geometry}

% Set Paragraph Indentation and Spacing. This comes down to Taste.
\setlength{\parindent}{0pt} % We don't like that around here.
\setlength{\parskip}{1.5ex plus 0.5ex minus 0.2ex} % Sets a reasonable Range.

%%%%%%%%%%%%%
% Pagestyle %
%%%%%%%%%%%%%

\RequirePackage{tikz} % Required for Graphics Functionsality.
\usetikzlibrary{calc} % This makes Tikz much more versatile.
\RequirePackage{tikzpagenodes}
\RequirePackage[automark, plainfootsepline]{scrlayer-scrpage} % Used to customize the Pagestyle.
\pagestyle{scrheadings} % Activate default Page Style.
\clearpairofpagestyles % Clear default Page Style.
\newlength{\headingsLinewidth}
\setlength{\headingsLinewidth}{0.1415\headheight} % Making sure the Heading is scaled according to Header Height.

\newcommand{\headerodd}{
\begin{tikzpicture}[remember picture, overlay]
	% Debugging.
	%\draw [red] (current page header area.south west) rectangle (current page header area.north east); % Header Outline
	\begin{scope}[color=primary, line width=\headingsLinewidth, line cap=butt, line join=miter]
		% Global Anchors.
		\node (anchor_northwest) at ([yshift=4.9285\headingsLinewidth]current page header area.south west) {}; % Top left Headings Corner.
		\node (anchor_northeast) at ([yshift=4.9285\headingsLinewidth]current page header area.south east) {}; % Top right Headings Corner.
		
		% T
		\node (T_top_left) at ([yshift=-1/2*\headingsLinewidth] anchor_northwest){}; % T top Stroke left Side.
		\node (T_top_right) at ([xshift=3*\headingsLinewidth] T_top_left) {}; % T top Stroke right Side.
		\node (T_center_top) at ($(T_top_left)!0.5!(T_top_right)$) {}; % T center Stroke top Side.
		\node (T_center_bottom) at ([yshift=-4.9285*\headingsLinewidth] T_center_top) {}; % T center Stroke bottom Side.
		\draw (T_top_left.center) -- (T_top_right.center); % T top Stroke.
		\draw (T_center_top.center) -- (T_center_bottom.center); % T center Stroke.
		
		% U
		\node (U_top_left) at ([xshift=3.5*\headingsLinewidth] anchor_northwest) {}; % U top left Corner.
		\node (U_bottom_left) at ([yshift=-4.9285*\headingsLinewidth] U_top_left) {}; % U bottom left Corner.
		\node (U_bottom_right) at ([xshift=2*\headingsLinewidth] U_bottom_left) {}; % U bottom right Corner.
		\node (U_top_right) at ([xshift=2*\headingsLinewidth] U_top_left) {}; % U top right Corner.
		\draw (U_top_left.center) -- (U_bottom_left.center) -- (U_bottom_right.center) -- (U_top_right.center); % U all at once.
		
		% M
		\node (M_top_left) at ([xshift=3*\headingsLinewidth] T_top_right) {}; % M top Stroke left Side.
		\node (M_top_right) at ([xshift=4*\headingsLinewidth] M_top_left) {}; % M top Stroke right Side.
		\node (M_center_top) at ([xshift=6*\headingsLinewidth] T_center_top) {}; % M center Stroke top Side.
		\node (M_center_bottom) at ([xshift=6*\headingsLinewidth] T_center_bottom) {}; % M center Stroke bottom Side.
		\node (M_right_top) at ([xshift=2*\headingsLinewidth] M_center_top) {}; % M right Stroke top Side.
		\node (M_right_bottom) at ([xshift=2*\headingsLinewidth] M_center_bottom) {}; % M right Stroke bottom Side.
		\draw (M_top_left.center) -- (M_top_right.center); % M top Stroke.
		\draw (M_center_top.center) -- (M_center_bottom.center); % M middle Stroke.
		\draw (M_right_top.center) -- (M_right_bottom.center); % M middle Stroke.
		
		% Horizontal Rule
		\node (H_rule_left) at ([xshift=0.5*\headingsLinewidth, yshift=0.5*\headingsLinewidth] M_right_bottom) {}; % H Rule left Side.
		\node (H_rule_right) at ([yshift=-4.9285*\headingsLinewidth] anchor_northeast) {}; % H Rule right Side.
		\draw (H_rule_left.center) -- (H_rule_right.center); % H Rule.
	\end{scope}
\end{tikzpicture}
}

%%% Head %%%
% Head oneside.
\DeclareLayer[
clone=scrheadings.head.oneside,
contents={
\headerodd
}
]{scrheadings.head.oneside.background}

% Head twoside even.
\DeclareLayer[
clone=scrheadings.head.even,
contents={
\headerodd
}
]{scrheadings.head.even.background}

% Head twoside odd.
\DeclareLayer[
clone=scrheadings.head.odd,
contents={
\begin{tikzpicture}[remember picture, overlay]
	% Debugging.
	% \draw [red] (current page header area.south west) rectangle (current page header area.north east); % Header Outline
	\begin{scope}[color=primary, line width=\headingsLinewidth, line cap=butt, line join=miter]
		% Global Anchors.
		\node (anchor_northwest) at ([yshift=4.9285\headingsLinewidth]current page header area.south west) {}; % Top left Headings Corner.
		\node (anchor_northeast) at ([yshift=4.9285\headingsLinewidth]current page header area.south east) {}; % Top right Headings Corner.
		
		% T
		\node (T_top_left) at ([xshift=-10*\headingsLinewidth, yshift=-1/2*\headingsLinewidth] anchor_northeast){}; % T top Stroke left Side.
		\node (T_top_right) at ([xshift=3*\headingsLinewidth] T_top_left) {}; % T top Stroke right Side.
		\node (T_center_top) at ($(T_top_left)!0.5!(T_top_right)$) {}; % T center Stroke top Side.
		\node (T_center_bottom) at ([yshift=-4.9285*\headingsLinewidth] T_center_top) {}; % T center Stroke bottom Side.
		\draw (T_top_left.center) -- (T_top_right.center); % T top Stroke.
		\draw (T_center_top.center) -- (T_center_bottom.center); % T center Stroke.
		
		% U
		\node (U_top_left) at ([xshift=-6.5*\headingsLinewidth] anchor_northeast) {}; % U top left Corner.
		\node (U_bottom_left) at ([yshift=-4.9285*\headingsLinewidth] U_top_left) {}; % U bottom left Corner.
		\node (U_bottom_right) at ([xshift=2*\headingsLinewidth] U_bottom_left) {}; % U bottom right Corner.
		\node (U_top_right) at ([xshift=2*\headingsLinewidth] U_top_left) {}; % U top right Corner.
		\draw (U_top_left.center) -- (U_bottom_left.center) -- (U_bottom_right.center) -- (U_top_right.center); % U all at once.
		
		% M
		\node (M_top_left) at ([xshift=3*\headingsLinewidth] T_top_right) {}; % M top Stroke left Side.
		\node (M_top_right) at ([xshift=4*\headingsLinewidth] M_top_left) {}; % M top Stroke right Side.
		\node (M_center_top) at ([xshift=6*\headingsLinewidth] T_center_top) {}; % M center Stroke top Side.
		\node (M_center_bottom) at ([xshift=6*\headingsLinewidth] T_center_bottom) {}; % M center Stroke bottom Side.
		\node (M_right_top) at ([xshift=2*\headingsLinewidth] M_center_top) {}; % M right Stroke top Side.
		\node (M_right_bottom) at ([xshift=2*\headingsLinewidth] M_center_bottom) {}; % M right Stroke bottom Side.
		\draw (M_top_left.center) -- (M_top_right.center); % M top Stroke.
		\draw (M_center_top.center) -- (M_center_bottom.center); % M middle Stroke.
		\draw (M_right_top.center) -- (M_right_bottom.center); % M middle Stroke.
		
		% Horizontal Rule
		\node (H_rule_left) at ([yshift=-4.9285*\headingsLinewidth] anchor_northwest) {}; % H Rule left Side.
		\node (H_rule_right) at ([xshift=-0.5*\headingsLinewidth, yshift=0.5*\headingsLinewidth] T_center_bottom) {}; % H Rule right Side.
		\draw (H_rule_left.center) -- (H_rule_right.center); % H Rule.
	\end{scope}
\end{tikzpicture}
}
]{scrheadings.head.odd.background}

% Apply Layers
\AddLayersAtBeginOfPageStyle{scrheadings}{	
	scrheadings.head.oneside.background,
	scrheadings.head.odd.background,
	scrheadings.head.even.background
}

%%% Foot %%%
\KOMAoptions{footsepline=\headingsLinewidth}
\setkomafont{footsepline}{\color{primary}}
%\setfootsepline{\headingsLinewidth}[\color{primary}]

% Header Content.
\chead{\color{black}\rightmark} % Top center: current chapter/section and its name
\ifoot{\shorttumauthor} % Bottom inner: Author name
\cfoot{\tumdate} % Bottom center: date
\ofoot{\pagemark} % Bottom outer: page number
\if@twoside
\ihead{\shorttumtitle} % Top inner: Name of the document/title
\else
\rohead{\shorttumtitle}
\rehead{\shorttumtitle}
\fi

% Plain Footer
\ifoot*{\shorttumauthor} % Bottom inner: Author name
\cfoot*{\tumdate} % Bottom center: date
\ofoot*{\pagemark} % Bottom outer: page number

%%%%%%%%%%%%%%%%%%
% Chapter Titles %
%%%%%%%%%%%%%%%%%%

% Redefine the chapter command to color the title while keeping the number black
\renewcommand*{\chapterformat}{%
	\textcolor{primary}{\thechapter}\autodot\quad
}
\renewcommand*{\chaptermarkformat}{%
	\textcolor{primary}{\thechapter}%
}

% Redefine the section command to color the title while keeping the number black
\renewcommand*{\sectionformat}{%
	\textcolor{primary}{\thesection}\autodot\quad
}
\renewcommand*{\sectionmarkformat}{%
	\textcolor{primary}{\thesection}%
}

% Redefine the subsection command to color the title while keeping the number black
\renewcommand*{\subsectionformat}{%
	\textcolor{primary}{\thesubsection}\autodot\quad
}
\renewcommand*{\subsectionmarkformat}{%
	\textcolor{primary}{\thesubsection}%
}

% Redefine the subsubsection command to color the title while keeping the number black
\renewcommand*{\subsubsectionformat}{%
	\textcolor{primary}{\thesubsubsection}\autodot\quad
}
\renewcommand*{\subsubsectionmarkformat}{%
	\textcolor{primary}{\thesubsubsection}%
}

%%%%%%%%%%%%%%%%%%
% Make Titlepage %
%%%%%%%%%%%%%%%%%%

\renewcommand{\maketitle}{
	\enlargethispage{4.5cm} %Damit das Titelbild weit genug unten ist!
	%\enlargethispage{40cm}
	\begin{center}
		\phantom{u}
		%\vspace{0.5cm}
		\Huge{\sc \@title}\\
		\ifx\@vartitletranslation\empty
		{}
		\else
		\large{\sc (\@vartitletranslation) \\}
		\fi
		\vspace{1.5cm}
		
		\if@langGer
		\large{\@worktypetext \\}
		\large{\@degreetext \\}
		\else    
		\large{\@worktypetext \\}
		\large{\@degreetext \\}
		\fi
		\vspace{0.3cm}
		
		\if@langGer
		\ifx\@institute\@instituteHCR
		am Lehrstuhl f\"ur\\
		STEUERUNGS- und REGELUNGSTECHNIK\\
		Technische Universit\"at M\"unchen\\
		\fi
		\ifx\@institute\@instituteITR
		am Lehrstuhl f\"ur\\
		INFORMATIONSTECHNISCHE REGELUNG \\
		Technische Universit\"at M\"unchen\\
		\fi
		\else
		\ifx\@institute\@instituteHCR
		%Chair of \\
		%  \\
		at the Human-centered Assistive Robotics \\
		Technical University of Munich\\
		\fi
		\ifx\@institute\@instituteITR
		at the chair of \\
		INFORMATION-ORIENTED CONTROL\\
		Technical University of Munich\\
		\fi
		\fi
		\vspace{1.5cm}
		
		\if@langGer	
		\large{Eingereicht von }
		\@vartitle~\@student \\
		\large{ am }
		\@varyearone
		\else
		\large{Submitted by }
		\@vartitle~\@student \\
		\large{ on }
		\@varyearone
		\fi	
		\vspace{1.5cm}
		
		\if@langGer	
		\ifx\@institute\@instituteITR
		\large{Erstbetreuer:	}
		\vspace{0.4cm}
		Univ.-Prof.~Dr.-Ing. Sandra Hirche \\
		\large{Zweitbetreuer:	}
		\vspace{0.4cm}
		\@varsupervisor
		\fi    
		\ifx\@institute\@instituteHCR	
		\large{Erstbetreuer: }
		\vspace{0.4cm}
		Univ.-Prof.~Dr. Gordon Cheng \\
		\large{Zweitbetreuer:	}
		\vspace{0.4cm}
		\@varsupervisor
		\fi    
		\else
		\ifx\@institute\@instituteITR
		\large{First supervisor: } 
		\vspace{0.4cm}
		Univ.-Prof.~Dr.-Ing. Sandra Hirche \\
		\large{Second supervisor:	}
		\vspace{0.4cm}
		\@varsupervisor
		\fi    
		\ifx\@institute\@instituteHCR	
		\large{First supervisor: }         
		\vspace{0.4cm}
		Univ.-Prof.~Dr. Gordon Cheng \\
		\large{Second supervisor:	}
		\vspace{0.4cm}
		\@varsupervisor
		\fi    
		\fi	
	\end{center}
	\vspace{2.5cm}	
}
%%%%%%%%%%%%%%%%%%%%%
% Cosmetic Upgrades %
%%%%%%%%%%%%%%%%%%%%%

% Blue Boldface.
\DeclareRobustCommand{\pbold}[1]{\textbf{\color{primary}#1}}

% Make all Refrences Blue.
\RequirePackage[colorlinks, citecolor = primary, urlcolor = primary, linkcolor = primary]{hyperref}


\RequirePackage{microtype} % This enhances the Word Placement and Line Breaking. No reason not to use it :))
