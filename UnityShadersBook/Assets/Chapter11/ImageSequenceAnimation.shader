Shader "Chapter11/ImageSequenceAnimation"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
        Pass
        { 
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            
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
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            int num = 8;

            v2f vert (a2v v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);               
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {               
                float timer = _Time.y;
                timer = fmod(timer,64);
                float y = floor(timer/num);
                float x = timer - num * y;
                float2 uv = i.uv / num;
                uv.x = uv.x + ((1.0f/8.0f-1)*x);
                uv.y = uv.y + ((1.0f/8.0f-1)*y);
                float4 col = tex2D(_MainTex, uv);
                return col;
                // return float4(timer/64,0,0,1);
            }
            ENDCG
        }
    }
}
