namespace Dialog
{
    partial class MacroForm
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MacroForm));
            Audicon.SmartAnalyzer.Client.CustomControls.ConString conString1 = new Audicon.SmartAnalyzer.Client.CustomControls.ConString();
            Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric conNumeric1 = new Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric();
            Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric conNumeric2 = new Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric();
            Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric conNumeric3 = new Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric();
            this.Button_Description = new Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.smartComboBox1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox();
            this.smartLabel12 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.smartLabel13 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.smartTextBox1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.btnBrowse = new System.Windows.Forms.Button();
            this.dataExchanger = new Audicon.SmartAnalyzer.Client.CustomControls.SmartDataExchanger();
            this.Button_OK = new System.Windows.Forms.Button();
            this.smartToolTip1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartToolTip();
            this.smartCheckBox1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartTextBox2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.smartCheckBox2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartTextBox3 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.smartComboBox2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox();
            this.smartCheckBox3 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartTextBox4 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.SuspendLayout();
            // 
            // Button_Description
            // 
            resources.ApplyResources(this.Button_Description, "Button_Description");
            this.Button_Description.HelpId = null;
            this.Button_Description.Name = "Button_Description";
            this.Button_Description.UseVisualStyleBackColor = true;
            // 
            // Button_Cancel
            // 
            resources.ApplyResources(this.Button_Cancel, "Button_Cancel");
            this.Button_Cancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.Button_Cancel.Name = "Button_Cancel";
            this.Button_Cancel.ResultType = Audicon.SmartAnalyzer.Client.CustomControls.DiagResult.Cancel;
            this.Button_Cancel.UseVisualStyleBackColor = true;
            // 
            // smartComboBox1
            // 
            this.smartComboBox1.AssignedTag = "GLAccountNumber";
            this.smartComboBox1.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            resources.ApplyResources(this.smartComboBox1, "smartComboBox1");
            this.smartComboBox1.FormattingEnabled = true;
            this.smartComboBox1.Name = "smartComboBox1";
            this.smartComboBox1.ReportingName = "";
            this.smartComboBox1.Selection = -1;
            this.smartComboBox1.TagGroup = new string[] {
        "GLAccountNumber"};
            this.smartComboBox1.SelectedIndexChanged += new System.EventHandler(this.smartComboBox_SelectedIndexChanged);
            // 
            // smartLabel12
            // 
            resources.ApplyResources(this.smartLabel12, "smartLabel12");
            this.smartLabel12.Name = "smartLabel12";
            // 
            // smartLabel13
            // 
            resources.ApplyResources(this.smartLabel13, "smartLabel13");
            this.smartLabel13.Name = "smartLabel13";
            // 
            // smartTextBox1
            // 
            this.smartTextBox1.Constraint = conString1;
            resources.ApplyResources(this.smartTextBox1, "smartTextBox1");
            this.smartTextBox1.LanguageCode = "";
            this.smartTextBox1.Name = "smartTextBox1";
            this.smartTextBox1.ReportingName = "";
            this.smartTextBox1.Value = "";
            this.smartTextBox1.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.String;
            this.smartTextBox1.OnTextChanged += new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox.TextChangedHandler(this.smartTextBox1_OnTextChanged);
            // 
            // btnBrowse
            // 
            resources.ApplyResources(this.btnBrowse, "btnBrowse");
            this.btnBrowse.Name = "btnBrowse";
            this.smartToolTip1.SetToolTip(this.btnBrowse, resources.GetString("btnBrowse.ToolTip"));
            this.btnBrowse.UseVisualStyleBackColor = true;
            this.btnBrowse.Click += new System.EventHandler(this.btnBrowse_Click);
            // 
            // dataExchanger
            // 
            this.dataExchanger.Name = "dataExchanger";
            this.dataExchanger.ReportingName = null;
            this.dataExchanger.ReportingValue = "";
            // 
            // Button_OK
            // 
            resources.ApplyResources(this.Button_OK, "Button_OK");
            this.Button_OK.Name = "Button_OK";
            this.Button_OK.UseVisualStyleBackColor = true;
            this.Button_OK.Click += new System.EventHandler(this.Button_OK_Click);
            // 
            // smartToolTip1
            // 
            this.smartToolTip1.OwnerDraw = true;
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
            this.smartCheckBox1.ReportingName = "";
            this.smartCheckBox1.UseVisualStyleBackColor = true;
            this.smartCheckBox1.CheckedChanged += new System.EventHandler(this.smartCheckBox1_CheckedChanged);
            // 
            // smartTextBox2
            // 
            this.smartTextBox2.AllowEmpty = true;
            conNumeric1.DefaultValue = ((long)(0));
            this.smartTextBox2.Constraint = conNumeric1;
            resources.ApplyResources(this.smartTextBox2, "smartTextBox2");
            this.smartTextBox2.LanguageCode = "";
            this.smartTextBox2.Name = "smartTextBox2";
            this.smartTextBox2.ReportingName = "";
            this.smartTextBox2.Value = "";
            this.smartTextBox2.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Numeric;
            // 
            // smartCheckBox2
            // 
            resources.ApplyResources(this.smartCheckBox2, "smartCheckBox2");
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
            this.smartCheckBox2.Name = "smartCheckBox2";
            this.smartCheckBox2.ReportingName = "";
            this.smartCheckBox2.UseVisualStyleBackColor = true;
            this.smartCheckBox2.CheckedChanged += new System.EventHandler(this.smartCheckBox2_CheckedChanged);
            // 
            // smartTextBox3
            // 
            this.smartTextBox3.AllowEmpty = true;
            conNumeric2.DefaultValue = ((long)(0));
            this.smartTextBox3.Constraint = conNumeric2;
            resources.ApplyResources(this.smartTextBox3, "smartTextBox3");
            this.smartTextBox3.LanguageCode = "";
            this.smartTextBox3.Name = "smartTextBox3";
            this.smartTextBox3.ReportingName = "";
            this.smartTextBox3.Value = "";
            this.smartTextBox3.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Numeric;
            // 
            // smartComboBox2
            // 
            this.smartComboBox2.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            resources.ApplyResources(this.smartComboBox2, "smartComboBox2");
            this.smartComboBox2.FormattingEnabled = true;
            this.smartComboBox2.Items.AddRange(new object[] {
            resources.GetString("smartComboBox2.Items"),
            resources.GetString("smartComboBox2.Items1")});
            this.smartComboBox2.Name = "smartComboBox2";
            this.smartComboBox2.ReportingName = "";
            this.smartComboBox2.Selection = 0;
            // 
            // smartCheckBox3
            // 
            resources.ApplyResources(this.smartCheckBox3, "smartCheckBox3");
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
            this.smartCheckBox3.Name = "smartCheckBox3";
            this.smartCheckBox3.ReportingName = "";
            this.smartCheckBox3.UseVisualStyleBackColor = true;
            this.smartCheckBox3.CheckedChanged += new System.EventHandler(this.smartCheckBox3_CheckedChanged);
            // 
            // smartTextBox4
            // 
            this.smartTextBox4.AllowEmpty = true;
            conNumeric3.DefaultValue = ((long)(0));
            this.smartTextBox4.Constraint = conNumeric3;
            resources.ApplyResources(this.smartTextBox4, "smartTextBox4");
            this.smartTextBox4.LanguageCode = "";
            this.smartTextBox4.Name = "smartTextBox4";
            this.smartTextBox4.ReportingName = "";
            this.smartTextBox4.Value = "";
            this.smartTextBox4.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Numeric;
            // 
            // MacroForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.smartTextBox4);
            this.Controls.Add(this.smartCheckBox3);
            this.Controls.Add(this.smartComboBox2);
            this.Controls.Add(this.smartTextBox3);
            this.Controls.Add(this.smartCheckBox2);
            this.Controls.Add(this.smartTextBox2);
            this.Controls.Add(this.smartCheckBox1);
            this.Controls.Add(this.Button_OK);
            this.Controls.Add(this.btnBrowse);
            this.Controls.Add(this.smartTextBox1);
            this.Controls.Add(this.smartLabel13);
            this.Controls.Add(this.smartLabel12);
            this.Controls.Add(this.smartComboBox1);
            this.Controls.Add(this.Button_Cancel);
            this.Controls.Add(this.Button_Description);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "MacroForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Load += new System.EventHandler(this.MacroForm_Load);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.MacroForm_KeyDown);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp Button_Description;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_Cancel;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox smartComboBox1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel12;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel13;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox smartTextBox1;
        private System.Windows.Forms.Button btnBrowse;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartDataExchanger dataExchanger;
        private System.Windows.Forms.Button Button_OK;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartToolTip smartToolTip1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox smartCheckBox1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox smartTextBox2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox smartCheckBox2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox smartTextBox3;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox smartComboBox2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox smartCheckBox3;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox smartTextBox4;
    }
}

