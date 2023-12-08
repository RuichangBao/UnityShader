Shader "Custom/1_3merge2texture"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _MainTex2 ("Tex2 (RGB)", 2D) = "white" {}
        _Color("Main color",Color) = (1,1,1,1)
    }
    SubShader
    {
        Pass
        {
            Material
            {
                Diffuse[_Color]
            }
            Lighting on
            SetTexture[_MainTex]
            {
                //     第一张材质 * 顶点颜色
                Combine texture * primary
            }
            SetTexture[_MainTex2]
            {
                //     第二张材质 * 之前累积（这里即第一张材质）
                Combine texture * previous
            }
        }
    }
}
