using System.Windows.Forms;

namespace PNChange
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
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(_DialogMainForm));
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle3 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle5 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle6 = new System.Windows.Forms.DataGridViewCellStyle();
            this.Button_OK = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.smartDataExchanger = new Audicon.SmartAnalyzer.Client.CustomControls.SmartDataExchanger();
            this.buttonLoadFromFile = new System.Windows.Forms.Button();
            this.buttonSaveToFile = new System.Windows.Forms.Button();
            this.buttonResetGrid = new System.Windows.Forms.Button();
            this.tabPNAE = new System.Windows.Forms.TabPage();
            this.dataGridViewPNAE = new System.Windows.Forms.DataGridView();
            this.PN_NRAE = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.BEZEICHNUNGAE = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.MANUELLE_BUCHUNGENAE = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.AENDERUNG_RELEASEAE = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.tabPNST = new System.Windows.Forms.TabPage();
            this.dataGridViewPNST = new System.Windows.Forms.DataGridView();
            this.PN_NRST = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.BEZEICHNUNGST = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.MANUELLE_BUCHUNGENST = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.AENDERUNG_RELEASEST = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.tabControl = new System.Windows.Forms.TabControl();
            this.toolTip1 = new System.Windows.Forms.ToolTip(this.components);
            this.toolTip2 = new System.Windows.Forms.ToolTip(this.components);
            this.tabPNAE.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewPNAE)).BeginInit();
            this.tabPNST.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewPNST)).BeginInit();
            this.tabControl.SuspendLayout();
            this.SuspendLayout();
            // 
            // Button_OK
            // 
            this.Button_OK.DialogResult = System.Windows.Forms.DialogResult.OK;
            resources.ApplyResources(this.Button_OK, "Button_OK");
            this.Button_OK.Name = "Button_OK";
            this.Button_OK.ResultType = Audicon.SmartAnalyzer.Client.CustomControls.DiagResult.OK;
            this.Button_OK.UseVisualStyleBackColor = true;
            // 
            // Button_Cancel
            // 
            this.Button_Cancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            resources.ApplyResources(this.Button_Cancel, "Button_Cancel");
            this.Button_Cancel.Name = "Button_Cancel";
            this.Button_Cancel.ResultType = Audicon.SmartAnalyzer.Client.CustomControls.DiagResult.Cancel;
            this.Button_Cancel.UseVisualStyleBackColor = true;
            this.Button_Cancel.Click += new System.EventHandler(this.Button_Cancel_Click);
            // 
            // smartDataExchanger
            // 
            this.smartDataExchanger.Name = "smartDataExchanger";
            this.smartDataExchanger.ReportingName = null;
            this.smartDataExchanger.ReportingValue = "";
            // 
            // buttonLoadFromFile
            // 
            resources.ApplyResources(this.buttonLoadFromFile, "buttonLoadFromFile");
            this.buttonLoadFromFile.Name = "buttonLoadFromFile";
            this.toolTip1.SetToolTip(this.buttonLoadFromFile, resources.GetString("buttonLoadFromFile.ToolTip"));
            this.buttonLoadFromFile.UseVisualStyleBackColor = true;
            this.buttonLoadFromFile.Click += new System.EventHandler(this.buttonLoadFromFile_Click);
            // 
            // buttonSaveToFile
            // 
            resources.ApplyResources(this.buttonSaveToFile, "buttonSaveToFile");
            this.buttonSaveToFile.Name = "buttonSaveToFile";
            this.toolTip1.SetToolTip(this.buttonSaveToFile, resources.GetString("buttonSaveToFile.ToolTip"));
            this.buttonSaveToFile.UseVisualStyleBackColor = true;
            this.buttonSaveToFile.Click += new System.EventHandler(this.buttonSaveToFile_Click);
            // 
            // buttonResetGrid
            // 
            resources.ApplyResources(this.buttonResetGrid, "buttonResetGrid");
            this.buttonResetGrid.Name = "buttonResetGrid";
            this.buttonResetGrid.UseVisualStyleBackColor = true;
            this.buttonResetGrid.Click += new System.EventHandler(this.buttonResetGrid_Click);
            // 
            // tabPNAE
            // 
            this.tabPNAE.Controls.Add(this.dataGridViewPNAE);
            resources.ApplyResources(this.tabPNAE, "tabPNAE");
            this.tabPNAE.Name = "tabPNAE";
            this.tabPNAE.UseVisualStyleBackColor = true;
            // 
            // dataGridViewPNAE
            // 
            this.dataGridViewPNAE.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.ColumnHeader;
            dataGridViewCellStyle1.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle1.BackColor = System.Drawing.SystemColors.Control;
            dataGridViewCellStyle1.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle1.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle1.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle1.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle1.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dataGridViewPNAE.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle1;
            this.dataGridViewPNAE.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridViewPNAE.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.PN_NRAE,
            this.BEZEICHNUNGAE,
            this.MANUELLE_BUCHUNGENAE,
            this.AENDERUNG_RELEASEAE});
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle2.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dataGridViewPNAE.DefaultCellStyle = dataGridViewCellStyle2;
            resources.ApplyResources(this.dataGridViewPNAE, "dataGridViewPNAE");
            this.dataGridViewPNAE.Name = "dataGridViewPNAE";
            dataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Control;
            dataGridViewCellStyle3.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle3.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle3.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle3.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dataGridViewPNAE.RowHeadersDefaultCellStyle = dataGridViewCellStyle3;
            // 
            // PN_NRAE
            // 
            resources.ApplyResources(this.PN_NRAE, "PN_NRAE");
            this.PN_NRAE.Name = "PN_NRAE";
            // 
            // BEZEICHNUNGAE
            // 
            resources.ApplyResources(this.BEZEICHNUNGAE, "BEZEICHNUNGAE");
            this.BEZEICHNUNGAE.Name = "BEZEICHNUNGAE";
            // 
            // MANUELLE_BUCHUNGENAE
            // 
            resources.ApplyResources(this.MANUELLE_BUCHUNGENAE, "MANUELLE_BUCHUNGENAE");
            this.MANUELLE_BUCHUNGENAE.Name = "MANUELLE_BUCHUNGENAE";
            // 
            // AENDERUNG_RELEASEAE
            // 
            resources.ApplyResources(this.AENDERUNG_RELEASEAE, "AENDERUNG_RELEASEAE");
            this.AENDERUNG_RELEASEAE.Name = "AENDERUNG_RELEASEAE";
            // 
            // tabPNST
            // 
            this.tabPNST.Controls.Add(this.dataGridViewPNST);
            resources.ApplyResources(this.tabPNST, "tabPNST");
            this.tabPNST.Name = "tabPNST";
            this.tabPNST.UseVisualStyleBackColor = true;
            // 
            // dataGridViewPNST
            // 
            this.dataGridViewPNST.AllowUserToAddRows = false;
            this.dataGridViewPNST.AllowUserToDeleteRows = false;
            this.dataGridViewPNST.AllowUserToResizeColumns = false;
            this.dataGridViewPNST.AllowUserToResizeRows = false;
            this.dataGridViewPNST.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.ColumnHeader;
            dataGridViewCellStyle4.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle4.BackColor = System.Drawing.SystemColors.Control;
            dataGridViewCellStyle4.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle4.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle4.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle4.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle4.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dataGridViewPNST.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle4;
            this.dataGridViewPNST.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridViewPNST.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.PN_NRST,
            this.BEZEICHNUNGST,
            this.MANUELLE_BUCHUNGENST,
            this.AENDERUNG_RELEASEST});
            dataGridViewCellStyle5.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle5.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle5.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle5.ForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle5.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle5.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle5.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dataGridViewPNST.DefaultCellStyle = dataGridViewCellStyle5;
            resources.ApplyResources(this.dataGridViewPNST, "dataGridViewPNST");
            this.dataGridViewPNST.Name = "dataGridViewPNST";
            this.dataGridViewPNST.ReadOnly = true;
            dataGridViewCellStyle6.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle6.BackColor = System.Drawing.SystemColors.Control;
            dataGridViewCellStyle6.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle6.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle6.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle6.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle6.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dataGridViewPNST.RowHeadersDefaultCellStyle = dataGridViewCellStyle6;
            this.dataGridViewPNST.RowTemplate.ReadOnly = true;
            this.dataGridViewPNST.ShowEditingIcon = false;
            this.dataGridViewPNST.KeyDown += new System.Windows.Forms.KeyEventHandler(this.dataGridViewPNAE_KeyDown);
            // 
            // PN_NRST
            // 
            resources.ApplyResources(this.PN_NRST, "PN_NRST");
            this.PN_NRST.Name = "PN_NRST";
            this.PN_NRST.ReadOnly = true;
            // 
            // BEZEICHNUNGST
            // 
            resources.ApplyResources(this.BEZEICHNUNGST, "BEZEICHNUNGST");
            this.BEZEICHNUNGST.Name = "BEZEICHNUNGST";
            this.BEZEICHNUNGST.ReadOnly = true;
            // 
            // MANUELLE_BUCHUNGENST
            // 
            resources.ApplyResources(this.MANUELLE_BUCHUNGENST, "MANUELLE_BUCHUNGENST");
            this.MANUELLE_BUCHUNGENST.Name = "MANUELLE_BUCHUNGENST";
            this.MANUELLE_BUCHUNGENST.ReadOnly = true;
            // 
            // AENDERUNG_RELEASEST
            // 
            resources.ApplyResources(this.AENDERUNG_RELEASEST, "AENDERUNG_RELEASEST");
            this.AENDERUNG_RELEASEST.Name = "AENDERUNG_RELEASEST";
            this.AENDERUNG_RELEASEST.ReadOnly = true;
            // 
            // tabControl
            // 
            this.tabControl.Controls.Add(this.tabPNST);
            this.tabControl.Controls.Add(this.tabPNAE);
            resources.ApplyResources(this.tabControl, "tabControl");
            this.tabControl.Name = "tabControl";
            this.tabControl.SelectedIndex = 0;
            // 
            // _DialogMainForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.buttonResetGrid);
            this.Controls.Add(this.buttonSaveToFile);
            this.Controls.Add(this.buttonLoadFromFile);
            this.Controls.Add(this.tabControl);
            this.Controls.Add(this.Button_Cancel);
            this.Controls.Add(this.Button_OK);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.KeyPreview = true;
            this.MinimizeBox = false;
            this.Name = "_DialogMainForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Show;
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this._DialogMainForm_FormClosing);
            this.Load += new System.EventHandler(this._DialogMainForm_Load);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this._DialogMainForm_KeyDown);
            this.tabPNAE.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewPNAE)).EndInit();
            this.tabPNST.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewPNST)).EndInit();
            this.tabControl.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_OK;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_Cancel;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartDataExchanger smartDataExchanger;
        private System.Windows.Forms.Button buttonLoadFromFile;
        private System.Windows.Forms.Button buttonSaveToFile;
        private System.Windows.Forms.Button buttonResetGrid;
        private System.Windows.Forms.TabPage tabPNAE;
        private System.Windows.Forms.DataGridView dataGridViewPNAE;
        private System.Windows.Forms.TabPage tabPNST;
        private System.Windows.Forms.DataGridView dataGridViewPNST;
        private System.Windows.Forms.TabControl tabControl;
        private System.Windows.Forms.DataGridViewTextBoxColumn PN_NRAE;
        private System.Windows.Forms.DataGridViewTextBoxColumn BEZEICHNUNGAE;
        private System.Windows.Forms.DataGridViewTextBoxColumn MANUELLE_BUCHUNGENAE;
        private System.Windows.Forms.DataGridViewTextBoxColumn AENDERUNG_RELEASEAE;
        private System.Windows.Forms.DataGridViewTextBoxColumn PN_NRST;
        private System.Windows.Forms.DataGridViewTextBoxColumn BEZEICHNUNGST;
        private System.Windows.Forms.DataGridViewTextBoxColumn MANUELLE_BUCHUNGENST;
        private System.Windows.Forms.DataGridViewTextBoxColumn AENDERUNG_RELEASEST;
        private System.Windows.Forms.ToolTip toolTip1;
        private System.Windows.Forms.ToolTip toolTip2;
    }
}

