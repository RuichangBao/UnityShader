//切线空间下的凹凸纹理
Shader "Chapter7/NormalMapTangentSpace"
{
    Properties
    {
        _Color ("图片颜色", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white" {}
        _BumpMap("法线纹理", 2D) = "white" {}
        _BumpScale("法线纹理影响程度",float ) = 1.0
        _Specular ("高光反射", Color) = (1, 1, 1, 1)
        _Gloss ("光泽度", Range(8.0, 256)) = 20
    }
    SubShader
    {
        Tags { "LightMode"="ForwardBase" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            float4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            float _BumpScale;
            float4 _Specular;
            float _Gloss;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD0;
                //切线空间下的光照方向
                float3 lightDir : TEXCOORD1;
                //切线空间下的视角方向
                float3 viewDir : TEXCOORD2;
            };

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
                //世界空间下的法线
                fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
                //世界空间下的切换
                fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                //世界空间下的副法线  
                fixed3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;
                //世界空间到切线空间的变换矩阵 
                float3x3 worldToTangent = float3x3(worldTangent, worldBinormal, worldNormal);
                //世界空间下的光照方向
                float4 worldSpaceLightDir = WorldSpaceLightDir(v.vertex);
                //世界空间下的观察方向
                float4 worldSpaceViewDir = WorldSpaceViewDir(v.vertex);
                o.lightDir = mul(worldToTangent, worldSpaceLightDir);
                o.viewDir = mul(worldToTangent, worldSpaceViewDir);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            { 
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 albedo = tex2D(_MainTex, i.uv)*_Color.rgb;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal, worldLightDir));
                
                fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - UnityObjectToWorldNormal(i.pos).xyz);
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, viewDir)), _Gloss);
                fixed3 color = ambient + diffuse + specular ;
                return fixed4(color, 1);
            }
            ENDCG
        }
    }
}
//未完待续