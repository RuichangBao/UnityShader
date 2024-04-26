//玻璃效果
Shader "Chapter10/GlassRefraction"
{
    Properties 
    {
        _MainTex("材质纹理", 2D) = "white"{}
        _NormalMap("法线贴图", 2D) = "white" {}
        _Cubemap("环境纹理", Cube) = "_Skybx" {}
        _Distortion("扭曲程度", Range(1, 100)) = 10
        _RefractAmount("折射量", Range(0, 1)) = 1
    }
    SubShader 
    {
        Tags { "Queue"="Transparent" "RenderType"="Opaque" }
        GrabPass {"_RefractionTex"}
        
        Pass 
        {		
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _NormalMap;
            float4 _NormalMap_ST;
            samplerCUBE _Cubemap;
            float _Distortion;
            float _RefractAmount;
            sampler2D _RefractionTex;
            float4 _RefractionTex_TexelSize;
            
            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float4 texcoord : TEXCOORD0;
            };
            
            struct v2f
            {               
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD0;
                float4 scrPos :TEXCOORD1;
                float4 TtoW0 : TEXCOORD2;
                float4 TtoW1 : TEXCOORD3;
                float4 TtoW2 : TEXCOORD4;
            };
            
            v2f vert (a2v v) 
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                //获得屏幕图像的采样坐标
                o.scrPos = ComputeGrabScreenPos(o.pos);
                o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.uv.zw = TRANSFORM_TEX(v.texcoord, _NormalMap);

                float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float3 worldTangent = UnityObjectToWorldDir(v.tangent);
                float3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;
                o.TtoW0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
                o.TtoW1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
                o.TtoW2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target 
            {
                float3 worldPos = normalize(float3(i.TtoW0.w, i.TtoW1.w, i.TtoW2.w));
                float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
                float4 nomalColor = tex2D(_NormalMap, i.uv.zw);
                float3 tangentNormal = UnpackNormal(nomalColor);
                // float3 tangentNormal; 
                // tangentNormal.xy = nomalColor.wy * 2 - 1;
                // tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));
                float2 offset = tangentNormal.xy * _Distortion * _RefractionTex_TexelSize.xy;
                i.scrPos.xy = offset * i.scrPos.z + i.scrPos.xy;
                //折射颜色
                fixed3 refrcol = tex2D(_RefractionTex, i.scrPos.xy/i.scrPos.w).rgb;
                //将法线转换到世界空间下
                float3 worldNormal = normalize(float3(dot(i.TtoW0.xyz, tangentNormal), dot(i.TtoW1.xyz, tangentNormal), dot(i.TtoW2.xyz, tangentNormal)));
                fixed3 reflDir = reflect(-worldViewDir, worldNormal);              
                float4 texColor = tex2D(_MainTex, i.uv.xy);
                //反射颜色
                fixed3 reflCol = texCUBE(_Cubemap, reflDir).rgb * texColor.rgb;
                fixed3 finalColor = reflCol * (1 - _RefractAmount) + refrcol * _RefractAmount;
                return float4(finalColor, 1);
            }
            
            ENDCG
        }
    }
    
    FallBack "Diffuse"
}