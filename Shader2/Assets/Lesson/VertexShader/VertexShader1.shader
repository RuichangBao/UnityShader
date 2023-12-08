// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/VertexShader1"
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
                o.vertex= UnityObjectToClipPos(v.vertex);
                if(v.vertex.x==0.5&&v.vertex.y==0.5&&v.vertex.z==0.5)
                {
                    o.color=float4(_SinTime.w/2+0.5,_CosTime.w/2+0.5,_SinTime.y,1);
                }
                else
                {
                    o.color=float4(0,0,1,1);
                }
                // float4 pos = mul(unity_ObjectToWorld,v.vertex);
                // if (pos.x<0.5 && pos.y<0.5 && pos.z<0.5 )
                // {
                    //     o.color=float4(1,0,0,1);
                // }
                // else
                // {
                    //     o.color=float4(1,1,1,1);
                // }
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
