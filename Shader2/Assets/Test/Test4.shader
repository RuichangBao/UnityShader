
//前向渲染判断是否是平行光
Shader "Custom/Test4"
{ 
    SubShader
    {
        Pass
        {
            Tags {"LightMode"="ForwardBase" }
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 color : COLOR;
            };

            v2f vert(float4 vertex : POSITION)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                #ifdef USING_DIRECTIONAL_LIGHT      //平行光
                    o.color = float4(1,1,1,1);
                #else 
                    o.color = float4(1,0,0,1);
                #endif
                return o;
            }
            
            fixed4 frag(v2f i) :SV_Target
            {
                return i.color;
            }
            ENDCG
        }
    }
}