// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
//逐顶点高光反射
Shader "UnityShadersBook/Chapter6/SpecularVertexLevel"
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
        Tags { "LightMode"="ForwardBase" }

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
                fixed3 color : COLOR;
                float4 pos : SV_POSITION;
            };

            fixed4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;

            v2f vert (a2v v)
            {
                v2f o;
                // o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                //环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                //法线转换
                //fixed3 worldNormal = normalize(mul(v.normal,(float3x3)_World2Object));
                //mul 矩阵和向量或者向量和矩阵的相乘
                //unity_WorldToObject 当前世界矩阵的逆矩阵。
                //模型空间的法线转换成世界空间下的法线
                fixed3 worldNormal = normalize(mul(v.normal,(float3x3)unity_WorldToObject));
                //光源方向
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                //漫反射光 Cdiffuse = (Clight · Mdiffuse)max(0,n·I)
                //_LightColor0环境光
                //saturate 取[0-1]
                //dot 返回两个向量的点积
                fixed3 diffuse = _LightColor0.rgb*_Diffuse.rgb*saturate(dot(worldNormal, worldLightDir));
                //高光反射方向
                //reflect 计算高光反射光方向
                fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));
                //获得世界空间中的视角方向
                //_WorldSpaceCameraPos 世界空间中的摄像机位置
                //unity_ObjectToWorld 当前模型矩阵。
                fixed3 worldPos = mul(unity_ObjectToWorld, v.vertex);
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - worldPos);
                //高光反射
                //cspecular =  (clight · mspecular)max(0,v·r)  mgloss
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, viewDir)), _Gloss);
                o.color = ambient + diffuse + specular;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4(i.color,1);
            }
            ENDCG
            
        } 
       
    } 
    Fallback "Specular"
}
