//环境映射 反射
Shader "Chapter10/Reflection"
{
    Properties
    {
        _Color("漫反射颜色", Color) = (1, 1, 1, 1)
        _ReflectionColor("反射颜色", Color) = (1, 1, 1, 1)
        _ReflectionAmount("反射程度", Range(0, 1)) = 1
        _Cubemap("环境纹理", Cube) = "_Skybox" {}
    }
    SubShader
    {
        Tags {"RenderType"="Opaque" "Queue"="Geometry"}

        Pass
        {
            Tags { "LightMode"="ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile_fwdbase

            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct a2v
            {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
            };

            struct v2f
            {               
                float4 pos : SV_POSITION; 
                float3 worldNormal : TEXCOORD0;
                float4 worldPos : TEXCOORD1;
                float3 worldViewDir : TEXCOORD2;
                float3 worldRefl : TEXCOORD3;
                SHADOW_COORDS(4)
            };

            fixed4 _Color;
            fixed4 _ReflectionColor;
            fixed _ReflectionAmount;
            samplerCUBE _Cubemap;
            
            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                //观察方向  UnityWorldSpaceViewDir:输入一个世界空间中的顶点位置，返回世界空间中从该点到摄像机的观察方向。
                o.worldViewDir = UnityWorldSpaceViewDir(o.worldPos);
                //反射方向
                o.worldRefl = reflect(-o.worldViewDir, o.worldNormal);
                TRANSFER_SHADOW(o);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed3 worldViewDir = normalize(i.worldViewDir);
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                //cdiffuse = (clight · mdiffuse)max(0,n·I)
                fixed3 diffuse = _LightColor0.rgb * _Color.rgb * max(0, dot(worldNormal, worldLightDir));
                fixed3 reflection = texCUBE(_Cubemap, i.worldRefl).rgb * _ReflectionColor.rgb;
                UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
                fixed3 color = ambient + lerp(diffuse, reflection, _ReflectionAmount) * atten;
                return fixed4(color, 1);
            }
            ENDCG
        }
    }
}
