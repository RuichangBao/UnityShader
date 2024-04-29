Shader "Chapter11/Water"
{
    Properties
    {
        _MainTex ("河流纹理", 2D) = "white" {}
        _Color("整体颜色", Color) = (1, 1, 1, 1)
        _Magnitude("波动幅度", float) = 1.0
        _Frequency("频率", float) = 1.0
        _InvWaveLength("波长倒数", float) = 1
        _Speed("速度", float) = 1   //河流纹理的移动速度
    }
    SubShader
    {
        Tags{"Queue"="Transparent" "RenderType" = "Transparent" "DisableBatching" = "True" "IgnoreProjector" = "true" }
        Pass
        {
            Tags{"LightMode" = "ForwardBase"}
            ZWrite Off
            BlendOp Add
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
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
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _Magnitude;
            float _Frequency;
            float _InvWaveLength;
            float _Speed;  //河流纹理的移动速度

            v2f vert (a2v v)
            {
                v2f o;
                float4 offset;
                offset.yzw = float3(0, 0, 0);
                offset.x = sin(_Frequency * _Time.y + v.vertex.x * _InvWaveLength + v.vertex.y * _InvWaveLength + v.vertex.z * _InvWaveLength) * _Magnitude;
                o.pos = UnityObjectToClipPos(v.vertex + offset);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv += float2(0, _Time.y * _Speed); 
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex,i.uv);
                color.rgb *= _Color.rgb;
                return color;
            }
            ENDCG
        }
    }
    FallBack "VertexLit"
}
