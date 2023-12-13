Shader"Custom/Test1"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Lighting.cginc"

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD;
            };
            v2f vert (float4 pos:POSITION)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(pos);
                o.worldPos = mul(unity_ObjectToWorld, pos);
                return o;
            }
            
            fixed4 frag (v2f o) : SV_Target
            {
                //光源方向
                float3 lightDirection = UnityWorldSpaceLightDir(o.worldPos);
                return fixed4(lightDirection.xyz, 1);
            }
            ENDCG
        }
    }
}
