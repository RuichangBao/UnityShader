//素描风格渲染
Shader "Chapter14/Hatching"
{
    Properties
    {
        _Color("颜色", Color) = (1, 1, 1, 1)
        _TileFactor("平铺系数", float) = 1
        _Outline("Outline", Range(0, 1)) = 0.1
        _Hatch0("Hacch 0", 2D) = "white"{}
        _Hatch1("Hacch 1", 2D) = "white"{}
        _Hatch2("Hacch 2", 2D) = "white"{}
        _Hatch3("Hacch 3", 2D) = "white"{}
        _Hatch4("Hacch 4", 2D) = "white"{}
        _Hatch5("Hacch 5", 2D) = "white"{}
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque"  "Queue" = "Geometry"}
        UsePass "Chapter14/ToonShading/OUTLINE"
        
        Pass
        {
            Tags { "LightMode" = "ForwardBase"}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                fixed3 hatchWeights0 : TEXCOORD1;
                fixed3 hatchWeights1 : TEXCOORD2;
                float3 worldPos : TEXCOORD3;
                SHADOW_COORDS(4)
            };

            float4 _Color;
            float _TileFactor;
            sampler2D _Hatch0;
            sampler2D _Hatch1;
            sampler2D _Hatch2;
            sampler2D _Hatch3;
            sampler2D _Hatch4;
            sampler2D _Hatch5;
            
            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex); 
                o.uv = v.vertex * _TileFactor;
                fixed3 worldLightDir = normalize(WorldSpaceLightDir(v.vertex));
                fixed3 worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
                fixed diff = max(0, dot(worldLightDir, worldNormal));//两个单位向量相乘长度不可能大于1
                o.hatchWeights0 = fixed3(0, 0, 0);
                o.hatchWeights1 = fixed3(0, 0, 0);
                
                float hatchFactor = diff * 7;
                if(hatchFactor > 6)
                {}
                else if(hatchFactor > 5)
                {
                    o.hatchWeights0.x = hatchFactor - 5;
                }
                else if(hatchFactor > 4)
                {
                    o.hatchWeights0.x = hatchFactor - 4;
                    o.hatchWeights0.y = 1 - o.hatchWeights0.x;
                }
                else if(hatchFactor > 3)
                {
                    o.hatchWeights0.y = hatchFactor - 3;
                    o.hatchWeights0.z = 1 - o.hatchWeights0.y;
                }
                else if(hatchFactor > 2)
                {
                    o.hatchWeights0.z = hatchFactor - 2;
                    o.hatchWeights1.x = 1 - o.hatchWeights0.z;
                } 
                else if(hatchFactor > 1)
                {
                    o.hatchWeights1.x = hatchFactor - 1;
                    o.hatchWeights1.y = 1 - o.hatchWeights1.x;
                }
                else
                {
                    o.hatchWeights1.y = hatchFactor ;
                    o.hatchWeights1.z = 1 - o.hatchWeights1.y;
                }
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                TRANSFER_SHADOW(o);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 hatchTex0 = tex2D(_Hatch0, i.uv) * i.hatchWeights0.x;
                fixed4 hatchTex1 = tex2D(_Hatch1, i.uv) * i.hatchWeights0.y;
                fixed4 hatchTex2 = tex2D(_Hatch2, i.uv) * i.hatchWeights0.z;
                fixed4 hatchTex3 = tex2D(_Hatch3, i.uv) * i.hatchWeights1.x;
                fixed4 hatchTex4 = tex2D(_Hatch4, i.uv) * i.hatchWeights1.y;
                fixed4 hatchTex5 = tex2D(_Hatch5, i.uv) * i.hatchWeights1.z;
                fixed4 whiteColor = fixed4(1,1,1,1) * (1 - i.hatchWeights0.x - i.hatchWeights0.y - i.hatchWeights0.z - 
                i.hatchWeights1.x - i.hatchWeights1.y - i.hatchWeights1.z);
                fixed4 hatchColor = hatchTex0 + hatchTex1 + hatchTex2 + hatchTex3 + hatchTex4 + hatchTex5 + whiteColor;
                UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
                return fixed4(hatchColor.rgb * _Color.rgb * atten, 1);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}
