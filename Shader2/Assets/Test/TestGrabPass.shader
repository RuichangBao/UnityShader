Shader "Unlit/TestGrabPass"
{
    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Transparent" }
        //GrabPass可以获取屏幕图像
        // 将对象后面的屏幕抓取到 _BackgroundTexture 中
        GrabPass
        {
            "_BackgroundTexture"
        }

        // 使用上面生成的纹理渲染对象，并反转颜色
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            struct a2v
            {
                float4 pos : POSITION;
                float4 uv : TEXCOORD0;
            };
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.uv = 1 - v.uv.xy;
                return o;
            }

            sampler2D _BackgroundTexture;

            half4 frag(v2f i) : SV_Target
            {
                half4 bgcolor = tex2D(_BackgroundTexture, i.uv);
                return bgcolor;
            }
            ENDCG
        }
    }
}