Shader "Unlit/Test"
{
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
                float3 worldNormal:TEXCOORD0;
            };

            v2f vert( float4 vertex:POSITION, float3 normal:NORMAL)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                 o.worldNormal = mul(normal, (float3x3)unity_WorldToObject);
                //o.worldNormal = mul(unity_ObjectToWorld, normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // fixed3 col = float3(1,1,1);
                // float3x3 mat = float3x3(
                // 0, 0, 0,
                // 1.0f, 0, 0,
                // 0, 0, 0);
                // float3 color = mul(col, mat).xyz;

                fixed3 color = i.worldNormal;
                return fixed4(color, 1);
            }
            ENDCG
        }
    }
}
