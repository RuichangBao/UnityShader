Shader "Custom/Wave"
{
    SubShader
    {
        Pass{
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct v2f
            {
                float4 pos:SV_POSITION;
                fixed4 col:SV_Target;
            };

            v2f vert(float4 pos:POSITION)
            {
                 pos.y += 0.2 * sin(pos.x+pos.z + _Time.y);
                 pos.y += 0.3 * sin(pos.x-pos.z + _Time.w);
                 v2f o;
                 o.pos = UnityObjectToClipPos(pos);
                 o.col = fixed4(pos.y/2+0.5,pos.y/2+0.5,pos.y/2+0.5,1);

                //pos.y = 0.2 * sin(length(pos.xz) + _Time.y);
                //v2f o;
                //o.pos = UnityObjectToClipPos(pos);
                //o.col = fixed4(pos.y/2+0.5,pos.y/2+0.5,pos.y/2+0.5,1);
                return o;
            }

            fixed4 frag(v2f o):SV_Target
            {
                return o.col;
            }
            ENDCG
        }
    }
}
