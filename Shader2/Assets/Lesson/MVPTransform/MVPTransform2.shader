// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Custom/MVPTransform2"
{

    SubShader
    {
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            float4x4 mvp;


            float4 vert (float4 pos:POSITION):SV_POSITION
            {
                return mul(mvp,pos);
            }

            float4 frag (float4 pos:POSITION) : SV_Target
            {
                //return pos;
                return float4(1,1,1,1);
            }
            ENDCG
        }
    }
}
