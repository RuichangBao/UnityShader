using UnityEngine;

/// <summary>高斯模糊</summary>
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
    /// <param name="source">源渲染纹理，（处理前屏幕的渲染纹理）</param>
    /// <param name="destination">目标渲染纹理，（处理后屏幕的渲染纹理）</param>
    /*private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material != null)
        {
            int rtW = source.width;
            int rtH = source.height;
            RenderTexture buffer = RenderTexture.GetTemporary(rtW, rtH, 0);
            Graphics.Blit(source, buffer, material, 0);//传给pass1  竖直方向模糊
            Graphics.Blit(buffer, destination, material, 1);//传给pass2 水平方向模糊
            RenderTexture.ReleaseTemporary(buffer);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }*/

    /// <param name="source">源渲染纹理，（处理前屏幕的渲染纹理）</param>
    /// <param name="destination">目标渲染纹理，（处理后屏幕的渲染纹理）</param>
    /*private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material != null)
        {
            //利用缩放进行降采样，从而减少需要处理的像素个数
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
            Graphics.Blit(source, buffer0);//buffer0 滤波采样
            for (int i = 0; i < iterations; i++)
            {
                material.SetFloat("_BlurSize", 1.0f + i * blurSpread);
                RenderTexture buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);
                Graphics.Blit(buffer0, buffer1, material, 0);//竖直方向模糊
                buffer0 = buffer1;
                buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);//水平方向模糊
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