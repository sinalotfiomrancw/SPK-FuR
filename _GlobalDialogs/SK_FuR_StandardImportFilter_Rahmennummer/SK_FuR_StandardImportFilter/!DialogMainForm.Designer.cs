namespace SK_FuR_StandardImportFilter
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
            Audicon.SmartAnalyzer.Client.CustomControls.ConString conString1 = new Audicon.SmartAnalyzer.Client.CustomControls.ConString();
            this.Button_OK = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.AccountList = new Audicon.SmartAnalyzer.Client.CustomControls.SmartFromToList();
            this.smartLabel2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.AccountFilter = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.RahmenFilter = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.RahmenList = new Audicon.SmartAnalyzer.Client.CustomControls.SmartFromToList();
            this.smartLabel1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.smartDataExchanger1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartDataExchanger();
            this.SuspendLayout();
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
            // AccountList
            // 
            this.AccountList.AllowEmpty = true;
            this.AccountList.Caption = "Kontonummer:";
            this.AccountList.CaptionFrom = "Von/Einzelwert:";
            this.AccountList.CaptionTo = "Bis:";
            conNumeric1.DefaultValue = ((long)(0));
            this.AccountList.Constraint = conNumeric1;
            resources.ApplyResources(this.AccountList, "AccountList");
            this.AccountList.IsOptional = false;
            this.AccountList.Name = "AccountList";
            this.AccountList.ParameterName = null;
            this.AccountList.ReportingName = "";
            this.AccountList.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Numeric;
            // 
            // smartLabel2
            // 
            resources.ApplyResources(this.smartLabel2, "smartLabel2");
            this.smartLabel2.Name = "smartLabel2";
            // 
            // AccountFilter
            // 
            resources.ApplyResources(this.AccountFilter, "AccountFilter");
            this.AccountFilter.Enables = new string[] {
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
            this.AccountFilter.Name = "AccountFilter";
            this.AccountFilter.ReportingName = "";
            this.AccountFilter.UseVisualStyleBackColor = true;
            this.AccountFilter.CheckedChanged += new System.EventHandler(this.AccountFilter_CheckedChanged);
            // 
            // RahmenFilter
            // 
            resources.ApplyResources(this.RahmenFilter, "RahmenFilter");
            this.RahmenFilter.Enables = new string[] {
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
            this.RahmenFilter.Name = "RahmenFilter";
            this.RahmenFilter.ReportingName = "";
            this.RahmenFilter.UseVisualStyleBackColor = true;
            this.RahmenFilter.CheckedChanged += new System.EventHandler(this.RahmenFilter_CheckedChanged);
            // 
            // RahmenList
            // 
            this.RahmenList.AllowEmpty = true;
            this.RahmenList.Caption = "Rahmennummer:";
            this.RahmenList.CaptionFrom = "Von/Einzelwert:";
            this.RahmenList.CaptionTo = "Bis:";
            this.RahmenList.Constraint = conString1;
            resources.ApplyResources(this.RahmenList, "RahmenList");
            this.RahmenList.IsOptional = false;
            this.RahmenList.Name = "RahmenList";
            this.RahmenList.ParameterName = null;
            this.RahmenList.ReportingName = "";
            this.RahmenList.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.String;
            // 
            // smartLabel1
            // 
            resources.ApplyResources(this.smartLabel1, "smartLabel1");
            this.smartLabel1.Name = "smartLabel1";
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
            this.Controls.Add(this.smartLabel1);
            this.Controls.Add(this.RahmenList);
            this.Controls.Add(this.RahmenFilter);
            this.Controls.Add(this.AccountFilter);
            this.Controls.Add(this.smartLabel2);
            this.Controls.Add(this.AccountList);
            this.Controls.Add(this.Button_Cancel);
            this.Controls.Add(this.Button_OK);
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
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_OK;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_Cancel;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartFromToList AccountList;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox AccountFilter;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox RahmenFilter;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartFromToList RahmenList;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartDataExchanger smartDataExchanger1;
    }
}

