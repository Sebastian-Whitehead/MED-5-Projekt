
// https://forum.unity.com/threads/alpha-mask-shader-help.181605/
// https://gist.github.com/2600th/2df0691b025ba61feea4
// https://www.youtube.com/watch?v=EthjeNeNTsM&ab_channel=N3KEN

Shader "Unlit/Lerp" {
    Properties {
        _BaseColor ("BaseColor", Color) = (0, 0, 0, 1)

        [Header(Major gradient)]
        _TransL ("Opacity", range(0, 1)) = .5
        _ColorStartL ("Upper", range(0, 1)) = .7
        _ColorEndL ("Lower", range(-1, 1)) = .0

        [Header(Minor gradient)]
        _TransS ("Opacity", range(0, 1)) = .9
        _ColorStartS ("Upper", range(0, 1)) = .05
        _ColorEndS ("Lower", range(-1, 1)) = .03

        [Header(Out of seight)]
        _Fade ("Opacity", range(0, 1)) = 1.0
    }

    SubShader {
        Tags {
             "RenderType" = "Transparent"
             "RenderType" = "Opaque"
             }

        Blend SrcAlpha OneMinusSrcAlpha
        ColorMask RGB

        // In seight shader
        Pass {

            Cull Back
            ZWrite Off
            ZTest LEqual // Render in front objects

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float4 _BaseColor; // Base color

            float _TransS; // Opacity for minor gradient
            float _ColorStartS; // Gradient start position
            float _ColorEndS; // Gradient end position
            
            float _TransL; // Opacity for major gradient
            float _ColorStartL; // Gradient start position
            float _ColorEndL; // Gradient end position

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            // Gradient function
            float InverseLerp(float a, float b, float v) {
                return (v-a) / (b-a);
            }

            fixed4 frag (v2f i) : SV_Target {

                fixed4 col = _BaseColor; // Set base color to color

                // Make major gradient mask
                float tL = saturate(InverseLerp( _ColorStartL, _ColorEndL, i.uv.x ));
                tL *= _TransL; // Adjust opacity

                // Make minor gradient mask
                float tS = saturate(InverseLerp( _ColorStartS, _ColorEndS, i.uv.x ));
                tS *= _TransS; // Adjust opacity
                float4 t = tL + tS; // Add major and minor gradient mask

                col.a *= t; // Multiply color with mask

                return col; // Return color with mask
            }
            ENDCG
        }

        // Out of seight shader
        Pass {

            Cull Back
            ZWrite Off
            ZTest Greater // Render in front objects

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float4 _BaseColor; // Base color

            float _TransS; // Opacity for minor gradient
            float _ColorStartS; // Gradient start position
            float _ColorEndS; // Gradient end position
            
            float _TransL; // Opacity for major gradient
            float _ColorStartL; // Gradient start position
            float _ColorEndL; // Gradient end position

            float _Fade; // Out of seight opacity

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            // Gradient function
            float InverseLerp(float a, float b, float v) {
                return (v-a) / (b-a);
            }

            fixed4 frag (v2f i) : SV_Target {

                fixed4 col = _BaseColor; // Set base color to color

                // Make major gradient mask
                float tL = saturate(InverseLerp( _ColorStartL, _ColorEndL, i.uv.x ));
                tL *= _TransL; // Adjust opacity

                // Make minor gradient mask
                float tS = saturate(InverseLerp( _ColorStartS, _ColorEndS, i.uv.x ));
                tS *= _TransS; // Adjust opacity

                float4 t = tL + tS; // Add major and minor gradient mask
                col.a *= t; // Multiply color with mask

                col.a *= _Fade; // Adjust opacity out of seight

                return col; // Return color with mask
            }
            ENDCG
        }
    }
}
