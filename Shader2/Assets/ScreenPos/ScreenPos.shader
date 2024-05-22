Shader "Unlit/ScreenPos"
{
    SubShader
    {

        Pass
        {
            CGPROGRAM
            
            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            // float4 vert (float4 vertex:POSITION):SV_POSITION
            // {
            //     float4 pos = UnityObjectToClipPos(vertex);
            //     return pos;
            // }

            // fixed4 frag (float4 sp:VPOS) : SV_Target
            // {
            //     return fixed4(sp.xy/_ScreenParams.xy, 1, 1);
            // }

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 srcPos : TEXCOORD0;
            };

            v2f vert (float4 vertex:POSITION)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                o.srcPos = ComputeScreenPos(o.pos);
                return o;
            }

            fixed4 frag(v2f i):SV_Target
            {
                float2 wcoord = (i.srcPos.xy/i.srcPos.w);
                return fixed4(wcoord,0,1);
            }
            ENDCG
        }
    }
}
