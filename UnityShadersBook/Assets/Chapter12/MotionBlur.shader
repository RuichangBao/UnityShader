//运动模糊
Shader "Chapter12/MotionBlur"
{
    Properties
    {
        _MainTex ("Base(RGB)", 2D) = "white" {}
        _BlurAmount("运动量", Float) = 1
    }
    SubShader
    {
        CGINCLUDE
        
        #include "UnityCG.cginc"

        sampler2D _MainTex;
        float4 _MainTex_ST;
        fixed _BlurAmount;
        
        struct a2v
        {
            float4 vertex : POSITION;
            float2 texcoord : TEXCOORD0;
        };

        struct v2f
        {
            float2 uv : TEXCOORD0;
            float4 pos : SV_POSITION;
        };

        v2f vert (a2v v)
        {
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
            return o;
        }
        ENDCG

        ZTest Always Cull Off ZWrite Off
        Pass
        {
            //拿前几帧得到的结果跟当前帧进行混合
            Blend SrcAlpha OneMinusSrcAlpha
            ColorMask RGB
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            fixed4 frag(v2f i):SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return fixed4(col.rgb, _BlurAmount);
            }
            ENDCG
        }

        Pass
        {
            Blend One Zero
            ColorMask A
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            half4 frag(v2f i):SV_Target
            {
                half4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
