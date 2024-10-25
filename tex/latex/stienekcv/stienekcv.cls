% This Class File has been designed for my personal Applications.
% It has many Commands to make creating your own CV easier.
%
% Usage and Options will be explained below.
%
% Version: 1.0
% Creator: Laurin Weitzel (laurin.weitzel@gmail.com)

\NeedsTeXFormat{LaTeX2e}[2020-10-01]
\ProvidesClass{stienekcv}[2024/10/24 Professional CV Class. Designed to use LuaLaTeX.]

% Parsing Options would go here.

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{letter}} % Passes all unhandled Options.
\ProcessOptions\relax % Execute Code form all \DeclareOption.
\LoadClass{letter} % Load Class as Base.

%%%%%%%%%%%%
% Includes %
%%%%%%%%%%%%
% LuaLaTeX.
\RequirePackage{ifluatex} % Use custom Font if running LuaLaTeX.

% Graphics.
\RequirePackage{pgf}
\RequirePackage{tikz}
\usetikzlibrary{shadows.blur}
\RequirePackage[table]{xcolor} % Advanced Color Control and Table coloring.

% Page Setup.
\RequirePackage{geometry}

%%%%%%%%%%%
% General %
%%%%%%%%%%%

% Font Setup.
\ifluatex
	% If LuaTeX is detected, load the fontspec Package to use .ttf Fonts.
	\RequirePackage{fontspec}
	\setmainfont[
		UprightFont		= *-Regular,	% Regular (Upright) version
		BoldFont		= *-Bold,		% Bold version
		ItalicFont		= *-Italic,		% Italic version
		BoldItalicFont	= *-BoldItalic,	% Bold Italic version
		ThinFont		= *-Thin,		% Thin version
		BlackFont		= *-Black		% Black (Heavy) version
	]{Lato}							% The base name of your font
\else
	% Else, just use the default sans-font.
	\RequirePackage{helvet}
	\renewcommand{\familydefault}{\sfdefault}
\fi

% Page Style.
\pagestyle{empty}	% No Page Number, no Header or Footer.

%%%%%%%%%%%%%%%%%
% Color Options %
%%%%%%%%%%%%%%%%%


\makeatletter
% Define Color Palette (Official TUM has more Colors, but we won't use those for now)
\definecolor{dark-grey}{cmyk}{0, 0, 0, 0.8}
\definecolor{grey}{cmyk}{0, 0, 0, 0.5}
\definecolor{light-grey}{cmyk}{0, 0, 0, 0.2}

% Primary Colorscheme
\definecolor{primary}{HTML}{116466}
\definecolor{secondary}{HTML}{FFCB9A}
\definecolor{tertiary}{HTML}{D1E8E2}
\makeatother

%%%%%%%%%%%%
% Elements %
%%%%%%%%%%%%

% Skills. Name on the left, Star Rating on the Right.
\newcommand{\cvskill}[2]{%
	\pgfmathparse{#2}
	\let\stars\pgfmathresult

	\pgfmathparse{ceil(\stars)}
	\let\ceilstars\pgfmathresult

	\setlength{\fboxsep}{0pt}
	\makebox[\linewidth][l]{%
		\makebox{#1}
		\hfill
		\makebox{%
			\foreach \index in {1, 2, 3, 4, 5}{%
				\pgfmathparse{\stars >= \index}
				\ifnum\pgfmathresult=1
				\includegraphics[width=\fontcharht\font`A]{star_full}%
				\else
				\pgfmathparse{\ceilstars == \index}
				\ifnum\pgfmathresult=1
				\includegraphics[width=\fontcharht\font`A]{star_half}%
				\else
				\includegraphics[width=\fontcharht\font`A]{star_empty}%
				\fi
				\fi
				\pgfmathparse{\index < 5}
				\ifnum\pgfmathresult=1
				\hspace{1ex}%
				\fi
			}%
		}%
	}
}

% Background.
\newlength{\cvimagesize}
\setlength{\cvimagesize}{3cm}
\newlength{\cvaccentlinewidth}
\setlength{\cvaccentlinewidth}{2.5pt}
\newcommand{\cvpagesetup}{%
	\begin{tikzpicture}[
			remember picture,
			overlay,
			every shadow/.style={
				shadow scale=1,
				shadow xshift=0pt,
				shadow yshift=0pt,
				shadow opacity=100,
				shadow blur steps=16,
				shadow blur radius=0.25cm
			}
		]
		\node[right=0.381966 * \paperwidth] (ColumnDividerTop) at (current page.north west) {};		% Golden Ratio.
		\node (LeftColumnTopMiddle) at ($ (current page.north west)!0.5!(ColumnDividerTop) $) {};	% Left Column Middle (top).
		\node[below=0.381966 * \paperwidth / 2] (ImageCenter) at (LeftColumnTopMiddle) {};

		% Draw a square from the left edge of the page to the middle
		\fill[primary] (current page.south west) rectangle (ColumnDividerTop);

		\begin{scope} % Clip a circular area to show the image inside it
			\clip (ImageCenter) circle [radius=\cvimagesize];

			% Place the image inside the circular cutout
			\node[anchor=center] at (ImageCenter) {\includegraphics[width=6cm]{Profile}}; % Replace 'example-image' with the path to your image
		\end{scope}

%		\draw[secondary, line width=\cvaccentlinewidth] (ImageCenter) circle [radius=\cvimagesize + 1.5 * \cvaccentlinewidth];

		% Vertical Line at Column Separation.
%		\draw[secondary, line width=\cvaccentlinewidth] ($(ColumnDividerTop) + (-1.5 * \cvaccentlinewidth, 0)$) -- ++(0, -\paperheight);
	\end{tikzpicture}
}
