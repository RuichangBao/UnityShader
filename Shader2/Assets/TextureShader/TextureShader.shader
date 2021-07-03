Shader"Unlit/TextureShader"
{
    Properties
    {
        _MainTex("MainTex",2D)="white"{}
        _Color("Color",COLOR)=(1,1,1,1)
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            struct a2v
            {
                float4 pos:POSITION;
                float4 texcoord:TEXCOORD0;
            };
            struct v2f
            {
                float4 pos:SV_POSITION;
                float2 texcoord:TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _Color;
            float4 _MainTex_ST;
            v2f vert(a2v a)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(a.pos);
                //_MainTex_ST.xy控制缩放
                //_MainTex_ST.zw 控制位移
                o.texcoord = a.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
                return o;
            }

            float4 frag(v2f v):SV_Target
            {
                float4 col = tex2D(_MainTex,v.texcoord);
                col*=_Color;
                return col;
            }
            ENDCG
        }
    }
}
