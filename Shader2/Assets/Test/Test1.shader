Shader"Custom/Test1"
{
    Properties
    {
        [HDR]_Color("Color", Color) = (0.5, 0.5, 0.5, 0.5)
        [Enum(R,0,G,1,B,2,A,3)]_MainTexAlpha("MainTexAlpha", Int) = 0
    }


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
            
            float4 _Color;
            fixed4 frag (float4 pos:SV_POSITION) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}
