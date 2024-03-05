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

            struct v2f
            {
                float4 pos : SV_POSITION;
                // float4 grabPos : TEXCOORD0;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                // 使用 UnityCG.cginc 中的 ComputeGrabScreenPos 函数
                // 获得正确的纹理坐标
                // o.grabPos = ComputeGrabScreenPos(o.pos);
                o.uv = 1- v.texcoord.xy ;
                return o;
            }

            sampler2D _BackgroundTexture;

            half4 frag(v2f i) : SV_Target
            {
                // half4 bgcolor = tex2Dproj(_BackgroundTexture, i.grabPos);
                // return 1 - bgcolor;
                half4 bgcolor = tex2D(_BackgroundTexture, i.uv);
                return bgcolor;
            }
            ENDCG
        }
    }
}