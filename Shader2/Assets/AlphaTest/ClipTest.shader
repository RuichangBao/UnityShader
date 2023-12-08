Shader "Custom/ClipTest"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        // _CutOutTex("Texture", 2D) = "white" {}
        _CutOutValue("Value",Range(0,1))=0.5
    }
    SubShader
    {
        Pass
        {
            AlphaTest never 0
            Blend  SrcAlpha  OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            // sampler2D _CutOutTex;
            float _CutOutValue;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                clip(i.uv.x- _CutOutValue);
                return col;
            }
            ENDCG
        }
    }
}