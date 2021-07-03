Shader "Unlit/CubeShader"
{
    Properties
    {
        _Color("Color",COLOR)=(0,0,0,0)
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct a2v
            {
                float4 pos:SV_POSITION;
                float4 col:TEXCOORD0;
            };
           
            a2v vert(float4 pos:POSITION)
            {
                a2v o;
                o.pos = UnityObjectToClipPos(pos);
                o.col = pos+float4(0.5,0.5,0.5,0);
                return o;
            }

            float4 _Color;
            float4 frag(a2v a):SV_Target
            {
                return a.col*_Color.rgba;
            }
            ENDCG
        }
    }
}
