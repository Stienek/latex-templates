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

%%%%%%%%%%%
% General %
%%%%%%%%%%%

% Font Setup.
\RequirePackage{ifluatex} % Use custom Font if running LuaLaTeX.
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

%%%%%%%%%%%%%%%%%
% Color Options %
%%%%%%%%%%%%%%%%%

%\RequirePackage[table]{xcolor} % Advanced Color Control and Table coloring.
%
%\makeatletter
%% Define Color Palette (Official TUM has more Colors, but we won't use those for now)
%\definecolor{dark-grey}{cmyk}{0, 0, 0, 0.8}
%\definecolor{grey}{cmyk}{0, 0, 0, 0.5}
%\definecolor{light-grey}{cmyk}{0, 0, 0, 0.2}
%
%% "Borrowed" from https://portal.mytum.de/corporatedesign/vorlagen/index_html/vorlagen/index_farben
%\definecolor{primary}{cmyk}{1, 0.43, 0, 0}
%\definecolor{secondary}{cmyk}{1, 0.54, 0.04, 0.19}
%\definecolor{tertiary}{cmyk}{1, 0.57, 0.12, 0.7}
%\makeatother
%
%\newcommand{\cvskill}[2]{%
%	\pgfmathparse{#2}
%	\let\stars\pgfmathresult
%
%	\pgfmathparse{ceil(\stars)}
%	\let\ceilstars\pgfmathresult
%
%	\setlength{\fboxsep}{0pt}
%	\makebox[\linewidth][l]{%
%		\makebox{#1}
%		\hfill
%		\makebox{%
%			\foreach \index in {1, 2, 3, 4, 5}{%
%				\pgfmathparse{\stars >= \index}
%				\ifnum\pgfmathresult=1
%				\includegraphics[width=\fontcharht\font`A]{star_full}%
%				\else
%				\pgfmathparse{\ceilstars == \index}
%				\ifnum\pgfmathresult=1
%				\includegraphics[width=\fontcharht\font`A]{star_half}%
%				\else
%				\includegraphics[width=\fontcharht\font`A]{star_empty}%
%				\fi
%				\fi
%				\pgfmathparse{\index < 5}
%				\ifnum\pgfmathresult=1
%				\hspace{1ex}%
%				\fi
%			}%
%		}%
%	}
%}