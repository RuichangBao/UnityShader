Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        //x y 中心点位置 z w 挖洞的宽高
        _Center("中心点",Vector)=(0.5, 0.5, 0.05, 0.05)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha 
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            sampler2D _MainTex;
            float4 _Center;
            struct a2v
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f o) : SV_Target
            { 
                fixed4 col = tex2D(_MainTex, o.uv);
                if(o.uv.x > _Center.x - _Center.z && o.uv.x < _Center.x + _Center.z && o.uv.y > _Center.y - _Center.w && o.uv.y < _Center.y + _Center.w)
                {
                    col.a = 0;
                }
                else
                {
                    col.a = 1;
                }
                // col.a = 0;
                return col;
            }
            ENDCG
        }
    }
}
