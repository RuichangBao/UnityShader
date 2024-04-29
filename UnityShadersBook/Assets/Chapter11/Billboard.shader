//广告牌效果
Shader "Chapter11/Billboard"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _VerticalBillboarding("水平限制", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType"="Transparent" "IgnoreProjector" = "True" "DisableBatching" = "True"}
        // Tags { "Queue" = "Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "DisableBatching"="True"}

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
            #include "Lighting.cginc"

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
            float _VerticalBillboarding;//1:法线方向，视角方向固定， 0：向上方向固定（0，1，0） 
            //1.根据法线和向上方向，求向右方向（这个最初的向上方向不一定和法线垂直）
            //2.根据向右方向和法线，重新求向上方向，这个时候法线，向右方向，和向上方向三个方向垂直
            //3.根据三个方向从新计算模型空间的坐标
            v2f vert (a2v v)
            {
                v2f o;   
                
                float3 center = float3(0, 0, 0);
                //相机的模型空间
                float3 viewer = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1));
                //法线（视角方向）
                float3 normalDir = viewer - center;
                normalDir.y = normalDir.y * _VerticalBillboarding;
                normalDir = normalize(normalDir);
                float3 upDir = abs(normalDir.y) > 0.999 ? float3(0, 0, 1):float3(0, 1, 0);
                
                float3 rightDir = normalize(cross(upDir, normalDir));
                upDir = normalize(cross(normalDir, rightDir));
                float3 centerOffs = v.vertex.xyz - center;
                float3 localPos = rightDir * centerOffs.x + upDir * centerOffs.y + normalDir * centerOffs.z;
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
    FallBack "Transparent/VertexLit"
}
