Shader "Custom/Discard"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _MinX("MinX",Range(0,1)) = 0.25
        _MaxX("MaxX",Range(0,1)) = 0.75
        _MinY("MinX",Range(0,1)) = 0.25
        _MaxY("MaxX",Range(0,1)) = 0.75
    }
    SubShader
    {
        // Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha 
        // AlphaTest Greater 0.1
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct a2v
            {
                float4 pos:POSITION;
                float4 texcoord:TEXCOORD0;
            };

            struct v2f
            {
                float4 pos:POSITION;
                float2 uv:TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(a2v a)
            {
                v2f v;
                v.pos = UnityObjectToClipPos(a.pos);
                v.uv = a.texcoord.xy;
                return v;
            }

            float _MinX;
            float _MaxX;
            float _MinY;
            float _MaxY;

            //判断能否溶解
            bool CanDiscard(float2 uv)
            {
                return uv.x > _MinX && uv.x <_MaxX && uv.y > _MinY && uv.y <_MaxY;
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
