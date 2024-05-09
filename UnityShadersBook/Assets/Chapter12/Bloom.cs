using UnityEngine;

public class Bloom : PostEffectsBase
{
    public Shader bloomShader;
    private Material bloomMaterial;
    public Material material
    {
        get
        {
            bloomMaterial = CheckShaderAndCreateMaterial(bloomShader, bloomMaterial);
            return bloomMaterial;
        }
    }

    ///<summary>迭代次数</summary>
    [Range(0, 4)]
    public int iterations = 3;

    ///<summary>模糊传播</summary>
    [Range(0.2f, 3.0f)]
    public float blurSpread = 0.6f;

    ///<summary></summary>
    [Range(1,8)]
    public int downSample = 2;

    ///<summary>亮度阈值</summary>
    [Range(0f, 4f)]
    public float luminanceThreshold = 0.6f;
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material != null)
        {
            material.SetFloat("_LuminanceThreshold", luminanceThreshold);
            int rtW = source.width / downSample;
            int rtH = source.height / downSample;
            RenderTexture buffer0 = RenderTexture.GetTemporary(rtW, rtH, 0);
            buffer0.filterMode = FilterMode.Bilinear;
            Graphics.Blit(source, buffer0, material);
            for (int i = 0; i < iterations; i++)
            {
                material.SetFloat("_BlurSize", 1.0f + i * blurSpread);
                RenderTexture buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);
                Graphics.Blit(buffer0, buffer1, material, 1);

                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
                buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);
                Graphics.Blit(buffer0, buffer1, material, 2);

                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
            }
            material.SetTexture("_Bloom", buffer0);
            Graphics.Blit(source, destination, material, 3);
            RenderTexture.ReleaseTemporary(buffer0);
        }
        else
            Graphics.Blit(source, destination);
    }
}