//Schlick Fresnel 菲涅尔反射 
Shader"UnityShadersBook/Chapter10/Fresnel"
{
    Properties
    {
        [HDR]_Color("颜色", Color) = (1, 1, 1, 1)
        _FresnelScale("", Range(0, 1)) = 0.5
        _Cubemap("", Cube) = "_Skybox" {}
    }
    SubShader
    {
        

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct a2v
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float3 pos : SV_POSITION;
                float3 worldNormal:TEXCOORD0;
                float3 worldPos:TEXCOORD1;
                float3 worldViewDir:TEXCOORD2;
                float3 worldRefl:TEXCOORD3;
                SHADOW_COORDS(4)
            };


            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                // o.worldNormal = Unit
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4(1,1,1,1);
            }
            ENDCG
        }
    }
}
