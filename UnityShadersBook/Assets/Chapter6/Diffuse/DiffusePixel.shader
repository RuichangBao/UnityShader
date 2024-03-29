//逐像素漫反射
Shader "Chapter6/DiffusePixel"
{
    Properties
    {
        _Diffuse("漫反射颜色",Color)=(1,1,1,1)
    }
    SubShader
    {
        Tags{"LightModel" = "ForwardBase"}
        Pass
        {
            CGPROGRAM
            #include "Lighting.cginc"

            #pragma vertex vert
            #pragma fragment frag
            fixed4 _Diffuse;
            struct a2v
            {
                float4 pos:POSITION;
                float3 normal:NORMAL;
            };
            struct v2f
            {  
                float4 pos:SV_POSITION;
                float3 worldNormal:TEXCOORD0;
            };
            
            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.worldNormal = UnityObjectToWorldNormal(v.normal).xyz;
                return o;
            }

            float4 frag(v2f v):SV_Target
            { 
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 worldNormal = normalize(v.worldNormal);
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));
                fixed3 color = ambient + diffuse;
                return fixed4(color, 1.0);
            }
            ENDCG
        }        
    }
}