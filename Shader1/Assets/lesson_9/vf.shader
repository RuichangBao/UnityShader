Shader "Sbin/vf" 
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
				col=float4(1,0,0,1);
				//col=pos;
			}

			void frag(inout float4 col:COLOR)
			{
				//col=float4(0,1,0,1);
			}

			ENDCG
		}
	}
}
