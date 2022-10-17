Shader "Unlit/Lerp" {
    Properties {
        _BaseColor ("BaseColor", Color) = (0, 0, 0, 1)

        [Header(Major gradient)]
        _Value0 ("Transparency", range(0, 1)) = 1.0
        _ColorStartL ("Upper", range(0, 1)) = 1.0
        _ColorEndL ("Lower", range(-1, 1)) = 1.0

        [Header(Minor gradient)]
        _Value1 ("Transparency", range(0, 1)) = 1.0
        _ColorStartS ("Upper", range(0, 1)) = 1.0
        _ColorEndS ("Lower", range(-1, 1)) = 1.0
    }

    SubShader {
        Tags { "RenderType" = "Opaque" }

        Pass {

            Blend SrcAlpha OneMinusSrcAlpha
            ColorMask RGB

            Cull Back
            ZWrite Off
            ZTest Off

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

            float4 _BaseColor;

            float _Value0;
            float _ColorStartS;
            float _ColorEndS;
            
            float _Value1;
            float _ColorStartL;
            float _ColorEndL;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float InverseLerp(float a, float b, float v) {
                return (v-a) / (b-a);
            }

            fixed4 frag (v2f i) : SV_Target {

                fixed4 col = _BaseColor;

                float tL = clamp(
                    InverseLerp( _ColorStartL, _ColorEndL, i.uv.x ),
                    0, _Value0);

                float tS = clamp(
                    InverseLerp( _ColorStartS, _ColorEndS, i.uv.x ),
                    0, _Value1);

                float4 t = tL + tS;

                col.a *= t;

                return col;
            }
            ENDCG
        }
    }
}
