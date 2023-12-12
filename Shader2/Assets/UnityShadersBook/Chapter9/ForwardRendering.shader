//前向渲染计算光照衰减
Shader "UnityShadersBook/Chapter9/ForwardRendering"
{
    Properties
    {
        //漫反射颜色
        _Diffuse ("Diffuse", Color) = (1,1,1,1)
        //高光反射颜色
        _Specular("Specular  高光反射",Color) = (1,1,1,1)
        //光泽度
        _Gloss("Gloss 光泽度",Range(8,256)) = 20
    }
    SubShader
    { 
        Pass//Base Pass
        {
            Tags {"LightMode" = "ForwardBase"}

            CGPROGRAM
            //需要添加这个声明
            #pragma multi_compile_fwdbase
            
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            fixed4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //归一化世界法线
                fixed3 worldNormal = normalize(i.worldNormal);
                //归一化光源方向  _WorldSpaceLightPos0:平行光的方向
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                //环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                //_LightColor0.rgb 光源颜色和强度
                //漫反射
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * max(0, dot(worldNormal, worldLightDir));

                //高光反射视角方向
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
                //得到世界空间的一半方向
                fixed3 halfDir = normalize(worldLightDir + viewDir);
                //高光反射
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);
                fixed atten = 1.0;
                return fixed4(ambient + (diffuse + specular) * atten, 1);
            }
            ENDCG   
        } 

        Pass
        {
            Tags {"LightMode"="ForwardAdd" }
            Blend One One //混合模式
            CGPROGRAM
            #pragma multi_compile_fwdadd

            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            fixed4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = mul(v.normal,(float3x3)unity_WorldToObject);
                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //归一化世界法线
                fixed3 worldNormal = normalize(i.worldNormal);
                //归一化光源方向
                /******************获取光源方向 Start**************************/
                #ifdef USING_DIRECTIONAL_LIGHT      //平行光
                    fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                #else      //点光源或者聚光灯的方向是 _WorldSpaceLightPos0.xyz（光源位置）减去世界空间下的顶点位置
                    fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos.xyz);
                #endif
                /******************获取光源方向 End**************************/
                //_LightColor0.rgb 光源颜色
                //漫反射
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * max(0, dot(worldNormal,worldLightDir));
                //高光反射视角方向
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
                //得到世界空间的一半方向
                fixed3 halfDir = normalize(worldLightDir + viewDir);
                //高光反射
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)),_Gloss);
                
                #ifdef USING_DIRECTIONAL_LIGHT //平行光光照衰减是1
                    fixed atten = 1.0;
                #else
                    //_LightTexture0:Unity 内部提供用来计算光照衰减的纹理
                    #if defined (POINT)
                        // float3 lightCoord = mul(_LightMatrix0, float4(i.worldPos, 1)).xyz;
                        float3 lightCoord = mul(unity_WorldToLight, float4(i.worldPos, 1)).xyz;
                        fixed atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
                    #elif defined (SPOT)
                        // float4 lightCoord = mul(_LightMatrix0, float4(i.worldPos, 1));
                        float4 lightCoord = mul(unity_WorldToLight, float4(i.worldPos, 1));
                        fixed atten = (lightCoord.z > 0) * tex2D(_LightTexture0, lightCoord.xy / lightCoord.w + 0.5).w * tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
                    #else
                        fixed atten = 1.0;
                    #endif
                #endif
                //  return fixed4((diffuse + specular), 1);
                return fixed4((diffuse + specular) * atten, 1);
            }
            ENDCG
            
        } 
        
    } 
    Fallback "Specular"
}