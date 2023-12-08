//透明度混合
Shader "Custom/AlphaBlend"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        // _AlphaScale("Alpha Scale",Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "IgnorePeojector" = "True" "RenderType"="Transparent" }

        Pass
        {
            Tags {"LightMode" = "ForwardBase"}

            ZWrite Off  //关闭深度写入
            BlendOp Add
            // Blend SrcAlpha OneMinusSrcAlpha 
            Blend One One 
            //源颜色(资源颜色)*第一个参数 + 目标颜色(已经存在缓冲区的颜色)
            //Blend DstColor Zero
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            struct a2v
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
            // float _AlphaScale;

            v2f vert (a2v v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex,i.uv);
                // col.a = col.a * _AlphaScale;
                return col;
            }
            ENDCG
        }
    }
    Fallback "Transparent/VertexLit"
}
