using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices.WindowsRuntime;
using UnityEngine;
[ExecuteInEditMode]
public class Test : MonoBehaviour
{
    private Camera camera;
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

    void Start()
    {
        Debug.LogError("start");
        camera = Camera.main;
        //camera.depthTextureMode = DepthTextureMode.DepthNormals;
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, material);
    }
}