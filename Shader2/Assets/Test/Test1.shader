Shader "Custom/Test1"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            struct a2v{
                float4 pos : POSITION;
                float4 texcoord : TEXCOORD0;
            };
            
            struct v2f{
                float4 vertex:SV_POSITION;
                float4 col:TEXCOORD0;
            };

            v2f vert (a2v v){
                v2f o;
                o.vertex = UnityObjectToClipPos(v.pos);
                o.col = float4(v.pos.x+0.5, v.pos.y+0.5, v.pos.z+0.5, 1);
                //o.col = v.texcoord;
                return o;
            }
            
            fixed4 frag (v2f o) : SV_Target{
                // return fixed4(o.col.xyz,1);
                return o.col;
            }
            ENDCG
        }
    }
}
