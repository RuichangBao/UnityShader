using UnityEngine;

/// <summary>��˹ģ��</summary>
public class GaussianBlur : PostEffectsBase
{
    public Shader gaussianBlurShader;
    private Material gaussianBlurMaterial;
    private Material material
    {
        get
        {
            gaussianBlurMaterial = CheckShaderAndCreateMaterial(gaussianBlurShader, gaussianBlurMaterial);
            return gaussianBlurMaterial;
        }
    }
    [Range(0, 4)]
    public int iterations = 3;
    [Range(0.2f, 3f)]
    public float blurSpread = 0.6f;
    [Range(1, 8)]
    public int downSample = 2;
    /// <summary>
    /// 
    /// </summary>
    /// <param name="source">Դ��Ⱦ����������ǰ��Ļ����Ⱦ����</param>
    /// <param name="destination">Ŀ����Ⱦ�������������Ļ����Ⱦ����</param>
    /*private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material != null)
        {
            int rtW = source.width;
            int rtH = source.height;
            RenderTexture buffer = RenderTexture.GetTemporary(rtW, rtH, 0);
            Graphics.Blit(source, buffer, material, 0);//����pass1  ��ֱ����ģ��
            Graphics.Blit(buffer, destination, material, 1);//����pass2 ˮƽ����ģ��
            RenderTexture.ReleaseTemporary(buffer);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }*/

    /// <param name="source">Դ��Ⱦ����������ǰ��Ļ����Ⱦ����</param>
    /// <param name="destination">Ŀ����Ⱦ�������������Ļ����Ⱦ����</param>
    /*private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material != null)
        {
            //�������Ž��н��������Ӷ�������Ҫ��������ظ���
            int rtW = source.width / downSample;
            int rtH = source.height / downSample;
            RenderTexture buffer = RenderTexture.GetTemporary(rtW, rtH, 0);
            buffer.filterMode = FilterMode.Bilinear;
            Graphics.Blit(source, buffer, material, 0);
            Graphics.Blit(buffer, destination, material, 1);
            RenderTexture.ReleaseTemporary(buffer);
        }
    }*/

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material != null)
        {
            int rtW = source.width / downSample;
            int rtH = source.height / downSample;
            RenderTexture buffer0 = RenderTexture.GetTemporary(rtW, rtH, 0);
            buffer0.filterMode = FilterMode.Bilinear;
            Graphics.Blit(source, buffer0);//buffer0 �˲�����
            for (int i = 0; i < iterations; i++)
            {
                material.SetFloat("_BlurSize", 1.0f + i * blurSpread);
                RenderTexture buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);
                Graphics.Blit(buffer0, buffer1, material, 0);//��ֱ����ģ��
                buffer0 = buffer1;
                buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);//ˮƽ����ģ��
                Graphics.Blit(buffer0, buffer1, material, 1);
                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
            }
            Graphics.Blit(buffer0, destination);
            RenderTexture.ReleaseTemporary(buffer0);
        }
        else
            Graphics.Blit(source, destination);
    }/**/
}