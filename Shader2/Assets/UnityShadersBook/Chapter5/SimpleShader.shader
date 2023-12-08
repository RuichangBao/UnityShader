
Shader "UnityShadersBook/Chapter5/SimpleShader"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Assets/CommonShader/CommonShader.cginc"

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.color = v.normal * 0.5 + fixed3(0.5,0.5,0.5);
                return o;
            }

            fixed4 frag() : SV_Target
            {
                return fixed4(1,1,1,1);
            }
            ENDCG
        }
    }
}
