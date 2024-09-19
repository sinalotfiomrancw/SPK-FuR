namespace Import_OBR_Vergleich
{
    partial class _DialogMainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(_DialogMainForm));
            Audicon.SmartAnalyzer.Client.CustomControls.ConString conString5 = new Audicon.SmartAnalyzer.Client.CustomControls.ConString();
            Audicon.SmartAnalyzer.Client.CustomControls.ConString conString6 = new Audicon.SmartAnalyzer.Client.CustomControls.ConString();
            Audicon.SmartAnalyzer.Client.CustomControls.ConString conString7 = new Audicon.SmartAnalyzer.Client.CustomControls.ConString();
            Audicon.SmartAnalyzer.Client.CustomControls.ConString conString8 = new Audicon.SmartAnalyzer.Client.CustomControls.ConString();
            this.Button_Description = new Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp();
            this.Button_OK = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.smartLabel1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.smartLabel2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.aktuellesGeschäftsjahr = new Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox();
            this.aktuellesGJAHROBR = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.aktuellesGJAHRSearchOBR = new System.Windows.Forms.Button();
            this.smartLabel4 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.aktuellesGJAHRUmsetzungen = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.aktuellesGJAHRSearchUmsetzungen = new System.Windows.Forms.Button();
            this.vorherigesGJAHRSearchUmsetzungen = new System.Windows.Forms.Button();
            this.vorherigesGJAHRUmsetzungen = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.smartLabel5 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.vorherigesGJAHRSearchOBR = new System.Windows.Forms.Button();
            this.vorherigesGJAHROBR = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.smartLabel7 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.smartLabel8 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.vorherigesGeschäftsjahr = new Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.aktuellesGJAHRCSV = new System.Windows.Forms.RadioButton();
            this.aktuellesGJAHRCurrentProject = new System.Windows.Forms.RadioButton();
            this.aktuellesGJAHRDifferentProject = new System.Windows.Forms.RadioButton();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.vorherigesGJAHRDifferentProject = new System.Windows.Forms.RadioButton();
            this.vorherigesGJAHRCSV = new System.Windows.Forms.RadioButton();
            this.vorherigesGJAHRCurrentProject = new System.Windows.Forms.RadioButton();
            this.smartDataExchanger1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartDataExchanger();
            this.overrideGJAHRaktuell = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.aktuellesGJAHROBRcurrent = new System.Windows.Forms.ComboBox();
            this.vorherigesGJAHROBRcurrent = new System.Windows.Forms.ComboBox();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.SuspendLayout();
            // 
            // Button_Description
            // 
            resources.ApplyResources(this.Button_Description, "Button_Description");
            this.Button_Description.HelpId = null;
            this.Button_Description.Name = "Button_Description";
            this.Button_Description.UseVisualStyleBackColor = true;
            // 
            // Button_OK
            // 
            resources.ApplyResources(this.Button_OK, "Button_OK");
            this.Button_OK.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.Button_OK.Name = "Button_OK";
            this.Button_OK.ResultType = Audicon.SmartAnalyzer.Client.CustomControls.DiagResult.OK;
            this.Button_OK.UseVisualStyleBackColor = true;
            this.Button_OK.Click += new System.EventHandler(this.Button_OK_Click);
            // 
            // Button_Cancel
            // 
            resources.ApplyResources(this.Button_Cancel, "Button_Cancel");
            this.Button_Cancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.Button_Cancel.Name = "Button_Cancel";
            this.Button_Cancel.ResultType = Audicon.SmartAnalyzer.Client.CustomControls.DiagResult.Cancel;
            this.Button_Cancel.UseVisualStyleBackColor = true;
            // 
            // smartLabel1
            // 
            resources.ApplyResources(this.smartLabel1, "smartLabel1");
            this.smartLabel1.Name = "smartLabel1";
            // 
            // smartLabel2
            // 
            resources.ApplyResources(this.smartLabel2, "smartLabel2");
            this.smartLabel2.Name = "smartLabel2";
            // 
            // aktuellesGeschäftsjahr
            // 
            this.aktuellesGeschäftsjahr.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            resources.ApplyResources(this.aktuellesGeschäftsjahr, "aktuellesGeschäftsjahr");
            this.aktuellesGeschäftsjahr.FormattingEnabled = true;
            this.aktuellesGeschäftsjahr.Items.AddRange(new object[] {
            resources.GetString("aktuellesGeschäftsjahr.Items"),
            resources.GetString("aktuellesGeschäftsjahr.Items1"),
            resources.GetString("aktuellesGeschäftsjahr.Items2"),
            resources.GetString("aktuellesGeschäftsjahr.Items3"),
            resources.GetString("aktuellesGeschäftsjahr.Items4"),
            resources.GetString("aktuellesGeschäftsjahr.Items5"),
            resources.GetString("aktuellesGeschäftsjahr.Items6"),
            resources.GetString("aktuellesGeschäftsjahr.Items7"),
            resources.GetString("aktuellesGeschäftsjahr.Items8"),
            resources.GetString("aktuellesGeschäftsjahr.Items9"),
            resources.GetString("aktuellesGeschäftsjahr.Items10"),
            resources.GetString("aktuellesGeschäftsjahr.Items11"),
            resources.GetString("aktuellesGeschäftsjahr.Items12"),
            resources.GetString("aktuellesGeschäftsjahr.Items13"),
            resources.GetString("aktuellesGeschäftsjahr.Items14"),
            resources.GetString("aktuellesGeschäftsjahr.Items15"),
            resources.GetString("aktuellesGeschäftsjahr.Items16"),
            resources.GetString("aktuellesGeschäftsjahr.Items17"),
            resources.GetString("aktuellesGeschäftsjahr.Items18"),
            resources.GetString("aktuellesGeschäftsjahr.Items19"),
            resources.GetString("aktuellesGeschäftsjahr.Items20"),
            resources.GetString("aktuellesGeschäftsjahr.Items21")});
            this.aktuellesGeschäftsjahr.Name = "aktuellesGeschäftsjahr";
            this.aktuellesGeschäftsjahr.ReportingName = "";
            this.aktuellesGeschäftsjahr.Selection = 21;
            // 
            // aktuellesGJAHROBR
            // 
            this.aktuellesGJAHROBR.Constraint = conString5;
            resources.ApplyResources(this.aktuellesGJAHROBR, "aktuellesGJAHROBR");
            this.aktuellesGJAHROBR.IsOptional = true;
            this.aktuellesGJAHROBR.LanguageCode = "";
            this.aktuellesGJAHROBR.Name = "aktuellesGJAHROBR";
            this.aktuellesGJAHROBR.ReportingName = "";
            this.aktuellesGJAHROBR.Value = "";
            this.aktuellesGJAHROBR.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.String;
            // 
            // aktuellesGJAHRSearchOBR
            // 
            resources.ApplyResources(this.aktuellesGJAHRSearchOBR, "aktuellesGJAHRSearchOBR");
            this.aktuellesGJAHRSearchOBR.Name = "aktuellesGJAHRSearchOBR";
            this.aktuellesGJAHRSearchOBR.UseVisualStyleBackColor = true;
            this.aktuellesGJAHRSearchOBR.Click += new System.EventHandler(this.aktuellesGJAHRSearchOBR_Click);
            // 
            // smartLabel4
            // 
            resources.ApplyResources(this.smartLabel4, "smartLabel4");
            this.smartLabel4.Name = "smartLabel4";
            // 
            // aktuellesGJAHRUmsetzungen
            // 
            this.aktuellesGJAHRUmsetzungen.Constraint = conString6;
            resources.ApplyResources(this.aktuellesGJAHRUmsetzungen, "aktuellesGJAHRUmsetzungen");
            this.aktuellesGJAHRUmsetzungen.LanguageCode = "";
            this.aktuellesGJAHRUmsetzungen.Name = "aktuellesGJAHRUmsetzungen";
            this.aktuellesGJAHRUmsetzungen.ReportingName = "";
            this.aktuellesGJAHRUmsetzungen.Value = "";
            this.aktuellesGJAHRUmsetzungen.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.String;
            // 
            // aktuellesGJAHRSearchUmsetzungen
            // 
            resources.ApplyResources(this.aktuellesGJAHRSearchUmsetzungen, "aktuellesGJAHRSearchUmsetzungen");
            this.aktuellesGJAHRSearchUmsetzungen.Name = "aktuellesGJAHRSearchUmsetzungen";
            this.aktuellesGJAHRSearchUmsetzungen.UseVisualStyleBackColor = true;
            this.aktuellesGJAHRSearchUmsetzungen.Click += new System.EventHandler(this.aktuellesGJAHRSearchUmsetzungen_Click);
            // 
            // vorherigesGJAHRSearchUmsetzungen
            // 
            resources.ApplyResources(this.vorherigesGJAHRSearchUmsetzungen, "vorherigesGJAHRSearchUmsetzungen");
            this.vorherigesGJAHRSearchUmsetzungen.Name = "vorherigesGJAHRSearchUmsetzungen";
            this.vorherigesGJAHRSearchUmsetzungen.UseVisualStyleBackColor = true;
            this.vorherigesGJAHRSearchUmsetzungen.Click += new System.EventHandler(this.vorherigesGJAHRSearchUmsetzungen_Click);
            // 
            // vorherigesGJAHRUmsetzungen
            // 
            this.vorherigesGJAHRUmsetzungen.Constraint = conString7;
            resources.ApplyResources(this.vorherigesGJAHRUmsetzungen, "vorherigesGJAHRUmsetzungen");
            this.vorherigesGJAHRUmsetzungen.LanguageCode = "";
            this.vorherigesGJAHRUmsetzungen.Name = "vorherigesGJAHRUmsetzungen";
            this.vorherigesGJAHRUmsetzungen.ReportingName = "";
            this.vorherigesGJAHRUmsetzungen.Value = "";
            this.vorherigesGJAHRUmsetzungen.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.String;
            // 
            // smartLabel5
            // 
            resources.ApplyResources(this.smartLabel5, "smartLabel5");
            this.smartLabel5.Name = "smartLabel5";
            // 
            // vorherigesGJAHRSearchOBR
            // 
            resources.ApplyResources(this.vorherigesGJAHRSearchOBR, "vorherigesGJAHRSearchOBR");
            this.vorherigesGJAHRSearchOBR.Name = "vorherigesGJAHRSearchOBR";
            this.vorherigesGJAHRSearchOBR.UseVisualStyleBackColor = true;
            this.vorherigesGJAHRSearchOBR.Click += new System.EventHandler(this.vorherigesGJAHRSearchOBR_Click);
            // 
            // vorherigesGJAHROBR
            // 
            this.vorherigesGJAHROBR.Constraint = conString8;
            resources.ApplyResources(this.vorherigesGJAHROBR, "vorherigesGJAHROBR");
            this.vorherigesGJAHROBR.IsOptional = true;
            this.vorherigesGJAHROBR.LanguageCode = "";
            this.vorherigesGJAHROBR.Name = "vorherigesGJAHROBR";
            this.vorherigesGJAHROBR.ReportingName = "";
            this.vorherigesGJAHROBR.Value = "";
            this.vorherigesGJAHROBR.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.String;
            // 
            // smartLabel7
            // 
            resources.ApplyResources(this.smartLabel7, "smartLabel7");
            this.smartLabel7.Name = "smartLabel7";
            // 
            // smartLabel8
            // 
            resources.ApplyResources(this.smartLabel8, "smartLabel8");
            this.smartLabel8.Name = "smartLabel8";
            // 
            // vorherigesGeschäftsjahr
            // 
            this.vorherigesGeschäftsjahr.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            resources.ApplyResources(this.vorherigesGeschäftsjahr, "vorherigesGeschäftsjahr");
            this.vorherigesGeschäftsjahr.FormattingEnabled = true;
            this.vorherigesGeschäftsjahr.Items.AddRange(new object[] {
            resources.GetString("vorherigesGeschäftsjahr.Items"),
            resources.GetString("vorherigesGeschäftsjahr.Items1"),
            resources.GetString("vorherigesGeschäftsjahr.Items2"),
            resources.GetString("vorherigesGeschäftsjahr.Items3"),
            resources.GetString("vorherigesGeschäftsjahr.Items4"),
            resources.GetString("vorherigesGeschäftsjahr.Items5"),
            resources.GetString("vorherigesGeschäftsjahr.Items6"),
            resources.GetString("vorherigesGeschäftsjahr.Items7"),
            resources.GetString("vorherigesGeschäftsjahr.Items8"),
            resources.GetString("vorherigesGeschäftsjahr.Items9"),
            resources.GetString("vorherigesGeschäftsjahr.Items10"),
            resources.GetString("vorherigesGeschäftsjahr.Items11"),
            resources.GetString("vorherigesGeschäftsjahr.Items12"),
            resources.GetString("vorherigesGeschäftsjahr.Items13"),
            resources.GetString("vorherigesGeschäftsjahr.Items14"),
            resources.GetString("vorherigesGeschäftsjahr.Items15"),
            resources.GetString("vorherigesGeschäftsjahr.Items16"),
            resources.GetString("vorherigesGeschäftsjahr.Items17"),
            resources.GetString("vorherigesGeschäftsjahr.Items18"),
            resources.GetString("vorherigesGeschäftsjahr.Items19"),
            resources.GetString("vorherigesGeschäftsjahr.Items20"),
            resources.GetString("vorherigesGeschäftsjahr.Items21")});
            this.vorherigesGeschäftsjahr.Name = "vorherigesGeschäftsjahr";
            this.vorherigesGeschäftsjahr.ReportingName = "";
            this.vorherigesGeschäftsjahr.Selection = 21;
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            // 
            // aktuellesGJAHRCSV
            // 
            resources.ApplyResources(this.aktuellesGJAHRCSV, "aktuellesGJAHRCSV");
            this.aktuellesGJAHRCSV.Checked = true;
            this.aktuellesGJAHRCSV.Name = "aktuellesGJAHRCSV";
            this.aktuellesGJAHRCSV.TabStop = true;
            this.aktuellesGJAHRCSV.UseVisualStyleBackColor = true;
            // 
            // aktuellesGJAHRCurrentProject
            // 
            resources.ApplyResources(this.aktuellesGJAHRCurrentProject, "aktuellesGJAHRCurrentProject");
            this.aktuellesGJAHRCurrentProject.Name = "aktuellesGJAHRCurrentProject";
            this.aktuellesGJAHRCurrentProject.UseVisualStyleBackColor = true;
            // 
            // aktuellesGJAHRDifferentProject
            // 
            resources.ApplyResources(this.aktuellesGJAHRDifferentProject, "aktuellesGJAHRDifferentProject");
            this.aktuellesGJAHRDifferentProject.Name = "aktuellesGJAHRDifferentProject";
            this.aktuellesGJAHRDifferentProject.UseVisualStyleBackColor = true;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.aktuellesGJAHRDifferentProject);
            this.groupBox1.Controls.Add(this.aktuellesGJAHRCSV);
            this.groupBox1.Controls.Add(this.aktuellesGJAHRCurrentProject);
            resources.ApplyResources(this.groupBox1, "groupBox1");
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.TabStop = false;
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.vorherigesGJAHRDifferentProject);
            this.groupBox2.Controls.Add(this.vorherigesGJAHRCSV);
            this.groupBox2.Controls.Add(this.vorherigesGJAHRCurrentProject);
            resources.ApplyResources(this.groupBox2, "groupBox2");
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.TabStop = false;
            // 
            // vorherigesGJAHRDifferentProject
            // 
            resources.ApplyResources(this.vorherigesGJAHRDifferentProject, "vorherigesGJAHRDifferentProject");
            this.vorherigesGJAHRDifferentProject.Name = "vorherigesGJAHRDifferentProject";
            this.vorherigesGJAHRDifferentProject.UseVisualStyleBackColor = true;
            // 
            // vorherigesGJAHRCSV
            // 
            resources.ApplyResources(this.vorherigesGJAHRCSV, "vorherigesGJAHRCSV");
            this.vorherigesGJAHRCSV.Checked = true;
            this.vorherigesGJAHRCSV.Name = "vorherigesGJAHRCSV";
            this.vorherigesGJAHRCSV.TabStop = true;
            this.vorherigesGJAHRCSV.UseVisualStyleBackColor = true;
            // 
            // vorherigesGJAHRCurrentProject
            // 
            resources.ApplyResources(this.vorherigesGJAHRCurrentProject, "vorherigesGJAHRCurrentProject");
            this.vorherigesGJAHRCurrentProject.Name = "vorherigesGJAHRCurrentProject";
            this.vorherigesGJAHRCurrentProject.UseVisualStyleBackColor = true;
            // 
            // smartDataExchanger1
            // 
            this.smartDataExchanger1.Name = "smartDataExchanger1";
            this.smartDataExchanger1.ReportingName = null;
            this.smartDataExchanger1.ReportingValue = "";
            // 
            // overrideGJAHRaktuell
            // 
            this.overrideGJAHRaktuell.Enables = new string[] {
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null};
            resources.ApplyResources(this.overrideGJAHRaktuell, "overrideGJAHRaktuell");
            this.overrideGJAHRaktuell.Name = "overrideGJAHRaktuell";
            this.overrideGJAHRaktuell.ReportingName = "";
            this.overrideGJAHRaktuell.UseVisualStyleBackColor = true;
            this.overrideGJAHRaktuell.CheckedChanged += new System.EventHandler(this.overrideGJAHRaktuell_CheckedChanged);
            // 
            // groupBox3
            // 
            resources.ApplyResources(this.groupBox3, "groupBox3");
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.TabStop = false;
            // 
            // aktuellesGJAHROBRcurrent
            // 
            this.aktuellesGJAHROBRcurrent.FormattingEnabled = true;
            resources.ApplyResources(this.aktuellesGJAHROBRcurrent, "aktuellesGJAHROBRcurrent");
            this.aktuellesGJAHROBRcurrent.Name = "aktuellesGJAHROBRcurrent";
            // 
            // vorherigesGJAHROBRcurrent
            // 
            this.vorherigesGJAHROBRcurrent.FormattingEnabled = true;
            resources.ApplyResources(this.vorherigesGJAHROBRcurrent, "vorherigesGJAHROBRcurrent");
            this.vorherigesGJAHROBRcurrent.Name = "vorherigesGJAHROBRcurrent";
            // 
            // _DialogMainForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.vorherigesGJAHROBRcurrent);
            this.Controls.Add(this.aktuellesGJAHROBRcurrent);
            this.Controls.Add(this.overrideGJAHRaktuell);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.vorherigesGeschäftsjahr);
            this.Controls.Add(this.vorherigesGJAHRSearchUmsetzungen);
            this.Controls.Add(this.vorherigesGJAHRUmsetzungen);
            this.Controls.Add(this.smartLabel5);
            this.Controls.Add(this.vorherigesGJAHRSearchOBR);
            this.Controls.Add(this.vorherigesGJAHROBR);
            this.Controls.Add(this.smartLabel7);
            this.Controls.Add(this.smartLabel8);
            this.Controls.Add(this.aktuellesGJAHRSearchUmsetzungen);
            this.Controls.Add(this.aktuellesGJAHRUmsetzungen);
            this.Controls.Add(this.smartLabel4);
            this.Controls.Add(this.aktuellesGJAHRSearchOBR);
            this.Controls.Add(this.aktuellesGJAHROBR);
            this.Controls.Add(this.aktuellesGeschäftsjahr);
            this.Controls.Add(this.smartLabel2);
            this.Controls.Add(this.smartLabel1);
            this.Controls.Add(this.Button_Cancel);
            this.Controls.Add(this.Button_OK);
            this.Controls.Add(this.Button_Description);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.groupBox3);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "_DialogMainForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this._DialogMainForm_FormClosing);
            this.Load += new System.EventHandler(this._DialogMainForm_Load);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this._DialogMainForm_KeyDown);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp Button_Description;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_OK;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_Cancel;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox aktuellesGeschäftsjahr;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox aktuellesGJAHROBR;
        private System.Windows.Forms.Button aktuellesGJAHRSearchOBR;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel4;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox aktuellesGJAHRUmsetzungen;
        private System.Windows.Forms.Button aktuellesGJAHRSearchUmsetzungen;
        private System.Windows.Forms.Button vorherigesGJAHRSearchUmsetzungen;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox vorherigesGJAHRUmsetzungen;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel5;
        private System.Windows.Forms.Button vorherigesGJAHRSearchOBR;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox vorherigesGJAHROBR;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel7;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel8;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox vorherigesGeschäftsjahr;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.RadioButton aktuellesGJAHRCSV;
        private System.Windows.Forms.RadioButton aktuellesGJAHRCurrentProject;
        private System.Windows.Forms.RadioButton aktuellesGJAHRDifferentProject;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.RadioButton vorherigesGJAHRDifferentProject;
        private System.Windows.Forms.RadioButton vorherigesGJAHRCSV;
        private System.Windows.Forms.RadioButton vorherigesGJAHRCurrentProject;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartDataExchanger smartDataExchanger1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox overrideGJAHRaktuell;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.ComboBox aktuellesGJAHROBRcurrent;
        private System.Windows.Forms.ComboBox vorherigesGJAHROBRcurrent;
    }
}

