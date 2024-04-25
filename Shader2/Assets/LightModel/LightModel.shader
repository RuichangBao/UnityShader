//光照模型 包括漫反射（兰伯特，半兰伯特光照模型） 高光（Phong，Blinn-Phong光照模型）
Shader "Unlit/LightModel"
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
            CGPROGRAM
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
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };



            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv.xy = v.uv.xy *_MainTex_ST.xy + _MainTex_ST.zw;
                o.uv.zw = v.uv.xy *_NormalMap_ST.xy + _NormalMap_ST.zw;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 textureCol = tex2D(_MainTex, i.uv);
                float3 worldPos = i.worldPos;//世界空间下的点坐标
                
                //光源方向
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(worldPos));
                float3 worldNormal = normalize(i.worldNormal);

                //兰伯特光照模型
                float3 diffuse = _LightColor0.rgb * _Diffuse * saturate(dot(worldNormal, worldLightDir));
                //半兰伯特光照模型
                //float3 diffuse = _LightColor0.rgb * _Diffuse * (0.5 * saturate(dot(worldNormal, worldLightDir)) + 0.5);


                //Phong模型计算高光反射
                // float3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));//视角方向
                // //光照方向
                // worldLightDir = -worldLightDir;
                // //reflect(i,n) i:光源指向交点
                // float3 reflectDir = normalize(reflect(worldLightDir, worldNormal));//反射方向
                // float3 specular = _LightColor0.rgb * _Specular * pow(max(0, dot(reflectDir, viewDir)), _Glass);
                
                //Blinn-Phong模型计算高光反射
                float3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));//视角方向
                float3 halfDir = normalize((worldLightDir + viewDir) / 2);
                float3 specular = _LightColor0.rgb * _Specular * pow(max(0, dot(worldNormal, halfDir)), _Glass);

                fixed3 color = textureCol * diffuse + specular;
                return fixed4(color, 1);
                // return fixed4(diffuse, 1);
            }
            ENDCG
        }
    }
}
