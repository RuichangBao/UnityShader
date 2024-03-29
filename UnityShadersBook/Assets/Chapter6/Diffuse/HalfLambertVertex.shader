//逐顶点半兰伯特光照
Shader "Chapter6/DiffuseVertexLevel"
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
                float4 vertex:POSITION;
                float3 normal:NORMAL;
            };
            struct v2f
            {  
                float4 pos:SV_POSITION;
                float4 color:COLOR;
            };
            
            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                fixed halfLambert = dot(worldNormal, worldLightDir) * 0.5 + 0.5;
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * halfLambert;
                o.color = float4(ambient + diffuse,1);
                return o;
            }

            float4 frag(v2f v):SV_Target
            {
                return v.color;
            }
            ENDCG
        }        
    }
}