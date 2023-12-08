Shader "Custom/CustomLogoShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        _LightLength("LightLength",Range(0,1))=0.2
        _Speed("Speed",float)=1
        _Angle("Angle",Range(0,360))=90
    }
    SubShader
    {
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float _LightLength;
            //循环一次的时间 注意不是秒数
            float _Speed;
            //倾斜角度
            float _Angle;
            //返回流光颜色
            fixed4 GetFlushColor(float2 uv,fixed4 textureCol)
            {
                float _Radian =  radians(_Angle);
                //中点位置
                //float midX  = _Time.x*_Speed;
                float midX  = _Time.x*_Speed+uv.y/tan(_Radian);
                midX = fmod(midX,1);
                
                //该点距离中心轴的距离
                float xLength = abs(midX-uv.x);
                //半个流光的宽度
                float halfLightLenth = _LightLength/2;
                //是否在流光效果内
                if(xLength<=halfLightLenth)
                {
                    //像素透明没有流光效果
                    if(textureCol.a==0)
                    {
                        return textureCol;
                    }
                    fixed4 tempCol = lerp(fixed4(1,1,1,1), fixed4(0,0,0,1), xLength/halfLightLenth);
                    return textureCol+tempCol;
                }
                else
                {
                    return textureCol;
                }
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // col *= fixed4(0,0,0,1);
                return GetFlushColor(i.uv,col);
            }
            ENDCG
        }
    }
}
