using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        Debug.LogError(sizeof(int));
        Debug.LogError(sizeof(char));
        string str = "adfdsf";
        Byte[] data = System.Text.Encoding.Unicode.GetBytes(str);
        Debug.LogError(data.Length);
        string str2 = "";
        foreach (var item in data)
        {
            str2 += item;
        }
        Debug.LogError(str2);
        Debug.LogError(str.Length);
    }
}