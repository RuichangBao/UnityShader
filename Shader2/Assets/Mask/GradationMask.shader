Shader "Custom/GradationMask"
{
    Properties
    {
        _MainTex("",2D)=""{}
        _Radius("半径", Range(0, 1)) = 0.25
        //x y 中心点位置 z 过度长度
        _Center("中心点",Vector)=(0.5, 0.5, 0.05, 0)
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

            sampler2D _MainTex;
            float _Radius;
            float4 _Center;
            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f o) : SV_Target
            { 
                fixed4 col = tex2D(_MainTex, o.uv);
                //坐标点距离中心点长度
                half len = length(half2(_Center.x, _Center.y)- o.uv);
                //step:(len >= _Radius)?1:0
                half a = step(len, _Radius);
                half cxA = step(len, _Center.z + _Radius);
                half le = 1 - step(cxA, a);
                half a2 = lerp(0, 1, (_Center.z + _Radius - len) / _Center.z) * cxA;
                col.a = a + a2 * le;
                return col;
            }
            ENDCG
        }
    }
}
