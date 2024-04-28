Shader "Chapter11/ImageSequenceAnimation"
{
    Properties 
    {
        _MainTex ("Image Sequence", 2D) = "white" {}
        _num ("num", float) = 8
        _Speed("速度", int) = 30 
    }
    SubShader 
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        
        Pass 
        {
            Tags { "LightMode"="ForwardBase" }
            
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            
            #pragma vertex vert  
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _num;
            int _Speed;
            struct a2v 
            {  
                float4 vertex : POSITION; 
                float2 texcoord : TEXCOORD0;
            };  
            
            struct v2f 
            {  
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };  
            
            v2f vert (a2v v) 
            {  
                v2f o;  
                o.pos = UnityObjectToClipPos(v.vertex);  
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);  
                return o;
            }  
            
            fixed4 frag (v2f i) : SV_Target 
            {
                float time = floor(_Time.y * _Speed);
                // time = fmod(time, _num * _num);//因为有_MainTex_ST 所以 这段代码可以省略掉
                float y = _num - 1 - floor(time / _num);//索引是0到（_num-1)
                float x = time - y * _num;
    
                // float2 uv = i.uv / _num;
                // uv.x = uv.x + x / _num;
                // uv.y = uv.y + y / _num;
                //上边三行代码可以简化成下边代码
                float2 uv = float2((i.uv.x+x)/_num, (i.uv.y+y)/_num);
               
                fixed4 color = tex2D(_MainTex, uv);
                return color;
            }
            ENDCG
        }  
    }
    FallBack "Transparent/VertexLit"
}
