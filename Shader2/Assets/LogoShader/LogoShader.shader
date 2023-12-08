// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/LogoShader" {
    Properties 
    {
        _MainTex ("Texture", 2D) = "white" { }
        _Angle("倾斜角度",float) = 110
        _XLength("光带长度",float) = 0.5
        _LoopTime("单次循环时间", float) = 0.7
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        //透明度混合
        //SrcAlpha 原颜色透明度值
        //OneMinusSrcAlpha 1-原颜色透明度值
        Blend SrcAlpha OneMinusSrcAlpha 
        AlphaTest Greater 0.1
        pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            
            struct a2v
            {
                float4 vertex :POSITION;
                float2 texcoord: TEXCOORD0;
            };

            struct v2f 
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
            
            //顶点函数没什么特别的，和常规一样
            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
                //o.uv=v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }
            float _Angle;
            float _XLength;
            float _LoopTime;
            //必须放在使用其的 frag函数之前，否则无法识别。
            //核心：计算函数 uv，间隔，开始时间，偏移
            float inFlash(float2 uv,int interval,int beginTime, float offX)
            {
                //亮度值
                float brightness =0;
                //倾斜角
                float angleInRad = 0.0174444 * _Angle;
                
                //当前时间
                float currentTime = _Time.y;
                
                //获取本次光照的起始时间
                int currentTimeInt = _Time.y/interval;
                currentTimeInt *=interval;
                
                //获取本次光照的流逝时间 = 当前时间 - 起始时间
                float currentTimePassed = currentTime -currentTimeInt;
                if(currentTimePassed >beginTime)
                {
                    //底部左边界和右边界
                    float xBottomLeftBound;
                    float xBottomRightBound;

                    //此点边界
                    float xPointLeftBound;
                    float xPointRightBound;
                    
                    float x0 = currentTimePassed-beginTime;
                    x0 /= _LoopTime;
                    
                    //设置右边界
                    xBottomRightBound = x0;
                    
                    //设置左边界
                    xBottomLeftBound = x0 - _XLength;
                    
                    //投影至x的长度 = y/ tan(_Angle)
                    float xProjL;
                    xProjL= (uv.y)/tan(angleInRad);

                    //此点的左边界 = 底部左边界 - 投影至x的长度
                    xPointLeftBound = xBottomLeftBound - xProjL;
                    //此点的右边界 = 底部右边界 - 投影至x的长度
                    xPointRightBound = xBottomRightBound - xProjL;
                    
                    //边界加上一个偏移
                    xPointLeftBound += offX;
                    xPointRightBound += offX;
                    
                    //如果该点在区域内
                    if(uv.x > xPointLeftBound && uv.x < xPointRightBound)
                    {
                        //得到发光区域的中心点
                        float midness = (xPointLeftBound + xPointRightBound)/2;
                        
                        //趋近中心点的程度，0表示位于边缘，1表示位于中心点
                        float rate= (_XLength -2*abs(uv.x - midness))/ (_XLength);
                        brightness = rate;
                    }
                }
                brightness= max(brightness,0);
                
                //返回颜色 = 纯白色 * 亮度
                float4 col = float4(1,1,1,1) * brightness;
                return brightness;
            }
            
            float4 frag (v2f i) : COLOR
            {
                float4 outp;
                
                //根据uv取得纹理颜色，和常规一样
                float4 texCol = tex2D(_MainTex,i.uv);
                
                //传进i.uv等参数，得到亮度值
                float tmpBrightness;
                // tmpBrightness =inFlash(i.uv,5,2,0.15);
                tmpBrightness =inFlash(i.uv,5,0,0.15);
                //图像区域，判定设置为 颜色的A > 0.5,输出为材质颜色+光亮值
                if(texCol.w >0.5)
                {
                    outp  = texCol+float4(1,1,1,1)*tmpBrightness;
                }
                //空白区域，判定设置为 颜色的A <=0.5,输出空白
                else
                {
                    outp =float4(0,0,0,0);
                }
                return outp;
            }
            ENDCG
        }
    }
}