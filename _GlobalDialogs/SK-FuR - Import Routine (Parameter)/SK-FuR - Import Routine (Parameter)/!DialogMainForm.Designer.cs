namespace SK_FuR___Import_Routine__Parameter_
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
            Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric conNumeric3 = new Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric();
            Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric conNumeric4 = new Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric();
            Audicon.SmartAnalyzer.Client.CustomControls.ConString conString3 = new Audicon.SmartAnalyzer.Client.CustomControls.ConString();
            Audicon.SmartAnalyzer.Client.CustomControls.ConString conString4 = new Audicon.SmartAnalyzer.Client.CustomControls.ConString();
            this.Button_Description = new Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp();
            this.Button_OK = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.TabPageAllgemein = new System.Windows.Forms.TabPage();
            this.smartTextBox2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.smartTextBox1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.smartLabel2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.smartLabel1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.TabPageOBRKonten = new System.Windows.Forms.TabPage();
            this.button1 = new System.Windows.Forms.Button();
            this.smartTextBox3 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.smartLabel3 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.TabPageUmsaetze = new System.Windows.Forms.TabPage();
            this.button2 = new System.Windows.Forms.Button();
            this.smartTextBox4 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.smartLabel4 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.smartToolTip1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartToolTip();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.folderBrowserDialog1 = new System.Windows.Forms.FolderBrowserDialog();
            this.smartDataExchanger1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartDataExchanger();
            this.tabControl1.SuspendLayout();
            this.TabPageAllgemein.SuspendLayout();
            this.TabPageOBRKonten.SuspendLayout();
            this.TabPageUmsaetze.SuspendLayout();
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
            // tabControl1
            // 
            this.tabControl1.Controls.Add(this.TabPageAllgemein);
            this.tabControl1.Controls.Add(this.TabPageOBRKonten);
            this.tabControl1.Controls.Add(this.TabPageUmsaetze);
            resources.ApplyResources(this.tabControl1, "tabControl1");
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            // 
            // TabPageAllgemein
            // 
            this.TabPageAllgemein.Controls.Add(this.smartTextBox2);
            this.TabPageAllgemein.Controls.Add(this.smartTextBox1);
            this.TabPageAllgemein.Controls.Add(this.smartLabel2);
            this.TabPageAllgemein.Controls.Add(this.smartLabel1);
            resources.ApplyResources(this.TabPageAllgemein, "TabPageAllgemein");
            this.TabPageAllgemein.Name = "TabPageAllgemein";
            this.TabPageAllgemein.UseVisualStyleBackColor = true;
            // 
            // smartTextBox2
            // 
            conNumeric3.DefaultValue = ((long)(0));
            this.smartTextBox2.Constraint = conNumeric3;
            resources.ApplyResources(this.smartTextBox2, "smartTextBox2");
            this.smartTextBox2.LanguageCode = "";
            this.smartTextBox2.Name = "smartTextBox2";
            this.smartTextBox2.ReportingName = "";
            this.smartTextBox2.Value = "";
            this.smartTextBox2.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Numeric;
            // 
            // smartTextBox1
            // 
            conNumeric4.DefaultValue = ((long)(0));
            this.smartTextBox1.Constraint = conNumeric4;
            resources.ApplyResources(this.smartTextBox1, "smartTextBox1");
            this.smartTextBox1.IsOptional = true;
            this.smartTextBox1.LanguageCode = "";
            this.smartTextBox1.Name = "smartTextBox1";
            this.smartTextBox1.ReportingName = "";
            this.smartTextBox1.Value = "";
            this.smartTextBox1.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Numeric;
            // 
            // smartLabel2
            // 
            resources.ApplyResources(this.smartLabel2, "smartLabel2");
            this.smartLabel2.Name = "smartLabel2";
            // 
            // smartLabel1
            // 
            resources.ApplyResources(this.smartLabel1, "smartLabel1");
            this.smartLabel1.Name = "smartLabel1";
            // 
            // TabPageOBRKonten
            // 
            this.TabPageOBRKonten.Controls.Add(this.button1);
            this.TabPageOBRKonten.Controls.Add(this.smartTextBox3);
            this.TabPageOBRKonten.Controls.Add(this.smartLabel3);
            resources.ApplyResources(this.TabPageOBRKonten, "TabPageOBRKonten");
            this.TabPageOBRKonten.Name = "TabPageOBRKonten";
            this.TabPageOBRKonten.UseVisualStyleBackColor = true;
            // 
            // button1
            // 
            resources.ApplyResources(this.button1, "button1");
            this.button1.Name = "button1";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // smartTextBox3
            // 
            this.smartTextBox3.Constraint = conString3;
            resources.ApplyResources(this.smartTextBox3, "smartTextBox3");
            this.smartTextBox3.LanguageCode = "";
            this.smartTextBox3.Name = "smartTextBox3";
            this.smartTextBox3.ReportingName = "";
            this.smartTextBox3.Value = "";
            this.smartTextBox3.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.String;
            // 
            // smartLabel3
            // 
            resources.ApplyResources(this.smartLabel3, "smartLabel3");
            this.smartLabel3.Name = "smartLabel3";
            // 
            // TabPageUmsaetze
            // 
            this.TabPageUmsaetze.Controls.Add(this.button2);
            this.TabPageUmsaetze.Controls.Add(this.smartTextBox4);
            this.TabPageUmsaetze.Controls.Add(this.smartLabel4);
            resources.ApplyResources(this.TabPageUmsaetze, "TabPageUmsaetze");
            this.TabPageUmsaetze.Name = "TabPageUmsaetze";
            this.TabPageUmsaetze.UseVisualStyleBackColor = true;
            // 
            // button2
            // 
            resources.ApplyResources(this.button2, "button2");
            this.button2.Name = "button2";
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new System.EventHandler(this.button2_Click);
            // 
            // smartTextBox4
            // 
            this.smartTextBox4.Constraint = conString4;
            resources.ApplyResources(this.smartTextBox4, "smartTextBox4");
            this.smartTextBox4.LanguageCode = "";
            this.smartTextBox4.Name = "smartTextBox4";
            this.smartTextBox4.ReportingName = "";
            this.smartTextBox4.Value = "";
            this.smartTextBox4.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.String;
            // 
            // smartLabel4
            // 
            resources.ApplyResources(this.smartLabel4, "smartLabel4");
            this.smartLabel4.Name = "smartLabel4";
            // 
            // smartToolTip1
            // 
            this.smartToolTip1.OwnerDraw = true;
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            // 
            // smartDataExchanger1
            // 
            this.smartDataExchanger1.Name = "smartDataExchanger1";
            this.smartDataExchanger1.ReportingName = null;
            this.smartDataExchanger1.ReportingValue = "";
            // 
            // _DialogMainForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.tabControl1);
            this.Controls.Add(this.Button_Cancel);
            this.Controls.Add(this.Button_OK);
            this.Controls.Add(this.Button_Description);
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
            this.tabControl1.ResumeLayout(false);
            this.TabPageAllgemein.ResumeLayout(false);
            this.TabPageAllgemein.PerformLayout();
            this.TabPageOBRKonten.ResumeLayout(false);
            this.TabPageOBRKonten.PerformLayout();
            this.TabPageUmsaetze.ResumeLayout(false);
            this.TabPageUmsaetze.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp Button_Description;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_OK;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_Cancel;
        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage TabPageAllgemein;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox smartTextBox2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox smartTextBox1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel1;
        private System.Windows.Forms.TabPage TabPageOBRKonten;
        private System.Windows.Forms.TabPage TabPageUmsaetze;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartToolTip smartToolTip1;
        private System.Windows.Forms.Button button1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox smartTextBox3;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel3;
        private System.Windows.Forms.Button button2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox smartTextBox4;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel4;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.FolderBrowserDialog folderBrowserDialog1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartDataExchanger smartDataExchanger1;
    }
}

