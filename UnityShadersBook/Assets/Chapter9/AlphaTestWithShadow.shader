//透明度测试计算阴影衰减
Shader "Chapter9/AlphaTestWithShadow"
{
    Properties
    {
        _Color ("颜色", Color) = (1, 1, 1, 1)
        _MainTex ("纹理", 2D) = "white" {}
        _Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}

        Pass
        {
            Tags{"LightMode" = "ForwardBase"}
            Cull Off
            CGPROGRAM	
            #pragma multi_compile_fwdbase
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed _Cutoff;
            
            struct a2v 
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;                   
            };
            
            struct v2f 
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float2 uv : TEXCOORD2;
                SHADOW_COORDS(3)
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                //在顶点着色器种计算阴影纹理坐标
                TRANSFER_SHADOW(o);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target 
            {
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                
                fixed4 texColor = tex2D(_MainTex, i.uv);
                // Alpha test
                clip (texColor.a - _Cutoff);
                fixed3 albedo = texColor.rgb * _Color.rgb;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                //漫反射
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal, worldLightDir));
                //在片元着色器种计算阴影值和衰减
                UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
                return fixed4(ambient + diffuse * atten, 1.0);
            }
            ENDCG
        }  
    }
    FallBack "Transparent/Cutout/VertexLit"
}