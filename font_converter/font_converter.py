import sys
import os
from PyQt6.QtWidgets import (
    QApplication,
    QWidget,
    QVBoxLayout,
    QLabel,
    QLineEdit,
    QPushButton,
    QFileDialog,
    QCheckBox,
    QStatusBar,
    QGridLayout,
    QMainWindow,
    QGroupBox,
    QMessageBox,
)
from PyQt6.QtCore import QSettings
import qdarktheme
import qtawesome as qta
import subprocess


class FontConverterApp(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("LaTeX Font Converter")

        # Create central widget and layout
        central_widget = QWidget()
        layout = QVBoxLayout(central_widget)

        # Menubar setup
        self.menuBar = self.menuBar()
        self.setupMenuBar()

        # Font type toggle removed
        self.isVariableFont = QCheckBox("Use Variable Font")
        self.isVariableFont.stateChanged.connect(self.toggleFontFields)

        # Static font groupbox
        self.staticGroupBox = QGroupBox("Static Font Files")
        staticLayout = QVBoxLayout(self.staticGroupBox)
        self.staticFields = self.createFontFields(["Regular TTF", "Bold TTF", "Italic TTF", "BoldItalic TTF"])
        for field in self.staticFields:
            staticLayout.addWidget(field["layout"])
        layout.addWidget(self.staticGroupBox)

        # Variable font groupbox
        self.variableGroupBox = QGroupBox("Variable Font Files")
        variableLayout = QVBoxLayout(self.variableGroupBox)
        self.variableFields = self.createFontFields(["Variable Regular TTF", "Variable Italic TTF"])
        for field in self.variableFields:
            variableLayout.addWidget(field["layout"])
        layout.addWidget(self.variableGroupBox)

        # Output texmf path groupbox
        self.outputGroupBox = QGroupBox("Output Settings")
        outputLayout = QVBoxLayout(self.outputGroupBox)
        self.outputPath = QLineEdit(self.getLastPath("texmf_path", "../texmf"))
        outputLayout.addWidget(QLabel("Output texmf Path:"))
        outputLayout.addWidget(self.outputPath)
        layout.addWidget(self.outputGroupBox)

        # Convert button with icon
        self.convertButton = QPushButton(qta.icon("fa.font", color="gray"), "Convert Fonts")
        self.convertButton.clicked.connect(self.convertFonts)
        layout.addWidget(self.convertButton)

        # Status bar setup
        self.statusBar = QStatusBar()
        self.setStatusBar(self.statusBar)

        central_widget.setLayout(layout)
        self.setCentralWidget(central_widget)

        self.toggleFontFields()

    def setupMenuBar(self):
        # Menu for selecting font type
        font_menu = self.menuBar.addMenu("Font Type")
        static_action = font_menu.addAction("Static Font")
        static_action.triggered.connect(lambda: self.isVariableFont.setChecked(False))
        variable_action = font_menu.addAction("Variable Font")
        variable_action.triggered.connect(lambda: self.isVariableFont.setChecked(True))

        # Theme menu
        theme_menu = self.menuBar.addMenu("Theme")
        light_action = theme_menu.addAction("Light")
        dark_action = theme_menu.addAction("Dark")
        auto_action = theme_menu.addAction("Auto")
        light_action.triggered.connect(lambda: self.setTheme("light"))
        dark_action.triggered.connect(lambda: self.setTheme("dark"))
        auto_action.triggered.connect(lambda: self.setTheme("auto"))

        # Help menu
        help_menu = self.menuBar.addMenu("Help")
        help_action = help_menu.addAction("About")
        help_action.triggered.connect(self.showHelp)

    def createFontFields(self, labels):
        fields = []
        for label_text in labels:
            element = QWidget()
            h_layout = QGridLayout(element)

            label = QLabel(f"{label_text} Path:")
            line_edit = QLineEdit(self.getLastPath(f"{label_text}_path", ""))
            browse_button = QPushButton(qta.icon("fa.folder-open", color="gray"), "Browse")
            browse_button.clicked.connect(lambda ch, le=line_edit, lbl=label_text: self.browseFile(le, lbl))

            h_layout.addWidget(label, 0, 0)
            h_layout.addWidget(line_edit, 0, 1)
            h_layout.addWidget(browse_button, 0, 2)

            fields.append({"layout": element, "lineEdit": line_edit})
        return fields

    def browseFile(self, lineEdit, label_text):
        file, _ = QFileDialog.getOpenFileName(self, "Select TTF Font File", "", "TTF Files (*.ttf)")
        if file:
            lineEdit.setText(file)
            self.savePath(f"{label_text}_path", file)

    def toggleFontFields(self):
        isVariable = self.isVariableFont.isChecked()
        self.staticGroupBox.setVisible(not isVariable)
        self.variableGroupBox.setVisible(isVariable)

    def convertFonts(self):
        texmf_path = self.outputPath.text()
        self.savePath("texmf_path", texmf_path)

        if not self.isVariableFont.isChecked():
            static_paths = [field["lineEdit"].text() for field in self.staticFields]
            if not static_paths[0]:
                self.statusBar.showMessage("Please specify the Regular TTF file for static fonts.", 5000)
                return

            ttf_names = ["", "Bold", "Italic", "BoldItalic"]
            for i, ttf_path in enumerate(static_paths):
                if ttf_path:
                    ttf_name = f"ecYourFont{ttf_names[i]}"
                    self.createFontFiles(
                        texmf_path, ttf_path, ttf_name, bold="Bold" in ttf_name, italic="Italic" in ttf_name
                    )

        else:
            regular_file = self.variableFields[0]["lineEdit"].text()
            italic_file = self.variableFields[1]["lineEdit"].text()
            if not regular_file:
                self.statusBar.showMessage("Please specify the Regular TTF file for variable fonts.", 5000)
                return

            self.createFontFiles(texmf_path, regular_file, "ecYourFont", bold=False, italic=False)
            if italic_file:
                self.createFontFiles(texmf_path, italic_file, "ecYourFontItalic", bold=False, italic=True)
            else:
                self.createFontFiles(texmf_path, regular_file, "ecYourFontItalic", bold=False, italic=True, slant=True)

    def createFontFiles(self, texmf_path, ttf_path, ttf_name, bold=False, italic=False, slant=False):
        output_dir_vf = os.path.join(texmf_path, "fonts/vf/ms/yourfont")
        output_dir_tfm = os.path.join(texmf_path, "fonts/tfm/ms/yourfont")
        os.makedirs(output_dir_vf, exist_ok=True)
        os.makedirs(output_dir_tfm, exist_ok=True)

        vpl_file = os.path.join(output_dir_vf, f"{ttf_name}.vpl")
        tfm_file = os.path.join(output_dir_tfm, f"{ttf_name}.tfm")
        slant_option = "-s .167" if slant else ""
        bold_option = "-E" if bold else ""

        try:
            ttf2tfm_command = (
                f'ttf2tfm "{ttf_path}" -q -T T1-WGL4.enc {slant_option} '
                f'{bold_option} -v "{vpl_file}" "{tfm_file}" >> ttfonts.map'
            )
            subprocess.run(ttf2tfm_command, shell=True, check=True)

            vf_file = os.path.join(output_dir_vf, f"{ttf_name}.vf")
            vptovf_command = f'vptovf "{vpl_file}" "{vf_file}" "{tfm_file}"'
            subprocess.run(vptovf_command, shell=True, check=True)
            os.remove(vpl_file)
            self.statusBar.showMessage(f"Generated font files for {ttf_name}", 5000)
        except subprocess.CalledProcessError as e:
            self.statusBar.showMessage(f"Error processing {ttf_name}: {e}", 5000)

    def setTheme(self, theme_name):
        qdarktheme.setup_theme(theme_name)

    def showHelp(self):
        help_message = QMessageBox()
        help_message.setWindowTitle("About")
        help_message.setText("LaTeX Font Converter helps convert TTF files for LaTeX.")
        help_message.exec()

    def savePath(self, key, value):
        settings = QSettings("FontConverterApp", "Paths")
        settings.setValue(key, value)

    def getLastPath(self, key, default=""):
        settings = QSettings("FontConverterApp", "Paths")
        return settings.value(key, default)


if __name__ == "__main__":
    app = QApplication(sys.argv)
    qdarktheme.setup_theme("auto")
    window = FontConverterApp()
    window.show()
    sys.exit(app.exec())
