namespace Auswahl_Positionen
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
            this.Button_Description = new Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.smartLabel1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.sCB_A = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.sCB_P = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.sCB_E = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.sCB_V = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.Button_OK = new System.Windows.Forms.Button();
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
            // smartLabel1
            // 
            resources.ApplyResources(this.smartLabel1, "smartLabel1");
            this.smartLabel1.Name = "smartLabel1";
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
            // 
            // Button_OK
            // 
            resources.ApplyResources(this.Button_OK, "Button_OK");
            this.Button_OK.Name = "Button_OK";
            this.Button_OK.UseVisualStyleBackColor = true;
            this.Button_OK.Click += new System.EventHandler(this.Button_OK_Click);
            // 
            // _DialogMainForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.Button_OK);
            this.Controls.Add(this.sCB_V);
            this.Controls.Add(this.sCB_E);
            this.Controls.Add(this.sCB_P);
            this.Controls.Add(this.sCB_A);
            this.Controls.Add(this.smartLabel1);
            this.Controls.Add(this.Button_Cancel);
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
            this.PerformLayout();

        }

        #endregion

        private Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp Button_Description;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_Cancel;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCB_A;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCB_P;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCB_E;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCB_V;
        private System.Windows.Forms.Button Button_OK;
    }
}

