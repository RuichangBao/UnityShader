Shader "Custom/TestLight"
{ 
    SubShader
    {
        Pass
        {
            Tags {"LightMode" = "ForwardBase"}
            CGPROGRAM
            #pragma multi_compile_fwdbase
            #pragma vertex vert
            #pragma fragment frag
            
            float4 vert(float4 pos:POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(pos);
            }
            float4 frag():SV_Target
            {
                #ifdef USING_DIRECTIONAL_LIGHT
                    return float4(1,0,0,1);  
                #else 
                    return float4(1,1,1,1);
                #endif 
            }
            ENDCG
        }
    }
}