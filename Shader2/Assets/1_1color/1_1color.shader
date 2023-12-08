Shader "Custom/1_1color"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,0.5,0.5,1)
    }
    SubShader
    {
        // Tags { "RenderType"="Opaque" }
        // LOD 100

        Pass {
            Material {
                //显示该颜色
                Diffuse [_Color]
            }
            //打开光照开关，即接受光照
            Lighting On
        }
    }
}
