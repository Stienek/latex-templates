\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{stiebook}[2024/03/17 v1.0 Stienek Book Format.]

%%%%%%%%%%%
% Options %
%%%%%%%%%%%

% Load advanced Options Parsing.
\RequirePackage{xkeyval}
\RequirePackage{xparse}
\RequirePackage{ifthen}

% Preview adds Margins for standalone Readablility.
\newif\ifpreview
\DeclareOption{preview}{\previewtrue}

% For easier Debugging. Remove when drafting a final Version.
%\newif\ifdebug
%\DeclareOption{debug}{\debugtrue}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}  % Pass all Options to scrbook.
\ProcessOptions\relax  % Process Options.

\LoadClass{book}  % Load Koma-Script Book Class.

%%%%%%%%%%%
% General %
%%%%%%%%%%%

\RequirePackage{microtype}  % Improves the Flow of Text.
\RequirePackage{fontspec}  % Loading Fonts into Koma-Script.
\RequirePackage{xcolor}  % Required for everthing with Visuals and Color.
\RequirePackage{geometry}  % Set Page Size and Margins.

% Set the Books main Font.
\setmainfont[
	UprightFont = Signika.ttf,
	BoldFont = Signika.ttf,
	ItalicFont = Signika.ttf,
	ItalicFeatures = {Italic=1},
	BoldFeatures = {Weight=700}
]{Signika}

% Define accent Colors.
\definecolor{primary}{RGB}{142, 40, 51}
\definecolor{primaryDark}{RGB}{102, 30, 41}
\definecolor{primaryLight}{RGB}{182, 60, 71}
\definecolor{secondary}{RGB}{204, 153, 51}
\definecolor{secondaryDark}{RGB}{153, 102, 0}
\definecolor{secondaryLight}{RGB}{255, 204, 102}

% Set the Page Size and Margins.
\ifpreview  % If preview == True.
	% Add an extra Margin in Preview Mode.
	\geometry{paperwidth=12.5cm, paperheight=20.5cm, left=2cm, right=2cm, top=2.5cm, bottom=2.5cm}
\else  % If preview == False.
	\geometry{paperwidth=8.5cm, paperheight=15.5cm, left=0cm, right=0cm, top=0cm, bottom=0cm}
\fi  % End \ifpreview.

%%%%%%%%%%%%%
% Pagestyle %
%%%%%%%%%%%%%

\RequirePackage{fancyhdr}
\RequirePackage{tikz}
\usetikzlibrary{fit, calc, shapes.geometric} % This makes Tikz much more versatile.
\RequirePackage{tikzpagenodes}

% Define Style Variables.
\newlength{\lineThickness}
\newlength{\lineThicknessSmall}
\newlength{\skewThickness}
\newlength{\skewThicknessSmall}
\newlength{\skewHeight}
\newlength{\skewHeightSmall}
\newlength{\lineGap}

\setlength{\lineThickness}{0.2mm}
\setlength{\lineThicknessSmall}{0.618833\lineThickness}
\setlength{\skewThickness}{1mm}
\setlength{\skewThicknessSmall}{0.618833\skewThickness}
\setlength{\skewHeight}{6mm}
\setlength{\skewHeightSmall}{0.618833\skewHeight}
\pgfmathsetmacro{\skewAngle}{45}
\setlength{\lineGap}{0.618833\lineThicknessSmall}

\newlength{\skewAnchorDX}
\newlength{\skewAnchorDY}

% Get Text Heigt and Width.
\newsavebox{\mybox}
\newdimen\textHeight
\sbox{\mybox}{\large M}
\textHeight=\ht\mybox % Get the height of the text

% Command to create 9 shifted coordinates
\newcommand{\drawSkew}[7]{%
	% Parameters:
	% #1 = Name of the coordinate set
	% #2 = Anchor node (e.g., A)
	% #3 = Anchor position (one of: N, S, E, W, NE, NW, SE, SW, center)
	% #4 = Height
	% #5 = Width
	% #6 = Angle
	% #7 = Color

	% Calculate Dimensions
	\pgfmathsetlengthmacro{\h}{#4 / 2} % Half height
	\pgfmathsetlengthmacro{\w}{#5 / 2} % Half width
	\pgfmathsetlengthmacro{\t}{(tan(#6) * #4)/2} % Tilt offset


	\ifthenelse{\equal{#3}{C}}{%
		\setlength{\skewAnchorDX}{0cm}
		\setlength{\skewAnchorDY}{0cm}
	}{%
	\ifthenelse{\equal{#3}{E}}{%
		\setlength{\skewAnchorDX}{-\w}
		\setlength{\skewAnchorDY}{0cm}
	}{%
	\ifthenelse{\equal{#3}{W}}{%
		\setlength{\skewAnchorDX}{\w}
		\setlength{\skewAnchorDY}{0cm}
	}{%
	\ifthenelse{\equal{#3}{N}}{%
		\setlength{\skewAnchorDX}{-\t}(
		\setlength{\skewAnchorDY}{-\h}
	}{%
	\ifthenelse{\equal{#3}{NE}}{%
		\setlength{\skewAnchorDX}{\dimexpr-\t-\w\relax}
		\setlength{\skewAnchorDY}{-\h}
	}{%
	\ifthenelse{\equal{#3}{NW}}{%
		\setlength{\skewAnchorDX}{\dimexpr-\t + \w\relax}
		\setlength{\skewAnchorDY}{-\h}
	}{%
	\ifthenelse{\equal{#3}{S}}{%
		\setlength{\skewAnchorDX}{\t}
		\setlength{\skewAnchorDY}{\h}
	}{%
	\ifthenelse{\equal{#3}{SE}}{%
		\setlength{\skewAnchorDX}{\dimexpr\t - \w\relax}
		\setlength{\skewAnchorDY}{\h}
	}{%
	\ifthenelse{\equal{#3}{SW}}{%
		\setlength{\skewAnchorDX}{\dimexpr\t + \w\relax}
		\setlength{\skewAnchorDY}{\h}
	}{% Default C.
		\setlength{\skewAnchorDX}{0cm}
		\setlength{\skewAnchorDY}{0cm}
	}}}}}}}}}

	% Create all Anchors.
	\path let \p1 = (#2) in
	coordinate (#1C) at (\x1 + \skewAnchorDX, \y1 + \skewAnchorDY)
	coordinate (#1E) at ([xshift={\w}] #1C)
	coordinate (#1W) at ([xshift={-\w}] #1C)
	coordinate (#1N) at ([xshift={\t}, yshift={\h}] #1C)
	coordinate (#1NE) at ([xshift={\t + \w}, yshift={\h}] #1C)
	coordinate (#1NW) at ([xshift={\t - \w}, yshift={\h}] #1C)
	coordinate (#1S) at ([xshift={-\t}, yshift={-\h}] #1C)
	coordinate (#1SE) at ([xshift={-\t + \w}, yshift={-\h}] #1C)
	coordinate (#1SW) at ([xshift={-\t - \w}, yshift={-\h}] #1C);

	% Draw the main Shape.
	\fill[#7]  (#1NE)
	-- (#1NW)
	-- (#1SW)
	-- (#1SE)
	-- cycle;
}

% Fancy Footer.
\newcommand{\fancyfooter}{
\begin{tikzpicture}[overlay,remember picture]
	% General Nodes.
	\node (footerCornerL) at (current page footer area.south west) {};
	\node (footerCornerR) at (current page footer area.south east) {};
	\node (footerCenter) at ($ (footerCornerL) !0.5! (footerCornerR) $) {};

	% Primary Outer Skew.
	\drawSkew{footerSkewPriLO}{footerCornerL}{NW}{0.5\textHeight}{\skewThickness}{-\skewAngle}{primary}
	\drawSkew{footerSkewPriRO}{footerCornerR}{NE}{0.5\textHeight}{\skewThickness}{\skewAngle}{primary}

	% Add the Text.
	\node[anchor=center, inner sep=0pt] (footerPageNumber) at (footerCenter |- footerSkewPriLOS) {\large\thepage};
	\node (footerPageNumberSW) at ([yshift={-0.5\textHeight}] footerPageNumber.west) {};
	\node (footerPageNumberSE) at ([yshift={-0.5\textHeight}] footerPageNumber.east) {};

	% Primary Inner Bottom Skew.
	\pgfmathparse{0.5\textHeight - \lineGap}
	\drawSkew{footerPriLIB}{footerPageNumberSW}{SE}{\pgfmathresult}{\skewThickness}{-\skewAngle}{primary}
	\drawSkew{footerPriRIB}{footerPageNumberSE}{SW}{\pgfmathresult}{\skewThickness}{\skewAngle}{primary}

	% Primary Inner Top Skew.
	\node (footerSkewPriLITNode) at ([yshift={\lineGap}] footerPriLIBN) {};
	\node (footerSkewPriRITNode) at ([yshift={\lineGap}] footerPriRIBN) {};
	\drawSkew{footerSkewPriLIT}{footerSkewPriLITNode}{SE}{0.5\textHeight}{\skewThickness}{\skewAngle}{primary}
	\drawSkew{footerSkewPriRIT}{footerSkewPriRITNode}{SW}{0.5\textHeight}{\skewThickness}{-\skewAngle}{primary}

	% Primary Connector Lines.
	\draw[primary, line width=\lineThickness] ([yshift=0.5\lineThickness] footerSkewPriLOS) -- ([yshift=0.5\lineThickness] footerSkewPriLITS);
	\draw[primary, line width=\lineThickness] ([yshift=0.5\lineThickness] footerSkewPriROS) -- ([yshift=0.5\lineThickness] footerSkewPriRITS);

	% Calculate Offset for Secondary Color.
	\newdimen\secondaryOffset
	\newdimen\secondaryOffsetMacro
	\pgfmathsetmacro{\secondaryOffsetMacro}{-1 * tan(\skewAngle) * (\lineThickness - \lineGap)}
	\pgfmathsetlength{\secondaryOffset}{\secondaryOffsetMacro}

	% Guides for Secondary Color.
	\node (footerSkewSecLONode) at ([xshift={\secondaryOffset}, yshift={\lineThickness + \lineGap}] footerSkewPriLOSE) {};
	\node (footerSkewSecRONode) at ([xshift={-\secondaryOffset}, yshift={\lineThickness + \lineGap}] footerSkewPriROSW) {};
	\node (footerSkewSecLINode) at ([xshift={-\secondaryOffset}, yshift={\lineThickness + \lineGap}] footerSkewPriLITSW) {};
	\node (footerSkewSecRINode) at ([xshift={\secondaryOffset}, yshift={\lineThickness + \lineGap}] footerSkewPriRITSE) {};

	% Secondary Outer Skew.
	\drawSkew{footerSkewSecLO}{footerSkewSecLONode}{SW}{0.25\textHeight}{\skewThicknessSmall}{-\skewAngle}{secondary}
	\drawSkew{footerSkewSecRO}{footerSkewSecRONode}{SE}{0.25\textHeight}{\skewThicknessSmall}{\skewAngle}{secondary}

	% Secondary Inner Skew.
	\drawSkew{footerSkewSecLI}{footerSkewSecLINode}{SE}{0.25\textHeight}{\skewThicknessSmall}{\skewAngle}{secondary}
	\drawSkew{footerSkewSecRI}{footerSkewSecRINode}{SW}{0.25\textHeight}{\skewThicknessSmall}{-\skewAngle}{secondary}

	% Secondary Connector Lines.
	\draw[secondary, line width=\lineThicknessSmall] ([yshift=0.5\lineThicknessSmall] footerSkewSecLOS)
	-- ([yshift=0.5\lineThicknessSmall] footerSkewSecLIS);
	\draw[secondary, line width=\lineThicknessSmall] ([yshift=0.5\lineThicknessSmall] footerSkewSecROS)
	-- ([yshift=0.5\lineThicknessSmall] footerSkewSecRIS);
\end{tikzpicture}
}

% Fancy Header.
\newcommand{\fancyheader}{
	\begin{tikzpicture}[overlay,remember picture]
		% General Nodes.
		\node (headerCornerL) at (current page header area.south west) {};
		\node (headerCornerR) at (current page header area.south east) {};
		\node (headerCenter) at ($ (headerCornerL) !0.5! (headerCornerR) $) {};

		% Primary Outer Skew.
		\drawSkew{headerSkewPriLO}{headerCornerL}{SW}{0.5\textHeight}{\skewThickness}{\skewAngle}{primary}
		\drawSkew{headerSkewPriRO}{headerCornerR}{SE}{0.5\textHeight}{\skewThickness}{-\skewAngle}{primary}

		% Add the Text.
		\node[anchor=base, inner sep=0pt] (chapterTitle) at (headerCenter) {\large\headmark};
		\node (headerTitleAnchor) at (headerCenter |- headerSkewPriLON) {};
		\node (headerTitleNW) at ([yshift={0.5\textHeight}] chapterTitle.west |- headerTitleAnchor) {};
		\node (headerTitleNE) at ([yshift={0.5\textHeight}] chapterTitle.east |- headerTitleAnchor) {};

		% Primary Inner Bottom Skew.
		\pgfmathparse{0.5\textHeight - \lineGap}
		\drawSkew{headerSkewPriLIT}{headerTitleNW}{NE}{\pgfmathresult}{\skewThickness}{\skewAngle}{primary}
		\drawSkew{headerSkewPriRIT}{headerTitleNE}{NW}{\pgfmathresult}{\skewThickness}{-\skewAngle}{primary}

		% Primary Inner Top Skew.
		\node (headerSkewPriLIBNode) at ([yshift={-\lineGap}] headerSkewPriLITS) {};
		\node (headerSkewPriRIBNode) at ([yshift={-\lineGap}] headerSkewPriRITS) {};
		\drawSkew{headerSkewPriLIB}{headerSkewPriLIBNode}{NE}{0.5\textHeight}{\skewThickness}{-\skewAngle}{primary}
		\drawSkew{headerSkewPriRIB}{headerSkewPriRIBNode}{NW}{0.5\textHeight}{\skewThickness}{\skewAngle}{primary}

		% Primary Connector Lines.
		\draw[primary, line width=\lineThickness] ([yshift=-0.5\lineThickness] headerSkewPriLON) -- ([yshift=-0.5\lineThickness] headerSkewPriLIBN);
		\draw[primary, line width=\lineThickness] ([yshift=-0.5\lineThickness] headerSkewPriRON) -- ([yshift=-0.5\lineThickness] headerSkewPriRIBN);

		% Calculate Offset for Secondary Color.
		\newdimen\secondaryOffset
		\newdimen\secondaryOffsetMacro
		\pgfmathsetmacro{\secondaryOffsetMacro}{-1 * tan(\skewAngle) * (\lineThickness - \lineGap)}
		\pgfmathsetlength{\secondaryOffset}{\secondaryOffsetMacro}

		% Guides for Secondary Color.
		\node (headerSkewSecOLNode) at ([xshift={\secondaryOffset}, yshift={-\lineThickness - \lineGap}] headerSkewPriLONE) {};
		\node (headerSkewSecORNode) at ([xshift={-\secondaryOffset}, yshift={-\lineThickness - \lineGap}] headerSkewPriRONW) {};
		\node (headerSkewSecILNode) at ([xshift={-\secondaryOffset}, yshift={-\lineThickness - \lineGap}] headerSkewPriLIBNW) {};
		\node (headerSkewSecIRNode) at ([xshift={\secondaryOffset}, yshift={-\lineThickness - \lineGap}] headerSkewPriRIBNE) {};

		% Secondary Outer Skew.
		\drawSkew{headerSkewSecLO}{headerSkewSecOLNode}{NW}{0.25\textHeight}{\skewThicknessSmall}{\skewAngle}{secondary}
		\drawSkew{headerSkewSecRO}{headerSkewSecORNode}{NE}{0.25\textHeight}{\skewThicknessSmall}{-\skewAngle}{secondary}

		% Secondary Inner Skew.
		\drawSkew{headerSkewSecLI}{headerSkewSecILNode}{NE}{0.25\textHeight}{\skewThicknessSmall}{-\skewAngle}{secondary}
		\drawSkew{headerSkewSecRI}{headerSkewSecIRNode}{NW}{0.25\textHeight}{\skewThicknessSmall}{\skewAngle}{secondary}

		% Secondary Connector Lines.
		\draw[secondary, line width=\lineThicknessSmall] ([yshift=-0.5\lineThicknessSmall] headerSkewSecLON)
		-- ([yshift=-0.5\lineThicknessSmall] headerSkewSecLIN);
		\draw[secondary, line width=\lineThicknessSmall] ([yshift=-0.5\lineThicknessSmall] headerSkewSecRON)
		-- ([yshift=-0.5\lineThicknessSmall] headerSkewSecRIN);
	\end{tikzpicture}
}

% New Command for Chapter Titles.
%\NewDocumentCommand{\stiechapter}{ s o m }{%
%	\IfBooleanTF{#1}{%
%		% Starred version: unnumbered chapter
%		\IfValueTF{#2}{%
%			\chapter*[#2]{#3}%
%			\markboth{}{#2}%
%			\addcontentsline{toc}{chapter}{#2}%
%		}{%
%			\chapter*{#3}%
%			\markboth{}{#3}%
%			\addcontentsline{toc}{chapter}{#3}%
%		}%
%	}{%
%		% Non-starred version: numbered chapter
%		\IfValueTF{#2}{%
%			\chapter[#2]{#3}%
%			\markboth{}{#2}%
%		}{%
%			\chapter{#3}%
%			\markboth{}{#3}%
%		}%
%	}%
%}

% Reduce margin between content and header/footer areas
\setlength{\headsep}{10pt}
\setlength{\footskip}{5pt}

% Reset Page Styles.
\pagestyle{fancy}
\fancyhf{}

\fancyhead[C]{\fancyheader}
\fancyfoot[C]{\fancyfooter}

\fancypagestyle{empty}{
	\fancyhf{}  % Remove all header and footer content
}

\fancypagestyle{plain}{
	\fancyhf{}  % Clear header and footer
	\fancyfoot[C]{\fancyfooter} % Footer on chapter pages only
}

% Redefine the chapter heading format:
%\renewcommand{\chapterlinesformat}[3]{%
%	% Here #1 = chapter number, #2 = chapter title, #3 = additional info.
%	\begin{tikzpicture}[overlay, remember picture]
%		% General Nodes.
%		\node (chapterCornerL) at ([yshift={-2.25cm}] current page text area.north west) {};
%		\node (chapterCornerR) at ([yshift={-2.25cm}] current page text area.north east) {};
%
%		% Outer Skews.
%		\drawSkew{chapterSkewPriBL}{chapterCornerL}{SW}{0.5\textHeight}{\skewThickness}{\skewAngle}{primary}
%		\drawSkew{chapterSkewPriBR}{chapterCornerR}{SE}{0.5\textHeight}{\skewThickness}{-\skewAngle}{primary}
%
%		% Primary Connector.
%		\draw[primary, line width=\lineThickness] ([yshift=-0.5\lineThickness] chapterSkewPriBLN) -- ([yshift=-0.5\lineThickness] chapterSkewPriBRN);
%
%		% Calculate Offset for Secondary Color.
%		\newdimen\secondaryOffset
%		\newdimen\secondaryOffsetMacro
%		\pgfmathsetmacro{\secondaryOffsetMacro}{-1 * tan(\skewAngle) * (\lineThickness - \lineGap)}
%		\pgfmathsetlength{\secondaryOffset}{\secondaryOffsetMacro}
%
%		% Guides for Secondary Color.
%		\node (chapterSkewSecBLNode) at ([xshift={\secondaryOffset}, yshift={-\lineThickness - \lineGap}] chapterSkewPriBLNE) {};
%		\node (chapterSkewSecBRNode) at ([xshift={-\secondaryOffset}, yshift={-\lineThickness - \lineGap}] chapterSkewPriBRNW) {};
%
%		% Secondary Outer Skew.
%		\drawSkew{chapterSkewSecBL}{chapterSkewSecBLNode}{NW}{0.25\textHeight}{\skewThicknessSmall}{\skewAngle}{secondary}
%		\drawSkew{chapterSkewSecBR}{chapterSkewSecBRNode}{NE}{0.25\textHeight}{\skewThicknessSmall}{-\skewAngle}{secondary}
%
%		% Secondary Connector.
%		\draw[secondary, line width=\lineThicknessSmall] ([yshift=-0.5\lineThicknessSmall] chapterSkewSecBLN)
%		-- ([yshift=-0.5\lineThicknessSmall] chapterSkewSecBRN);
%
%		% Primary Lower Text Border. TODO: The Offset on the Diamond isn't perfect but will work for now.
%		\node (chapterSkewPriMLNode) at ([yshift={\lineGap}]chapterSkewPriBLN) {};
%		\drawSkew{chapterSkewPriML}{chapterSkewPriMLNode}{S}{0.5\textHeight}{\skewThickness}{-\skewAngle}{primary}
%		\pgfmathparse{0.5 * 0.70711 * (tan(\skewAngle) * \textHeight - 1.41421\lineGap)}
%		\newdimen\chapterDiamondW
%		\pgfmathsetlength{\chapterDiamondW}{\pgfmathresult}
%		\node[fill=secondary, minimum width=\chapterDiamondW, minimum height=\chapterDiamondW, inner sep=0pt, rotate=45] (chapterDiamondL) at ([xshift={-0.5\lineGap}] $(chapterSkewPriBLW) !0.5! (chapterSkewPriMLW)$) {};
%
%		% Draw Title.
%		\node[anchor=south west, inner sep=0pt, text=secondary] (chapterTitleBackground) at (chapterSkewPriMLSE) {\Huge\textbf{#3}};
%		\node[anchor=center, inner sep=0pt, text=primaryDark] (chapterTitleForeground) at ([xshift=-0.2mm, yshift=0.2mm]chapterTitleBackground.center) {\Huge\textbf{#3}};
%		\node[anchor=east, inner sep=0pt, text=secondary] (chapterNum) at ([xshift=2ex]chapterTitleForeground.east -| chapterSkewPriBRNE) {\Huge\textbf{#2}};
%
%
%	\end{tikzpicture}
%
%	% Optionally add vertical space so that the chapter body doesn’t overlap:
%	\vspace*{2cm}%
%}

% Set TOC depth to include only parts, chapters, and sections
\setcounter{tocdepth}{2}

\endinput
