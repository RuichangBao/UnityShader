// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

//世界空间下计算法线纹理
Shader "UnityShadersBook/Chapter7/NormalMapWorldSpace"
{
    Properties
    {
        _Color("Color Tint", Color) = (1,1,1,1)
        _MainTex("Main Tex", 2D) = "white" {}
        _BumpMap("Normal Map", 2D) = "bump" {}  //凹凸纹理
        _BumpScale("Bump Scale", Float) = 1.0
        _Specular("Specular", Color) = (1,1,1,1)//高光反射颜色
        _Gloss("Gloss", Range(8.0, 256)) = 20   //光泽度
    }
    
    SubShader
    {
        Tags {"LightMode" = "ForwardBase"}
        Pass
        {
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            float _BumpScale;
            fixed4 _Specular;
            float _Gloss;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                fixed4 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD0;
                //切线空间到世界空间的矩阵
                float4 TtoW0 : TESSFACTOR1;
                float4 TtoW1 : TESSFACTOR2;
                float4 TtoW2 : TESSFACTOR3;
            };

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                // o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.uv.xy = TRANSFORM_TEX(v.texcoord,_MainTex);
                // o.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
                o.uv.zw = TRANSFORM_TEX(v.texcoord,_BumpMap);

                // float3 worldPos = mul(_Object2World,v.vertex).xyz;
                float3 worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
                fixed3 worldTangent = UnityObjectToWorldDir(v.tangent);
                fixed3 worldBinormal = cross(worldNormal,worldTangent) * v.tangent.xyz;//cross 计算两个向量的叉积

                //从切空间到世界空间变换方向的矩阵
                //将世界位置放在w分量中进行优化
                o.TtoW0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
                o.TtoW1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
                o.TtoW2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //在世界坐标中获取位置
                float3 worldPos = float3(i.TtoW0.z, i.TtoW1.z, i.TtoW2.z);
                //在世界坐标中获取光源和视角方向
                fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));

                fixed4 packedNormal = tex2D(_BumpMap,i.uv.zw);

                //获取切线空间法线
                fixed3 bump = UnpackNormal(packedNormal);
                bump.xy *= _BumpScale;
                bump.z = sqrt(1 - saturate(dot(bump.xy, bump.xy)));
                bump = normalize(half3(dot(i.TtoW0.xyz, bump), dot(i.TtoW1.xyz, bump), dot(i.TtoW2.xyz, bump)));

                fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
                //环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0,dot(bump, lightDir));

                fixed3 halfDir = normalize(lightDir + viewDir);
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(bump, halfDir)), _Gloss);
                return fixed4(ambient + diffuse + specular, 1);
                // return fixed4(1,1,1, 1);
            }
            ENDCG
        }   
    }
    Fallback "Specular"
}