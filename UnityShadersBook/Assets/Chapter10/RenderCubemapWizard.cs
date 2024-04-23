using UnityEngine;
using UnityEditor;

public class RenderCubemapWizard : ScriptableWizard
{

    public Transform renderFromPosition;
    public Cubemap cubemap;

    void OnWizardUpdate()
    {
        helpString = "选择要渲染的transform和要渲染的cubemap";
        isValid = (renderFromPosition != null) && (cubemap != null);
    }

    void OnWizardCreate()
    {
        // create temporary camera for rendering
        GameObject go = new GameObject("CubemapCamera");
        go.AddComponent<Camera>();
        // place it on the object
        go.transform.position = renderFromPosition.position;
        // render into cubemap		
        go.GetComponent<Camera>().RenderToCubemap(cubemap);

        // destroy temporary camera
        DestroyImmediate(go);
    }

    [MenuItem("GameObject/渲染环境映射")]
    static void RenderCubemap()
    {
        ScriptableWizard.DisplayWizard<RenderCubemapWizard>("Render cubemap", "渲染!");
    }
}