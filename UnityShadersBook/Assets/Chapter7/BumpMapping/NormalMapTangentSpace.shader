// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

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
                // o.pos = UnityObjectToClipPos(v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
                //模型空间下的光照方向
                float3 modelLightDir = ObjSpaceLightDir(v.vertex);
                //模型空间下的视角方向
                float3 mmodelVierDir = ObjSpaceViewDir(v.vertex);
                TANGENT_SPACE_ROTATION;
                o.lightDir = mul(rotation, modelLightDir).xyz;
                o.viewDir = mul(rotation, mmodelVierDir).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            { 
                fixed3 tangentLightDir = normalize(i.lightDir);
                fixed3 tangentViewDir = normalize(i.viewDir);
                //凹凸纹理
                fixed4 packedNormal = tex2D(_BumpMap, i.uv.zw);
                // UnpackNormal
                // tangentNormal.xy = packednormal.wy * 2 - 1;
                // tangentNormal.z = sqrt(1 - saturate(dot(normal.xy, normal.xy)));
                fixed3 tangentNormal = UnpackNormal(packedNormal);
                
                tangentNormal.xy *= _BumpScale;
                //法向量是单位向量长度为1，所以x方+y方+z方=1
                //根据这个公式计算z的长度，
                tangentNormal.z = sqrt(1 - dot(tangentNormal.xy, tangentNormal.xy));
                fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(tangentNormal, tangentLightDir));

                fixed3 halfDir  = normalize(tangentLightDir + tangentViewDir);
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(tangentNormal, halfDir)), _Gloss);
                fixed3 color  = ambient + diffuse + specular;
                return fixed4(color, 1);
            }
            ENDCG
        }
    }
}