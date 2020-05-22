Shader "CustomFilter/RetroScreen"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Pixelate("Pixelate", float) = 100.0
		_Posterize("PosterizeColor", Range(1,256)) = 1
		_Hue("Hue", float) = 0.0
		_Saturation("Saturation", float) = 1.0

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
			float _Pixelate,_Posterize,_Hue,_Saturation;

			float3  posterize(float3 color, float power)
            {
                float div= 256.0 /float((int)power);
                float3 pos = ( floor( color * div ) / div );
                return pos;
            }

			float3 hsv2rgb(float hue, float saturation, float value)
            {
	            return ((clamp(abs(frac(hue+float3(0,2,1)/3.)*6.-3.)-1.,0.,1.)-1.)*saturation+1.)*value;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv;
				float s = _Pixelate;
				uv = floor(uv*s)/s;

				float4 base = tex2D(_MainTex,uv);

				float3 poscol = posterize(base.rgb,_Posterize);
				float gray = Luminance(poscol);

				float3 hsvcol = hsv2rgb(_Hue,_Saturation,gray);


                return float4(hsvcol,base.w);
            }
            ENDCG
        }
    }
}
