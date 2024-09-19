using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Audicon.SmartAnalyzer.Client.CustomControls;
using Audicon.SmartAnalyzer.Common.Types.Tagging;
using Audicon.SmartAnalyzer.Components;
using Audicon.SmartAnalyzer.Common.Types;
using Audicon.SmartAnalyzer.IdeaAccess;
using Audicon.SmartAnalyzer.IdeaAccess.Types;
using System.Runtime.InteropServices;
using COMMONIDEACONTROLSLib;

namespace SK_allgemein_Stichprobenauswahl
{
    //[DefaultForm]  // uncomment this line for apps requiring IDEA 10.1 and higher
    public partial class _DialogMainForm : Form
    {
        public bool AskQuestion = false;
        private bool m_isServer = false;
        private string taggedFilePath;
        private bool fullFileNameUpdated = false;
        private string fullFileName = string.Empty;

        private string FullFileName
        {
            get
            {
                return fullFileName;
            }

            set
            {
                fullFileNameUpdated = true;
                fullFileName = value;
            }
        }

        public _DialogMainForm()
        {
            InitializeComponent();
            this.Font = SystemFonts.DefaultFont;
            foreach (Control c in this.Controls)
            {
                c.Font = SystemFonts.DefaultFont;
            }
            smartLabel1.Enabled = false;
            smartTextBox1.Enabled = false;
            smartTextBox2.Enabled = false;
            smartTextBox3.Enabled = false;
            //smartComboBox1.Enabled = false;
            smartComboBox2.Enabled = false;
        }

        private void _DialogMainForm_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape) this.Close();
        }

        private void _DialogMainForm_Load(object sender, EventArgs e)
        {
            EnableUiSuspension(false);

            try
            {
                Audicon.SmartAnalyzer.Client.Components.Services.IDialogDataAccess executionContext = smartDataExchanger1.Context;
                m_isServer = ((int)executionContext.Location) > 0;
                FullFileName = executionContext.InputFiles[""].Path.ToString();

            }
            catch { }

            _comboBoxList = new[]
            {
                new SmartComboBoxEx(smartComboBox1, IdeaColumnTypes.Numeric),// | IdeaColumnTypes.Character | IdeaColumnTypes.Date),
            };

            if (File.Exists(FullFileName))
                if (true)//(smartDataExchanger1.Value.ContainsKey(0) && smartDataExchanger1.Value.ContainsKey(10))
                {
                    RestoreComboBox();
                    if (smartCheckBox2.Checked == true || smartCheckBox3.Checked == true)
                    {
                        smartComboBox1.Enabled = true;
                    }
                    else
                    {
                        smartComboBox1.Enabled = false;
                    }
                }
                else
                {
                    InitComboBox();
                    if (smartCheckBox2.Checked == true || smartCheckBox3.Checked == true)
                    {
                        smartComboBox1.Enabled = true;
                    }
                    else
                    {
                        smartComboBox1.Enabled = false;
                    }
                }

            EnableUiSuspension(true);
            SuspendUiComboBox(false);
        }

        private void RestoreComboBox()
        {
            SuspendUiComboBox(true);

            try
            {
                for (var i = 0; i < _comboBoxList.Length; i++)
                {
                    _comboBoxList[i].Control.Items.Clear();
                    _comboBoxList[i].Control.Items.AddRange((object[])smartDataExchanger1.Value[i]);
                    _comboBoxList[i].Control.SelectedIndex = (int)smartDataExchanger1.Value[100 + i];
                }

                UpdateComboBoxLists();
            }

            finally
            {
                SuspendUiComboBox(false);
            }
        }

        private IList<IdeaTableFieldEx> _columns;

        internal IEnumerable<IdeaTableFieldEx> Columns
        {
            get
            {
                if (_columns == null || fullFileNameUpdated)
                {
                    fullFileNameUpdated = false;

                    if (File.Exists(FullFileName))
                    {
                        try
                        {
                            _columns = IdeaServerOperations.GetIdeaTableFields(FullFileName, !m_isServer).
                                Select(s => new IdeaTableFieldEx(s)).ToList();
                        }
                        catch (FileNotFoundException)
                        {
                            _columns = null;
                        }
                    }

                    if (_columns == null)
                    {
                        _columns = new IdeaTableFieldEx[0];
                    }
                }

                return _columns;
            }
        }

        private SmartComboBoxEx[] _comboBoxList;

        private bool _suspendUiComboBox = true;
        private bool _suspensionEnabled = false;

        private void EnableUiSuspension(bool value)
        {
            _suspensionEnabled = value;
        }
        private void SuspendUiComboBox(bool value)
        {
            if (_suspensionEnabled)
                _suspendUiComboBox = value;
        }
        private void InitComboBox()
        {
            SuspendUiComboBox(true);

            try
            {
                foreach (var cbEx in _comboBoxList)
                {
                    cbEx.Items.Clear();
                    foreach (var column in Columns)
                    {
                        if (!column.Used && cbEx.HasCommonTypeWith(column) && cbEx.HasCommonTagWith(column) )
                        {
                            column.Used = true;
                            cbEx.Items.Add(column.Field.FieldName);
                            cbEx.Selection = 0;
                            break;
                        }
                    }
                }

                UpdateComboBoxLists();
            }

            finally
            {
                SuspendUiComboBox(false);
            }
        }
        private void AnalyzeAvailableColumns()
        {
            foreach (var column in Columns)
            {
                column.Used = false;
            }
            foreach (var cbEx in _comboBoxList)
            {
                var selectedColumn = cbEx.GetSelectedColumn();
                if (selectedColumn != null)
                    selectedColumn.Used = true;
            }
        }
        private void UpdateComboBoxLists()
        {
            SuspendUiComboBox(true);

            try
            {
                AnalyzeAvailableColumns();
                for (var i = 0; i < _comboBoxList.Length; i++)
                {
                    var selectedColumn = _comboBoxList[i].GetSelectedColumn();
                    RefreshComboBoxItems(i);
                    ComboBoxItems_InsertSelectedColumn(selectedColumn == null ? null : selectedColumn.Field, i);
                }
            }

            finally
            {
                SuspendUiComboBox(false);
            }
        }
        private void ComboBoxItems_InsertSelectedColumn(IdeaTableField selectedColumn, int i)
        {
            if (selectedColumn == null)
            {
                _comboBoxList[i].Selection = 0;
            }
            else
            {
                var j = 0;
                for (; j < _comboBoxList[i].Items.Count; j++)
                {
                    if (string.CompareOrdinal(selectedColumn.FieldName, (string)_comboBoxList[i].Items[j]) < 0)
                    {
                        break;
                    }
                }
                _comboBoxList[i].Items.Insert(j, selectedColumn.FieldName);
                _comboBoxList[i].Selection = j;
            }
        }
        private void RefreshComboBoxItems(int i)
        {
            _comboBoxList[i].Items.Clear();
            _comboBoxList[i].Items.Add("");

            foreach (var column in Columns)
            {
                if (!column.Used && _comboBoxList[i].HasCommonTypeWith(column))
                    _comboBoxList[i].Items.Add(column.Field.FieldName);
            }
        }

        private void Form_Current(object sender, EventArgs e)
        {
            smartTextBox1.Visible = smartCheckBox1.Checked;
            smartTextBox2.Visible = smartCheckBox2.Checked;
            smartTextBox3.Visible = smartCheckBox3.Checked;
        }

        private void smartCheckBox1_CheckedChanged(object sender, EventArgs e)
        {
            if (smartCheckBox1.Checked == true)
            {
                smartTextBox1.Enabled = true;
                smartTextBox1.IsOptional = false;
                smartLabel1.Enabled = true;
                smartCheckBox2.IsOptional = true;
                smartTextBox2.IsOptional = true;
                smartCheckBox3.IsOptional = true;
                smartTextBox3.IsOptional = true;
                smartComboBox1.IsOptional = true;
            }
            if (smartCheckBox1.Checked == false)
            {
                smartTextBox1.Enabled = false;
                smartTextBox1.IsOptional = true;
                smartLabel1.Enabled = false;
                smartCheckBox2.IsOptional = false;
                smartTextBox2.IsOptional = false;
                smartCheckBox3.IsOptional = false;
                smartTextBox3.IsOptional = false;
                smartComboBox1.IsOptional = false;

            }
        }

        private void smartCheckBox2_CheckedChanged(object sender, EventArgs e)
        {
            if (smartCheckBox2.Checked == true)
            {
                smartCheckBox1.IsOptional = true;
                smartTextBox1.IsOptional = true;
                smartTextBox2.Enabled = true;
                smartTextBox2.IsOptional = false;
                smartCheckBox3.IsOptional = true;
                smartTextBox3.IsOptional = true;
                smartComboBox1.Enabled = true;
                smartComboBox1.IsOptional = false;
            }
            if (smartCheckBox2.Checked == false)
            {
                smartCheckBox1.IsOptional = false;
                smartTextBox1.IsOptional = false;
                smartTextBox2.Enabled = false;
                smartTextBox2.IsOptional = true;
                smartCheckBox3.IsOptional = false;
                smartTextBox3.IsOptional = false;
                if (smartCheckBox3.Checked == false)
                {
                    smartComboBox1.Enabled = false;
                    smartComboBox1.IsOptional = true;
                }
            }
            if (smartCheckBox2.Checked == true && smartCheckBox3.Checked == true)
            {
                smartComboBox2.Enabled = true;
            }
        }
        private void smartCheckBox3_CheckedChanged(object sender, EventArgs e)
        {
            if (smartCheckBox3.Checked == true)
            {
                smartCheckBox1.IsOptional = true;
                smartTextBox1.IsOptional = true;
                smartTextBox3.Enabled = true;
                smartTextBox3.IsOptional = false;
                smartCheckBox2.IsOptional = true;
                smartTextBox2.IsOptional = true;
                smartComboBox1.Enabled = true;
                smartComboBox1.IsOptional = false;
            }
            if (smartCheckBox3.Checked == false)
            {
                smartCheckBox1.IsOptional = false;
                smartTextBox1.IsOptional = false;
                smartTextBox3.Enabled = false;
                smartTextBox3.IsOptional = true;
                smartCheckBox2.IsOptional = false;
                smartTextBox2.IsOptional = false;
            }
            if (smartCheckBox2.Checked == true && smartCheckBox3.Checked == true)
            {
                smartComboBox2.Enabled = true;
            }
            if (smartCheckBox2.Checked == false && smartCheckBox3.Checked == false)
            {
                smartComboBox1.Enabled = false;
                smartComboBox1.IsOptional = true;
            }
        }
        private void Button_OK_Click(object sender, EventArgs e)
        {
            AskQuestion = true;

            for (var i = 0; i < _comboBoxList.Length; i++)
            {
                var c = new object[_comboBoxList[i].Control.Items.Count];
                _comboBoxList[i].Control.Items.CopyTo(c, 0);
                smartDataExchanger1.Value[i] = c;
                smartDataExchanger1.Value[100 + i] = _comboBoxList[i].Control.SelectedIndex;
            }

            DialogResult = DialogResult.OK;
            Close();
            _columns = null;
            GC.Collect();
            GC.WaitForPendingFinalizers();
        }

        private bool IsLineValid(int index)
        {
            return _comboBoxList[index - 1] != null && _comboBoxList[index - 1].GetSelectedColumn() != null;
        }

        private void smartComboBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!_suspendUiComboBox)
                UpdateComboBoxLists();
        }
        private void _DialogMainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (AskQuestion == true)
            {
                AskQuestion = false;
                if (smartCheckBox1.Checked == false && smartCheckBox2.Checked == false && smartCheckBox3.Checked == false)
                {
                    string message = "Sie haben keine Stichprobenauswahl getätigt. Bitte wählen Sie mindestens eine Methode.";
                    string caption = "Fehlende Auswahl";
                    MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                    DialogResult result;

                    result = MessageBox.Show(message, caption, buttons);
                    if (result == System.Windows.Forms.DialogResult.Yes)
                    {
                        e.Cancel = true;
                    }
                    else if (result == System.Windows.Forms.DialogResult.No)
                    {
                        smartCheckBox1.IsOptional = false;
                        smartCheckBox2.IsOptional = false;
                        smartCheckBox3.IsOptional = false;
                        e.Cancel = false;
                    }
                }
                else if (smartCheckBox1.Checked == true && smartTextBox1.Value == "")
                {
                    string message = "Sie haben die Zufallsauswahl betätigt, jedoch keine Stichprobengröße ausgewählt. Bitte geben Sie eine Stichprobengröße ein.";
                    string caption = "Fehlende Eingabe";
                    //MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                    DialogResult result;

                    result = MessageBox.Show(message, caption);//, buttons);
                    if (result == System.Windows.Forms.DialogResult.OK)
                    {
                        e.Cancel = true;
                    }
                }
                else if (smartCheckBox2.Checked == true && smartTextBox2.Value == "")
                {
                    string message = "Sie haben den Cut Off obere Grenze betätigt, jedoch keinen Schwellenwert angegeben. Bitte geben Sie einen Schwellenwert ein.";
                    string caption = "Fehlende Eingabe";
                    //MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                    DialogResult result;

                    result = MessageBox.Show(message, caption);//, buttons);
                    if (result == System.Windows.Forms.DialogResult.OK)
                    {
                        e.Cancel = true;
                    }
                }
                else if (smartCheckBox3.Checked == true && smartTextBox3.Value == "")
                {
                    string message = "Sie haben den Cut Off untere Grenze betätigt, jedoch keinen Schwellenwert angegeben. Bitte geben Sie einen Schwellenwert ein.";
                    string caption = "Fehlende Eingabe";
                    //MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                    DialogResult result;

                    result = MessageBox.Show(message, caption);//, buttons);
                    if (result == System.Windows.Forms.DialogResult.OK)
                    {
                        e.Cancel = true;
                    }
                }
                else if ((smartCheckBox2.Checked == true || smartCheckBox3.Checked == true) && smartComboBox1.SelectedIndex == 0)
                {
                    string message = "Sie haben keine Spalte für den Cutt Off ausgewählt. Bitte wählen Sie eine Spalte aus.";
                    string caption = "Fehlende Eingabe";
                    //MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                    DialogResult result;

                    result = MessageBox.Show(message, caption);//, buttons);
                    if (result == System.Windows.Forms.DialogResult.OK)
                    {
                        e.Cancel = true;
                    }
                }
                AskQuestion = false;
            }
        }

        private void smartComboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!_suspendUiComboBox)
                UpdateComboBoxLists();
        }
    }

    internal class SmartComboBoxEx
    {
        public SmartComboBoxEx(SmartComboBox control, IdeaColumnTypes type)
        {
            Control = control;
            control.Enabled = true;
            FieldType = type;
        }

        internal SmartComboBox Control { get; set; }
        internal IdeaColumnTypes FieldType { get; set; }
        internal ComboBox.ObjectCollection Items { get { return Control.Items; } }
        internal int Selection { get { return Control.Selection; } set { Control.Selection = value; } }
        public bool HasCommonTagWith(IdeaTableFieldEx field)
        {
            if (string.IsNullOrEmpty(Control.AssignedTag))
                return false;
 
            return field.Field.HasTag(Control.AssignedTag);
        }
        public bool HasCommonTypeWith(IdeaTableFieldEx field)
        {
            return (FieldType & field.Field.ColumnType) != 0;
        }
        public IdeaTableFieldEx GetSelectedColumn()
        {
            var selectedColumnName = (string)Control.SelectedItem;

            if (String.IsNullOrEmpty(selectedColumnName))
                return null;

            foreach (var column in ((_DialogMainForm)Control.Parent).Columns)
            {
                if (column != null && column.Field != null && column.Field.FieldName != null && column.Field.FieldName == selectedColumnName)
                    return column;
            }

            return null;
        }
    }
    internal class IdeaTableFieldEx
    {
        internal IdeaTableFieldEx(IdeaTableField f)
        {
            Field = f;
        }

        internal IdeaTableField Field;
        internal bool FieldTyp;

        internal bool Used { get; set; }

    }
}
