using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class RenderCubemapWizard : ScriptableWizard
{
    public Transform renderFromPosition;
    public Cubemap cubemap;

    void OnWizardUpdate()
    {
        Debug.LogError("AAAAAAAAAAAAAAAAAAAAAA");
        string helpString = "Select transform to render from and cubemap to render into";
        //bool isValid = (renderFromPosition != null) & amp; &amp; (cubemap != null);
    }
    void OnWizardCreate()
    {
        Debug.LogError("BBBBBBBBBBBBBBBBBBBBBBBBBB");
        // create temporary camera for rendering
        GameObject go = new GameObject("CubemapCamera");
        go.AddComponent<Camera>();
        // place it on the object
        go.transform.position = renderFromPosition.position;
        go.transform.rotation = Quaternion.identity;
        // render into cubemap
        go.GetComponent<Camera>().RenderToCubemap(cubemap);

        DestroyImmediate(go);
    }

    [MenuItem("渲染/RenderToCubemap")]
    static void RenderCubemap()
    {
        ScriptableWizard.DisplayWizard<RenderCubemapWizard>( "Render cubemap", "Render!");
    }
}
