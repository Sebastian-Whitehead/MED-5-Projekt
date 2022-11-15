Shader "Universal Render Pipeline/Meta guardian" {
    Properties {
        _Basecolor ("Texture", Color) = (1, 1, 1, 1)
        _LineThick ("Line thickness", range(0, 1)) = .05
        _Interval ("Lines interval", float) = 10
        _Opacity ("Opacity", range(0, 1)) = 0
    }

    SubShader {
        Tags {
            "RenderType"="Opaque"
            "Queue"="Transparent"}

        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off 

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata {
                float2 uv : TEXCOORD0;
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            float4 _Basecolor;
            float _LineThick;
            float _Interval;
            float _Opacity;

            v2f vert (appdata v) {
                v2f o;
                o.uv = v.uv;
                o.normal = v.normal;
                o.vertex = UnityObjectToClipPos(v.vertex);
                
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

            fixed4 frag (v2f i) : SV_Target {

                float yFaces = abs(i.normal.y) < 0.99; // Only show vertical faces
                clip(yFaces - 0.00001);

                float xLines = frac((i.uv.x + _LineThick / 2) * _Interval) < _LineThick;
                float yLines = frac((i.uv.y + _LineThick / 2) * _Interval) < _LineThick;
                clip((xLines + yLines) - 0.00001);

                fixed4 col = _Basecolor;
                col.a *= _Opacity;
                return col;
            }
            ENDCG
        }
    }
}
