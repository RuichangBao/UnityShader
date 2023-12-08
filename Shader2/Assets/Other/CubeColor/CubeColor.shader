// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/CubeColor"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct a2v
            {
                float4 pos:SV_POSITION;
                float4 col:TEXCOORD0;
            };
            a2v vert(float4 pos:POSITION)
            {
                a2v o;
                // o.pos = UnityObjectToClipPos(pos);
                float4 vPos = mul(UNITY_MATRIX_MV, pos);
                o.pos = mul(UNITY_MATRIX_P, vPos);
                o.col = pos + float4(0.5, 0.5, 0.5, 0);
                return o;
            }

            float4 frag(a2v a) :SV_Target
            {
                return a.col;
            }
            ENDCG
        }
    }
}
