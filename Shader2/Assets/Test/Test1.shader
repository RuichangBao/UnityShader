Shader "Custom/Test1"
{
    SubShader
    {
       
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            float2 r = float2(1,1);
            float4 vert (float4 pos:POSITION):SV_POSITION
            {
                // r = 1;
                return UnityObjectToClipPos(pos);
            }
            
            float4 frag ():SV_Target
            {
                
                return float4(r,1,1);
            }
            ENDCG
        }
    }
}
