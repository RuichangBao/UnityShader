Shader "Chapter12/BrightnessSaturationAndContrast"
{
    Properties
    {
        _MainTex ("Base(RGB)", 2D) = "white" {}
        _Brightness("亮度", Float) = 1
        _Saturation("饱和度", Float) = 1
        _Contrast("对比度", Float) = 1
    }
    SubShader
    {
        // Tags { "RenderType"="Opaque" }

        Pass
        {
            ZTest Always Cull Off Zwrite Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            sampler2D _MainTex;
            float4 _MainTex_ST;
            half _Brightness;   //亮度
            half _Saturation;   //饱和度
            half _Contrast;     //对比度
            
            struct a2v
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };


            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 renderTex = tex2D(_MainTex, i.uv);
                fixed luminance = 0.2125 * renderTex.x + 0.7154 * renderTex.g + 0.0721 * renderTex.b;//亮度
                //亮度
                fixed3 finalColor = renderTex.rgb * _Brightness;
                fixed luminanceColor = fixed3(luminance, luminance, luminance);
                //饱和度影响
                finalColor = lerp(luminanceColor, finalColor, _Saturation);
                //对比度
                fixed3 avgColor = fixed3(0.5, 0.5, 0.5);
                finalColor = lerp(avgColor, finalColor, _Contrast);
                return fixed4(finalColor, renderTex.a);
            }
            ENDCG
        }
    }
    Fallback Off
}
