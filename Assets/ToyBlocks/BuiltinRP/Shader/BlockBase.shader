Shader "Custom/BlockBase"
{
	Properties
	{
		_MainColor("Main", Color) = (1,0,0,1)
		_SubColor("Sub", Color) = (0,1,0,1)
		_White("White", Color) = (1,1,1,1)
		_Dust("Dust", Color) = (1,1,1,1)
		_MetalColor("Metal", Color) = (0,1,0,1)
		_MaskTex("Mask", 2D) = "white" {}
		_MaskTex2("Mask Dust", 2D) = "white" {}
		_MetallicGlossMap("Metallic", 2D) = "white" {}
		_BumpMap("Normal Map", 2D) = "bump" {}
		_DustIntensity("Dust Intensity", Float) = 0
	}
		SubShader
		{
			Tags{ "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM

			#pragma surface surf Standard fullforwardshadows
			#pragma target 3.0

			#include "UnityCG.cginc"

			sampler2D _MaskTex;
			sampler2D _MaskTex2;
			sampler2D _MetallicGlossMap;
			sampler2D _BumpMap;

			struct Input {
				float2 uv_MaskTex;
				float2 uv_MaskTex2;
				float2 uv_MetallicGlossMap;
				float2 uv_BumpMap;
			};


			fixed4 _MainColor;
			fixed4 _SubColor;
			fixed4 _MetalColor;
			fixed4 _White;
			fixed4 _Dust;
			float _DustIntensity;

			void surf(Input IN, inout SurfaceOutputStandard o)
			{
				fixed4 c = _MainColor;
				fixed4 mask = tex2D(_MaskTex, IN.uv_MaskTex);
				fixed4 mask2 = tex2D(_MaskTex2, IN.uv_MaskTex2);
				fixed4 m = tex2D(_MetallicGlossMap, IN.uv_MetallicGlossMap);
				float3 n = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));

				c = lerp(_MetalColor, _MainColor, pow(mask.g, 2));
				c = lerp(c, _White, pow(mask.r, 2));
				c = lerp(c, _SubColor, pow(mask.b, 2));
				c = lerp(c, _Dust, pow(mask2.r * _DustIntensity, 2));

				o.Albedo = c;
				o.Metallic = m.rgb;
				o.Smoothness = m.a;
				o.Normal = n;
				/*
				float3 normal1 = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
				o.Normal = normalize(half3(normal1.xy + normal2.xy, normal1.z * normal2.z));
				*/
			}

			ENDCG

		}
			FallBack "Standard"
}
