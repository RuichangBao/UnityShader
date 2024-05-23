using UnityEngine;
///<summary>边缘检测</summary>
public class EdgeDetectNormalAndDepth : PostEffectsBase
{
    public Shader edgeDetectShader = null;
    private Material edgeDetectMaterial = null;
    public Material material
    {
        get
        {
            edgeDetectMaterial = CheckShaderAndCreateMaterial(edgeDetectShader, edgeDetectMaterial);
            return edgeDetectMaterial;
        }
    }
    [Range(0, 1)]
    public float edgesOnly = 0f;
    public Color edgeColor = Color.black;
    public Color backgroundColor = Color.white;
    //采样距离
    public float sampleDistance = 1f;
    public float sensitivityDepth = 1f;
    public float sensitivityNormals = 1f;
    private void OnEnable()
    {
        GetComponent<Camera>().depthTextureMode |= DepthTextureMode.DepthNormals;
    }

    [ImageEffectOpaque]//在不透明pass渲染完毕后执行
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (edgeDetectMaterial == null)
        {
            Graphics.Blit(source, destination);
            return;
        }

        material.SetFloat("_EdgeOnly", edgesOnly);
        material.SetColor("_EdgeColor", edgeColor);
        material.SetColor("_BackgroundColor", backgroundColor);
        material.SetFloat("_SampleDistance", sampleDistance);
        material.SetVector("_Sensitivity", new Vector4(sensitivityNormals, sensitivityDepth, 0.0f, 0.0f));

        Graphics.Blit(source, destination, material);
    }


    //[ImageEffectOpaque]
    //void OnRenderImage(RenderTexture src, RenderTexture dest)
    //{
    //    if (material != null)
    //    {
    //        material.SetFloat("_EdgeOnly", edgesOnly);
    //        material.SetColor("_EdgeColor", edgeColor);
    //        material.SetColor("_BackgroundColor", backgroundColor);
    //        material.SetFloat("_SampleDistance", sampleDistance);
    //        material.SetVector("_Sensitivity", new Vector4(sensitivityNormals, sensitivityDepth, 0.0f, 0.0f));

    //        Graphics.Blit(src, dest, material);
    //    }
    //    else
    //    {
    //        Graphics.Blit(src, dest);
    //    }
    //}
}