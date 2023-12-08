Shader "Texgen" {
   Properties {
  _Tex ("Cube", 2D) = "white" { TexGen SphereMap }
   }
SubShader {
Pass {
SetTexture [_MainTex] { combine
texture }
}
}
}