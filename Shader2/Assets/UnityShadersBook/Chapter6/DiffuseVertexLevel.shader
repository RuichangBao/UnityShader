// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
//逐顶点漫反射光照
Shader "UnityShadersBook/Chapter6/DiffuseVertexLevel"
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

            fixed4 _Diffuse;

            struct a2v {
                float4 pos : POSITION;
                float4 texcoord : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                fixed3 color : COLOR0;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                //环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                //fixed3 worldNormal = normalize(mul(v.normal,(float3x3)_World2Object));
                //mul 矩阵和向量或者向量和矩阵的相乘
                //unity_WorldToObject 当前世界矩阵的逆矩阵。
                //模型空间的法线转换成世界空间下的法线              
                fixed3 worldNormal = normalize(mul(v.normal,(float3x3)unity_WorldToObject));
                //_WorldSpaceLightPos0 Unity 内置变量 光源方向
                //光源方向
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                //漫反射光
                //saturate 取[0-1]
                //dot 返回两个向量的点积
                //_LightColor0 Unity 内置变量获取光源的颜色和强度
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal,worldLight));
                //输出颜色 环境光+反射光
                o.color = ambient + diffuse;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return fixed4(i.color,1);
            }
            ENDCG
        }
    }
}
