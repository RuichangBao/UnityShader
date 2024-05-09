//Bloom效果
Shader "Chapter12/Bloom"
{
    Properties
    {
        _MainTex ("Base(RGB)", 2D) = "white" {}
        _Bloom("Bloom(RGB)", 2D) = "black" {}
        _LuminanceThreshold("亮度阈值",float) = 0.5
        _BlurSize("模糊参数", Float) = 1
    }

    SubShader
    {
        CGINCLUDE           
        #include "UnityCG.cginc"
        
        sampler2D _MainTex;
        fixed2 _MainTex_TexelSize;
        sampler2D _Bloom;
        
        float _BlurSize;
        
        struct a2v
        {
            float4 vertex : POSITION;
            float2 uv : TEXCOORD0;
        };

        ENDCG

        ZTest Always Cull Off ZWrite Off
        //第一个pass 提取较亮的区域
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            struct v2f
            {
                float4 pos : SV_POSITION;
                half2 uv : TEXCOORD0;
            };

            float _LuminanceThreshold;
            
            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            fixed luminance(fixed4 color)
            {
                return 0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b;//亮度
            }
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed val = clamp(luminance(col) - _LuminanceThreshold, 0, 1);
                return col * val;
            }
            ENDCG
        }
        //第二个pass 竖直方向高斯模糊
        UsePass "Chapter12/GaussianBlur/GAUSSIAN_BLUR_VERTICAL"
        //第三个pass 水平方向高斯模糊
        UsePass "Chapter12/GaussianBlur/GAUSSIAN_BLUR_HORIZONTAL"
        //第四个pass
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            struct v2f
            {
                float4 pos : SV_POSITION;
                half4 uv : TEXCOORD0;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv.xy = v.uv;
                o.uv.zw = v.uv;
                #if UNITY_UV_STARTS_AT_TOP
                    if(_MainTex_TexelSize.y < 0)
                    {
                        o.uv.w = 1 - o.uv.w;
                    }
                #endif
                return o;
            }

            fixed4 frag(v2f i):SV_Target
            {
                return tex2D(_MainTex, i.uv.xy) + tex2D(_Bloom, i.uv.zw);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
