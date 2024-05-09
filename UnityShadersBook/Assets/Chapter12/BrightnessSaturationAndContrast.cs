using UnityEngine;

/// <summary> ���ȱ��ͶȺͶԱȶ�</summary>
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
    public float brightness = 1.0f;//����

    [Range(0, 3)]
    public float saturation = 1.0f;//���Ͷ�

    [Range(0, 3)]
    public float contrast = 1.0f;//�Աȶ�

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        //Debug.LogError("On Render Image");
        if (material != null)
        {
            material.SetFloat("_Brightness", brightness);
            material.SetFloat("_Saturation", saturation);
            material.SetFloat("_Contrast", contrast);
            //ʹ����ɫ����Դ�����Ƶ�Ŀ��������
            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}