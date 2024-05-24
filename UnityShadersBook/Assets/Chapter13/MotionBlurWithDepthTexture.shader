//运动模糊
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
            half4 _MainTex_TexelSize;//主纹理的纹素大小
            //深度纹理
            sampler2D _CameraDepthTexture;
            //当前从裁剪空间变换到世界空间的矩阵
            float4x4 _CurrentViewProjectionInverseMatrix;
            //上一帧从世界空间变换到裁剪空间的矩阵,视图*投影矩阵
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
                //深度值
                float d = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv_depth);
                //NDC下的坐标
                float4 H = float4(i.uv.x * 2 - 1, i.uv.y * 2 - 1, d * 2 - 1, 1);
                //世界坐标
                float4 D = mul(_CurrentViewProjectionInverseMatrix, H);
                float4 worldPos = D / D.w;
                //当前NDC下的坐标
                float4 currentPos = H;
                //上一帧NDC下的坐标
                float4 previousPos = mul(_PreviousViewProjectionMatrix, worldPos);
                previousPos /= previousPos.w;
                //速度
                float2 velocity = (currentPos.xy - previousPos.xy) / 2.0f;

                float2 uv = i.uv;
                fixed4 col = tex2D(_MainTex, i.uv);
                uv += velocity * _BlurSize;
                for(int it = 1; it < 3; it++, uv += velocity * _BlurSize)
                {
                    float4 currentColor = tex2D(_MainTex, uv);
                    col += currentColor;
                }
                col /= 3;
                return col;
            }
            ENDCG
        }
    }
}
