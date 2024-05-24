using UnityEngine;
///<summary>��Ե���</summary>
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
    //��������
    public float sampleDistance = 1;
    public float sensitivityDepth = 1;
    public float sensitivityNormals = 1;
    private void OnEnable()
    {
        GetComponent<Camera>().depthTextureMode |= DepthTextureMode.DepthNormals;
    }

    [ImageEffectOpaque]//�ڲ�͸��pass��Ⱦ��Ϻ�ִ��
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material == null)
        {
            Graphics.Blit(source, destination);
            return;
        }

        material.SetFloat("_EdgeOnly", edgesOnly);
        material.SetColor("_EdgeColor", edgeColor);
        material.SetColor("_BackgroundColor", backgroundColor);
        material.SetFloat("_SampleDistance", sampleDistance);
        material.SetVector("_Sensitivity", new Vector2(sensitivityNormals, sensitivityDepth));

        Graphics.Blit(source, destination, material);
    }
}