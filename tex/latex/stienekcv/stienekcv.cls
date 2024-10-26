% This Class File has been designed for my personal Applications.
% It has many Commands to make creating your own CV easier.
%
% Usage and Options will be explained below.
%
% Version: 1.0
% Creator: Laurin Weitzel (laurin.weitzel@gmail.com)

\NeedsTeXFormat{LaTeX2e}[2020-10-01]
\ProvidesClass{stienekcv}[2024/10/24 Professional CV Class. Designed to use LuaLaTeX.]

% Load advanced Options Parsing.
\RequirePackage{xkeyval}
\RequirePackage{ifthen}


% Draw Debug Stuff.
\newif\ifdebug
\DeclareOption{debug}{\debugtrue}

% Draw Shadows on graphical Elements.
\newif\ifdrawshadow
\DeclareOption{drawshadow}{\drawshadowtrue}

% Roundness of the CV.
\newlength{\cvcorners}
\setlength{\cvcorners}{1mm}
\DeclareOptionX{corners}{
	\ifthenelse{\equal{#1}{sharp}}{\setlength{\cvcorners}{0mm}}{
	\ifthenelse{\equal{#1}{rounded}}{\setlength{\cvcorners}{1.5mm}}{
	\ifthenelse{\equal{#1}{round}}{\setlength{\cvcorners}{8mm}}{
		\PackageWarning{stienekcv}{Valid options for corners are sharp, rounded, and round.}
		\setlength{\cvcorners}{0pt}
	}}}
}

% Accent Line Thickness.
\newlength{\cvaccentlinewidth}
\setlength{\cvaccentlinewidth}{1mm}
\DeclareOptionX{linewidth}{\setlength{\cvaccentlinewidth}{#1}}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{letter}} % Passes all unhandled Options.
\ProcessOptions\relax % Execute Code form all \DeclareOption.
\ProcessOptionsX\relax % Execute Code form all \DeclareOptionX.
\LoadClass{letter} % Load Class as Base.

%%%%%%%%%%%%
% Includes %
%%%%%%%%%%%%

% General.
\RequirePackage{calc}
\RequirePackage{microtype}

% LuaLaTeX.
\RequirePackage{ifluatex} % Use custom Font if running LuaLaTeX.

% Graphics.
\RequirePackage{pgf}
\RequirePackage{tikz}
\usetikzlibrary{shadows.blur, calc}
\RequirePackage[table]{xcolor} % Advanced Color Control and Table coloring.

% Page Setup.
\RequirePackage{geometry}

%%%%%%%%%%%%%%%%
% User Defines $
%%%%%%%%%%%%%%%%

% User Information.
\newcommand{\cvfirstname}[1]{\renewcommand{\cvfirstname}{#1}}
\newcommand{\cvlastname}[1]{\renewcommand{\cvlastname}{#1}}
\newcommand{\cvjobtitle}[1]{\renewcommand{\cvjobtitle}{#1}}

%%%%%%%%%%%
% General %
%%%%%%%%%%%

% Font Setup.
\ifluatex
	% If LuaTeX is detected, load the fontspec Package to use .ttf Fonts.
	\RequirePackage{fontspec}
	\setmainfont[
		UprightFont = Signika.ttf, 		% Base font file
		BoldFont = Signika.ttf,
		ItalicFont = Signika.ttf,
		ItalicFeatures = {Italic=1}, 	% Enable italic styling (if applicable)
		BoldFeatures = {Weight=700}, 	% Weight axis for bold
		FontFace={sb}{n}{Weight=400} 	% Adjust for other styles as needed
	]{Signika.ttf}
\else
	% Else, just use the default sans-font.
	\PackageWarning{stienekcv}{This class is designed to be used with LuaTeX. May or may not work well in PdfLaTeX.}
	\RequirePackage{helvet}
	\renewcommand{\familydefault}{\sfdefault}
\fi

% Font Size.
\newcommand{\setfontsize}[1]{\fontsize{#1}{#1 * 1.2}\selectfont}

% Page Style.
\pagestyle{empty}	% No Page Number, no Header or Footer.

% Color Definition.
\makeatletter
% Define Color Palette (Official TUM has more Colors, but we won't use those for now)
\definecolor{dark-grey}{cmyk}{0, 0, 0, 0.8}
\definecolor{grey}{cmyk}{0, 0, 0, 0.5}
\definecolor{light-grey}{cmyk}{0, 0, 0, 0.2}

% Primary Colorscheme
\definecolor{primary}{HTML}{363844}
\definecolor{secondary}{HTML}{D1C5AB}
\definecolor{tertiary}{HTML}{D1E8E2}
\makeatother

%%%%%%%%%%%%%%
% Page Setup %
%%%%%%%%%%%%%%

\newlength{\cvtopbarheight}
\newlength{\cvlargearrowdepth}
\newlength{\cvsidebarwidth}
\newlength{\cvimageinset}
\newlength{\cvshadowradius}
\setlength{\cvshadowradius}{1.5mm}

% Declare TikZ Layers
\pgfdeclarelayer{background}
\pgfdeclarelayer{foreground}
\pgfsetlayers{background, main, foreground}

% Scaled Text.
\newcommand{\titletext}{%
	\textls[0]{\setfontsize{42pt}%
		\textcolor{white}{\MakeUppercase{\cvfirstname}}%
		\hspace{0.5ex}%
		{\textcolor{secondary}{\MakeUppercase{\cvlastname}}}%
	}%
}

\newlength{\boxwidth}
\newlength{\boxheight}
\newbox\measurebox
\newcommand{\boxsize}[1]{%
	\sbox\measurebox{#1}
	\setlength{\boxwidth}{\the\wd\measurebox}
	\setlength{\boxheight}{\the\ht\measurebox}
}


% Define the custom page setup command.
\newcommand{\cvpagesetup}{%
	\boxsize{\titletext}
	\begin{tikzpicture}[%
		remember picture,
		overlay,
		every shadow/.style={
			shadow scale=1,
			shadow xshift=0pt,
			shadow yshift=0pt,
			shadow opacity=100,
			shadow blur steps=25,
			shadow blur radius=\cvshadowradius
		}
		]
		% Declare Lengths used in this Background.
		\setlength{\cvtopbarheight}{5cm}
		\setlength{\cvlargearrowdepth}{0.381966\cvtopbarheight}
		\setlength{\cvsidebarwidth}{0.381966\paperwidth}
		\setlength{\cvimageinset}{0.1\cvtopbarheight}

		% Declare key Nodes used for the Design.
		\node (TopBarTopLeft) at (current page.north west) {};
		\node (TopBarTopRight) at (current page.north east) {};
		\node (TopBarBottomLeft) at ([yshift=-\cvtopbarheight] TopBarTopLeft) {};
		\node (TopBarBottomRight) at ([yshift=-\cvtopbarheight] TopBarTopRight) {};
		\node (TopBarArrowRight) at ([xshift=\cvsidebarwidth] TopBarBottomLeft) {};
		\node (TopBarArrowTip) at ([xshift = \cvsidebarwidth / 2, yshift=-\cvlargearrowdepth] TopBarBottomLeft) {};

		\node (SideBarTopLeft) at (TopBarTopLeft) {};
		\node (SideBarTopRight) at ([xshift=\cvsidebarwidth] SideBarTopLeft) {};
		\node (SideBarBottomLeft) at (current page.south west) {};
		\node (SideBarBottomRight) at ([xshift=\cvsidebarwidth] SideBarBottomLeft) {};

		\node (ImageTopLeft) at ([xshift=\cvimageinset, yshift=-\cvimageinset] TopBarTopLeft) {};
		\node (ImageTopRight) at ([xshift=-\cvimageinset, yshift=-\cvimageinset] SideBarTopRight) {};
		\node (ImageBottomLeft) at ([xshift=\cvimageinset, yshift=\cvimageinset] TopBarBottomLeft) {};
		\node (ImageBottomRight) at ([xshift=-\cvimageinset, yshift=\cvimageinset] TopBarArrowRight) {};
		\node (ImageTip) at ([yshift=1.41421356 * \cvimageinset] TopBarArrowTip) {};
		\node (ImageCenter) at ($ ([xshift=\cvsidebarwidth / 2] TopBarTopLeft)!0.5!(TopBarArrowTip) $) {};

		% Draw the Sidebar for the small content.
		\begin{pgfonlayer}{main}
			\fill[secondary, \ifdrawshadow blur shadow\fi]
			   (SideBarTopLeft.center)
			-- (SideBarTopRight.center)
			-- (SideBarBottomRight.center)
			-- (SideBarBottomLeft.center)
			-- cycle;
		\end{pgfonlayer}

		% Draw the Topbar with an Image Field.
		\begin{pgfonlayer}{foreground}
			% Primary Color Banner with Arrow on the Side.
			\fill[primary, \ifdrawshadow blur shadow\fi]
			(TopBarTopLeft.center)
			-- (TopBarTopRight.center)
			-- (TopBarBottomRight.center)
			{[rounded corners=\cvcorners]
				-- (TopBarArrowRight.center)
				-- (TopBarArrowTip.center)
				-- (TopBarBottomLeft.center)
			}
			-- cycle;

			% Add Outline to Image.
			\newlength{\cvtotalradius}
			\setlength{\cvtotalradius}{\cvshadowradius + \cvaccentlinewidth}
			\draw[secondary,
				  rounded corners=\cvcorners,
				  line width=2 * \cvaccentlinewidth,
				  \ifdrawshadow
				  	blur shadow,
				  	shadow blur radius=\cvtotalradius,
				  	shadow opacity=100
				  \fi
				 ]
			(ImageTopLeft.center)
			-- (ImageTopRight.center)
			-- (ImageBottomRight.center)
			-- (ImageTip.center)
			-- (ImageBottomLeft.center)
			-- cycle;

			% Add Image with optional Outline.
			\begin{scope} % Cliping environnment.
				\clip[rounded corners=\cvcorners] % Cutout Outline.
				   (ImageTopLeft.center)
				-- (ImageTopRight.center)
				-- (ImageBottomRight.center)
				-- (ImageTip.center)
				-- (ImageBottomLeft.center)
				-- cycle;

				% Add the Image to the Cutout Zone.
				\node at (ImageCenter.center) {\includegraphics[width=\cvsidebarwidth]{Profile}};
			\end{scope}

			% Add Title and Subtitle

			\pgfmathparse{(\paperwidth - \cvsidebarwidth - 3 * \cvimageinset)/\boxwidth}

			\node[inner sep=0pt] (TopTitleBottomLeft) at ([xshift=\cvimageinset, yshift=\cvimageinset / 2]$ (TopBarArrowRight)!0.5!(SideBarTopRight) $) [anchor=south west] {\scalebox{\pgfmathresult}{\titletext}};
			\node[inner sep=0pt] (BottomTitleTopLeft) at ([xshift=\cvimageinset, yshift=-\cvimageinset / 2]$ (TopBarArrowRight)!0.5!(SideBarTopRight) $) [anchor=north west] {
				\setfontsize{24pt}\textcolor{white}{\cvjobtitle}
			};

			\ifdebug % Draw Boxes in Debug Mode.
				\draw  (TopTitleBottomLeft.south west)
					-- (TopTitleBottomLeft.north west)
					-- (TopTitleBottomLeft.north east)
					-- (TopTitleBottomLeft.south east)
					-- cycle;
				\draw  (BottomTitleTopLeft.south west)
					-- (BottomTitleTopLeft.north west)
					-- (BottomTitleTopLeft.north east)
					-- (BottomTitleTopLeft.south east)
					-- cycle;
			\fi
		\end{pgfonlayer}
	\end{tikzpicture}
}

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

