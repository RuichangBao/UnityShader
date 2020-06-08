Shader "Sbin/sf" {
	Properties {
		//_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		//_Glossiness ("Smoothness", Range(0,1)) = 0.5  //高光
		//_Metallic ("Metallic", Range(0,1)) = 0.0       //金属光泽
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "queue"="transparent" }//不透明
		LOD 200

		CGPROGRAM   //使用CG语法
		// Physically based Standard lighting model, and enable shadows on all light types
		//#pragma surface surf Standard fullforwardshadows //
		//#pragma surface surf Lambert fullforwardshadows Alpha //
		#pragma surface surf Lambert Alpha Addshadow//
		//surf 函数名
		//Standard 光照类型(函数)
		//fullforwardshadows 阴影类型 完整的向前的阴影

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0 //  使用shader model 3.0

		

		struct Input 
		{
			float2 uv_MainTex;  //必须以uv开头
		};

		sampler2D _MainTex; //二维纹理 纹理采样
		//half _Glossiness;
		//half _Metallic;
		//fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		//void surf (Input IN, inout SurfaceOutputStandard o) 
		void surf (Input IN, inout SurfaceOutput o) 
		{
			// Albedo comes from a texture tinted by color
			//fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);// * _Color;
			o.Albedo = c.rgb;//Albedo 反射率
			// Metallic and smoothness come from slider variables
			//o.Metallic = _Metallic;
			//o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	//FallBack "Diffuse"
}
