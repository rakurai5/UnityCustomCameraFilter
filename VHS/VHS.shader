//The idea and technique is based on the "VHS tape effect" that was originally written by Gaktan. 
//The original shader is available at Shadertoy.

Shader "CustomFilter/VHS"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_range("OffsetRange", float) = 0.10
		_offsetIntensity("OffsetIntensity", float) = 0.01
		_noiseQuality("NoiseQuality", float) = 350.0
		_noiseIntensity("NoiseIntensity", float) = 0.005
		_colorOffsetIntensity("ColorOffsetIntensity", float) = 0.25
		_ScanSpeed("ScanSpeed",float)  = 100.0
		_ScanPower("ScanPower",Range(0.0,1.0)) = 0.0



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
			float _range,_noiseIntensity,_noiseQuality,_offsetIntensity,_colorOffsetIntensity,_ScanSpeed,_ScanPower;

			float rand(float2 co) {
	            return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
            }

			float verticalBar(float pos, float uvY, float offset){
                float edge0 = (pos - _range);
                float edge1 = (pos + _range);

                float x = smoothstep(edge0, pos, uvY) * offset;
                x -= smoothstep(pos, edge1, uvY) * offset;
                return x;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float Scan = saturate( ( ( 1.0 - frac( ( i.uv.y + ( _Time.y * _ScanSpeed ) ) ) ) + ( 1.0 - (0.0 + (_ScanPower - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) ) ) );
				float2 uv = i.uv;
				for (float i = 0.0; i < 0.71; i += 0.1313)
				{
					float d = fmod(_Time.y * i, 1.7);
					float o = sin(1.0 - tan(_Time.y * 0.24 * i));
    				o *= _offsetIntensity/100.0;
					uv.x += verticalBar(d, uv.y, o);
				}

				float uvY = uv.y;
				uvY *= _noiseQuality;
				uvY = float(int(uvY)) * (1.0 / _noiseQuality);
				float noise = rand(float2(_Time.y * 0.00001, uvY));
				uv.x += noise * (_noiseIntensity/100.0);

				float2 offsetR = float2(0.006 * sin(_Time.y), 0.0) * _colorOffsetIntensity;
				float2 offsetG = float2(0.0073 * (cos(_Time.y * 0.97)), 0.0) * _colorOffsetIntensity;

				float r = tex2D(_MainTex, uv + offsetR).r;
				float g = tex2D(_MainTex, uv + offsetG).g;
				float b = tex2D(_MainTex, uv).b;
				float a = tex2D(_MainTex, uv).a;

				float4 col = float4(r, g, b, a) * Scan;

                return col;
            }
            ENDCG
        }
    }
}
