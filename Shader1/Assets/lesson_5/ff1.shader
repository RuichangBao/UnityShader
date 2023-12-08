﻿Shader "Sbin/ff1"{

	Properties //属性
	{
		_Color("YanSe",color)=(1,1,1,1)
		//_Color2("照射光",color)=(1,1,1,1)
		_Ambient("HuanJingGuang",color)=(0.3,0.3,0.3,0.3)
		_Specular("GaoGuang",color)=(1,1,1,1)
		_Shininess("GaoGuangQuYu",range(0,8))=4
		_Emission("ZiFaGuang",color)=(1,1,1,1)
	}

	SubShader
	{
		pass
		{
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
		}
	}
}