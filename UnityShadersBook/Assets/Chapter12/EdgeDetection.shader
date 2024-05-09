//边缘检测
Shader "Chapter12/EdgeDetection"
{
    Properties
    {
        _MainTex ("Base(RGB)", 2D) = "white" {}
        _EdgeOnly("边缘检测", Float) = 1
        _EdgeColor("边缘颜色", Color) = (0,0,0,1)
        _BackgroundColor("背景颜色", Color) = (1,1,1,1)
    }
    SubShader
    {
        // Tags { "RenderType"="Opaque" }

        Pass
        {   
            //深度测试:开启 剔除模式:关闭 深度写入:关闭
            ZTest Always Cull Off Zwrite Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            sampler2D _MainTex;
            half2 _MainTex_TexelSize;

            fixed _EdgeOnly;   //亮度
            fixed4 _EdgeColor;   //边缘颜色
            fixed4 _BackgroundColor;     //背景颜色
            
            struct a2v
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                half2 uv[9] : TEXCOORD0;
            };


            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                half2 uv = v.uv;
                
                o.uv[0] = uv + _MainTex_TexelSize * half2(-1, -1);
                o.uv[1] = uv + _MainTex_TexelSize * half2(0, -1);
                o.uv[2] = uv + _MainTex_TexelSize * half2(1, -1);
                o.uv[3] = uv + _MainTex_TexelSize * half2(-1, 0);
                o.uv[4] = uv;
                o.uv[5] = uv + _MainTex_TexelSize * half2(1, 0);
                o.uv[6] = uv + _MainTex_TexelSize * half2(-1, 1);
                o.uv[7] = uv + _MainTex_TexelSize * half2(0, 1);
                o.uv[8] = uv + _MainTex_TexelSize * half2(1, 1);
                //1820 1024
                // o.uv[0] = uv + half2(-1.0f/1820, -1.0f/1024);
                // o.uv[1] = uv + half2(0.0f/1820, -1.0f/1024);
                // o.uv[2] = uv + half2(1.0f/1820, -1.0f/1024);
                // o.uv[3] = uv + half2(-1.0f/1820, 0.0f/1024);
                // o.uv[4] = uv + half2(0.0f/1820, 0.0f/1024);
                // o.uv[5] = uv + half2(1.0f/1820, 0.0f/1024);
                // o.uv[6] = uv + half2(-1.0f/1820, 1.0f/1024);
                // o.uv[7] = uv + half2(0.0f/1820, 1.0f/1024);
                // o.uv[8] = uv + half2(1.0f/1820, 1.0f/1024);
                return o;
            }
            //计算亮度 0.2125，0.7154，0.0721固定系数
            fixed luminance(fixed4 color)
            {
                return  0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b;//亮度
            }

            half Sobel(v2f i)
            {
                const half Gx[9] = {
                    -1, 0, 1,
                    -2, 0, 2,
                    -1, 0, 1
                };
                const half Gy[9] = {
                    -1, -2, -1,
                    0, 0, 0,
                    1, 2, 1
                };
                
                half texColor;
                half edgeX = 0;
                half edgeY = 0;
                for(int it = 0; it < 9; it++)
                {
                    fixed4 imageColor = tex2D(_MainTex, i.uv[it]);
                    //亮度值
                    texColor = luminance(imageColor);
                    edgeX += texColor * Gx[it];
                    edgeY += texColor * Gy[it];
                }
                half edge = 1 - abs(edgeX) - abs(edgeY);
                return edge;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                //亮度变化 edge值越小，越可能是边缘
                half edge = Sobel(i);
                //图像颜色
                fixed4 imageColor = tex2D(_MainTex, i.uv[4]);
                fixed4 withEdgeColor = lerp(_EdgeColor, imageColor, edge);
                fixed4 onlyEdgeColor = lerp(_EdgeColor, _BackgroundColor, edge);
                return lerp(withEdgeColor, onlyEdgeColor, _EdgeOnly);
            }

            ENDCG
        }
    }
    Fallback Off
}
