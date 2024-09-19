namespace Auswahl_Differenz
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
            Audicon.SmartAnalyzer.Client.CustomControls.ConDecimal conDecimal1 = new Audicon.SmartAnalyzer.Client.CustomControls.ConDecimal();
            Audicon.SmartAnalyzer.Client.CustomControls.ConDecimal conDecimal2 = new Audicon.SmartAnalyzer.Client.CustomControls.ConDecimal();
            this.Button_Description = new Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp();
            this.Button_OK = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.smartLabel1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.sTBAbsDiff = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.sCBLogicalConnection = new Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox();
            this.sTBPercDiff = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.sCheckBAbsDiff = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.sCheckBPercDiff = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartGroupBox1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartGroupBox();
            this.smartGroupBox2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartGroupBox();
            this.sCB_V = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.sCB_E = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.sCB_P = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.sCB_A = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartLabel2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.sCB_empty = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartGroupBox2.SuspendLayout();
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
            // sTBAbsDiff
            // 
            this.sTBAbsDiff.AllowEmpty = true;
            conDecimal1.DefaultValue = 0D;
            this.sTBAbsDiff.Constraint = conDecimal1;
            resources.ApplyResources(this.sTBAbsDiff, "sTBAbsDiff");
            this.sTBAbsDiff.LanguageCode = "";
            this.sTBAbsDiff.Name = "sTBAbsDiff";
            this.sTBAbsDiff.ReportingName = "";
            this.sTBAbsDiff.Value = "";
            this.sTBAbsDiff.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Decimal;
            // 
            // sCBLogicalConnection
            // 
            this.sCBLogicalConnection.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            resources.ApplyResources(this.sCBLogicalConnection, "sCBLogicalConnection");
            this.sCBLogicalConnection.FormattingEnabled = true;
            this.sCBLogicalConnection.Items.AddRange(new object[] {
            resources.GetString("sCBLogicalConnection.Items"),
            resources.GetString("sCBLogicalConnection.Items1")});
            this.sCBLogicalConnection.Name = "sCBLogicalConnection";
            this.sCBLogicalConnection.ReportingName = "";
            this.sCBLogicalConnection.Selection = 0;
            // 
            // sTBPercDiff
            // 
            this.sTBPercDiff.AllowEmpty = true;
            conDecimal2.DefaultValue = 0D;
            this.sTBPercDiff.Constraint = conDecimal2;
            resources.ApplyResources(this.sTBPercDiff, "sTBPercDiff");
            this.sTBPercDiff.LanguageCode = "";
            this.sTBPercDiff.Name = "sTBPercDiff";
            this.sTBPercDiff.ReportingName = "";
            this.sTBPercDiff.Value = "";
            this.sTBPercDiff.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Decimal;
            // 
            // sCheckBAbsDiff
            // 
            resources.ApplyResources(this.sCheckBAbsDiff, "sCheckBAbsDiff");
            this.sCheckBAbsDiff.Enables = new string[] {
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
            this.sCheckBAbsDiff.Name = "sCheckBAbsDiff";
            this.sCheckBAbsDiff.ReportingName = "";
            this.sCheckBAbsDiff.UseVisualStyleBackColor = true;
            this.sCheckBAbsDiff.CheckedChanged += new System.EventHandler(this.sCheckBAbsDiff_CheckedChanged);
            // 
            // sCheckBPercDiff
            // 
            resources.ApplyResources(this.sCheckBPercDiff, "sCheckBPercDiff");
            this.sCheckBPercDiff.Enables = new string[] {
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
            this.sCheckBPercDiff.Name = "sCheckBPercDiff";
            this.sCheckBPercDiff.ReportingName = "";
            this.sCheckBPercDiff.UseVisualStyleBackColor = true;
            this.sCheckBPercDiff.CheckedChanged += new System.EventHandler(this.sCheckBPercDiff_CheckedChanged);
            // 
            // smartGroupBox1
            // 
            resources.ApplyResources(this.smartGroupBox1, "smartGroupBox1");
            this.smartGroupBox1.Name = "smartGroupBox1";
            this.smartGroupBox1.TabStop = false;
            // 
            // smartGroupBox2
            // 
            this.smartGroupBox2.Controls.Add(this.sCB_empty);
            this.smartGroupBox2.Controls.Add(this.sCB_V);
            this.smartGroupBox2.Controls.Add(this.sCB_E);
            this.smartGroupBox2.Controls.Add(this.sCB_P);
            this.smartGroupBox2.Controls.Add(this.sCB_A);
            this.smartGroupBox2.Controls.Add(this.smartLabel2);
            resources.ApplyResources(this.smartGroupBox2, "smartGroupBox2");
            this.smartGroupBox2.Name = "smartGroupBox2";
            this.smartGroupBox2.TabStop = false;
            // 
            // sCB_V
            // 
            resources.ApplyResources(this.sCB_V, "sCB_V");
            this.sCB_V.Enables = new string[] {
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
            this.sCB_V.IsOptional = true;
            this.sCB_V.Name = "sCB_V";
            this.sCB_V.ReportingName = "V - Verlust/Aufwand";
            this.sCB_V.UseVisualStyleBackColor = true;
            this.sCB_V.CheckedChanged += new System.EventHandler(this.PositionChoice_CheckChanged);
            // 
            // sCB_E
            // 
            resources.ApplyResources(this.sCB_E, "sCB_E");
            this.sCB_E.Enables = new string[] {
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
            this.sCB_E.IsOptional = true;
            this.sCB_E.Name = "sCB_E";
            this.sCB_E.ReportingName = "E - Ertrag";
            this.sCB_E.UseVisualStyleBackColor = true;
            this.sCB_E.CheckedChanged += new System.EventHandler(this.PositionChoice_CheckChanged);
            // 
            // sCB_P
            // 
            resources.ApplyResources(this.sCB_P, "sCB_P");
            this.sCB_P.Enables = new string[] {
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
            this.sCB_P.IsOptional = true;
            this.sCB_P.Name = "sCB_P";
            this.sCB_P.ReportingName = "P - Passiva";
            this.sCB_P.UseVisualStyleBackColor = true;
            this.sCB_P.CheckedChanged += new System.EventHandler(this.PositionChoice_CheckChanged);
            // 
            // sCB_A
            // 
            resources.ApplyResources(this.sCB_A, "sCB_A");
            this.sCB_A.Enables = new string[] {
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
            this.sCB_A.IsOptional = true;
            this.sCB_A.Name = "sCB_A";
            this.sCB_A.ReportingName = "A - Aktiva";
            this.sCB_A.UseVisualStyleBackColor = true;
            this.sCB_A.CheckedChanged += new System.EventHandler(this.PositionChoice_CheckChanged);
            // 
            // smartLabel2
            // 
            resources.ApplyResources(this.smartLabel2, "smartLabel2");
            this.smartLabel2.Name = "smartLabel2";
            // 
            // sCB_empty
            // 
            resources.ApplyResources(this.sCB_empty, "sCB_empty");
            this.sCB_empty.Enables = new string[] {
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
            this.sCB_empty.Name = "sCB_empty";
            this.sCB_empty.ReportingName = "";
            this.sCB_empty.UseVisualStyleBackColor = true;
            // 
            // _DialogMainForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.smartGroupBox2);
            this.Controls.Add(this.sCheckBPercDiff);
            this.Controls.Add(this.sCheckBAbsDiff);
            this.Controls.Add(this.sTBPercDiff);
            this.Controls.Add(this.sCBLogicalConnection);
            this.Controls.Add(this.sTBAbsDiff);
            this.Controls.Add(this.smartLabel1);
            this.Controls.Add(this.Button_Cancel);
            this.Controls.Add(this.Button_OK);
            this.Controls.Add(this.Button_Description);
            this.Controls.Add(this.smartGroupBox1);
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
            this.smartGroupBox2.ResumeLayout(false);
            this.smartGroupBox2.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp Button_Description;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_OK;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_Cancel;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox sTBAbsDiff;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox sCBLogicalConnection;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox sTBPercDiff;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCheckBAbsDiff;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCheckBPercDiff;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartGroupBox smartGroupBox1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartGroupBox smartGroupBox2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCB_V;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCB_E;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCB_P;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCB_A;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCB_empty;
    }
}

