//遮罩纹理
Shader "UnityShadersBook/Chapter7/MaskTexture"
{
    Properties
    {
        _Color("Color Tint", Color) = (1,1,1,1)
        _MainTex("Main Tex", 2D) = "white" {}
        _BumpMap("Normal Map", 2D) = "bump" {} //凹凸映射
        _BumpScale("Bump Scale", float) = 1
        _SpecularMask("Specular Mask", 2D) = "white" {}             //高光反射遮罩
        _SpecularMaskScale("Specular MaskScale Scale", float) = 1   //遮罩系数
        _Specular("Specular",Color) = (1,1,1,1) //高光反射颜色
        _Gloss("Gloss",Range(8,256)) = 20       //光泽度
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
            sampler2D _BumpMap;
            float _BumpScale;
            sampler2D _SpecularMask;
            float _SpecularMaskScale;
            fixed4 _Specular;
            float _Gloss;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 lightDir : TEXCOORD1;
                float3 viewDir : TEXCOORD2;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                // o.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);

                TANGENT_SPACE_ROTATION;
                // float3 binormal = cross( normalize(v.normal), normalize(v.tangent.xyz) ) * v.tangent.w;
                // float3x3 rotation = float3x3( v.tangent.xyz, binormal, v.normal )
                // rotation:模型空间转切线空间矩阵  ObjSpaceLightDir：模型空间下光源方向
                o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
                o.viewDir = mul(rotation, ObjSpaceViewDir(v.vertex)).xyz;
                return o;
            }

            fixed4 frag(v2f i) :SV_Target
            {
                fixed3 tangentLightDir = normalize(i.lightDir);
                fixed3 tangentViewDir = normalize(i.viewDir);

                fixed3 tangentNormal = UnpackNormal(tex2D(_BumpMap, i.uv));
                tangentNormal.xy *= _BumpScale;
                tangentNormal.z = sqrt(1 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));

                fixed3 albedo = tex2D(_MainTex,i.uv).rgb * _Color.rgb;
                //UNITY_LIGHTMODEL_AMBIENT 环境光的颜色和强度信息
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

                //漫反射
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(tangentNormal, tangentLightDir));

                //高光反射部分
                //h
                fixed3 halfDir = normalize(tangentLightDir + tangentViewDir);
                //获取遮罩
                fixed specularMask = tex2D(_SpecularMask, i.uv).r * _SpecularMaskScale;
                //计算高光反射
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0,dot(tangentNormal, halfDir)), _Gloss) * specularMask;
                return fixed4(ambient + diffuse + specular,1);
            }

            ENDCG
        }
    }
    Fallback "Specular"
}
