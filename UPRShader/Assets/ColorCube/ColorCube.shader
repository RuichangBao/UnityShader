Shader "Unlit/ColorCube"
{
    SubShader
    {

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 color : TEXCOORD0;
            };


            v2f vert (float4 pos:POSITION)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(pos);
                o.color = float4(0.5f, 0.5f, 0.5f, 1) + float4(pos.xyz, 0);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                return i.color;
            }
            ENDHLSL
        }
    }
}
