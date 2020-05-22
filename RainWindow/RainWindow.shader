//The idea and technique is based on the "Heartfelt " that was originally written by  BigWIngs. 
//The original shader is available at Shadertoy.

Shader "CustomFilter/RainWindow"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Size ("Size", float) = 1
		_T ("TimeScale", float) = 1
		_Posterize("PosterizeTime", Range( 1 , 256)) = 1
		_Distortion("Distortion", range(-5, 5)) = 1
		_rotate ("RotateUV", float) = 0.0
		[Toggle] _Apply_SoftBlur("SoftBlur Toggle", Float) = 0
		_Blur("Blur" , range(0, 1)) = 1
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

			#define S(a, b, t) smoothstep(a, b, t)

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
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			float _Size, _T, _Distortion, _Blur, _Posterize, _rotate;

			float N21(float2 p){
				p = frac(p*float2(123.34, 345.45));
				p += dot(p, p + 34.345);
				return frac(p.x*p.y);
			}

			float3 Layer(float2 UV, float t){
				float2 aspect = float2(2,1);
				float2 uv = UV*_Size*aspect;
				uv.y += t * .25;
				float2 gv = frac(uv)-.5;
				float2 id = floor(uv);

				float n = N21(id); //0 1
				t += n*6.2831;

				float w = UV.y * 10;
				float x = (n - .5)*.8; //-.4 .4
				x += (.4-abs(x)) * sin(3*w)*pow(sin(w), 6)*.45;

				float y = -sin(t+sin(t+sin(t)*.5))*.45;
				y -= (gv.x-x)*(gv.x-x);

				float2 dropPos = (gv-float2(x, y)) / aspect;
				float drop = S(.04, .03, length(dropPos));

				float2 trailPos = (gv-float2(x, t * .25)) / aspect;
				trailPos.y = (frac(trailPos.y * 8)-.5)/8;
				float trail = S(.02, .005, length(trailPos));
				float fogTrail = S(-.05, .05, dropPos.y);
				fogTrail *= S(.5, y, gv.y);
				trail *= fogTrail;
				fogTrail *= S(.05, .04, abs(dropPos.x));
				

				float2 offs = drop*dropPos + trail*trailPos;

				return float3(offs, fogTrail);
			}

			#pragma shader_feature _APPLY_SOFTBLUR_ON


            fixed4 frag (v2f i) : SV_Target
            {
                float posT = 256.0/float((int)_Posterize);
			    float t = (floor(fmod(_Time.y*_T , 7200) * posT) / posT);

				float2 uv2 = i.uv;
				
                float angle = _rotate;
                float2x2 rotate = float2x2(cos(angle), -sin(angle), sin(angle), cos(angle));
                float scale = 1;
                float2 pivot_uv = float2(0.5, 0.5);
                float2 r = (i.uv.xy - pivot_uv) * (1 / scale);
                uv2 = mul(rotate, r) + pivot_uv;

				uv2.x *= _ScreenParams.x/_ScreenParams.y;


				float4 col = 0;

				float3 drops = Layer(uv2, t);
				drops += Layer(uv2*1.23+7.54, t);
				drops += Layer(uv2*1.35+1.54, t);
				//drops += Layer(i.uv*1.57-7.54, t);
				
				float fade = 1-saturate(fwidth(i.uv)*60);

				float blur = _Blur * 5 * (1-drops.z*fade);


				float2 projuv = i.uv;
				projuv += drops.xy * _Distortion * fade;
				blur *= 0.01;
				
				const float numSamples = 32;
				float a = N21(i.uv)*6.2831;

				for(float i = 0; i < numSamples; i++){
				    float2 offs = float2(sin(a), cos(a))*blur;
					float d = frac(sin((i+1)*546.)*5424.);

					#ifdef _APPLY_SOFTBLUR_ON
                    	d = pow(d, 2);
                    #else
                        d = sqrt(d);
                    #endif

					offs *= d;
                
					col += tex2D(_MainTex, projuv+offs);
					a++;
				}
				col /= numSamples;
                return col;
            }
            ENDCG
        }
    }
}
