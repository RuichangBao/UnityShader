Shader "Chapter11/ScrollingBackground"
{
    Properties
    {
        _MainTex ("背景图", 2D) = "white" {}
        _DetailTex("细节图", 2D) = "white" {}
        _MainSpeed("背景速度", float) = 1.0
        _DetailSpeed("前景速度", float) = 1.0
        _Speed("整体速度", float) = 1
        _Multiplier("层级乘数", float) = 1
    }
    SubShader
    {

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct a2v
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _DetailTex;
            float4 _DetailTex_ST;
            float _MainSpeed;
            float _DetailSpeed;
            float _Speed;
            float _Multiplier;

            v2f vert (a2v v)
            {
                v2f o;
                float time = _Time.y;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex) + frac(float2(_MainSpeed, 0) * time * _Speed);
                o.uv.zw = TRANSFORM_TEX(v.uv, _DetailTex) + frac(float2(_DetailSpeed, 0) * time * _Speed);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 mainTexCol = tex2D(_MainTex, i.uv.xy);
                fixed4 detailTexCol = tex2D(_DetailTex, i.uv.zw);
                fixed4 color = lerp(mainTexCol, detailTexCol, detailTexCol.a);
                color.rgb *= _Multiplier;
                return color;
            }
            ENDCG
        }
    }
    FallBack "VertexLit"
}
