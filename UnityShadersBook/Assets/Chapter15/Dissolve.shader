//溶解效果
Shader "Chapter15/Dissolve"
{
    Properties
    {
        _BurnAmount("消融程度", Range(0, 1)) = 0
        _LineWidth("燃烧线宽度", Range(0, 0.2)) = 0.1
        _MainTex ("Texture", 2D) = "white" {}
        _BumpMap ("法线贴图", 2D) = "bump" {}
        _BurnFirstColor("消融开始颜色", Color) = (1,0,0,1)
        _BurnSecondColor("消融第二颜色", Color) = (1,0,0,1)
        _BurnMap ("燃烧贴图", 2D) = "white" {}
    }

    SubShader
    {
        Pass
        {
            Tags { "RenderType" = "ForwardBase" }
            Cull Off

            CGPROGRAM

            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            
            #pragma multi_compile_fwdbase

            #pragma vertex vert
            #pragma fragment frag

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 uv : TEXCOORD0; 
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uvMainTex : TEXCOORD0;
                float2 uvBumpMap : TEXCOORD1;
                float2 uvBurnMap : TEXCOORD2;
                float3 lightDir : TEXCOORD3;
                float3 worldPos : TEXCOORD4;
                SHADOW_COORDS(5)
            };

            float _BurnAmount;
            float _LineWidth;
            sampler2D _MainTex; //主贴图
            float4 _MainTex_ST;
            sampler2D _BumpMap; //法线贴图
            float4 _BumpMap_ST;
            sampler2D _BurnMap; //燃烧贴图(噪声纹理)
            float4 _BurnMap_ST;
            float4 _BurnFirstColor;
            float4 _BurnSecondColor;
            


            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uvMainTex = TRANSFORM_TEX(v.uv, _MainTex);
                o.uvBumpMap = TRANSFORM_TEX(v.uv, _BumpMap);
                o.uvBurnMap = TRANSFORM_TEX(v.uv, _BurnMap);
                TANGENT_SPACE_ROTATION; //切线空间矩阵
                o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                TRANSFER_SHADOW(o);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 burn = tex2D(_BurnMap, i.uvBurnMap);
                clip(burn.r - _BurnAmount);
                float3 tangentLightDir = normalize(i.lightDir);
                fixed3 tangentNormal = UnpackNormal(tex2D(_BumpMap, i.uvBumpMap));
                fixed3 albedo = tex2D(_MainTex, i.uvMainTex);
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(tangentNormal, tangentLightDir));
                fixed t = 1 - smoothstep(0, _LineWidth, burn.r - _BurnAmount);
                fixed3 burnColor = lerp(_BurnFirstColor, _BurnSecondColor, t);
                burnColor = pow(burnColor, 5);
                UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
                fixed3 finalColor = lerp(ambient + diffuse * atten, burnColor, t * step(0.0001, _BurnAmount));
                return fixed4(finalColor, 1);
            }
            ENDCG
        }
        //阴影计算pass
        Pass
        {
            Tags {"LightMode" = "ShadowCaster"}
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile_shadowcaster

            #include "UnityCG.cginc"

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                V2F_SHADOW_CASTER;
                float2 uvBurnMap : TEXCOORD1;
            };

            fixed _BurnAmount;
            sampler2D _BurnMap;
            float4 _BurnMap_ST;

            v2f vert(a2v v)
            {
                v2f o;
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                o.uvBurnMap = TRANSFORM_TEX(v.texcoord, _BurnMap);
                return o;
            }
            
            fixed4 frag(v2f i) : SV_Target 
            {
                fixed3 burn = tex2D(_BurnMap, i.uvBurnMap).rgb;
                clip(burn.r - _BurnAmount);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
