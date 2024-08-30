Shader "Chapter14/ToonShading"
{
    Properties
    {
        _Color("颜色", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _Ramp("漫反射渐变纹理", 2D) = "white" {}
        _Outline("边缘线宽度",Range(0,1)) = 0.1
        _OutLineColor("边缘线颜色", Color) = (0,0,0,1)
        _Specular("高光颜色",Color) = (1,1,1,1)
        _SpecularScale("高光反射阈值",Range(0,0.1)) = 0.01
    }
    SubShader
    { 
        Tags { "RenderType"="Opaque" "Queue"="Geometry"}
        Pass
        {
            NAME "OUTLINE"
            Cull Front//剔除正面
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            float _Outline;
            float4 _OutLineColor;

            v2f vert (a2v v)
            {
                v2f o;
                //UNITY_MATRIX_MV:模型*观察矩阵
                //观察空间位置
                float4 pos = mul(UNITY_MATRIX_MV, v.vertex);
                //UNITY_MATRIX_IT_MV:法线模型*观察矩阵，将法线从模型空间变换到观察空间
                //观察空间的法线
                float3 normal = mul(UNITY_MATRIX_IT_MV, v.normal);
                normal.z = -0.5;
                //在视角空间下把模型的顶点沿着法线向外扩张一段距离
                pos = pos + float4(normalize(normal), 0) * _Outline;
                //UNITY_MATRIX_P:将顶点从观察空间变换到裁剪空间
                o.pos = mul(UNITY_MATRIX_P, pos);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float4 col = float4(_OutLineColor.rgb, 1);
                return col;
            }
            ENDCG
        }

        Pass 
        {
            Tags{"LightMode" = "ForwardBase"}
            Cull Back

            CGPROGRAM             

            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"       
            #include "Lighting.cginc"

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord :TEXCOORD0;
            };
            
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
                SHADOW_COORDS(3)
            };
            
            float4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _Ramp;
            float4 _Ramp_ST;
            float4 _Specular;
            float _SpecularScale;
            
            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                //模型空间法线转换成世界空间
                // o.worldNormal = UnityObjectToWorldNormal(v.normal);
                 //正交矩阵的逆矩阵 等于正交矩阵的转置矩阵
                //unity_WorldToObject:用于将顶点从世界空间变换到模型空间
                o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
                // o.worldNormal = mul(unity_ObjectToWorld, v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                TRANSFER_SHADOW(o);
                return o;
            }
           
            fixed4 frag(v2f i):SV_Target
            {
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                fixed3 worldHalfDir = normalize(worldLightDir + worldViewDir);
                
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed3 albedo = col.rgb * _Color.rgb;
                //环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
                fixed diff = dot(worldNormal, worldLightDir);
                diff = (diff * 0.5 + 0.5) * atten;
                fixed3 diffuse = _LightColor0.rgb * albedo * tex2D(_Ramp, float2(diff, diff)).rgb;
                fixed spec = dot(worldNormal, worldHalfDir);
                fixed w  = fwidth(spec) * 2;
                fixed3 specular = _Specular.rgb * lerp(0, 1, smoothstep(-w, w, spec + _SpecularScale - 1)) * step(0.0001, _SpecularScale);
                return fixed4(ambient + diffuse + specular, 1);
            }
            ENDCG
        }
    }
}
