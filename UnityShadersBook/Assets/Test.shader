Shader "Unlit/Test"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _Color2("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct v2f
            {
                float4 pos:SV_POSITION;
                float4 vertex: TEXCOORD0;
            };
            float4 _Color;
            float4 _Color2;

            v2f vert( float4 vertex:POSITION, float3 normal:NORMAL)
            {
                v2f o;
                if(vertex.x>0 && vertex.y>0 && vertex.z>0)
                {
                    vertex.x = vertex.x + 0.25;
                    // vertex.y = vertex.y + 0.5;
                    // vertex.z = vertex.z + 0.5;
                }
                o.pos = UnityObjectToClipPos(vertex);
                o.vertex = vertex;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                if(i.vertex.x>0.5)
                {
                    return _Color2;
                }
                return _Color;
            }
            ENDCG
        }
    }
}
