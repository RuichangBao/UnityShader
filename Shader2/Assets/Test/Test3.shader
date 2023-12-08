

Shader "Custom/Test3"
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
                float4 vertex : POSITION;
                float3 mormal : NORMAL;
                float3 color : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 color : COLOR;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = float3(v.color);
                // o.color = v.vertex;
                return o;
            }
            
            fixed4 frag(v2f i) :SV_Target
            {
                return fixed4(i.color,1);
                // return fixed4(0.5,0.5,0.5,1);
            }
            ENDCG
        }
    }
}