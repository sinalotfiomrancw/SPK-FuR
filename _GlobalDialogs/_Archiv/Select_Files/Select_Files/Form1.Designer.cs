namespace Select_Files
{
    partial class Form1
    {
        /// <summary>
        /// Erforderliche Designervariable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Verwendete Ressourcen bereinigen.
        /// </summary>
        /// <param name="disposing">True, wenn verwaltete Ressourcen gelöscht werden sollen; andernfalls False.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Vom Windows Form-Designer generierter Code

        /// <summary>
        /// Erforderliche Methode für die Designerunterstützung.
        /// Der Inhalt der Methode darf nicht mit dem Code-Editor geändert werden.
        /// </summary>
        private void InitializeComponent()
        {
            Audicon.SmartAnalyzer.Client.CustomControls.ConString conString1 = new Audicon.SmartAnalyzer.Client.CustomControls.ConString();
            Audicon.SmartAnalyzer.Client.CustomControls.ConString conString2 = new Audicon.SmartAnalyzer.Client.CustomControls.ConString();
            this.smartButton1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.smartButton2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.smartInputBox1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartInputBox();
            this.label1 = new System.Windows.Forms.Label();
            this.smartButton3 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.smartButton4 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.label2 = new System.Windows.Forms.Label();
            this.smartInputBox2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartInputBox();
            this.SuspendLayout();
            // 
            // smartButton1
            // 
            this.smartButton1.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.smartButton1.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.smartButton1.Location = new System.Drawing.Point(602, 413);
            this.smartButton1.Name = "smartButton1";
            this.smartButton1.ResultType = Audicon.SmartAnalyzer.Client.CustomControls.DiagResult.OK;
            this.smartButton1.Size = new System.Drawing.Size(90, 25);
            this.smartButton1.TabIndex = 0;
            this.smartButton1.Text = "OK";
            this.smartButton1.UseVisualStyleBackColor = true;
            // 
            // smartButton2
            // 
            this.smartButton2.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.smartButton2.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.smartButton2.Location = new System.Drawing.Point(698, 413);
            this.smartButton2.Name = "smartButton2";
            this.smartButton2.ResultType = Audicon.SmartAnalyzer.Client.CustomControls.DiagResult.Cancel;
            this.smartButton2.Size = new System.Drawing.Size(90, 25);
            this.smartButton2.TabIndex = 1;
            this.smartButton2.Text = "Abbrechen";
            this.smartButton2.UseVisualStyleBackColor = true;
            // 
            // smartInputBox1
            // 
            conString1.Max = 32767;
            this.smartInputBox1.Constraint = conString1;
            this.smartInputBox1.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.smartInputBox1.LanguageCode = "";
            this.smartInputBox1.Location = new System.Drawing.Point(15, 25);
            this.smartInputBox1.MaximumSize = new System.Drawing.Size(1000, 20);
            this.smartInputBox1.MinimumSize = new System.Drawing.Size(0, 20);
            this.smartInputBox1.Name = "smartInputBox1";
            this.smartInputBox1.ReportingName = "";
            this.smartInputBox1.Size = new System.Drawing.Size(567, 20);
            this.smartInputBox1.TabIndex = 3;
            this.smartInputBox1.Value = "";
            this.smartInputBox1.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.String;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 9);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(256, 13);
            this.label1.TabIndex = 4;
            this.label1.Text = "Bitte wählen Sie die CSV-Datei der OBR-Konten aus:";
            // 
            // smartButton3
            // 
            this.smartButton3.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.smartButton3.Location = new System.Drawing.Point(602, 20);
            this.smartButton3.Name = "smartButton3";
            this.smartButton3.ResultType = Audicon.SmartAnalyzer.Client.CustomControls.DiagResult.OK;
            this.smartButton3.Size = new System.Drawing.Size(90, 25);
            this.smartButton3.TabIndex = 5;
            this.smartButton3.Text = "Auswählen ...";
            this.smartButton3.UseVisualStyleBackColor = true;
            // 
            // smartButton4
            // 
            this.smartButton4.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.smartButton4.Location = new System.Drawing.Point(602, 68);
            this.smartButton4.Name = "smartButton4";
            this.smartButton4.ResultType = Audicon.SmartAnalyzer.Client.CustomControls.DiagResult.OK;
            this.smartButton4.Size = new System.Drawing.Size(90, 25);
            this.smartButton4.TabIndex = 8;
            this.smartButton4.Text = "Auswählen ...";
            this.smartButton4.UseVisualStyleBackColor = true;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(12, 57);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(257, 13);
            this.label2.TabIndex = 7;
            this.label2.Text = "Bitte wählen Sie die RDF-Datei der OBR-Konten aus:";
            // 
            // smartInputBox2
            // 
            conString2.Max = 32767;
            this.smartInputBox2.Constraint = conString2;
            this.smartInputBox2.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.smartInputBox2.LanguageCode = "";
            this.smartInputBox2.Location = new System.Drawing.Point(15, 73);
            this.smartInputBox2.MaximumSize = new System.Drawing.Size(1000, 20);
            this.smartInputBox2.MinimumSize = new System.Drawing.Size(0, 20);
            this.smartInputBox2.Name = "smartInputBox2";
            this.smartInputBox2.ReportingName = "";
            this.smartInputBox2.Size = new System.Drawing.Size(567, 20);
            this.smartInputBox2.TabIndex = 6;
            this.smartInputBox2.Value = "";
            this.smartInputBox2.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.String;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.smartButton4);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.smartInputBox2);
            this.Controls.Add(this.smartButton3);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.smartInputBox1);
            this.Controls.Add(this.smartButton2);
            this.Controls.Add(this.smartButton1);
            this.Name = "Form1";
            this.Text = "Form1";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton smartButton1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton smartButton2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartInputBox smartInputBox1;
        private System.Windows.Forms.Label label1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton smartButton3;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton smartButton4;
        private System.Windows.Forms.Label label2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartInputBox smartInputBox2;
    }
}

