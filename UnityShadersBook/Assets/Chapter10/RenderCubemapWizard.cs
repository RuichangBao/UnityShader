using UnityEngine;
using UnityEditor;

public class RenderCubemapWizard : ScriptableWizard
{

    public Transform renderFromPosition;
    public Cubemap cubemap;

    void OnWizardUpdate()
    {
        helpString = "ѡ��Ҫ��Ⱦ��transform��Ҫ��Ⱦ��cubemap";
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

    [MenuItem("GameObject/��Ⱦ����ӳ��")]
    static void RenderCubemap()
    {
        ScriptableWizard.DisplayWizard<RenderCubemapWizard>("Render cubemap", "��Ⱦ!");
    }
}