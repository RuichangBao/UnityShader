//逐顶点漫反射
Shader "Chapter6/DiffuseVertex"
{
    Properties
    {
        _Diffuse("漫反射颜色",Color)=(1,1,1,1)
    }
    SubShader
    {
        Tags{"LightModel" = "ForwardBase"}
        Pass
        {
            CGPROGRAM
            #include "Lighting.cginc"

            #pragma vertex vert
            #pragma fragment frag
            fixed4 _Diffuse;
            struct a2v
            {
                float4 vertex:POSITION;
                float3 normal:NORMAL;
            };
            struct v2f
            {  
                float4 pos:SV_POSITION;
                float4 color:COLOR;
            };
            
            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                //环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                //世界空间下的法线
                // fixed3 worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
                fixed3 worldNormal = normalize(mul(unity_ObjectToWorld, v.normal));
                //观察方向
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                //saturate 把输入值限制到[0, 1]之间。dot:返回两个向量的点积。
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));
                o.color = float4(ambient + diffuse, 1);
                return o;
            }

            float4 frag(v2f v):SV_Target
            {
                return v.color;
            }
            ENDCG
        }        
    }
}