// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/BasicShader"	//定义着色器的名称
{
	SubShader	//Unity选择最适合GPU的subshader
	{
		Pass	//有些着色器需要多个Pass
		{
			//这里开始Unity的Cg部分
			CGPROGRAM

			//将vert函数指定为顶点着色器函数
			//vertex 顶点着色器函数
			#pragma vertex vert 
			//将Frag函数指定为片段着色器函数
			//fragment 片段着色器函数
			#pragma fragment frag

			//顶点着色器函数
			//POSITION模型空间下的顶点坐标  SV_POSITION:建材空间中的顶点坐标
			float4 vert(float4 vertexPos:POSITION):SV_POSITION
			{
				return UnityObjectToClipPos(vertexPos);
				//该行将顶点输入参数vertexPos转换为内置矩阵UNITY_MATRIX_MVP，
            	//并将其作为无名顶点输出参数返回 
			}

			float4 frag(void):COLOR
			{
				return float4(1.0,0.0,0.0,1.0);
				//此片段着色器返回设置为不透明红色(red=1,green=0,blue=0,alpha=1)
            	//的无名片段输出参数（带语义COLOR）
			}

			//这里是CG的结束部分
			ENDCG
		}
	}
}
