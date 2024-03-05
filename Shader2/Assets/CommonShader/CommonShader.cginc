struct a2v {
    float4 pos : POSITION;
    float4 texcoord : TEXCOORD0;
    float3 normal : NORMAL;
};

struct v2f
{
    float4 pos : SV_POSITION;
    fixed3 color : COLOR0;
};
