// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/MVPTransform"
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

            struct v2f{
                float4 pos:POSITION;
            };

            v2f vert (appdata_base v)
            {
                v2f o;
                // o.pos = mul(UNITY_MATRIX_MVP,v.vertex)
                // o.pos = UnityObjectToClipPos(v.vertex);

                // float4x4 m=mul(UNITY_MATRIX_MVP,rm);
                // float4x4 m=UnityObjectToClipPos(rm);

                o.pos = mul(mvp,v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                
                return fixed4(1,1,1,1);
            }
            ENDCG
        }
    }
}
