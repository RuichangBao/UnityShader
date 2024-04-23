//镜面效果
Shader "Chapter10/Mirror"
{
    Properties
    {
        _MainTex("RenderTexture资源", 2D) = "white"{}
    }
    SubShader
    {
        Tags {"RenderType"="Opaque" "Queue"="Geometry"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            sampler2D _MainTex;

            struct a2v
            {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f
            {               
                float4 pos : SV_POSITION; 
                float3 uv : TEXCOORD0;
            };

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                o.uv.x = 1 - o.uv.x;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return tex2D(_MainTex, i.uv);
            }
            ENDCG
        }
    }
    FallBack "Reflective/VertexLit"
}