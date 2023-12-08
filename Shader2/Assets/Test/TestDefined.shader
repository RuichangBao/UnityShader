Shader "Custom/TestDefined"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            //声明可以使用 RED 和 GREEN 两个宏
            #pragma shader_feature RED
            #pragma shader_feature GREEN
            #pragma shader_feature BLACK
            #pragma shader_feature WHITE

            float4 vert (float4 pos:POSITION):SV_POSITION
            {
                return UnityObjectToClipPos(pos);
            }
            fixed4 frag () : SV_Target
            {
                //#ifdef A = #if defined(A)
                //#ifndef A :如果不满足条件A
                #ifdef RED
                    return fixed4(1,0,0,1);  
                #elif GREEN
                    return fixed4(0,1,0,1);
                #elif BLACK
                    return fixed4(0,0,1,1);
                #else
                    return fixed4(1,1,1,1);
                #endif
            }
            ENDCG
        }
    }
}
