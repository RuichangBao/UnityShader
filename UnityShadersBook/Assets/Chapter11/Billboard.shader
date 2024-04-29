Shader "Chapter11/Billboard"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _VerticalBilllboarding("水平限制", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType"="Opaque" "IgnoreProjector" = "True" "DisableBatching" = "True"}

        Pass
        {
            Tags{"LightMode" = "ForwardBase"}

            ZWrite Off  //深度写入关闭
            BlendOp Add //混合方式 加
            Blend SrcAlpha OneMinusSrcAlpha //透明度混合
            Cull Off    //剔除方式 关闭

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct a2v
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            { 
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _VerticalBilllboarding;

            v2f vert (a2v v)
            {
                v2f o;   
                
                float3 center = float3(0, 0, 0);
                float3 viewer = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1));
                float3 normalDir = viewer - center;
                normalDir.y = normalDir.y * _VerticalBilllboarding;
                normalDir = normalize(normalDir);
                float3 upDir = abs(normalDir.y) > 0.999 ? float3(0,0,1):float3(0,1,0);
                
                float3 rightDir = normalize(cross(normalDir, normalDir));
                upDir = normalize(cross(normalDir, rightDir));
                float3 centerOffs = v.vertex.xyz - center;
                float3 localPos = center + rightDir * centerOffs.x + upDir * centerOffs.y + normalDir.z * centerOffs.z;
                o.pos = UnityObjectToClipPos(float4(localPos, 1));
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
