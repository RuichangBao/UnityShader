//切线空间下计算法线纹理
Shader "UnityShadersBook/Chapter7/NormalMapInTangentSpace"
{
    Properties
    {
        [HDR]_Color("Color Tint", Color) = (1,1,1,1)
        [MainTexture]_MainTex("Main Tex", 2D) = "white" {}
        _BumpMap("Normal Map", 2D) = "bump" {}  //凹凸纹理
        _BumpScale("Bump Scale", Float) = 1.0
        [HDR]_Specular("Specular", Color) = (1,1,1,1)//高光反射颜色
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
                float3 lightDir : TEXCOORD1;//切线空间下的光照方向
                float3 viewDir : TEXCOORD2; //切线空间下的视角方向
            };

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.uv.zw = TRANSFORM_TEX(v.texcoord, _BumpMap);

                //计算副法线 cross：求向量的叉积
                //tangent.w:副切线的方向性
                float3 binormal = cross(normalize(v.normal), normalize(v.tangent.xyz)) * v.tangent.w;
                //切线空间(模型空间到切线空间矩阵)：x 切线方向 y 法线和切线的叉积得到 z 法线方向
                float3x3 rotation = float3x3(v.tangent.xyz, binormal, v.normal);
                // TANGENT_SPACE_ROTATION;
                
                //将光线方向从模型空间转换为切线空间 
                //ObjSpaceLightDir：求模型空间下某一点的光源方向
                o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
                //将视角方向从模型空间转换为切线空间 
                //ObjSpaceViewDir：求模型空间下某一点的视角方向
                o.viewDir = mul(rotation, ObjSpaceViewDir(v.vertex)).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 tangentLightDir = normalize(i.lightDir);
                fixed3 tangentViewDir = normalize(i.viewDir);
                
                //对法线纹理采样
                fixed4 packedNormal = tex2D(_BumpMap,i.uv.zw);
                fixed3 tangentNormal;
                // //如果纹理没有被标记为“Normal map”
                // tangentNormal.xy = (packedNormal.xy * 2 - 1) * _BumpScale;
                // //saturate 取值0到1
                // tangentNormal.z = sqrt(1 - saturate(dot(tangentNormal.xy,tangentNormal.xy)));
                //如果纹理被标记为“Normal map”，则使用内置函数
                tangentNormal = UnpackNormal(packedNormal);
                tangentNormal.xy *=_BumpScale;
                tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));
                
                fixed3 albedo = tex2D(_MainTex, i.uv.xy).rgb * _Color.rgb;
                //环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0,dot(tangentNormal, tangentLightDir));

                fixed3 halfDir = normalize(tangentLightDir + tangentViewDir);
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(tangentNormal, halfDir)), _Gloss);
                return fixed4(ambient + diffuse + specular, 1);
            }
            ENDCG
        }   
    }
    Fallback "Specular"
}
