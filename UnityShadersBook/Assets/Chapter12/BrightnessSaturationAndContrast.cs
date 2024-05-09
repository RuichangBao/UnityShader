using UnityEngine;

/// <summary> 亮度饱和度和对比度</summary>
public class BrightnessSaturationAndContrast : PostEffectsBase
{
    public Shader briSatConShader;
    private Material briSatConMaterial;
    public Material material
    {
        get
        {
            briSatConMaterial = CheckShaderAndCreateMaterial(briSatConShader, briSatConMaterial);
            return briSatConMaterial;
        }
    }

    [Range(0, 3)]
    public float brightness = 1.0f;//亮度

    [Range(0, 3)]
    public float saturation = 1.0f;//饱和度

    [Range(0, 3)]
    public float contrast = 1.0f;//对比度

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        //Debug.LogError("On Render Image");
        if (material != null)
        {
            material.SetFloat("_Brightness", brightness);
            material.SetFloat("_Saturation", saturation);
            material.SetFloat("_Contrast", contrast);
            //使用着色器将源纹理复制到目标纹理中
            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}