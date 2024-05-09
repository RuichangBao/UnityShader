using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode]
public class FilterModes : MonoBehaviour
{
    public Shader shader;
    private Material _material;
    public Material material
    {
        get
        {
            if (_material == null)
                _material = new Material(shader);
            if (_material.shader != shader)
                _material.shader = shader;
            return _material;
        }
    }
    [Range(1, 100)]
    public int zoom = 1;
    public void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        int width = source.width / zoom;
        int height = source.height / zoom;
        RenderTexture renderTexture = RenderTexture.GetTemporary(width, height);
        renderTexture.filterMode = FilterMode.Bilinear;
        Graphics.Blit(source, renderTexture);
        Graphics.Blit(renderTexture, destination, material);
    }
}