 Shader "Unlit/DefaultTransparent" {
 Properties {
     _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	 _ReticleColor("ReticleColor", Color) = (1,1,1,1)
 }
 
 SubShader {
     Tags
			{
				"Queue" = "Transparent+1000"
				"IgnoreProjector" = "True"
				"RenderType" = "Transparent"
			}
     Cull Off
	Lighting Off
	ZWrite Off
	ZTest Off
	Offset -1,-1
	Blend SrcAlpha OneMinusSrcAlpha
     
     Pass {  
         CGPROGRAM
             #pragma vertex vert
             #pragma fragment frag
             #include "UnityCG.cginc"
 
             //struct appdata_t {
             //    float4 vertex : POSITION;
             //    float2 texcoord : TEXCOORD0;
             //};
 
			struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				//float4 color : COLOR;
            };

			 struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
				//float4 color : COLOR;
            };

             //struct v2f {
             //    float4 vertex : SV_POSITION;
             //    half2 texcoord : TEXCOORD0;
             //};
 
             sampler2D _MainTex;
             float4 _MainTex_ST;
             float4 _ReticleColor;

             v2f vert (appdata v)
             {
                 v2f o;
                 o.vertex = UnityObjectToClipPos(v.vertex);
                 o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                 //UNITY_TRANSFER_FOG(o,o.vertex);
                 return o;
             }
             
             fixed4 frag (v2f i) : SV_Target
             {
                 fixed4 col = tex2D(_MainTex, i.uv);
                 return col;
             }
         ENDCG
     }
 }
 
 }
 