//溶解效果
Shader "Chapter15/Dissolve"
{
    Properties
    {
        _BurnAmount("消融程度", Range(0, 1)) = 0
        _LineWidth("燃烧线宽度", Range(0, 0.2)) = 0.1
        _MainTex ("Texture", 2D) = "white" {}
        _BumpMap ("法线贴图", 2D) = "bump" {}
        _BurnFirstColor("消融开始颜色", Color) = (1,0,0,1)
        _BurnSecondColor("消融第二颜色", Color) = (1,0,0,1)
        _BurnMap ("燃烧贴图", 2D) = "white" {}
    }
    SubShader
    {
        


        Pass
        {
            Tags { "RenderType" = "ForwardBase" }
            Cull Off

            CGPROGRAM
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            #pragma multi_compile_fwdbase

            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"

            struct a2v
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uvMainTex : TEXCOORD0;
                float2 uvBumpMap : TEXCOORD1;
                float2 uvBurnMap : TEXCOORD2;
                float3 lightDir : TEXCOORD3;
                float3 worldPos : TEXCOORD4;
                SHADOW_COORDS(5)
            };

            float _BurnAmount;
            float _LineWidth;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            float4 _BurnFirstColor;
            float4 _BurnSecondColor;
            sampler2D _BurnMap;
            float4 _BurnMap_ST;


            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uvMainTex = TRANSFORM_TEX(v.uv, _MainTex);
                o.uvBumpMap = TRANSFORM_TEX(v.uv, _BumpMap);
                o.uvBurnMap = TRANSFORM_TEX(v.uv, _BurnMap);
                TANGENT_SPACE_ROTATION;
                o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                TRANSFER_SHADOW(o);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uvMainTex);
                return col;
            }
            ENDCG
        }
    }
}
