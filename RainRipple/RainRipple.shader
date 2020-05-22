Shader "CustomFilter/RainRipple"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_RippleScale("RippleScale", float) = 15.0
		_RainNormal("RainNormal", Range(0.0,1.0)) = 0.15
		_RainSpeed("RainSpeed",float) = 0.15
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

			#define MAX_RADIUS 3

            #define HASHSCALE1 .1031
            #define HASHSCALE3 float3(.1031, .1030, .0973)

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
			float _RainNormal,_RainSpeed,_RippleScale;

			float hash12(float2 p)
            {
                 float3 p3  = frac(float3(p.xyx) * HASHSCALE1);
                 p3 += dot(p3, p3.yzx + 19.19);
                 return frac((p3.x + p3.y) * p3.z);
            }

            float2 hash22(float2 p)
            {
	             float3 p3 = frac(float3(p.xyx) * HASHSCALE3);
                 p3 += dot(p3, p3.yzx+19.19);
                 return frac((p3.xx+p3.yz)*p3.zy);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv;
				uv.x *= _ScreenParams.x/_ScreenParams.y;
				uv = uv*_RippleScale;
				float2 p0 = floor(uv);

				float2 circles = float2(0.0, 0.0);
                for (int j = -MAX_RADIUS; j <= MAX_RADIUS; ++j)
                {
                     for (int k = -MAX_RADIUS; k <= MAX_RADIUS; ++k)
                     {
			              float2 pi = p0 + float2(k, j);
                          float2 hsh = pi;
         
                          float2 p = pi + hash22(hsh);

                          float t = frac(_RainSpeed*_Time.y + hash12(hsh));
                          float2 v = p - uv;
                          float d = length(v) - (float(MAX_RADIUS) + 1.)*t;

                          float h = 0.001;
                          float d1 = d - h;
                          float d2 = d + h;
                          float p1 = sin(31.*d1) * smoothstep(-0.6, -0.3, d1) * smoothstep(0., -0.3, d1);
                          float p2 = sin(31.*d2) * smoothstep(-0.6, -0.3, d2) * smoothstep(0., -0.3, d2);
                          circles += 0.5 * normalize(v) * ((p2 - p1) / (2. * h) * (1. - t) * (1. - t));
                     }
                }
                circles /= float((MAX_RADIUS*2+1)*(MAX_RADIUS*2+1));

	            float intensity = lerp(0.01, _RainNormal/10.0, smoothstep(0.1, 0.3, abs(frac(0.02*_Time.y + 0.5)*2.-1.)));
	            float3 n = float3(circles, sqrt(1. - dot(circles, circles)));
	            float2 rippleuv = intensity*n.xy;

	            float4 col = tex2D(_MainTex, i.uv+rippleuv);

				
                return col;
            }
            ENDCG
        }
    }
}
