Shader "Chapter5/SimpleShader"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            float4 vert(float4 v : POSITION):SV_POSITION
            {
                return UnityObjectToClipPos(v);
            }

            float4 frag():SV_Target
            {
                return float4(1,1,1,1);
            }
            ENDCG
        }        
    }
}