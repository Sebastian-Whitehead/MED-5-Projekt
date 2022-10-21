// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/WindowShader"
{
    Properties{
       color1 ("Color1", Color) = (1,1,1,1)
       _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags{ 
            "RenderType"="Transparent"
            "Queue" = "Transparent"
            "IgnoreProjector"="True"
            }
            ZWrite Off 
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            LOD 100
        
        Pass{
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag 
            #include "UnityCG.cginc"

            struct MeshData{
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct Interpolator{
                float4 vertex : SV_POSITION;
                half2 texcoord : TEXCOORD0; 
            };


            float4 color1;

            Interpolator vert (MeshData v){
                Interpolator o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (Interpolator i) : SV_Target{
                return fixed4(0,0,0,0.7) + color1;
                
            }
            ENDCG
        }
    }
}