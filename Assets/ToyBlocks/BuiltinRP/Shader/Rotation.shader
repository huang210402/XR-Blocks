Shader "Custom/Surface UV Rotation in vertex" {
    Properties{
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0,1)) = 0.5
        _Metallic("Metallic", Range(0,1)) = 0.0
        [NoScaleOffset] _RotatedTex("Texture", 2D) = "white" {}
        _Rotation("Rotation", Range(0,360)) = 0.0
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 200

            CGPROGRAM
            // Physically based Standard lighting model, and enable shadows on all light types
            #pragma surface surf Standard fullforwardshadows vertex:vert

            // Use shader model 3.0 target, to get nicer looking lighting
            #pragma target 3.0

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

            sampler2D _MainTex;
            sampler2D _RotatedTex;

            struct Input {
                float2 uv_MainTex;
                float2 rotatedUV;
            };

            half _Glossiness;
            half _Metallic;
            fixed4 _Color;
            float _Rotation;

            void vert(inout appdata_full v, out Input o) {
                UNITY_INITIALIZE_OUTPUT(Input,o);
                o.rotatedUV = rotateUV(v.texcoord, _Rotation);
            }

            void surf(Input IN, inout SurfaceOutputStandard o) {
                // Albedo comes from a texture tinted by color
                fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;

                // rotated texture
                fixed4 c2 = tex2D(_RotatedTex, IN.rotatedUV);

                // blend the two together so we can see them
                c = (c + c2) / 2.0;

                o.Albedo = c.rgb;
                // Metallic and smoothness come from slider variables
                o.Metallic = _Metallic;
                o.Smoothness = _Glossiness;
                o.Alpha = c.a;
            }
            ENDCG
        }
            FallBack "Diffuse"
}