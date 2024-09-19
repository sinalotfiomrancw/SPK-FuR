//using Audicon.SmartAnalyzer.Client.CustomControls;
//using Audicon.SmartAnalyzer.Client.CustomControls.Forms;

using Audicon.SmartAnalyzer.Client.CustomControls;
using Audicon.SmartAnalyzer.Parameters;
using System.Collections;
using System.Collections.Generic;
using System.IO;

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
            Audicon.SmartAnalyzer.Client.CustomControls.ConDate conDate1 = new Audicon.SmartAnalyzer.Client.CustomControls.ConDate();
            Audicon.SmartAnalyzer.Client.CustomControls.ConDate conDate2 = new Audicon.SmartAnalyzer.Client.CustomControls.ConDate();
            Audicon.SmartAnalyzer.Client.CustomControls.ConString conString1 = new Audicon.SmartAnalyzer.Client.CustomControls.ConString();
            Audicon.SmartAnalyzer.Client.CustomControls.ConString conString2 = new Audicon.SmartAnalyzer.Client.CustomControls.ConString();
            Audicon.SmartAnalyzer.Client.CustomControls.ConString conString3 = new Audicon.SmartAnalyzer.Client.CustomControls.ConString();
            Audicon.SmartAnalyzer.Client.CustomControls.ConDecimal conDecimal1 = new Audicon.SmartAnalyzer.Client.CustomControls.ConDecimal();
            Audicon.SmartAnalyzer.Client.CustomControls.ConString conString4 = new Audicon.SmartAnalyzer.Client.CustomControls.ConString();
            Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric conNumeric1 = new Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.smartLabel1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.smartLabel2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.smartTextBox1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.smartTextBox2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.smartFromToList1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartFromToList();
            this.smartFromToList2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartFromToList();
            this.smartSingleList2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartSingleList();
            this.smartTextBox3 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.smartLabel4 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.smartCheckBox10 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartCheckBox7 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartSingleList1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartSingleList();
            this.tabPage2 = new System.Windows.Forms.TabPage();
            this.smartLabel6 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.smartCheckBox8 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartLabel5 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.smartTextBox4 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.tabControl2 = new System.Windows.Forms.TabControl();
            this.tabPage3 = new System.Windows.Forms.TabPage();
            this.tabPage4 = new System.Windows.Forms.TabPage();
            this.tabPage5 = new System.Windows.Forms.TabPage();
            this.smartLabel3 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.smartCheckBox4 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartCheckBox3 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartCheckBox2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartCheckBox1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.button1 = new System.Windows.Forms.Button();
            this.tabControl1.SuspendLayout();
            this.tabPage1.SuspendLayout();
            this.tabPage2.SuspendLayout();
            this.tabControl2.SuspendLayout();
            this.tabPage3.SuspendLayout();
            this.tabPage4.SuspendLayout();
            this.tabPage5.SuspendLayout();
            this.SuspendLayout();
            // 
            // Button_Cancel
            // 
            resources.ApplyResources(this.Button_Cancel, "Button_Cancel");
            this.Button_Cancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.Button_Cancel.Name = "Button_Cancel";
            this.Button_Cancel.ResultType = Audicon.SmartAnalyzer.Client.CustomControls.DiagResult.Cancel;
            this.Button_Cancel.UseVisualStyleBackColor = true;
            this.Button_Cancel.Click += new System.EventHandler(this.Button_Cancel_Click);
            // 
            // smartLabel1
            // 
            this.smartLabel1.AssignedTag = null;
            resources.ApplyResources(this.smartLabel1, "smartLabel1");
            this.smartLabel1.Name = "smartLabel1";
            // 
            // smartLabel2
            // 
            this.smartLabel2.AssignedTag = null;
            resources.ApplyResources(this.smartLabel2, "smartLabel2");
            this.smartLabel2.Name = "smartLabel2";
            // 
            // smartTextBox1
            // 
            this.smartTextBox1.AllowEmpty = true;
            this.smartTextBox1.AssignedTag = "EntryDate";
            conDate1.DefaultValue = new System.DateTime(2015, 4, 23, 0, 0, 0, 0);
            conDate1.Max = new System.DateTime(2050, 12, 31, 0, 0, 0, 0);
            conDate1.Min = new System.DateTime(1950, 1, 1, 0, 0, 0, 0);
            this.smartTextBox1.Constraint = conDate1;
            resources.ApplyResources(this.smartTextBox1, "smartTextBox1");
            this.smartTextBox1.IsOptional = true;
            this.smartTextBox1.LanguageCode = "";
            this.smartTextBox1.Name = "smartTextBox1";
            this.smartTextBox1.ReportFormat = "d";
            this.smartTextBox1.ReportingName = null;
            this.smartTextBox1.ReportOrder = 102;
            this.smartTextBox1.TagGroup = new string[] {
        "EntryDate"};
            this.smartTextBox1.Value = "";
            this.smartTextBox1.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Date;
            // 
            // smartTextBox2
            // 
            this.smartTextBox2.AllowEmpty = true;
            this.smartTextBox2.AssignedTag = "EntryDate";
            conDate2.DefaultValue = new System.DateTime(2015, 4, 23, 0, 0, 0, 0);
            conDate2.Max = new System.DateTime(2050, 12, 31, 0, 0, 0, 0);
            conDate2.Min = new System.DateTime(1950, 1, 1, 0, 0, 0, 0);
            this.smartTextBox2.Constraint = conDate2;
            resources.ApplyResources(this.smartTextBox2, "smartTextBox2");
            this.smartTextBox2.IsOptional = true;
            this.smartTextBox2.LanguageCode = "";
            this.smartTextBox2.Name = "smartTextBox2";
            this.smartTextBox2.ReportFormat = "d";
            this.smartTextBox2.ReportingName = null;
            this.smartTextBox2.ReportOrder = 103;
            this.smartTextBox2.TagGroup = new string[] {
        "EntryDate"};
            this.smartTextBox2.Value = "";
            this.smartTextBox2.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Date;
            // 
            // smartFromToList1
            // 
            this.smartFromToList1.AllowEmpty = true;
            this.smartFromToList1.AssignedTag = null;
            this.smartFromToList1.BackColor = System.Drawing.Color.Transparent;
            resources.ApplyResources(this.smartFromToList1, "smartFromToList1");
            this.smartFromToList1.Caption = "smartFromToList1";
            this.smartFromToList1.CaptionFrom = "From:";
            this.smartFromToList1.CaptionTo = "To:";
            this.smartFromToList1.Constraint = conString1;
            this.smartFromToList1.ForeColor = System.Drawing.SystemColors.ControlText;
            this.smartFromToList1.IsOptional = false;
            this.smartFromToList1.Name = "smartFromToList1";
            this.smartFromToList1.ParameterName = "Kontonummern";
            this.smartFromToList1.RecommendedDatabases = new string[] {
        "ChartOfAccounts",
        "TrailBalanceGL"};
            this.smartFromToList1.ReportFormat = "#,##0";
            this.smartFromToList1.ReportingName = null;
            this.smartFromToList1.ReportOrder = 101;
            this.smartFromToList1.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.String;
            // 
            // smartFromToList2
            // 
            this.smartFromToList2.AllowEmpty = true;
            this.smartFromToList2.AssignedTag = null;
            this.smartFromToList2.Caption = "smartFromToList2";
            this.smartFromToList2.CaptionFrom = "From:";
            this.smartFromToList2.CaptionTo = "To:";
            this.smartFromToList2.Constraint = conString2;
            resources.ApplyResources(this.smartFromToList2, "smartFromToList2");
            this.smartFromToList2.IsOptional = false;
            this.smartFromToList2.Name = "smartFromToList2";
            this.smartFromToList2.ParameterName = "Rahmennummern";
            this.smartFromToList2.RecommendedDatabases = new string[] {
        "ChartOfAccounts",
        "TrailBalanceGL"};
            this.smartFromToList2.ReportFormat = "#,##0";
            this.smartFromToList2.ReportingName = null;
            this.smartFromToList2.ReportOrder = 104;
            this.smartFromToList2.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.String;
            // 
            // smartSingleList2
            // 
            this.smartSingleList2.AllowEmpty = true;
            this.smartSingleList2.Caption = "smartSingleList2";
            this.smartSingleList2.Constraint = conString3;
            resources.ApplyResources(this.smartSingleList2, "smartSingleList2");
            this.smartSingleList2.IsOptional = false;
            this.smartSingleList2.Name = "smartSingleList2";
            this.smartSingleList2.ParameterName = null;
            this.smartSingleList2.RecommendedDatabases = new string[] {
        "ChartOfAccounts",
        "TrailBalanceGL"};
            this.smartSingleList2.ReportingName = "";
            this.smartSingleList2.ReportOrder = 303;
            this.smartSingleList2.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.String;
            // 
            // smartTextBox3
            // 
            conDecimal1.DefaultValue = 0D;
            conDecimal1.EnableDefaultValue = true;
            conDecimal1.Min = 0D;
            this.smartTextBox3.Constraint = conDecimal1;
            resources.ApplyResources(this.smartTextBox3, "smartTextBox3");
            this.smartTextBox3.LanguageCode = "";
            this.smartTextBox3.Name = "smartTextBox3";
            this.smartTextBox3.ReportFormat = "#,##0.00";
            this.smartTextBox3.ReportingName = "";
            this.smartTextBox3.ReportOrder = 104;
            this.smartTextBox3.Value = "0";
            this.smartTextBox3.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Decimal;
            // 
            // smartLabel4
            // 
            resources.ApplyResources(this.smartLabel4, "smartLabel4");
            this.smartLabel4.Name = "smartLabel4";
            // 
            // tabControl1
            // 
            this.tabControl1.Controls.Add(this.tabPage1);
            this.tabControl1.Controls.Add(this.tabPage2);
            resources.ApplyResources(this.tabControl1, "tabControl1");
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            // 
            // tabPage1
            // 
            this.tabPage1.BackColor = System.Drawing.Color.Transparent;
            this.tabPage1.Controls.Add(this.smartCheckBox10);
            this.tabPage1.Controls.Add(this.smartCheckBox7);
            this.tabPage1.Controls.Add(this.smartSingleList1);
            resources.ApplyResources(this.tabPage1, "tabPage1");
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.UseVisualStyleBackColor = true;
            // 
            // smartCheckBox10
            // 
            this.smartCheckBox10.Enables = new string[] {
        "smartCheckBox7",
        "smartSingleList1"};
            resources.ApplyResources(this.smartCheckBox10, "smartCheckBox10");
            this.smartCheckBox10.Name = "smartCheckBox10";
            this.smartCheckBox10.ReportingName = "";
            this.smartCheckBox10.ReportOrder = 301;
            this.smartCheckBox10.UseVisualStyleBackColor = true;
            // 
            // smartCheckBox7
            // 
            this.smartCheckBox7.Enables = new string[] {
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
            resources.ApplyResources(this.smartCheckBox7, "smartCheckBox7");
            this.smartCheckBox7.Name = "smartCheckBox7";
            this.smartCheckBox7.ReportingName = "";
            this.smartCheckBox7.ReportOrder = 302;
            this.smartCheckBox7.UseVisualStyleBackColor = true;
            // 
            // smartSingleList1
            // 
            this.smartSingleList1.AllowEmpty = true;
            this.smartSingleList1.Caption = "smartSingleList1";
            this.smartSingleList1.Constraint = conString4;
            resources.ApplyResources(this.smartSingleList1, "smartSingleList1");
            this.smartSingleList1.IsOptional = false;
            this.smartSingleList1.Name = "smartSingleList1";
            this.smartSingleList1.ParameterName = null;
            this.smartSingleList1.RecommendedDatabases = new string[] {
        "ChartOfAccounts",
        "TrailBalanceGL"};
            this.smartSingleList1.ReportingName = "";
            this.smartSingleList1.ReportOrder = 303;
            this.smartSingleList1.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.String;
            // 
            // tabPage2
            // 
            this.tabPage2.BackColor = System.Drawing.Color.Transparent;
            this.tabPage2.Controls.Add(this.smartLabel6);
            this.tabPage2.Controls.Add(this.smartCheckBox8);
            this.tabPage2.Controls.Add(this.smartLabel5);
            this.tabPage2.Controls.Add(this.smartTextBox4);
            resources.ApplyResources(this.tabPage2, "tabPage2");
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.UseVisualStyleBackColor = true;
            // 
            // smartLabel6
            // 
            resources.ApplyResources(this.smartLabel6, "smartLabel6");
            this.smartLabel6.Name = "smartLabel6";
            // 
            // smartCheckBox8
            // 
            this.smartCheckBox8.Enables = new string[] {
        "smartLabel5",
        "smartTextBox4"};
            resources.ApplyResources(this.smartCheckBox8, "smartCheckBox8");
            this.smartCheckBox8.Name = "smartCheckBox8";
            this.smartCheckBox8.ReportingName = "";
            this.smartCheckBox8.ReportOrder = 201;
            this.smartCheckBox8.UseVisualStyleBackColor = true;
            // 
            // smartLabel5
            // 
            resources.ApplyResources(this.smartLabel5, "smartLabel5");
            this.smartLabel5.Name = "smartLabel5";
            // 
            // smartTextBox4
            // 
            conNumeric1.DefaultValue = ((long)(0));
            conNumeric1.EnableDefaultValue = true;
            conNumeric1.Min = ((long)(0));
            this.smartTextBox4.Constraint = conNumeric1;
            resources.ApplyResources(this.smartTextBox4, "smartTextBox4");
            this.smartTextBox4.LanguageCode = "";
            this.smartTextBox4.Name = "smartTextBox4";
            this.smartTextBox4.ReportingName = "";
            this.smartTextBox4.ReportOrder = 202;
            this.smartTextBox4.Value = "0";
            this.smartTextBox4.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Numeric;
            // 
            // tabControl2
            // 
            this.tabControl2.Controls.Add(this.tabPage3);
            this.tabControl2.Controls.Add(this.tabPage4);
            this.tabControl2.Controls.Add(this.tabPage5);
            resources.ApplyResources(this.tabControl2, "tabControl2");
            this.tabControl2.Name = "tabControl2";
            this.tabControl2.SelectedIndex = 0;
            // 
            // tabPage3
            // 
            this.tabPage3.BackColor = System.Drawing.Color.Transparent;
            this.tabPage3.Controls.Add(this.smartFromToList1);
            resources.ApplyResources(this.tabPage3, "tabPage3");
            this.tabPage3.Name = "tabPage3";
            this.tabPage3.UseVisualStyleBackColor = true;
            // 
            // tabPage4
            // 
            this.tabPage4.BackColor = System.Drawing.Color.Transparent;
            this.tabPage4.Controls.Add(this.smartFromToList2);
            resources.ApplyResources(this.tabPage4, "tabPage4");
            this.tabPage4.Name = "tabPage4";
            this.tabPage4.UseVisualStyleBackColor = true;
            // 
            // tabPage5
            // 
            this.tabPage5.Controls.Add(this.smartLabel3);
            this.tabPage5.Controls.Add(this.smartCheckBox4);
            this.tabPage5.Controls.Add(this.smartCheckBox3);
            this.tabPage5.Controls.Add(this.smartCheckBox2);
            this.tabPage5.Controls.Add(this.smartCheckBox1);
            resources.ApplyResources(this.tabPage5, "tabPage5");
            this.tabPage5.Name = "tabPage5";
            // 
            // smartLabel3
            // 
            resources.ApplyResources(this.smartLabel3, "smartLabel3");
            this.smartLabel3.Name = "smartLabel3";
            // 
            // smartCheckBox4
            // 
            resources.ApplyResources(this.smartCheckBox4, "smartCheckBox4");
            this.smartCheckBox4.Enables = new string[] {
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
            this.smartCheckBox4.IsOptional = true;
            this.smartCheckBox4.Name = "smartCheckBox4";
            this.smartCheckBox4.ReportingName = "V - Verlust/Aufwand";
            this.smartCheckBox4.UseVisualStyleBackColor = true;
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
            this.smartCheckBox3.IsOptional = true;
            this.smartCheckBox3.Name = "smartCheckBox3";
            this.smartCheckBox3.ReportingName = "E - Ertrag";
            this.smartCheckBox3.UseVisualStyleBackColor = true;
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
            this.smartCheckBox2.IsOptional = true;
            this.smartCheckBox2.Name = "smartCheckBox2";
            this.smartCheckBox2.ReportingName = "P - Passiva";
            this.smartCheckBox2.UseVisualStyleBackColor = true;
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
            this.smartCheckBox1.IsOptional = true;
            this.smartCheckBox1.Name = "smartCheckBox1";
            this.smartCheckBox1.ReportingName = "A - Aktiva";
            this.smartCheckBox1.UseVisualStyleBackColor = true;
            // 
            // button1
            // 
            resources.ApplyResources(this.button1, "button1");
            this.button1.Name = "button1";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // MacroForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.button1);
            this.Controls.Add(this.tabControl1);
            this.Controls.Add(this.tabControl2);
            this.Controls.Add(this.smartLabel4);
            this.Controls.Add(this.smartTextBox3);
            this.Controls.Add(this.smartTextBox2);
            this.Controls.Add(this.smartTextBox1);
            this.Controls.Add(this.smartLabel2);
            this.Controls.Add(this.smartLabel1);
            this.Controls.Add(this.Button_Cancel);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "MacroForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Load += new System.EventHandler(this.MacroForm_Load);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.MacroForm_KeyDown);
            this.tabControl1.ResumeLayout(false);
            this.tabPage1.ResumeLayout(false);
            this.tabPage2.ResumeLayout(false);
            this.tabControl2.ResumeLayout(false);
            this.tabPage3.ResumeLayout(false);
            this.tabPage4.ResumeLayout(false);
            this.tabPage5.ResumeLayout(false);
            this.tabPage5.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_Cancel;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox smartTextBox1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox smartTextBox2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartFromToList smartFromToList1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartFromToList smartFromToList2;
        private SmartSingleList smartSingleList2;
        private SmartTextBox smartTextBox3;
        private SmartLabel smartLabel4;
        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tabPage1;
        private System.Windows.Forms.TabPage tabPage2;
        private System.Windows.Forms.TabControl tabControl2;
        private System.Windows.Forms.TabPage tabPage3;
        private System.Windows.Forms.TabPage tabPage4;
        private System.Windows.Forms.TabPage tabPage5;
        private SmartLabel smartLabel6;
        private SmartCheckBox smartCheckBox8;
        private SmartLabel smartLabel5;
        private SmartTextBox smartTextBox4;
        private SmartCheckBox smartCheckBox10;
        private SmartCheckBox smartCheckBox7;
        private SmartSingleList smartSingleList1;
        private System.Windows.Forms.Button button1;
        private SmartCheckBox smartCheckBox1;
        private SmartCheckBox smartCheckBox3;
        private SmartCheckBox smartCheckBox2;
        private SmartCheckBox smartCheckBox4;
        private SmartLabel smartLabel3;
    }
}

