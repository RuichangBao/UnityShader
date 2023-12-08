Shader "Custom/Test7"
{  
    Properties
    {
        _color1("Color1", Color) = (1,1,1,1)
        _color2("Color2", Color) = (1,1,1,1)
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            float4 _color1;
            float4 _color2;
            float4 vert(float4 vert : POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(vert);
            }
            
            fixed4 frag(float4 v : SV_POSITION) : SV_Target
            {
                return _color1*_color2;
            }
            ENDCG
        }
    }
}