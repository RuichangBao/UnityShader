//光照衰减（计算阴影的时候顺便计算光照衰减）
Shader "Chapter9/AttenuationAndShadowUseBuildInFunctions"
{
    Properties
    {
        _Diffuse("漫反射", Color) = (1, 1, 1, 1)
        _Specular ("高光反射", Color) = (1, 1, 1, 1)
        _Gloss ("光泽度", Range(8.0, 256)) = 20
    }
    SubShader 
    {
        Tags { "RenderType"="Opaque" }
        
        Pass
        {
            Tags{"LightMode" = "ForwardBase"}
            CGPROGRAM
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            #pragma multi_compile_fwdbase

            #pragma vertex vert
            #pragma fragment frag
            

            struct a2v
            {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed3 worldNormal : TEXCOORD0;
                fixed3 worldPos : TEXCOORD1;
                //声明一个用于阴影纹理采样的坐标
                SHADOW_COORDS(2)
            };

            float4 _Diffuse;
            float4 _Specular;
            float _Gloss;

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                //在顶点着色器种计算阴影纹理坐标
                TRANSFER_SHADOW(o);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 worldNormal = normalize(i.worldNormal);
                // fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * max(0, dot(worldNormal, worldLightDir));
                // fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
                fixed3 halfDir = normalize(worldLightDir + viewDir);
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);
                //在片元着色器种计算阴影值和衰减
                UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
                return fixed4(ambient + (diffuse + specular) * atten , 1);
            }
            ENDCG
        }
        
        Pass 
        {
            Tags{"LightMode" = "ForwardAdd"}
            Blend One One
            CGPROGRAM
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            
            #pragma multi_compile_fwdadd
            
            #pragma vertex vert
            #pragma fragment frag
            

            struct a2v
            {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                fixed3 worldNormal : TEXCOORD0;
                fixed3 worldPos : TEXCOORD1;
                //声明一个用于阴影纹理采样的坐标
                SHADOW_COORDS(2)
            };

            float4 _Diffuse;
            float4 _Specular;
            float _Gloss;

            v2f vert (a2v v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                //在顶点着色器种计算阴影纹理坐标
                TRANSFER_SHADOW(o);
                return o;
            }
            
            fixed4 frag(v2f i) : SV_Target 
            {
                fixed3 worldNormal = normalize(i.worldNormal);
                //光照方向
                // fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                // fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                #ifndef USING_DIRECTIONAL_LIGHT
                    fixed3 worldLightDir = _WorldSpaceLightPos0.xyz - i.worldPos;
                #else
                    fixed3 worldLightDir= _WorldSpaceLightPos0.xyz;
                #endif

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * max(0, dot(worldNormal, worldLightDir));
                // fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
                fixed3 halfDir = normalize(worldLightDir + viewDir);
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);

                //在片元着色器种计算阴影值和衰减
                UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
                return fixed4(ambient + (diffuse + specular) * atten, 1);
            }
            
            ENDCG
        }
    }
    FallBack "Specular"
}
