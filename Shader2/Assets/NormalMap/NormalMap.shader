//法线贴图
Shader "Unlit/NormalMap"
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
        Pass
        {
            Tags { "LightMode"="ForwardBase" }
            CGPROGRAM
            #pragma multi_compile_fwdbase
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

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
            };

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv.xy = v.uv.xy *_MainTex_ST.xy + _MainTex_ST.zw;
                o.uv.zw = v.uv.xy *_NormalMap_ST.xy + _NormalMap_ST.zw;
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float3 worldPos = normalize(mul(unity_ObjectToWorld, v.vertex));
                // float3 worldPos = normalize(UnityObjectToWorldDir(v.vertex.xyz).xyz);
                float3 worldTangent = UnityObjectToWorldDir(v.tangent);
                float3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;
                o.TtoW0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
                o.TtoW1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
                o.TtoW2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 textureCol = tex2D(_MainTex, i.uv.xy);
                float3 worldPos = float3(i.TtoW0.w, i.TtoW1.w, i.TtoW2.w);//世界空间下的点坐标

                //光源方向
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(worldPos));
                float4 textureNormal = tex2D(_NormalMap, i.uv.zw);
                float3 tangentNormal = UnpackNormal(textureNormal);
                //UnpackNormal等同于下面代码
                // fixed3 tangentNormal;
                // tangentNormal.xy = textureNormal.wy * 2 - 1;
                tangentNormal.z = sqrt(1 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));
                //将纹理法线转换到世界空间下
                float3 worldNormal = float3(float3(dot(i.TtoW0.xyz, tangentNormal), dot(i.TtoW1.xyz, tangentNormal), dot(i.TtoW2.xyz, tangentNormal)));
                //兰伯特光照模型
                float3 diffuse = _LightColor0.rgb * _Diffuse * saturate(dot(worldNormal, worldLightDir));
                
                //Phong模型计算高光反射
                // float3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));//视角方向
                // //光照方向
                // worldLightDir = -worldLightDir;
                // //reflect(i,n) i:光源指向交点
                // float3 reflectDir = normalize(reflect(worldLightDir, worldNormal));//反射方向
                // float3 specular = _LightColor0.rgb * _Specular * pow(max(0, dot(reflectDir, viewDir)), _Glass);
                
                //Blinn-Phong模型计算高光反射
                float3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));//视角方向
                float3 halfDir = normalize(worldLightDir + viewDir);
                float3 specular = _LightColor0.rgb * _Specular * pow(max(0, dot(worldNormal, halfDir)), _Glass);

                fixed3 color = textureCol * diffuse + specular;
                //fixed3 color = specular;
                return fixed4(color, 1);
            }
            ENDCG
        }
    }
    // FallBack "Specular"
}
