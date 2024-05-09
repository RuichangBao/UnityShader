//高斯模糊
Shader "Chapter12/GaussianBlur"
{
    Properties
    {
        _MainTex ("Base(RGB)", 2D) = "white" {}
        _BlurSize("模糊参数", Float) = 1
    }
    SubShader
    {
        CGINCLUDE           
        #include "UnityCG.cginc"
        
        struct a2v
        {
            float4 vertex : POSITION;
            float2 uv : TEXCOORD0;
        };

        struct v2f
        {
            float4 pos : SV_POSITION;
            half2 uv[5] : TEXCOORD0;
        };
        
        sampler2D _MainTex;
        fixed2 _MainTex_TexelSize;
        float _BlurSize;

        fixed4 frag (v2f i) : SV_Target
        {
            float weight[5] = { 0.0545, 0.2442, 0.4026, 0.2442, 0.0545};
            fixed3 sum = tex2D(_MainTex, i.uv[0]).rgb * weight[0];
            for(int it = 1; it < 5; it++)
            {
                sum += tex2D(_MainTex, i.uv[it]).rgb * weight[it];
            }
            return fixed4(sum, 1);
        }
        ENDCG

        ZTest Always Cull Off ZWrite Off
        Pass //竖直方向模糊
        {
            NAME "GAUSSIAN_BLUR_VERTICAL"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                half2 uv = v.uv;
                o.uv[0] = uv + _MainTex_TexelSize * half2(0, -2) * _BlurSize;
                o.uv[1] = uv + _MainTex_TexelSize * half2(0, -1) * _BlurSize;
                o.uv[2] = uv;
                o.uv[3] = uv + _MainTex_TexelSize * half2(0, 1) * _BlurSize;
                o.uv[4] = uv + _MainTex_TexelSize * half2(0, 2) * _BlurSize;
                
                return o;
            }
            ENDCG
        }

        Pass//水平方向模糊
        {
            NAME "GAUSSIAN_BLUR_HORIZONTAL"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                half2 uv = v.uv;

                o.uv[0] = uv + _MainTex_TexelSize * half2(-2, 0) * _BlurSize;
                o.uv[1] = uv + _MainTex_TexelSize * half2(-1, 0) * _BlurSize;
                o.uv[2] = uv;
                o.uv[3] = uv + _MainTex_TexelSize * half2(1, 0) * _BlurSize;
                o.uv[4] = uv + _MainTex_TexelSize * half2(2, 0) * _BlurSize;
               
                return o;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
