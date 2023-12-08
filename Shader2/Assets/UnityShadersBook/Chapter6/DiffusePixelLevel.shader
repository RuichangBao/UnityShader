// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
//逐像素漫反射光照
Shader "UnityShadersBook/Chapter6/DiffusePixelLevel"
{
    Properties
    {
        _Diffuse("Diffuse", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "LightMode" = "ForwardBase" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed3 worldNormal : TEXCOORD0;
            };

            fixed4 _Diffuse;

            v2f vert(a2v v)
            {
                v2f o;
                // o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);

                //o.worldNormal = mul(v.normal,(float3x3)_World2Object);
                //mul 矩阵和向量或者向量和矩阵的相乘
                //unity_WorldToObject 当前世界矩阵的逆矩阵。
                //模型空间的法线转换成世界空间下的法线
                o.worldNormal = mul(v.normal,(float3x3)unity_WorldToObject);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                //环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                //法线归一化
                fixed3 worldNormal = normalize(i.worldNormal);
                //光源方向
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                //漫反射光
                //saturate 取[0-1]
                //dot 返回两个向量的点积
                //_LightColor0 Unity 内置变量获取光源的颜色和强度
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal,worldLight));
                fixed3 color = ambient + diffuse;
                return fixed4(color,1);
            }
            ENDCG
        }
    }
}
