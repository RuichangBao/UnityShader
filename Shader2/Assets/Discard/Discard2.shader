Shader "Custom/Discard2"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _CircleCenterX("CircleCenterX",Range(0,1)) = 0.5
        _CircleCenterY("CircleCenterY",Range(0,1)) = 0.5
        _Radius("Radius",Range(0,0.5)) = 0.25
    }
    SubShader
    {
        Blend SrcAlpha OneMinusSrcAlpha 
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float4 pos:POSITION;
                float2 uv:TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata_base a)
            {
                v2f v;
                v.pos=UnityObjectToClipPos(a.vertex);
                v.uv = TRANSFORM_TEX(a.texcoord,_MainTex);
                return v;
            }

            float _CircleCenterX;
            float _CircleCenterY;
            float _Radius;

            //判断能否溶解
            bool CanDiscard(float2 uv)
            {
                float length = distance( uv, float2(_CircleCenterX,_CircleCenterY)) ;
                return length<_Radius;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col;
                
                if(CanDiscard(i.uv))
                {
                    discard;
                }
                else
                {
                    col = tex2D(_MainTex, i.uv);
                }
                return col;
            }
            ENDCG
        }
    }
}
