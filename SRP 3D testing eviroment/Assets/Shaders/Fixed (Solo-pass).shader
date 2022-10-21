// https://forum.unity.com/threads/alpha-mask-shader-help.181605/
// https://gist.github.com/2600th/2df0691b025ba61feea4
// https://www.youtube.com/watch?v=EthjeNeNTsM&ab_channel=N3KEN
// https://www.youtube.com/watch?v=H12xHzuzjpI

Shader "Universal Render Pipeline/Fixed (Solo-pass)" {
    Properties {
        _BaseColor ("BaseColor", Color) = (0, 0, 0, 1)
        _TransOOS ("OOS transparency", range(0, 1)) = .2

        [Header(Major gradient)]
        _TransL ("Transparency", range(0, 1)) = .4
        _UpperLerpL ("Upper lerp", range(0, 2)) = .15
        _LowerLerpL ("Lower lerp", range(-1, 1)) = .0

        [Header(Minor gradient)]
        _TransS ("Transparency", range(0, 1)) = .9
        _UpperLerpS ("Upper lerp", range(0, 2)) = .05
        _LowerLerpS ("Lower lerp", range(-2, 1)) = .03

    }

    SubShader {

        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        Cull Off
        ColorMask RGB
        ZTest Always // Render in front objects

        Tags {
                "RenderType" = "Transparent"
                "Queue" = "Transparent"
            }

        Pass {

            CGPROGRAM#pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float4 screenuv : TEXCOORD3;
            };

            sampler2D _CameraDepthTexture;
            float4 _BaseColor; // Base color
            float _TransOOS; // Out of seight opacity

            float _TransL; // Opacity for major gradient
            float _UpperLerpL; // Gradient start position
            float _LowerLerpL; // Gradient end position

            float _TransS; // Opacity for minor gradient
            float _UpperLerpS; // Gradient start position
            float _LowerLerpS; // Gradient end position

            v2f vert (appdata v) {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.screenuv = ComputeScreenPos(o.vertex);
                COMPUTE_EYEDEPTH(o.screenuv.z);
                o.normal = v.normal;
                o.uv = v.uv;
                
                // Rotate uv map in -normal.z
                if (-o.normal.z > 0.99) {
                    float rotation = 3.14;
                    float c = cos(rotation);
                    float s = sin(rotation);
                    float2x2 mat = float2x2(c, -s, s, c);
                    o.uv = o.uv * 2 - 1;
                    o.uv = mul(mat, o.uv);
                    o.uv = o.uv * 0.5 + 0.5;
                }
                
                return o;
            }

            // Gradient function
            float InverseLerp(float a, float b, float v) {
                return (v-a) / (b-a);
            }

            fixed4 make_gradients(v2f i) {

                fixed4 col = _BaseColor; // Set base color to color

                // Make major gradient mask
                float tL = saturate(InverseLerp(_UpperLerpL, _LowerLerpL, i.uv.y));
                tL *= _TransL; // Adjust opacity

                // Make minor gradient mask
                float tS = saturate(InverseLerp(_UpperLerpS, _LowerLerpS, i.uv.y));
                tS *= _TransS; // Adjust opacity

                float4 t = tL + tS; // Add major and minor gradient mask

                col.a *= t; // Multiply color with mask
                col.a *= abs(i.normal.y) < 0.99; // Only show vertical faces

                return col; // Return color with mask
            }

            fixed4 frag (v2f i) : SV_Target {
                float sceneZ = LinearEyeDepth(
                    SAMPLE_DEPTH_TEXTURE_PROJ(
                        _CameraDepthTexture,
                    UNITY_PROJ_COORD(i.screenuv)
                    ));
                float partZ = i.screenuv.z;
                float intersect = sceneZ - partZ;

                fixed4 gradients = make_gradients(i);
                fixed4 col1 = gradients;

                col1.a *= saturate(-intersect) * _TransOOS;

                fixed4 col2 = gradients;
                col2.a *= saturate(intersect);

                fixed4 col = col1 + col2;

                return col;
            }
            ENDCG
        }
    }
}
