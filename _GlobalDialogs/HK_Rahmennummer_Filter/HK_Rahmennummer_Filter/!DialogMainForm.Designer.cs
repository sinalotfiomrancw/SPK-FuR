namespace HK_Rahmennummer_Filter
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
            this.Button_Description = new Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp();
            this.Button_OK = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.sFTLAccountNumber = new Audicon.SmartAnalyzer.Client.CustomControls.SmartFromToList();
            this.sFLTAccountFrame = new Audicon.SmartAnalyzer.Client.CustomControls.SmartFromToList();
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
            // 
            // Button_Cancel
            // 
            resources.ApplyResources(this.Button_Cancel, "Button_Cancel");
            this.Button_Cancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.Button_Cancel.Name = "Button_Cancel";
            this.Button_Cancel.ResultType = Audicon.SmartAnalyzer.Client.CustomControls.DiagResult.Cancel;
            this.Button_Cancel.UseVisualStyleBackColor = true;
            // 
            // sFTLAccountNumber
            // 
            this.sFTLAccountNumber.AllowEmpty = false;
            this.sFTLAccountNumber.Caption = "Kontonummer:";
            this.sFTLAccountNumber.CaptionFrom = "Von/Einzelwert:";
            this.sFTLAccountNumber.CaptionTo = "Bis:";
            conNumeric1.DefaultValue = ((long)(0));
            this.sFTLAccountNumber.Constraint = conNumeric1;
            resources.ApplyResources(this.sFTLAccountNumber, "sFTLAccountNumber");
            this.sFTLAccountNumber.IsOptional = false;
            this.sFTLAccountNumber.Name = "sFTLAccountNumber";
            this.sFTLAccountNumber.ParameterName = null;
            this.sFTLAccountNumber.ReportingName = "";
            this.sFTLAccountNumber.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Numeric;
            // 
            // sFLTAccountFrame
            // 
            this.sFLTAccountFrame.AllowEmpty = false;
            this.sFLTAccountFrame.Caption = "Rahmennummer:";
            this.sFLTAccountFrame.CaptionFrom = "Von/Einzelwert:";
            this.sFLTAccountFrame.CaptionTo = "Bis:";
            conNumeric2.DefaultValue = ((long)(0));
            this.sFLTAccountFrame.Constraint = conNumeric2;
            resources.ApplyResources(this.sFLTAccountFrame, "sFLTAccountFrame");
            this.sFLTAccountFrame.IsOptional = false;
            this.sFLTAccountFrame.Name = "sFLTAccountFrame";
            this.sFLTAccountFrame.ParameterName = null;
            this.sFLTAccountFrame.ReportingName = "";
            this.sFLTAccountFrame.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Numeric;
            // 
            // _DialogMainForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.sFLTAccountFrame);
            this.Controls.Add(this.sFTLAccountNumber);
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
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this._DialogMainForm_KeyDown);
            this.ResumeLayout(false);

        }

        #endregion

        private Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp Button_Description;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_OK;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_Cancel;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartFromToList sFTLAccountNumber;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartFromToList sFLTAccountFrame;
    }
}

