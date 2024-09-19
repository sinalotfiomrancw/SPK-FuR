using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Windows.Forms;
using Audicon.SmartAnalyzer.Client.CustomControls;
using Audicon.SmartAnalyzer.Common.Types.Tagging;
using Audicon.SmartAnalyzer.Components;
using Audicon.SmartAnalyzer.IdeaAccess;
using Audicon.SmartAnalyzer.IdeaAccess.Types;

namespace Dialog
{
    public partial class MacroForm : Form
    {
        private bool m_isServer = false;

        public MacroForm()
        {
            InitializeComponent();

            this.Font = SystemFonts.DefaultFont;
            foreach (Control c in this.Controls)
            {
                if (c.Name != "btnBrowse")
                {
                    c.Font = SystemFonts.DefaultFont;
                }
            }
        }

        private void MacroForm_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape) this.Close();
        }

        private void MacroForm_Load(object sender, EventArgs e)
        {
            EnableUiSuspension(false);

            // Form
            this.Text = DialogStrings.frmTitle;

            // FTL            
            //smartFromToList1.Caption = DialogStrings.ftlCaption;
            //smartFromToList1.CaptionFrom = DialogStrings.ftlCaptionFrom;
            //smartFromToList1.CaptionTo = DialogStrings.ftlCaptionTo;
            //smartFromToList1.ReportingName = DialogStrings.ftlReportName;

            smartToolTip1.SetToolTip(btnBrowse, DialogStrings.smartBtnBrowseToolTip);

            // LBL
            smartLabel12.Text = DialogStrings.smartLabel12Text;
            smartLabel13.Text = DialogStrings.smartLabel13Text;

            // CBX
            smartComboBox1.ReportingName = DialogStrings.smartComboBox1Report;
            smartComboBox2.ReportingName = DialogStrings.smartComboBox2Report;

            // TBX
            smartTextBox1.ReportingName = DialogStrings.smartTextBox1Report;
            smartTextBox2.ReportingName = DialogStrings.smartTextBox2Report;
            smartTextBox3.ReportingName = DialogStrings.smartTextBox3Report;
            smartTextBox4.ReportingName = DialogStrings.smartTextBox4Report;

            // OGR

            // CHBX
            smartCheckBox1.Text = DialogStrings.smartCheckBox1Text;
            smartCheckBox1.ReportingName = DialogStrings.smartCheckBox1Report;
            smartCheckBox2.Text = DialogStrings.smartCheckBox2Text;
            smartCheckBox2.ReportingName = DialogStrings.smartCheckBox3Report;
            smartCheckBox3.Text = DialogStrings.smartCheckBox3Text;
            smartCheckBox3.ReportingName = DialogStrings.smartCheckBox3Report;

            Button_Description.Text = DialogStrings.btnHint;

            if (smartTextBox1.Value == string.Empty)
            {
                smartCheckBox1.Enabled = false;
                smartTextBox2.Enabled = false;
                smartCheckBox2.Enabled = false;
                smartTextBox3.Enabled = false;
                smartCheckBox3.Enabled = false;
                smartTextBox4.Enabled = false;
                smartLabel13.Enabled = false;
                smartComboBox1.Enabled = false;
                smartComboBox2.Enabled = false;
            }
            else
            {
                if (smartCheckBox1.Checked == false)
                {
                    smartTextBox2.Enabled = false;
                }
                if (smartCheckBox2.Checked == false)
                {
                    smartTextBox3.Enabled = false;
                }
                if (smartCheckBox3.Checked == false)
                {
                    smartTextBox4.Enabled = false;
                }
                if (smartCheckBox2.Checked == false | smartCheckBox3.Checked == false)
                {
                    smartComboBox2.Enabled = false;
                }
                if (smartCheckBox2.Checked == false && smartCheckBox3.Checked == false)
                {
                    smartComboBox1.Enabled = false;
                }
            }

            try
            {
                dynamic context = (object)dataExchanger;
                m_isServer = ((int)context.Context.Location) > 0;
            }
            catch { }

            _comboBoxList = new []
            {
                new SmartComboBoxEx(smartComboBox1, IdeaColumnTypes.Numeric),
            };

            if (!string.IsNullOrEmpty(smartTextBox1.Value))
            {
                if (!m_isServer)
                {
                    FullFileName = Path.Combine(IdeaConfigAdapter.WorkingDirectory, smartTextBox1.Value);
                }

                if (File.Exists(FullFileName))
                {
                    if (dataExchanger.Value.ContainsKey(0))// && dataExchanger.Value.ContainsKey(8))
                    {
                        RestoreComboBoxes();
                    }
                    else
                    {
                        InitComboBoxes();
                    }
                }
            }

            EnableUiSuspension(true);
            SuspendUiComboBoxes(false);
        }

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

        private void RestoreComboBoxes()
        {
            SuspendUiComboBoxes(true);

            try
            {
                for (var i = 0; i < _comboBoxList.Length; i++)
                {
                    _comboBoxList[i].Control.Items.Clear();
                    _comboBoxList[i].Control.Items.AddRange((object[])dataExchanger.Value[i]);
                    _comboBoxList[i].Control.SelectedIndex = (int)dataExchanger.Value[100 + i];
                }

                UpdateComboBoxesLists();
            }

            finally
            {
                SuspendUiComboBoxes(false);
            }
        }

        private void btnBrowse_Click(object sender, EventArgs e)
        {
            Type openFileType = Type.GetTypeFromProgID("ideaex.FileExplorer");
            dynamic openFile = Activator.CreateInstance(openFileType);
            Enabled = false;

            try
            {
                openFile.DisplayDialog();
                Activate();
                string fileName = openFile.SelectedFile;

                if (!string.IsNullOrEmpty(fileName))
                {
                    string errorMessage = string.Empty;

                    if (!m_isServer)
                    {
                        if (fileName.StartsWith(IdeaConfigAdapter.WorkingDirectory))
                        {
                            fileName = fileName.Substring(IdeaConfigAdapter.WorkingDirectory.Length);
                            if (fileName.StartsWith("\\"))
                                fileName = fileName.Substring(1);
                        }
                        else
                        {
                            errorMessage = DialogStrings.MsgSelectLocalTable;
                        }
                    }

                    if (!string.IsNullOrEmpty(errorMessage))
                    {
                        Enabled = true;
                        MessageBox.Show(this, errorMessage, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                    else if (string.CompareOrdinal(smartTextBox1.Value.ToUpper(), fileName.ToUpper()) != 0)
                    {
                        FullFileName = openFile.SelectedFile;
                        smartTextBox1.Value = fileName;
                    }
                }
            }

            finally
            {
                //Enable
                smartCheckBox1.Enabled = true;
                //if(smartCheckBox1.Enabled == true) smartTextBox2.Enabled = false;
                smartCheckBox2.Enabled = true;
                //if (smartCheckBox2.Enabled == true) smartTextBox3.Enabled = false; 
                smartCheckBox3.Enabled = true;
                //if (smartCheckBox3.Enabled == true) smartTextBox4.Enabled = false;
                //if (smartCheckBox3.Enabled == true && smartCheckBox2.Enabled == true) smartComboBox2.Enabled = false;
                //if (smartCheckBox3.Enabled == true || smartCheckBox2.Enabled == true) smartLabel13.Enabled = false;
                //if (smartCheckBox3.Enabled == true || smartCheckBox2.Enabled == true) smartComboBox1.Enabled = false;
                Activate();
                Enabled = true;
            }
        }

        // columns from the selected table
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
                        catch(FileNotFoundException)
                        {
                            _columns = null;
                        }
                    }

                    if(_columns == null)
                    {
                        _columns = new IdeaTableFieldEx[0];
                    }
                }

                return _columns;
            }
        }

        private SmartComboBoxEx[] _comboBoxList;

        private bool _suspendUiComboBoxes = true;
        private bool _suspensionEnabled = false;
        private void EnableUiSuspension(bool value)
        {
            _suspensionEnabled = value;
        }

        private void SuspendUiComboBoxes(bool value)
        {
            if (_suspensionEnabled)
                _suspendUiComboBoxes = value;
        }

        private void InitComboBoxes()
        {
            SuspendUiComboBoxes(true);

            try
            {
                // add column names that maps to tags
                foreach (var cbEx in _comboBoxList)
                {
                    cbEx.Items.Clear();
                    foreach (var column in Columns)
                    {
                        if (!column.Used && cbEx.HasCommonTagWith(column) && cbEx.HasCommonTypeWith(column))
                        {
                            column.Used = true;
                            cbEx.Items.Add(column.Field.FieldName);
                            cbEx.Selection = 0;
                            break;
                        }
                    }
                }

                UpdateComboBoxesLists();
            }

            finally
            {
                SuspendUiComboBoxes(false);
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

        private void UpdateComboBoxesLists()
        {
            SuspendUiComboBoxes(true);

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
                SuspendUiComboBoxes(false);
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

        // clear and add available columns
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

        private void Button_OK_Click(object sender, EventArgs e)
        {
            //bool rule1 = IsLineValid(1) && (smartCheckBox2.Checked == true | smartCheckBox3.Checked == true); //&& (IsLineValid(11) || (IsLineValid(9) && IsLineValid(10)));
            if (smartCheckBox1.Checked == true && smartTextBox2.Value == "")
            {
                MessageBox.Show(DialogStrings.msgRule1, Text, MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
            if (smartCheckBox2.Checked == true && smartTextBox3.Value == "")
            {
                MessageBox.Show(DialogStrings.msgRule2, Text, MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
            if (smartCheckBox3.Checked == true && smartTextBox4.Value == "")
            {
                MessageBox.Show(DialogStrings.msgRule3, Text, MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
            if ((smartCheckBox2.Checked == true || smartCheckBox3.Checked == true) && !IsLineValid(1))
            {
                MessageBox.Show(DialogStrings.msgRule4, Text, MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            dataExchanger.Value.Clear();

            // save the comboBoxes items
            for (var i = 0; i < _comboBoxList.Length; i++)
            {
                var c = new object[_comboBoxList[i].Control.Items.Count];
                _comboBoxList[i].Control.Items.CopyTo(c, 0);
                dataExchanger.Value[i] = c;
                dataExchanger.Value[100 + i] = _comboBoxList[i].Control.SelectedIndex;
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
            if (!_suspendUiComboBoxes)
                UpdateComboBoxesLists();
        }

        private void smartTextBox1_OnTextChanged(object sender, EventArgs data)
        {
            if (!_suspendUiComboBoxes)
            {
                _columns = null;

                InitComboBoxes();
            }
        }
        // Enabled und IsOptional changes
        private void smartCheckBox1_CheckedChanged(object sender, EventArgs e)
        {
            if (smartCheckBox1.Checked == true)
            {
                smartTextBox2.Enabled = true;
                smartTextBox2.IsOptional = false;
                smartCheckBox2.IsOptional = true;
                smartTextBox3.IsOptional = true;
                smartCheckBox3.IsOptional = true;
                smartTextBox4.IsOptional = true;
                smartComboBox2.IsOptional = true;
            }
            if (smartCheckBox1.Checked == false)
            {
                smartTextBox2.Enabled = false;
                smartTextBox2.IsOptional = true;
                smartCheckBox2.IsOptional = false;
                smartTextBox3.IsOptional = false;
                smartCheckBox3.IsOptional = false;
                smartTextBox4.IsOptional = false;
                smartComboBox2.IsOptional = false;

            }
        }
        private void smartCheckBox2_CheckedChanged(object sender, EventArgs e)
        {
            if (smartCheckBox2.Checked == true)
            {
                smartCheckBox1.IsOptional = true;
                smartTextBox2.IsOptional = true;
                smartTextBox3.Enabled = true;
                smartTextBox3.IsOptional = false;
                smartCheckBox3.IsOptional = true;
                smartTextBox4.IsOptional = true;
                smartComboBox1.Enabled = true;
                smartComboBox1.IsOptional = false;
            }
            if (smartCheckBox2.Checked == false)
            {
                smartCheckBox1.IsOptional = false;
                smartTextBox2.IsOptional = false;
                smartTextBox3.Enabled = false;
                smartTextBox3.IsOptional = true;
                smartCheckBox3.IsOptional = false;
                smartTextBox4.IsOptional = false;
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
            else
            {
                smartComboBox2.Enabled = false;
            }
        }
        private void smartCheckBox3_CheckedChanged(object sender, EventArgs e)
        {
            if (smartCheckBox3.Checked == true)
            {
                smartCheckBox1.IsOptional = true;
                smartTextBox2.IsOptional = true;
                smartTextBox4.Enabled = true;
                smartTextBox4.IsOptional = false;
                smartCheckBox2.IsOptional = true;
                smartTextBox3.IsOptional = true;
                smartComboBox1.Enabled = true;
                smartComboBox1.IsOptional = false;
            }
            if (smartCheckBox3.Checked == false)
            {
                smartCheckBox1.IsOptional = false;
                smartTextBox2.IsOptional = false;
                smartTextBox4.Enabled = false;
                smartTextBox4.IsOptional = true;
                smartCheckBox2.IsOptional = false;
                smartTextBox3.IsOptional = false;
            }
            if (smartCheckBox2.Checked == true && smartCheckBox3.Checked == true)
            {
                smartComboBox2.Enabled = true;
            }
            else
            {
                smartComboBox2.Enabled = false;
            }
            if (smartCheckBox2.Checked == false && smartCheckBox3.Checked == false)
            {
                smartComboBox1.Enabled = false;
                smartComboBox1.IsOptional = true;
            }
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

            foreach (var column in ((MacroForm)Control.Parent).Columns)
            {
                if (column != null && column.Field != null && column.Field.FieldName != null && column.Field.FieldName == selectedColumnName)
                    return column;
            }

            return null;
            //throw new ApplicationException("selectedColumnName unknown (" + selectedColumnName + ")");
        }
    }

    internal class IdeaTableFieldEx
    {
        internal IdeaTableFieldEx(IdeaTableField f)
        {
            Field = f;
        }

        internal IdeaTableField Field;
        internal bool Used { get; set; }
    }
}