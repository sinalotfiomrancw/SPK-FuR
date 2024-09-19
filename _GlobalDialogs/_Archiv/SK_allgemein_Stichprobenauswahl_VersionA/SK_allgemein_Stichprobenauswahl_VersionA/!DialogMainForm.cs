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

namespace SK_allgemein_Stichprobenauswahl_VersionA
{
    //[DefaultForm]  // uncomment this line for apps requiring IDEA 10.1 and higher
    public partial class _DialogMainForm : Form
    {
        private bool m_isServer = false;
        public _DialogMainForm()
        {
            InitializeComponent();
            this.Font = SystemFonts.DefaultFont;
            foreach (Control c in this.Controls)
            {
                c.Font = SystemFonts.DefaultFont;
            }
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
                dynamic context = (object)smartDataExchanger1;
                m_isServer = ((int)context.Context.Location) > 0;
            }
            catch { }

            _comboBoxList = new[]
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
                    if (smartDataExchanger1.Value.ContainsKey(0) && smartDataExchanger1.Value.ContainsKey(10))
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
                    _comboBoxList[i].Control.Items.AddRange((object[])smartDataExchanger1.Value[i]);
                    _comboBoxList[i].Control.SelectedIndex = (int)smartDataExchanger1.Value[100 + i];
                }

                UpdateComboBoxesLists();
            }

            finally
            {
                SuspendUiComboBoxes(false);
            }
        }

        private void FileBrowse_Click(object sender, EventArgs e)
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
                            errorMessage = "Sie haben keine gültige IDEA Datei gewählt.";
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
                Activate();
                Enabled = true;
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
                        if (!column.Used && cbEx.HasCommonTypeWith(column) )//&& cbEx.HasCommonTagWith(column) )
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
            bool rule1 = IsLineValid(1); //&& (IsLineValid(11) || (IsLineValid(9) && IsLineValid(10)));
            if (!rule1)
            {
                MessageBox.Show("Bitte wählen Sie eine Spalte für den Cutt Off aus.", Text, MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            smartDataExchanger1.Value.Clear();

            // save the comboBoxes items
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
