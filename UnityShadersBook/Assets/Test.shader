Shader "Unlit/Test"
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
                float4 pos:SV_POSITION;
                float4 color:TEXCOORD0;
            };
            

            v2f vert (float4 pos:POSITION)
            {
                v2f o;
                o.pos = TransformObjectToHClip(pos);
                o.color = float4(pos.xyz, 1) + float4(0.5f, 0.5f, 0.5f, 0);
                return o;
            }

            float4 frag (v2f o) : SV_Target
            {
                return o.color;
            }
            ENDHLSL
        }
    }
}
