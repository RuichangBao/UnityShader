Shader "Chapter13/MotionBlurWithDepthTexture"
{
    Properties
    {
        _MainTex ("Base(RGB)", 2D) = "white" {}
        _BlurSize("Blur Size", Float) = 1
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct v2f
            {
                float4 pos : SV_POSITION;
                half2 uv : TEXCOORD0;
                half2 uv_depth : TEXCOORD1;
            };

            sampler2D _MainTex;
            half4 _MainTex_TexelSize;
            sampler2D _CameraDepthTexture;
            float4x4 _CurrentViewProjectionInverseMatrix;
            float4x4 _PreviousViewProjectionMatrix;
            half _BlurSize;


            v2f vert (float4 vertex:POSITION, half2 texcoord : TEXCOORD0)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                o.uv = texcoord;
                o.uv_depth = texcoord;
                #if UNITY_UV_STARTS_AT_TOP
                    if(_MainTex_TexelSize.y < 0)
                    {
                        o.uv_depth.y = 1 - o.uv_depth.y;
                    }
                #endif
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float d = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv_depth);
                float H = float4(i.uv.x * 2 - 1, i.uv.y * 2 - 1, d * 2 - 1, 1);
                float D = mul(_CurrentViewProjectionInverseMatrix, H);
                float4 worldPos = D / D.w;
                float4 currentPos = H;
                float4 previousPos = 
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
