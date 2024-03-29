//逐像素高光反射
Shader "Unlit/SpecularPixel"
{
    Properties
    {
        _Diffuse ("漫反射", Color) = (1, 1, 1, 1)
        _Specular ("高光反射", Color) = (1, 1, 1, 1)
        _Gloss ("光泽度", Range(8.0, 256)) = 20
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
            fixed4 _Specular;
            float _Gloss;

            struct a2v
            {
                float4 pos:POSITION;
                float3 normal:NORMAL;
            };
            struct v2f
            {  
                float4 pos:SV_POSITION;
                float3 worldPos:TEXCOORD0;
                float3 worldNormal:TEXCOORD1;
            };
            
            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.worldPos = mul(unity_ObjectToWorld, v.pos);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            float4 frag(v2f v):SV_Target
            { 
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 worldNormal = normalize(v.worldNormal);
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));
                fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - v.worldPos.xyz);
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, viewDir)), _Gloss);
                fixed3 color = ambient + diffuse + specular;
                return fixed4(color, 1.0);
            }
            ENDCG
        }        
    }
}