using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace PNChange
{
    static class Utilities
    {
        
        public static void SaveFile(System.IO.FileStream fs, string strFileContent)
        {
            Encoding inputEncoding = Encoding.GetEncoding("Windows-1252");
            System.IO.StreamWriter sw = new System.IO.StreamWriter(fs, inputEncoding);
            sw.WriteLine(strFileContent);

            sw.Flush();
            sw.Close();

            fs.Close();
        }

        public static string OpenFile(string fileName)
        {
            string fileContent = "";
            Encoding inputEncoding = Encoding.GetEncoding("Windows-1252");
            System.IO.StreamReader sr = new
                   System.IO.StreamReader(fileName, inputEncoding);
            fileContent = sr.ReadToEnd();
            sr.Close();

            return fileContent;
        }

        private static bool ValidateAllowedCharacters(string str)
        {
            bool result = true;
        
            /**
             * allowed characters are
             * "-"
             * "/"
             * "\"
             * "("
             * ")"
             */
        
            //must check if 
        
            return result;
        }
        
        public static bool IsRegionValid(string region)
        {
            bool result = true;
        
            region = region.Replace("-", ""); //it can have "-" within
            region = region.Replace("/", ""); //it can have "-" within
            region = region.Replace("\\", ""); //it can have "-" within
            region = region.Replace("(", ""); //it can have "-" within
            region = region.Replace(")", ""); //it can have "-" within
            region = region.Replace(" ", ""); //it can have "-" within
            region = region.Replace(".", ""); //it can have "-" within
        
            //validate is it a string
            if (string.IsNullOrEmpty(region))
            {
                result = false;
            }
            else if (!region.All(char.IsLetterOrDigit))
            {
                result = false;
            }
        
            return result;
        }
        
        public static bool IsNameValid(string name)
        {
            bool result = true;
            if (string.IsNullOrEmpty(name))
            {
                result = false;
            }
            else
            {
                name = name.Replace("-", ""); //it can have "-" within
                name = name.Replace("/", ""); //it can have "-" within
                name = name.Replace("\\", ""); //it can have "-" within
                name = name.Replace("(", ""); //it can have "-" within
                name = name.Replace(")", ""); //it can have "-" within
                name = name.Replace(".", ""); //it can have "-" within
                name = name.Replace(" ", ""); //it can have "-" within
        
                //validate is it a string
        
                if (!name.All(char.IsLetterOrDigit))
                {
                    result = false;
                }
            }
        
            return result;
        }
        
        
        public static bool IsDateValid(string date)
        {
            bool result = true;
        
            DateTime dateTime;
            string format = "yyyymmdd";
            if (!DateTime.TryParseExact(date, format, CultureInfo.InvariantCulture,
                DateTimeStyles.None, out dateTime))
            {
                result = false;
            }
        
            return result;
        }

        public static string RowValue(DataGridViewRow row, int cell)
        {
            string rValue;
            DialogResult test;
            if (row.Cells[cell].Value != null)
            {
                rValue = "";
                test = MessageBox.Show("leer" + row.ToString() + cell.ToString());
            }
            else
            {
                rValue = row.Cells[cell].Value.ToString();
                test = MessageBox.Show("nicht leer" + row.ToString() + cell.ToString());
            }
            return rValue;
        }
    }
}
