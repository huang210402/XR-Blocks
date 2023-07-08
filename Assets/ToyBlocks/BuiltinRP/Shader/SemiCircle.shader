// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/SemiCircle"
{
	Properties
	{
		_MaskColor("Color Mask", Color) = (1,0,0,1)
		_MaskColor2("Color Mask2", Color) = (0,1,0,1)
		_MaskTex("Mask (RGB)", 2D) = "white" {}
		_MaskFace("Mask Face", 2D) = "white" {}
		_MaskSide("Mask Side", 2D) = "white" {}
		_MetallicGlossMap("Metallic Side", 2D) = "white" {}
		_BumpMap("Normal Map Side", 2D) = "bump" {}
		_MetallicGlossMap2("Metallic2 Face", 2D) = "white" {}
		_BumpMap2("Normal Map2 Face", 2D) = "bump" {}
		_BumpMap0("Whole Normal", 2D) = "bump" {}
		_Rotation("Rotation", Range(0,360)) = 0.0
		_Scale("Texture Scale", Float) = 1.0

		[Toggle] _Invert_Mask("Invert Mask", Float) = 0
		[Toggle] _Invert_Color("Invert Color", Float) = 0
	}
		SubShader
		{
			Tags{ "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM

			#pragma shader_feature _INVERT_MASK_ON
			#pragma shader_feature _INVERT_COLOR
			#pragma surface surf Standard fullforwardshadows vertex:vert
			#pragma target 3.0

			#include "UnityCG.cginc"

			float2 rotateUV(float2 uv, float degrees)
			{
				// rotating UV
				const float Deg2Rad = (UNITY_PI * 2.0) / 360.0;

				float rotationRadians = degrees * Deg2Rad; // convert degrees to radians
				float s = sin(rotationRadians); // sin and cos take radians, not degrees
				float c = cos(rotationRadians);

				float2x2 rotationMatrix = float2x2(c, -s, s, c); // construct simple rotation matrix

				uv -= 0.5; // offset UV so we rotate around 0.5 and not 0.0
				uv = mul(rotationMatrix, uv); // apply rotation matrix
				uv += 0.5; // offset UV again so UVs are in the correct location

				return uv;
			}
			
			
			sampler2D _MaskTex;
			sampler2D _MaskSide;
			sampler2D _MaskFace;
			sampler2D _MetallicGlossMap;
			sampler2D _BumpMap;
			sampler2D _MetallicGlossMap2;
			sampler2D _BumpMap2;
			sampler2D _BumpMap0;
			sampler2D _RotatedTex;

			struct Input {
				float2 uv_MaskTex;
				float2 uv_MetallicGlossMap;
				float2 uv_BumpMap;
				float2 uv_MetallicGlossMap2;
				float2 uv_BumpMap2;
				float2 uv_BumpMap0;
				float2 rotatedUV;
			};

			fixed4 _MaskColor;
			fixed4 _MaskColor2;

			float _Rotation;
			float _Scale;

			void vert(inout appdata_full v, out Input o) {
				UNITY_INITIALIZE_OUTPUT(Input, o);
				o.rotatedUV = rotateUV(v.texcoord, _Rotation);
			}

			void surf(Input IN, inout SurfaceOutputStandard o)
			{
				fixed4 c = _MaskColor2;
				fixed4 mask = tex2D(_MaskTex, IN.uv_MaskTex);
				fixed4 maskColor = tex2D(_MaskTex, IN.rotatedUV * _Scale);
				fixed4 masks = tex2D(_MaskSide, IN.rotatedUV * _Scale);
				fixed4 maskf = tex2D(_MaskFace, IN.rotatedUV * _Scale);
				fixed4 m = tex2D(_MetallicGlossMap, IN.rotatedUV * _Scale);
				fixed4 m2 = tex2D(_MetallicGlossMap2, IN.rotatedUV * _Scale);

				maskColor = lerp(maskf, masks, pow(mask.r, 2));

				#ifdef _INVERT_COLOR
					c = lerp(c, _MaskColor, pow(maskColor.r, 2));
				#else
					c = lerp(_MaskColor,c, pow(maskColor.r, 2));
				#endif

				#ifdef _INVERT_MASK_ON
					m = lerp(m, m2, pow(mask.r, 2));
				#else
					m = lerp(m2, m, pow(mask.r, 2));
				#endif

				o.Albedo = c;
				o.Metallic = m.rgb;
				o.Smoothness = m.a;

				float3 normal1 = UnpackNormal(tex2D(_BumpMap, IN.rotatedUV * _Scale));
				float3 normal2 = UnpackNormal(tex2D(_BumpMap2, IN.rotatedUV * _Scale));

				#ifdef _INVERT_MASK_ON
				normal1 = lerp(normal1, normal2, pow(mask.r, 2));
				#else
				normal1 = lerp(normal2, normal1, pow(mask.r, 2));
				#endif

				float3 normal0 = UnpackNormal(tex2D(_BumpMap0, IN.uv_BumpMap0));

				o.Normal = normalize(half3(normal1.xy + normal0.xy, normal1.z * normal0.z));
			}

			ENDCG

		}
			FallBack "Standard"
}

