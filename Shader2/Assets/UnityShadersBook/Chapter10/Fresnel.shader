// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

//Schlick Fresnel 菲涅尔反射 
Shader"UnityShadersBook/Chapter10/Fresnel"
{
    Properties
    {
        [HDR]_Color("颜色", Color) = (1, 1, 1, 1)
        _FresnelScale("", Range(0, 1)) = 0.5
        _Cubemap("", Cube) = "_Skybox" {}
    }
    SubShader
    {
        

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct a2v
            {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal:TEXCOORD0;
                fixed3 worldPos:TEXCOORD1;
                fixed3 worldViewDir:TEXCOORD2;
                fixed3 worldRefl:TEXCOORD3;
                SHADOW_COORDS(4)
            };

			fixed4 _Color;
			fixed _FresnelScale;
			samplerCUBE _Cubemap;
            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                //原文中错误
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.worldViewDir = UnityWorldSpaceViewDir(o.worldPos);
                //反射方向
                o.worldRefl = reflect(-o.worldViewDir, o.worldNormal);
                TRANSFER_SHADOW(o);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 worldViewDir = normalize(i.worldViewDir);
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				//计算光照衰减
				UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
				fixed3 reflection = texCUBE(_Cubemap, i.worldRefl).rgb;
				//菲涅尔反射
				fixed fresnel = _FresnelScale + (1 - _FresnelScale) * pow(1 - dot(worldViewDir, worldNormal), 5);
				fixed3 diffuse = _LightColor0.rgb * _Color.rgb * max(0, dot(worldNormal, worldLightDir));
				fixed3 color = ambient + lerp(diffuse, reflection, saturate(fresnel)) * atten;
				return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}
