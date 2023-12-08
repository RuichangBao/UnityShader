// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Distorted"
{
    //扭曲形变shader 
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
                float4 pos:SV_POSITION;
                float4 color:COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            
            v2f vert (appdata_base v)
            {
                float angle= length(v.vertex)*_SinTime.w;
                
                float4x4 m={
                    float4((sin(angle)+1)/2,0,0,0),
                    float4(0,1,0,0),
                    float4(0,0,1,0),
                    float4(0,0,0,1)
                };

                v.vertex = mul(m,v.vertex);
                // float x = v.vertex.x*cos(angle)+v.vertex.z*sin(angle);
                // float z = -v.vertex.x*sin(angle)+v.vertex.z*cos(angle);
                // v.vertex.x=x;
                // v.vertex.z=z;

                v2f o;
                o.pos =UnityObjectToClipPos(v.vertex);
                o.color=float4(0,1,1,1);
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
