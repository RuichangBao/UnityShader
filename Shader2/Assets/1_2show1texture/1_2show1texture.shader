Shader "Custom/1_2show1texture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
                //combine color部分，alpha部分
                //     材质 * 顶点颜色
                Combine texture * primary,texture * constant
            }
        }
    }
}
