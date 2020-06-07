Shader "Sbin/ff2"{

	Properties //属性
	{
		_Color("YanSe",color)=(1,1,1,1)
		//_Color2("照射光",color)=(1,1,1,1)
		_Ambient("HuanJingGuang",color)=(0.3,0.3,0.3,0.3)
		_Specular("GaoGuang",color)=(1,1,1,1)
		_Shininess("GaoGuangQuYu",range(0,8))=4
		_Emission("ZiFaGuang",color)=(1,1,1,1)
		_MainTex("MainTex",2D)= "white" {}
		_MainTex2("MainTex2",2D)="white" {}
		_ConstantColor("ConstantColor",color)=(1,1,1,0.3)
	}

	SubShader
	{
		Tags {"Queue"="Transparent"} //渲染队列 用来表示渲染的先后顺序
		pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			//color(1,0,1,1)  //固定颜色
			//color[_Color2]   //可变颜色
			Material
			{
				Diffuse[_Color] //漫反射颜色
				Ambient[_Ambient]//环境光
				Specular[_Specular]//高光
				Shininess[_Shininess]//高光区域
				Emission[_Emission] //自发光
			}
			Lighting on			//是否打开光照顶点光照(打开光照后 照射光颜色不在改变只是显示漫反光颜色)
			Separatespecular on  //独立的镜面的高光

			Settexture[_MainTex]
			{
			    //Combine texture  //仅仅使用贴图
				Combine texture * Primary double //* Primary 代表了所有计算了材质光照的颜色(顶点光照)
													//因为两个小于1的浮点值相乘更小 所有乘以2倍 double
				//Combine texture * Primary quad	//quad四倍
			}

			Settexture[_MainTex2]
			{   //Previous 表示所有之前采样计算结果
				ConstantColor[_ConstantColor]
				//Combine texture * Previous double,texture*Constant
				Combine texture * Previous double,Constant //Constant表示自定义透明度
			}
		}
	}
}