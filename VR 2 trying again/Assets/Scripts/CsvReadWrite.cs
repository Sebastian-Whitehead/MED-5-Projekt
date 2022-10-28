using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System;
using Unity.VisualScripting;

public class CsvReadWrite : MonoBehaviour
{
    private List<string[]> _rowData = new List<string[]>();


    // Use this for initialization
    void Start()
    {
        First();
        InvokeRepeating("Save", 1.0f, repeatRate:1.0f);
      
    }

    void First(){
        string[] rowDataTemp = new string[3];
        rowDataTemp[0] = "New Participant";
        _rowData.Add(rowDataTemp);
    }
    // ReSharper disable Unity.PerformanceAnalysis
    void Save()
    {
        // Creating First row of titles manually..
        string[] rowDataTemp = new string[3];
        /*  rowDataTemp[0] = "Name";
          rowDataTemp[1] = "ID";
          rowDataTemp[2] = "Income";
          rowData.Add(rowDataTemp);
          */

        // You can add up the values in as many cells as you want.
        for (int i = 0; i < 1; i++)
        {
            rowDataTemp = new string[3];
            /* rowDataTemp[0] = "Sushanta"+i; // name
             rowDataTemp[1] = ""+i; // ID */
            rowDataTemp[2] = "$" + transform.position; // Income
            _rowData.Add(rowDataTemp);
        }
    }

    void OnApplicationQuit()
         {

             string[][] output = new string[_rowData.Count][];

             for (int i = 0; i < output.Length; i++)
             {
                 output[i] = _rowData[i];
             }

             int length = output.GetLength(0);
             const string delimiter = ",";

             StringBuilder sb = new StringBuilder();

             for (int index = 0; index < length; index++)
                 sb.AppendLine(string.Join(delimiter, output[index]));


             string filePath = GetPath();

             StreamWriter outStream = System.IO.File.AppendText(filePath);
             outStream.WriteLine(sb);
             outStream.Close();
             Debug.Log(transform.position);
         }

    // Following method is used to retrieve the relative path as device platform
    private string GetPath()
    {
#if UNITY_EDITOR
        return Application.dataPath + "/CSV/" + "Saved_data.csv";
#elif UNITY_ANDROID
        return Application.persistentDataPath+"Saved_data.csv";
#elif UNITY_IPHONE
        return Application.persistentDataPath+"/"+"Saved_data.csv";
#else
        return Application.dataPath +"/"+"Saved_data.csv";
#endif
    }
}