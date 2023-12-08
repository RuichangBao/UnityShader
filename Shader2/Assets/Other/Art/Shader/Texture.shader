Shader "Unlit/Texture"
{
    Properties
    {
        _MainTex("Main Color",2D)="white"{}
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
                float4 pos:POSITION;
                float2 uv:TEXCOORD2;
            };
            
            
            v2f vert(a2v a)
            {
                v2f v;
                v.pos=UnityObjectToClipPos(a.pos);
                v.uv =a.texcoord.xy;
                return v;
            }
            
            sampler2D _MainTex;
            fixed4 frag(v2f a): SV_Target
            {
                fixed4 col = tex2D(_MainTex,a.uv) ;
                return col;
            }

            ENDCG
        }
    }
}