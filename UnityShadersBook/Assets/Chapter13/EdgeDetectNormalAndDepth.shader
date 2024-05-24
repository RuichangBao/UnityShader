//边缘检测
Shader "Chapter13/EdgeDetectNormalAndDepth"
{
    Properties
    {
        _MainTex ("Base(RGB)", 2D) = "white" {}
        _EdgeOnly("边缘", Float) = 1
        _EdgeColor("边缘颜色", Color) = (0,0,0,1)
        _BackgroundColor("背景颜色", Color) = (1,1,1,1)
        _SampleDistance("采样距离", Float) = 1
        _Sensitivity("灵敏度", Vector) = (1,1,0,0)
    }
    SubShader
    {
        CGINCLUDE
        

        
        ENDCG

        Pass
        {
            ZTest Always Cull Off ZWrite Off
            CGPROGRAM
            #include "UnityCG.cginc"
            #pragma vertex vert
            #pragma fragment frag
            


            struct a2v
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION; 
                float2 uv[5] : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _MainTex_TexelSize;//像素
            sampler2D _CameraDepthNormalsTexture;
            float _EdgeOnly;
            float4 _EdgeColor;
            float4 _BackgroundColor;
            float _SampleDistance;
            float4 _Sensitivity;
            

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                half2 uv = v.texcoord;
                o.uv[0] = uv;
                #if UNITY_UV_STARTS_AT_TOP
                    if(_MainTex_TexelSize.y < 0)
                    uv.y = 1 - uv.y;
                #endif
                o.uv[1] = uv + _MainTex_TexelSize.xy * half2(1,1) * _SampleDistance;
                o.uv[2] = uv + _MainTex_TexelSize.xy * half2(-1,-1) * _SampleDistance;
                o.uv[3] = uv + _MainTex_TexelSize.xy * half2(-1,1) * _SampleDistance;
                o.uv[4] = uv + _MainTex_TexelSize.xy * half2(1,-1) * _SampleDistance;
                return o;
            }

            half CheckSame(half4 center,half4 sample)
            {
                half2 centerNormal = center.xy;
                float centerDepth = DecodeFloatRG(center.zw);
                half2 sampleNormal = sample.xy;
                float sampleDepth = DecodeFloatRG(sample.zw);

                half2 diffNormal = abs(centerNormal - sampleNormal) * _Sensitivity.x;
                int isSameNormal = (diffNormal.x + diffNormal.y) < 0.1;
                float diffDepth = abs(centerDepth - sampleDepth) * _Sensitivity.y;
                int isSameDepth = diffDepth < 0.1 * centerDepth;
                return isSameNormal * isSameDepth ? 1:0;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half4 sample1 = tex2D(_CameraDepthNormalsTexture, i.uv[1]);
                half4 sample2 = tex2D(_CameraDepthNormalsTexture, i.uv[2]);
                half4 sample3 = tex2D(_CameraDepthNormalsTexture, i.uv[3]);
                half4 sample4 = tex2D(_CameraDepthNormalsTexture, i.uv[4]);
                half edge = 1;
                edge *= CheckSame(sample1, sample2);
                edge *= CheckSame(sample3, sample4);
                float4 textureCol = tex2D(_MainTex, i.uv[0]);
                fixed4 withEdgeColor = lerp(_EdgeColor, textureCol, edge);
                fixed4 onlyEdgeColor = lerp(_EdgeColor, _BackgroundColor, edge);
                fixed4 col = lerp(withEdgeColor, onlyEdgeColor, _EdgeOnly);
                return col;
            }
            
            ENDCG
        }
    }
    FallBack Off
}
