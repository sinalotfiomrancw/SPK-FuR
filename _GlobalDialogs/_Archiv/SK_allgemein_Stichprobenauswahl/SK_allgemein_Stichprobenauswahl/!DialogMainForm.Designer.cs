namespace SK_allgemein_Stichprobenauswahl
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
            Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric conNumeric1 = new Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric();
            Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric conNumeric2 = new Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric();
            Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric conNumeric3 = new Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric();
            this.Button_Description = new Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp();
            this.Button_OK = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.smartCheckBox1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartTextBox1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.smartLabel1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.smartCheckBox2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartTextBox2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.smartLabel4 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.smartTextBox3 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.smartCheckBox3 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartComboBox1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox();
            this.smartDataExchanger1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartDataExchanger();
            this.smartComboBox2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox();
            this.smartLabel2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
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
            // smartCheckBox1
            // 
            resources.ApplyResources(this.smartCheckBox1, "smartCheckBox1");
            this.smartCheckBox1.Enables = new string[] {
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
            this.smartCheckBox1.Name = "smartCheckBox1";
            this.smartCheckBox1.ReportingName = "Zufallsauswahl";
            this.smartCheckBox1.ReportOrder = 1;
            this.smartCheckBox1.UseVisualStyleBackColor = true;
            this.smartCheckBox1.CheckedChanged += new System.EventHandler(this.smartCheckBox1_CheckedChanged);
            // 
            // smartTextBox1
            // 
            this.smartTextBox1.AllowEmpty = true;
            conNumeric1.DefaultValue = ((long)(0));
            this.smartTextBox1.Constraint = conNumeric1;
            resources.ApplyResources(this.smartTextBox1, "smartTextBox1");
            this.smartTextBox1.LanguageCode = "";
            this.smartTextBox1.Name = "smartTextBox1";
            this.smartTextBox1.ReportingName = "Anzahl der Stichproben";
            this.smartTextBox1.ReportOrder = 2;
            this.smartTextBox1.Value = "";
            this.smartTextBox1.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Numeric;
            // 
            // smartLabel1
            // 
            resources.ApplyResources(this.smartLabel1, "smartLabel1");
            this.smartLabel1.Name = "smartLabel1";
            // 
            // smartCheckBox2
            // 
            this.smartCheckBox2.Enables = new string[] {
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
            resources.ApplyResources(this.smartCheckBox2, "smartCheckBox2");
            this.smartCheckBox2.Name = "smartCheckBox2";
            this.smartCheckBox2.ReportingName = "Cut Off obere Grenze ( >= ):";
            this.smartCheckBox2.ReportOrder = 3;
            this.smartCheckBox2.UseVisualStyleBackColor = true;
            this.smartCheckBox2.CheckedChanged += new System.EventHandler(this.smartCheckBox2_CheckedChanged);
            // 
            // smartTextBox2
            // 
            this.smartTextBox2.AllowEmpty = true;
            this.smartTextBox2.BackColor = System.Drawing.SystemColors.ActiveCaptionText;
            resources.ApplyResources(this.smartTextBox2, "smartTextBox2");
            conNumeric2.DefaultValue = ((long)(0));
            this.smartTextBox2.Constraint = conNumeric2;
            this.smartTextBox2.LanguageCode = "";
            this.smartTextBox2.Name = "smartTextBox2";
            this.smartTextBox2.ReportingName = "Cut Off obere Grenze";
            this.smartTextBox2.ReportOrder = 4;
            this.smartTextBox2.Value = "";
            this.smartTextBox2.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Numeric;
            // 
            // smartLabel4
            // 
            resources.ApplyResources(this.smartLabel4, "smartLabel4");
            this.smartLabel4.Name = "smartLabel4";
            // 
            // smartTextBox3
            // 
            conNumeric3.DefaultValue = ((long)(0));
            this.smartTextBox3.Constraint = conNumeric3;
            resources.ApplyResources(this.smartTextBox3, "smartTextBox3");
            this.smartTextBox3.LanguageCode = "";
            this.smartTextBox3.Name = "smartTextBox3";
            this.smartTextBox3.ReportingName = "Cut Off untere Grenze";
            this.smartTextBox3.ReportOrder = 6;
            this.smartTextBox3.Value = "";
            this.smartTextBox3.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Numeric;
            // 
            // smartCheckBox3
            // 
            this.smartCheckBox3.Enables = new string[] {
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
            resources.ApplyResources(this.smartCheckBox3, "smartCheckBox3");
            this.smartCheckBox3.Name = "smartCheckBox3";
            this.smartCheckBox3.ReportingName = "Cut Off untere Grenze ( <= ):";
            this.smartCheckBox3.ReportOrder = 4;
            this.smartCheckBox3.UseVisualStyleBackColor = true;
            this.smartCheckBox3.CheckedChanged += new System.EventHandler(this.smartCheckBox3_CheckedChanged);
            // 
            // smartComboBox1
            // 
            this.smartComboBox1.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            resources.ApplyResources(this.smartComboBox1, "smartComboBox1");
            this.smartComboBox1.FormattingEnabled = true;
            this.smartComboBox1.IsOptional = true;
            this.smartComboBox1.Name = "smartComboBox1";
            this.smartComboBox1.ReportingName = "Feld für Cut Off";
            this.smartComboBox1.ReportOrder = 7;
            this.smartComboBox1.Selection = -1;
            this.smartComboBox1.SelectedIndexChanged += new System.EventHandler(this.smartComboBox1_SelectedIndexChanged);
            // 
            // smartDataExchanger1
            // 
            this.smartDataExchanger1.Name = "smartDataExchanger1";
            this.smartDataExchanger1.ReportingName = null;
            this.smartDataExchanger1.ReportingValue = "";
            // 
            // smartComboBox2
            // 
            this.smartComboBox2.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            resources.ApplyResources(this.smartComboBox2, "smartComboBox2");
            this.smartComboBox2.FormattingEnabled = true;
            this.smartComboBox2.IsOptional = true;
            this.smartComboBox2.Items.AddRange(new object[] {
            resources.GetString("smartComboBox2.Items"),
            resources.GetString("smartComboBox2.Items1")});
            this.smartComboBox2.Name = "smartComboBox2";
            this.smartComboBox2.ReportingName = "Verknüpfung";
            this.smartComboBox2.ReportOrder = 8;
            this.smartComboBox2.Selection = 0;
            // 
            // smartLabel2
            // 
            resources.ApplyResources(this.smartLabel2, "smartLabel2");
            this.smartLabel2.Name = "smartLabel2";
            // 
            // _DialogMainForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.smartLabel2);
            this.Controls.Add(this.smartComboBox2);
            this.Controls.Add(this.smartComboBox1);
            this.Controls.Add(this.smartCheckBox3);
            this.Controls.Add(this.smartTextBox3);
            this.Controls.Add(this.smartLabel4);
            this.Controls.Add(this.smartTextBox2);
            this.Controls.Add(this.smartCheckBox2);
            this.Controls.Add(this.smartLabel1);
            this.Controls.Add(this.smartTextBox1);
            this.Controls.Add(this.smartCheckBox1);
            this.Controls.Add(this.Button_Cancel);
            this.Controls.Add(this.Button_OK);
            this.Controls.Add(this.Button_Description);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "_DialogMainForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this._DialogMainForm_FormClosing);
            this.Load += new System.EventHandler(this._DialogMainForm_Load);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this._DialogMainForm_KeyDown);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp Button_Description;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_OK;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_Cancel;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox smartCheckBox1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox smartTextBox1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox smartCheckBox2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox smartTextBox2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel4;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox smartTextBox3;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox smartCheckBox3;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox smartComboBox1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartDataExchanger smartDataExchanger1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox smartComboBox2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel2;
    }
}

