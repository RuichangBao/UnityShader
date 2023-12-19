Shader "Custom/2lsy_earth"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Cloud ("_Cloud", 2D) = "white" {}
        _CloudRange("CloudRange",Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags{"Queue"="Transparent" "RenderType"="Transparent"}
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float4 _Color;
            sampler2D _MainTex;
            sampler2D _Cloud;
            float4 _MainTex_ST;
            float _CloudRange;
            struct a2v
            {
                float4  vertex : POSITION;
                float2  texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4  pos : SV_POSITION;
                float2  uv : TEXCOORD0;
            };

            v2f vert (a2v a)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(a.vertex);
                o.uv = TRANSFORM_TEX(a.texcoord.xy, _MainTex);
                return o;
            }

            half4  frag (v2f i) : COLOR
            {
                //地球的贴图uv, x即横向在动
                // float u_x = i.uv.x + -0.1 * _Time.x;
                // float2 uv_earth = float2( u_x , i.uv.y);
                // half4 texcolor_earth = tex2D (_MainTex, uv_earth);
                
                // //云层的贴图uv的x也在动，但是动的更快一些 
                // float2 uv_cloud;
                // u_x = i.uv.x + -0.2 * _Time.x;
                // uv_cloud = float2( u_x , i.uv.y);
                // half4 tex_cloudDepth = tex2D (_Cloud, uv_cloud);
                // //纯白 x 深度值= 该点的云颜色
                // half4 texcolor_cloud = float4(1,1,1,0) * (tex_cloudDepth.x);
                // //地球云彩颜色混合
                // return lerp(texcolor_earth,texcolor_cloud,0.5f);


                float moveX1 = i.uv.x - 0.1*_Time.x;
                float moveX2 = i.uv.x - 0.2*_Time.x;
                float2 pos1 = float2(moveX1, i.uv.y);
                float2 pos2 = float2(moveX2, i.uv.y);
                float4 _texture1  = tex2D(_MainTex, pos1);
                float4 _texture2  = tex2D(_Cloud, pos2);
                half4 texcolor_cloud = float4(1,1,1,0) * (_texture2.x);
                half4 endText = lerp(texcolor_cloud, _texture1, _CloudRange);
                // half4 endText = (texcolor_cloud+_texture1)/2;
                return endText;
            }
            ENDCG
        }
    }
}