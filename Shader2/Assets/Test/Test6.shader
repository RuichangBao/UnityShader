Shader "Custom/Test6"
{  
    Properties
    {
        _Num1("_Num1", float) = 0
        _Num2("_Num2", float) = 0
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            float _Num1;
            float _Num2;
            float4 vert(float4 vert : POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(vert);
            }
            
            fixed4 frag(float4 v : SV_POSITION) : SV_Target
            {
                int num = step(_Num1,_Num2);
                return fixed4(num,0,0,1);
            }
            ENDCG
        }
    }
}