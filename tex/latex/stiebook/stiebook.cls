%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The StieBook Class elevates the default Book Class	%
% by adding visual Style Elements in a fancy Way.		%
% Apart from just looking better, it behaves exactly	%
% like the base class.									%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters											%
%-------------------------------------------------------%
% o Preview (flag): Draw Margins around the Page		%
% o All Options from the base Class						%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creator: Laurin Weitzel								%
% Mail: lauirn.weitzel@gmail.com						%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\NeedsTeXFormat{LaTeX2e}[1995/12/01]  							% Required in all TeX Classes. Date is arbitrary.
\ProvidesClass{stiebook}[2024/03/17 v1.0 Stienek Book Format.] 	% Define Name and Description.

%%%%%%%%%%%
% Options %
%%%%%%%%%%%

% Load advanced Options Parsing.
\RequirePackage{xkeyval}
\RequirePackage{ifthen}

% Preview adds Margins for standalone Readablility.
\newif\ifpreview
\DeclareOption{preview}{\previewtrue}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}	% Pass all Options to the book Class.
\ProcessOptions\relax  										% Process Options.

\LoadClass{book}  % Load Koma-Script Book Class.

%%%%%%%%%%%
% Imports %
%%%%%%%%%%%

\RequirePackage{microtype}	% Improves the Flow of Text.
\RequirePackage{fontspec}	% Loading Fonts into Koma-Script.
\RequirePackage{xcolor}		% Required for everthing with Visuals and Color.
\RequirePackage{geometry}	% Set Page Size and Margins.

\RequirePackage{fancyhdr}					  % Simplifies the Creation of Headers and Footers.
\RequirePackage[explicit]{titlesec}			  % Simplifies the Creation of Chapter/Section Titles.
\RequirePackage{tikz}						  % Tikz is used for everything graphical.
\usetikzlibrary{fit, calc, shapes.geometric}  % This makes Tikz much more versatile.
\RequirePackage{tikzpagenodes}				  % Adds Anchors to Pages for Tikz to use.

\RequirePackage{imakeidx}  % Create an Index.
\RequirePackage{hyperref}  % Adds Links to the pdf for quickly jumping to References.

%%%%%%%%%%%
% General %
%%%%%%%%%%%

% Set the Books main Font. Signika just looks very fancy, I love it :)
\setmainfont[
UprightFont = Signika.ttf,
BoldFont = Signika.ttf,
ItalicFont = Signika.ttf,
ItalicFeatures = {Italic=1},
BoldFeatures = {Weight=500}
]{Signika}

% Define accent Colors.
\definecolor{primary}{RGB}{142, 40, 51}
\definecolor{primaryDark}{RGB}{102, 30, 41}
\definecolor{primaryLight}{RGB}{182, 60, 71}
\definecolor{secondary}{RGB}{204, 153, 51}
\definecolor{secondaryDark}{RGB}{153, 102, 0}
\definecolor{secondaryLight}{RGB}{255, 204, 102}

% Set the Page Size and Margins.
\geometry{paperwidth=12.5cm, paperheight=20.5cm, left=2cm, right=2cm, top=2.5cm, bottom=2.5cm}

%%%%%%%%%%%%%
% Pagestyle %
%%%%%%%%%%%%%

\input{stiebookHelpers.tex}	  % Helper Functions for graphical Page Design.
\input{stiebookHeadings.tex}  % Header and Footer Design.
\input{stiebookSections.tex}  % Chapter and Section Title Design.

\setcounter{tocdepth}{1}  % Show only the Part, Chapter and Section Names in TOC.

% Improved \index Command.
% #1	-	optional	- Short Index Entry
% #2	-	required	- Long Index Entry
% Usage: \idx[short]{long} (Short is saved to Index, long is printed and highlighted
% 							if no short is specified, long will be used for both)
\newcommand{\idx}[2][]{%
	\ifx&#1&%
	\textbf{\textcolor{primary}{#2}}%
	\index{#2}%
	\else
	\textbf{\textcolor{primary}{#2}}%
	\index{#1}%
	\fi
}

% Set up hyperref. This has to happen at the end to make sure it works.
\hypersetup{colorlinks=true, linkbordercolor=primary, linkcolor=primaryDark}
\makeindex[options=-s stiebookIdxStyle.ist, intoc, columns=2]  % .../texmf/makeindex/stiebookIdxStyle.ist

\endinput  % End of stiebook Class file.
