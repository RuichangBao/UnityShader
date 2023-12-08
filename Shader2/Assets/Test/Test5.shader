

Shader "Custom/Test5"
{ 
    Properties
    {
        [Toggle] _T1("T1", Float)=0
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "Assets/CommonShader/CommonShader.cginc"
            #pragma shader_feature _T1_ON
            

            v2f vert(float4 vertex : POSITION)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                o.color = fixed3(vertex.x/2 + 0.5, vertex.y/2 + 0.5, vertex.z/2 + 0.5);
                return o;
            }
            
            fixed4 frag(v2f v) : SV_Target
            {
                // return fixed4(v.color, 1);
                #ifdef _T1_ON
                    return fixed4(1,1,1,1);
                #else
                    return fixed4(0,0,0,1);
                #endif
            }
            ENDCG
        }
    }
}