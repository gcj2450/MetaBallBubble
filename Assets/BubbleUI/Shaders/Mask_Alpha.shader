
Shader "Unlit/Particles/Mask/Mask_Alpha"
{
	Properties
	{
		_TintColor("Tint Color", Color) = (0.5, 0.5, 0.5, 0.5)

		_MainTex("Particle Texture", 2D) = "white" {}
		_MaskTex	("Mask Texture", 2D) = "white" {}

		_StartAlpha("StartAlpha",Range(0,1))=0.3
		_BlendThreshold("BlendThreshold", Range(0.001, 0.1)) = 0.01
	}

	Category
	{
		Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		//AlphaTest Greater .01
		//ColorMask RGB
		Cull Off Lighting Off ZWrite Off

		SubShader {
			Pass {

				CGPROGRAM

				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				sampler2D _MainTex;
				float4 _MainTex_ST;

				sampler2D _MaskTex;
				float4 _MaskTex_ST;
				
				fixed4 _TintColor;

				float _StartAlpha;
				float _BlendThreshold;

				struct appdata_t 
				{
					float4 vertex : POSITION;
					float2 texcoord : TEXCOORD0;
					float2 texcoord2 : TEXCOORD1;
				};

				struct v2f 
				{
					float4 vertex : SV_POSITION;
					float2 texcoord : TEXCOORD0;
					float2 texcoord2 : TEXCOORD1;
				};

				

				v2f vert(appdata_t v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord2 = TRANSFORM_TEX(v.texcoord2, _MaskTex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					float4 texColor = tex2D(_MainTex, i.texcoord);
					float4 maskColor = tex2D(_MaskTex, i.texcoord2);

					texColor.a *= smoothstep(_StartAlpha,_StartAlpha+_BlendThreshold, maskColor.r);
					
					return _TintColor * texColor;
				}
				ENDCG
			}
		}
	}
}