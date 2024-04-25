//阴影
Shader "Unlit/Shadow"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NormalMap ("法线贴图", 2D) = "white" {}
        [HDR]_Diffuse("漫反射颜色", Color) = (1,1,1,1)
        [HDR]_Specular("高光颜色", Color) = (1,1,1,1)
        _Glass("高光",Range(8,256)) = 8
    }
    SubShader
    {
        // Tags { "RenderType"="Opaque" "Queue"="Geometry"}
        Pass
        {
            // Tags { "LightMode"="ForwardBase" }
            CGPROGRAM
            // #pragma multi_compile_fwdbase	

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _NormalMap;
            float4 _NormalMap_ST;
            float4 _Diffuse;
            float4 _Specular;
            float _Glass;
            
            struct a2v
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD0;
                float4 TtoW0 : TEXCOORD1;
                float4 TtoW1 : TEXCOORD2;
                float4 TtoW2 : TEXCOORD3;
                SHADOW_COORDS(4)
            };

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv.xy = v.uv.xy *_MainTex_ST.xy + _MainTex_ST.zw;
                o.uv.zw = v.uv.xy *_NormalMap_ST.xy + _NormalMap_ST.zw;
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float3 worldPos = UnityObjectToWorldDir(v.vertex);
                float3 worldTangent = UnityObjectToWorldDir(v.tangent);
                float3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;
                o.TtoW0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
                o.TtoW1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
                o.TtoW2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
                TRANSFER_SHADOW(o)
                return o;
            }

            fixed4 frag (v2f o) : SV_Target
            {
                fixed3 textureCol = tex2D(_MainTex, o.uv.xy);
                float3 worldPos = float3(o.TtoW0.w, o.TtoW1.w, o.TtoW2.w);//世界空间下的点坐标

                //光源方向
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(worldPos));
                float4 textureNormal = tex2D(_NormalMap, o.uv.zw);
                float3 tangentNormal = UnpackNormal(textureNormal);
                //UnpackNormal等同于下面代码
                // fixed3 tangentNormal;
                // tangentNormal.xy = textureNormal.wy * 2 - 1;
                tangentNormal.z = sqrt(1 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));
                //将纹理法线转换到世界空间下
                float3 worldNormal = float3(float3(dot(o.TtoW0.xyz, tangentNormal), dot(o.TtoW1.xyz, tangentNormal), dot(o.TtoW2.xyz, tangentNormal)));
                //兰伯特光照模型
                float3 diffuse = _LightColor0.rgb * _Diffuse * saturate(dot(worldNormal, worldLightDir));

                //Blinn-Phong模型计算高光反射
                float3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));//视角方向
                float3 halfDir = normalize((worldLightDir + viewDir) / 2);
                float3 specular = _LightColor0.rgb * _Specular * pow(max(0, dot(worldNormal, halfDir)), _Glass);
                UNITY_LIGHT_ATTENUATION(atten, o, worldPos);
                fixed3 color = textureCol * diffuse * atten + specular;
                //fixed3 color = specular;
                return fixed4(color, 1);
            }
            ENDCG
        }
    }
    FallBack "Specular"
}
