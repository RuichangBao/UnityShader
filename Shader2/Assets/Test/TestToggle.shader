Shader "Custom/TestToggle"
{
    Properties
    {
        [Toggle]_T1("toggle",float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        { 
            
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            
            #define One 1
            #define Zero 0
            bool _T1;
            
            fixed4 GetColor(bool toggle)
            {
                fixed4 col;
                if(toggle)
                {
                    col = fixed4(One,One,One,1);
                }
                else
                {
                    col = fixed4(One,Zero,Zero,1);
                }
                return col;
            }
            //定义函数 defineGetColor  等同于函数GetColor
            #define defineGetColor(toggle,toggel1) GetColor(toggle);
            float4 vert (float4 pos:POSITION):SV_POSITION
            {
                float4 o = UnityObjectToClipPos(pos);
                return o;
            }
            
            fixed4 frag (float4 pos:SV_POSITION) : SV_Target
            {
                fixed4 col = defineGetColor(_T1,0);
                return col;
            }

            ENDCG
        }
    }
}
