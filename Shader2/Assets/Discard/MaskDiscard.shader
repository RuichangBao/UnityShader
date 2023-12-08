//根据mask的RGB 中R的深度溶解
Shader "Custom/MaskDiscard"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Mask ("Mask", 2D) = "white" {}
        _DiscardDepth("溶解深度",Range(0,1))=0.5
    }
    SubShader
    {

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 mainUV : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _Mask;
            float4 _Mask_ST;
            float _DiscardDepth;

            //判断能否溶解
            bool CanDiscard(fixed4 maskCol)
            {
                return maskCol.x>=_DiscardDepth;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.mainUV = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col;
                fixed4 maskCol = tex2D(_Mask, i.mainUV);
                if(CanDiscard(maskCol))
                {
                    discard;
                }
                else
                {
                    col = tex2D(_MainTex, i.mainUV);
                }
                return col;
            }
            ENDCG
        }
    }
}
