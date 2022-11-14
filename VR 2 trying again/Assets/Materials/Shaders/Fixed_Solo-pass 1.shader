// https://forum.unity.com/threads/alpha-mask-shader-help.181605/
// https://gist.github.com/2600th/2df0691b025ba61feea4
// https://www.youtube.com/watch?v=EthjeNeNTsM&ab_channel=N3KEN
// https://www.youtube.com/watch?v=H12xHzuzjpI

Shader "Universal Render Pipeline/Fixed (Solo-pass) 1" {
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
        
        _LineThick ("Line thickness", range(0, 1)) = .05
        _Interval ("Lines interval", float) = 10
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

            CGPROGRAM
            #pragma target 3.0
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
            };

            float4 _BaseColor; // Base color
            float _LineThick;
            float _Interval;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = v.normal;
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {

                float yFaces = abs(i.normal.y) < 0.99; // Only show vertical faces
                clip(yFaces - 0.00001);

                float xLines = frac((i.uv.x + _LineThick / 2) * _Interval) < _LineThick;
                float yLines = frac((i.uv.y + _LineThick / 2) * _Interval) < _LineThick;
                clip((xLines + yLines) - 0.00001);

                fixed4 col = _BaseColor;
                return col;
            }
            ENDCG
        }
    }
}
