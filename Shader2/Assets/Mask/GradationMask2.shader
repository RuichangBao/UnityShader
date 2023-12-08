Shader "Custom/GradationMask2"
{
    Properties
    {
        _Radius("半径", Range(0, 1)) = 0.25
        //x y 中心点位置 z 过度长度
        _Center("中心点",Vector)=(0.5, 0.5, 0.05, 0)
        _MaskClolor("遮罩颜色", Color) = (0,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100

        Pass
        {
            Tags {"LightMode" = "ForwardBase"}
            ZWrite Off  //关闭深度写入
            Blend SrcAlpha OneMinusSrcAlpha 
            CGPROGRAM
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
                float2 uv : TEXCOORD0;
            };

            float _Radius;
            float4 _Center;
            float4 _MaskClolor;
            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f o) : SV_Target
            {
                half len = length(half2(_Center.x, _Center.y) - o.uv);
                half alpha = lerp(0, 1, (len - _Radius)/_Center.z);
                _MaskClolor.a = alpha;
                return _MaskClolor;
            }
            ENDCG
        }
    }
}
