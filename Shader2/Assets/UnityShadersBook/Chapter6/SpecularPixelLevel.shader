// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

//逐像素高光反射
Shader "UnityShadersBook/Chapter6/SpecularPixelLevel"
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
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            fixed4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;

            v2f vert (a2v v)
            {
                v2f o;
                // o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                // o.worldNormal = mul(v.normal,(float3x3)_World2Object);
                o.worldNormal = mul(v.normal,(float3x3)unity_WorldToObject);
                // o.worldPos = mul(_Object2World,v.vertex).xyz;
                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                //归一化世界法线
                fixed3 worldNormal = normalize(i.worldNormal);
                //归一化光源方向
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

                //_LightColor0.rgb 光源颜色
                //漫反射
                fixed3 diffuse = _LightColor0.rgb*_Diffuse.rgb*saturate(dot(worldNormal,worldLightDir));

                //高光反射部分
                //得到高光反射方向
                fixed3 reflectDir = normalize(reflect(-worldLightDir,worldNormal));
                //高光反射视角方向
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz-i.worldPos.xyz);
                fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(saturate(dot(reflectDir,viewDir)),_Gloss);
                return fixed4(ambient + diffuse + specular,1);
            }
            ENDCG
            
        } 
        
    } 
    Fallback "Specular"
}
