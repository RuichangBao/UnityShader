// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "UnityShadersBook/Chapter7/SingleTexture"
{
    Properties
    {
        _Color("Color Tint", Color) = (1,1,1,1)
        _MainTex("Main Tex", 2D) = "white"{}
        _Specular("Specular", Color) = (1,1,1,1)
        _Gloss("Gloss", Range(8,256)) = 20 //光泽度
    }
    SubShader
    {
        Pass
        {
            Tags{"LightMode" = "ForwardBase"}
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"
            #include "UnityCG.cginc"
            
            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Specular;
            float _Gloss;
            
            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                // o.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
                return o;
            }

            fixed4 frag(v2f i):SV_Target
            {
                
                fixed3 albedo = tex2D(_MainTex,i.uv).rgb * _Color.rgb;
                //UNITY_LIGHTMODEL_AMBIENT 环境光的颜色和强度信息
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                
                fixed3 worldNormal = normalize(i.worldNormal);
                //光照方向
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                //漫反射
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal, worldLightDir));

                //高光反射部分
                //视角方向
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                //h
                fixed3 halfDir = normalize(worldLightDir + viewDir);
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);
                return fixed4(ambient + diffuse + specular, 1);
            }
            
            ENDCG
        }
    }
    Fallback "Specular"
}
