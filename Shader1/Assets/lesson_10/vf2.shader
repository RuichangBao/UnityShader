Shader "Sbin/vf2" 
{	
	SubShader 
	{
		pass
		{
			CGPROGRAM
			#pragma vertex vert  //顶点 vert函数名
			#pragma fragment frag//片段 frag函数名
			
			void vert(in float2 objPos:POSITION,out float4 pos:POSITION,out float4 col:COLOR)
			{
				pos=float4(objPos,0,1);
				col=pos;
			}

			void frag(inout float4 col:COLOR)
			{
				fixed r = 1;
				fixed g = 0;
				fixed b = 0;
				fixed a = 1;
				col = fixed4(r,g,b,a);
				//fixed2=fixed2(1,0);
				//float==>float2/float3/float4
				//half==>half2/half3/half4
				//fixed==>fixed2/fixed3/fixed4
				//bool b = true || false;
				//int 
			}

			ENDCG
		}
	}
}
