Shader "Chapter13/FogWithDepthTexture"
{
    Properties
    {
        _MainTex ("Base(RGB)", 2D) = "white" {}
        _FogDensity("浓度", Float) = 1
        _FogColor("颜色", Color) = (1, 1, 1, 1)
        _FogStart("起始高度", float) = 0
        _FogEnd("终止高度", float) = 1 
    }
    SubShader
    {
        Pass
        {
            ZTest Always Cull Off ZWrite Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct a2v
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                half2 uv : TEXCOORD0;
                half2 uv_depth : TEXCOORD1;
                float4 interpolatedRay : TEXCOORD2;
            };

            float4x4 _FrustumCornersRay;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            half4 _MainTex_TexelSize;
            sampler2D _CameraDepthTexture;
            float _FogDensity;
            float4 _FogColor;
            float _FogStart;
            float _FogEnd;

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                // o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.uv = v.texcoord;
                o.uv_depth = v.texcoord;
                //如果是Direct3D,Metal 平台下 Direct3D,Metal纹理左上角为（0，0）
                #if UNITY_UV_STARTS_AT_TOP
                    if(_MainTex_TexelSize.y < 0)
                    o.uv_depth.y = 1 - o.uv_depth.y;
                #endif
                int index = 0;
                if(v.texcoord.x<0.5 && v.texcoord.y<0.5)
                index = 0;
                else if(v.texcoord.x>0.5 && v.texcoord.y<0.5)
                index = 1;
                else if(v.texcoord.x<0.5 && v.texcoord.y>0.5)
                index = 2;
                else 
                index = 3;
                #if UNITY_UV_STARTS_AT_TOP
                    if(_MainTex_TexelSize.y < 0)
                    index = 3 - index;
                #endif
                o.interpolatedRay = _FrustumCornersRay[index];
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //视角空间下的深度值
                float linearDepth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv_depth));
                float3 worldPos = _WorldSpaceCameraPos + linearDepth * i.interpolatedRay.xyz;
                float fogDensity = (_FogEnd - worldPos.y)/(_FogEnd - _FogStart);
                fogDensity = saturate(fogDensity * _FogDensity);
                
                fixed4 col = tex2D(_MainTex, i.uv);
                col.rgb = lerp(col.rgb, _FogColor.rgb, fogDensity);
                return col;
            }
            ENDCG
        }
    }
    FallBack Off
}
