using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(Test))]
public class TestEditor : Editor
{
    private Test test;
    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();
        test = target as Test;
        if (GUILayout.Button("AAA"))
        {
            test.TestFunc();
        }
    }
}