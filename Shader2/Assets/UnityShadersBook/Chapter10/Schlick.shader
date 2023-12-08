// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

//Schlick Fresnel 菲涅尔反射 
Shader "UnityShadersBook/Chapter10/Schlick"
{
    Properties {
        _Color ("Color Tint", Color) = (1, 1, 1, 1)
        _Fresnel ("Fresnel Scale", Range(0, 1)) = 0.5
        _Cubemap ("Refraction Cubemap", Cube) = "_Skybox" {}
    }
    SubShader {
        Tags { "RenderType"="Opaque" "Queue"="Geometry"}
        
        Pass { 
            Tags { "LightMode"="ForwardBase" }
            
            CGPROGRAM
            
            #pragma multi_compile_fwdbase	
            
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            
            fixed4 _Color;
            fixed4 _RefractColor;
            float _RefractAmount;
            fixed _RefractRatio;
            samplerCUBE _Cubemap;
            
            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;//模型空间下的法线
            };
            
            struct v2f {
                float4 pos : SV_POSITION;
                float3 worldPos : TEXCOORD0;
                fixed3 worldNormal : TEXCOORD1;
                fixed3 worldViewDir : TEXCOORD2;
                fixed3 worldRefr : TEXCOORD3;
                SHADOW_COORDS(4)
            };
            
            v2f vert(a2v v) {
                v2f o;
                // Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
                o.pos = UnityObjectToClipPos(v.vertex);
                
                /*原书中的错误
                o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);*/
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                //世界空间观察方向
                o.worldViewDir = UnityWorldSpaceViewDir(o.worldPos);

                o.worldRefr = reflect(o.worldViewDir, o.worldNormal);
                
                TRANSFER_SHADOW(o);
                
                return o;
            }
            float _FresnelScale;
            fixed4 frag(v2f i) : SV_Target {
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed3 worldViewDir = normalize(i.worldViewDir);
                
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                
                UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
                
                // Use the refract dir in world space to access the cubemap
                fixed3 refraction = texCUBE(_Cubemap, i.worldRefr).rgb;
                fixed fresnel = _FresnelScale + (1 - _FresnelScale) * pow(1 - dot(worldViewDir, worldNormal),5);
                fixed diffuse = _LightColor0.rgb * _Color.rgb * max(0, dot(worldNormal, worldLightDir));
                // Mix the diffuse color with the refract color
                fixed3 color = ambient + lerp(diffuse, refraction, saturate(fresnel)) * atten;
                
                return fixed4(color, 1.0);
            }
            
            ENDCG
        }
    } 
    FallBack "Reflective/VertexLit"
}