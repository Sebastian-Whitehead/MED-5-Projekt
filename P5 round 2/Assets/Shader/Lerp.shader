Shader "Unlit/Lerp" {
    Properties {
        _BaseColor ("BaseColor", Color) = (0, 0, 0, 1)
        _ColorA ("ColorA", Color) = (0, 0, 0, 1)
        _ColorB ("ColorB", Color) = (1, 1, 1, 1)
        _ColorStart ("Start", range(0, 1)) = 1.0
        _ColorEnd ("End", range(0, 1)) = 1.0
    }

    SubShader {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass {

            Blend SrcAlpha OneMinusSrcAlpha
            ColorMask RGB

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _BaseColor;
            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;
            float _ColorEnd;

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

                float t = InverseLerp( _ColorStart, _ColorEnd, i.uv.x );
                float4 mask = clamp(lerp( _ColorA, _ColorB, t ), 0, 1);

                col.a *= mask;

                return col;
            }
            ENDCG
        }
    }
}
