Shader "Custom/Test1"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            float4 vert (float4 pos:POSITION):SV_POSITION
            {
                return UnityObjectToClipPos(pos);
            }
            
            float4 frag ():SV_Target
            {
                return float4(1,1,1,1)*float4(1,0,0,1);
            }
            ENDCG
        }
    }
}
