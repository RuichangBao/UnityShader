// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

//反射
Shader "UnityShadersBook/Chapter10/Reflection"
{
    Properties
    {
        [HDR]_Color("漫反射颜色", Color) = (1,1,1,1)
        [HDR]_ReflectColor("纹理反射颜色", Color) = (1,1,1,1)
        _ReflectAmount("纹理反射反射量", Range(0,1)) = 1
        _Cubemap("Reflection Cubemap", Cube) = "_Skybox"{}//反射纹理
    }
    SubShader
    {
        //RenderType:shader 分类,Opaque:用于大多数着色器（法线着色器、自发光着色器、反射着色器以及地形的着色器）。
        //Queue: 控制渲染顺序,渲染队列，Geometry：	指定几何体渲染队列
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry"}

        Pass
        {
            //LightMode:渲染路径，ForwardBase：用于前向渲染。该Pass会计算环境光、最重要的平行光、逐顶点/SH光源和Lightmaps
            Tags { "LightMode"="ForwardBase" }
            
            CGPROGRAM
            #pragma multi_compile_fwdbase
            
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            #pragma vertex vert
            #pragma fragment frag

            struct a2v 
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f 
            {
                float4 pos : SV_POSITION;
                float3 worldPos : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float3 worldViewDir : TEXCOORD2;
                float3 worldRefl : TEXCOORD3;//反射反向

                // #define SHADOW_COORDS(idx1) unityShadowCoord4 _ShadowCoord : TEXCOORD##idx1;
                // float4 _ShadowCoord : TEXCOORD4;
                SHADOW_COORDS(4)
            };

            v2f vert (a2v v)
            {
                v2f o;
                //裁剪坐标
                o.pos = UnityObjectToClipPos(v.vertex);
                //世界空间法线
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                //世界空间坐标
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                //世界空间观察方向(视角方向)
                o.worldViewDir = UnityWorldSpaceViewDir(o.worldPos);
                //reflect:返回入射光线i对表面法线n的反射光线。
                //计算世界空间下的反射方向
                o.worldRefl = reflect(-o.worldViewDir, o.worldNormal);
                //o._ShadowCoord = ComputeScreenPos(o.pos);
                TRANSFER_SHADOW(o);
                return o;
            }

            fixed4 _Color;
            samplerCUBE _Cubemap;
            fixed4 _ReflectColor;
            //反射量
            float _ReflectAmount;

            fixed4 frag (v2f i) : SV_Target
            {
                //世界空间下的法线
                fixed3 worldNormal = normalize(i.worldNormal);
                //世界空间下的光源方向
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                //世界空间下的视角方向
                fixed3 worldViewDir = normalize(i.worldViewDir);
                //环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                //漫反射
                fixed3 diffuse = _LightColor0.rgb * _Color.rgb * max(0, dot(worldNormal, worldLightDir));
                //高光反射（texCUBE:立方体采样）
                fixed3 reflection = texCUBE(_Cubemap, i.worldRefl).rgb * _ReflectColor.rgb;

                UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);

                fixed3 color = ambient + lerp(diffuse, reflection, _ReflectAmount) * atten;
                return fixed4(color, 0);
                // return fixed4(reflection, 1);
                // return fixed4(diffuse,1);
            }
            ENDCG
        }
    }
}
