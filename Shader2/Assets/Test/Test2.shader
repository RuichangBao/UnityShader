Shader "Custom/Test2"
{ 
    Properties//Properties的作用是仅仅让熟悉显示在Inspector面板中
    {
    }
    SubShader
    { 
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct a2v{
                float4 pos : POSITION;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f{
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            v2f vert (a2v v){
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                // o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.uv = v.texcoord.xy ;//* _MainTex_ST.xy;
                return o;
            }
            
            fixed4 frag (v2f o) : SV_Target{
                fixed4 col = tex2D(_MainTex, o.uv);
                return col;
                // return o.uv;
            }
            ENDCG
        }
    }
}
