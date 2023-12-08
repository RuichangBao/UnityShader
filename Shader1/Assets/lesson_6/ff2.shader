Shader "Sbin/ff2"{

	Properties //����
	{
		_Color("YanSe",color)=(1,1,1,1)
		//_Color2("�����",color)=(1,1,1,1)
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
		Tags {"Queue"="Transparent"} //��Ⱦ���� ������ʾ��Ⱦ���Ⱥ�˳��
		pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			//color(1,0,1,1)  //�̶���ɫ
			//color[_Color2]   //�ɱ���ɫ
			Material
			{
				Diffuse[_Color] //��������ɫ
				Ambient[_Ambient]//������
				Specular[_Specular]//�߹�
				Shininess[_Shininess]//�߹�����
				Emission[_Emission] //�Է���
			}
			Lighting on			//�Ƿ�򿪹��ն������(�򿪹��պ� �������ɫ���ڸı�ֻ����ʾ��������ɫ)
			Separatespecular on  //�����ľ���ĸ߹�

			Settexture[_MainTex]
			{
			    //Combine texture  //����ʹ����ͼ
				Combine texture * Primary double //* Primary ���������м����˲��ʹ��յ���ɫ(�������)
													//��Ϊ����С��1�ĸ���ֵ��˸�С ���г���2�� double
				//Combine texture * Primary quad	//quad�ı�
			}

			Settexture[_MainTex2]
			{   //Previous ��ʾ����֮ǰ����������
				ConstantColor[_ConstantColor]
				//Combine texture * Previous double,texture*Constant
				Combine texture * Previous double,Constant //Constant��ʾ�Զ���͸����
			}
		}
	}
}