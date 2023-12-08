// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/VertexShader2"
{

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 color:COLOR;
            };

            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float x = o.vertex.x/o.vertex.z;
                if(x<-30)
                {
                    o.color=fixed4(1,0,0,1);
                }
                else if(x>30)
                {
                    o.color=fixed4(0,0,1,1);
                }
                else
                {
                    o.color=fixed4(x/30+0.5,x/30+0.5,x/30+0.5,1);
                }
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return i.color;
            }
            ENDCG
        }
    }
}
