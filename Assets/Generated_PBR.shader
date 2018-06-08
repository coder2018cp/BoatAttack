Shader "PBR Master"
{
    Properties
    {
        [NoScaleOffset] _MainTex("Albedo_Roughness", 2D) = "white" {}
[NoScaleOffset] Texture2D_DE8BF47E("Normal_AO", 2D) = "white" {}
_Color("MetaColor", Color) = (1,1,1,0)

    }
    SubShader
    {
        Tags{ "RenderPipeline" = "LightweightPipeline"}
        Tags
        {
            "RenderPipeline"="HDRenderPipeline"
            "RenderType"="Opaque"
            "Queue"="Geometry"
        }
        Pass
        {
        	Tags{"LightMode" = "LightweightForward"}

        	// Material options generated by graph

            Blend One Zero

            Cull Back

            ZTest LEqual

            ZWrite On

        	HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0

        	// -------------------------------------
            // Lightweight Pipeline keywords
            #pragma multi_compile _ _ADDITIONAL_LIGHTS
            #pragma multi_compile _ _VERTEX_LIGHTS
            #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
            #pragma multi_compile _ _SHADOWS_ENABLED
            #pragma multi_compile _ _LOCAL_SHADOWS_ENABLED
            #pragma multi_compile _ _SHADOWS_SOFT

        	// -------------------------------------
            // Unity defined keywords
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile_fog

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            #pragma vertex vert
        	#pragma fragment frag

        	// Defines generated by graph
            #define _NORMALMAP 1

        	#include "LWRP/ShaderLibrary/Core.hlsl"
        	#include "LWRP/ShaderLibrary/Lighting.hlsl"
        	#include "CoreRP/ShaderLibrary/Color.hlsl"
        	#include "CoreRP/ShaderLibrary/UnityInstancing.hlsl"
        	#include "ShaderGraphLibrary/Functions.hlsl"

            TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);
            TEXTURE2D(Texture2D_DE8BF47E); SAMPLER(samplerTexture2D_DE8BF47E);
            float4 _Color;

            struct VertexDescriptionInputs
            {
                float3 ObjectSpacePosition;
            };

            struct SurfaceDescriptionInputs
            {
                half4 uv0;
            };


            void Unity_Subtract_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A - B;
            }

            void Unity_Multiply_float (float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }

            struct VertexDescription
            {
                float3 Position;
            };

            VertexDescription PopulateVertexData(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                description.Position = IN.ObjectSpacePosition;
                return description;
            }

            struct SurfaceDescription
            {
                float3 Albedo;
                float3 Normal;
                float3 Emission;
                float Metallic;
                float Smoothness;
                float Occlusion;
                float Alpha;
                float AlphaClipThreshold;
            };

            SurfaceDescription PopulateSurfaceData(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _SampleTexture2D_903562CE_RGBA = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv0.xy);
                float _SampleTexture2D_903562CE_R = _SampleTexture2D_903562CE_RGBA.r;
                float _SampleTexture2D_903562CE_G = _SampleTexture2D_903562CE_RGBA.g;
                float _SampleTexture2D_903562CE_B = _SampleTexture2D_903562CE_RGBA.b;
                float _SampleTexture2D_903562CE_A = _SampleTexture2D_903562CE_RGBA.a;
                float4 _SampleTexture2D_D53F4AE6_RGBA = SAMPLE_TEXTURE2D(Texture2D_DE8BF47E, samplerTexture2D_DE8BF47E, IN.uv0.xy);
                float _SampleTexture2D_D53F4AE6_R = _SampleTexture2D_D53F4AE6_RGBA.r;
                float _SampleTexture2D_D53F4AE6_G = _SampleTexture2D_D53F4AE6_RGBA.g;
                float _SampleTexture2D_D53F4AE6_B = _SampleTexture2D_D53F4AE6_RGBA.b;
                float _SampleTexture2D_D53F4AE6_A = _SampleTexture2D_D53F4AE6_RGBA.a;
                float4 _Subtract_2BA4AC9D_Out;
                Unity_Subtract_float4(_SampleTexture2D_D53F4AE6_RGBA, float4(0.5, 0.5, 0.5, 0.5), _Subtract_2BA4AC9D_Out);
                float4 _Multiply_2407F12D_Out;
                Unity_Multiply_float(_Subtract_2BA4AC9D_Out, float4(2, 2, 2, 0), _Multiply_2407F12D_Out);

                surface.Albedo = (_SampleTexture2D_903562CE_RGBA.xyz);
                surface.Normal = (_Multiply_2407F12D_Out.xyz);
                surface.Emission = IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0));
                surface.Metallic = 0;
                surface.Smoothness = _SampleTexture2D_903562CE_A;
                surface.Occlusion = _SampleTexture2D_D53F4AE6_A;
                surface.Alpha = 1;
                surface.AlphaClipThreshold = 0;
                return surface;
            }

            struct GraphVertexInput
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };


        	struct GraphVertexOutput
            {
                float4 clipPos                : SV_POSITION;
                DECLARE_LIGHTMAP_OR_SH(lightmapUV, vertexSH, 0);
        		half4 fogFactorAndVertexLight : TEXCOORD1; // x: fogFactor, yzw: vertex light
            	float4 shadowCoord            : TEXCOORD2;

        		// Interpolators defined by graph
                float3 WorldSpacePosition : TEXCOORD3;
                float3 WorldSpaceNormal : TEXCOORD4;
                float3 WorldSpaceTangent : TEXCOORD5;
                float3 WorldSpaceBiTangent : TEXCOORD6;
                float3 WorldSpaceViewDirection : TEXCOORD7;
                half4 uv0 : TEXCOORD8;
                half4 uv1 : TEXCOORD9;

                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            GraphVertexOutput vert (GraphVertexInput v)
        	{
                GraphVertexOutput o = (GraphVertexOutput)0;
                
                UNITY_SETUP_INSTANCE_ID(v);
            	UNITY_TRANSFER_INSTANCE_ID(v, o);

        		// Vertex transformations performed by graph
                float3 WorldSpacePosition = mul(UNITY_MATRIX_M,v.vertex);
                float3 WorldSpaceNormal = mul(v.normal,(float3x3)UNITY_MATRIX_I_M);
                float3 WorldSpaceTangent = mul((float3x3)UNITY_MATRIX_M,v.tangent.xyz);
                float3 WorldSpaceBiTangent = normalize(cross(WorldSpaceNormal, WorldSpaceTangent.xyz) * v.tangent.w);
                float3 WorldSpaceViewDirection = SafeNormalize(_WorldSpaceCameraPos.xyz - mul(GetObjectToWorldMatrix(), float4(v.vertex.xyz, 1.0)).xyz);
                float4 uv0 = v.texcoord0;
                float4 uv1 = v.texcoord1;
                float3 ObjectSpacePosition = mul(UNITY_MATRIX_I_M,float4(WorldSpacePosition,1.0));

        		VertexDescriptionInputs vdi = (VertexDescriptionInputs)0;

        		// Vertex description inputs defined by graph
                vdi.ObjectSpacePosition = ObjectSpacePosition;

        	    VertexDescription vd = PopulateVertexData(vdi);
        		v.vertex.xyz = vd.Position;

        		// Vertex shader outputs defined by graph
                o.WorldSpacePosition = WorldSpacePosition;
                o.WorldSpaceNormal = WorldSpaceNormal;
                o.WorldSpaceTangent = WorldSpaceTangent;
                o.WorldSpaceBiTangent = WorldSpaceBiTangent;
                o.WorldSpaceViewDirection = WorldSpaceViewDirection;
                o.uv0 = uv0;
                o.uv1 = uv1;

        		float3 lwWNormal = TransformObjectToWorldNormal(v.normal);
        		float3 lwWorldPos = TransformObjectToWorld(v.vertex.xyz);
        		float4 clipPos = TransformWorldToHClip(lwWorldPos);

         		// We either sample GI from lightmap or SH.
        	    // Lightmap UV and vertex SH coefficients use the same interpolator ("float2 lightmapUV" for lightmap or "half3 vertexSH" for SH)
                // see DECLARE_LIGHTMAP_OR_SH macro.
        	    // The following funcions initialize the correct variable with correct data
        	    OUTPUT_LIGHTMAP_UV(v.texcoord1, unity_LightmapST, o.lightmapUV);
        	    OUTPUT_SH(lwWNormal, o.vertexSH);

        	    half3 vertexLight = VertexLighting(lwWorldPos, lwWNormal);
        	    half fogFactor = ComputeFogFactor(clipPos.z);
        	    o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
        	    o.clipPos = clipPos;

        	#ifdef _SHADOWS_ENABLED
        	#if SHADOWS_SCREEN
        		o.shadowCoord = ComputeShadowCoord(clipPos);
        	#else
        		o.shadowCoord = TransformWorldToShadowCoord(lwWorldPos);
        	#endif
        	#endif
        		return o;
        	}

        	half4 frag (GraphVertexOutput IN ) : SV_Target
            {
            	UNITY_SETUP_INSTANCE_ID(IN);

        		// Pixel transformations performed by graph
                float3 WorldSpacePosition = IN.WorldSpacePosition;
                float3 WorldSpaceNormal = normalize(IN.WorldSpaceNormal);
                float3 WorldSpaceTangent = IN.WorldSpaceTangent;
                float3 WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
                float3 WorldSpaceViewDirection = normalize(IN.WorldSpaceViewDirection);
                float4 uv0 = IN.uv0;
                float4 uv1 = IN.uv1;

                SurfaceDescriptionInputs surfaceInput = (SurfaceDescriptionInputs)0;

        		// Surface description inputs defined by graph
                surfaceInput.uv0 = uv0;

                SurfaceDescription surf = PopulateSurfaceData(surfaceInput);

        		float3 Albedo = float3(0.5, 0.5, 0.5);
        		float3 Specular = float3(0, 0, 0);
        		float Metallic = 1;
        		float3 Normal = float3(0, 0, 1);
        		float3 Emission = 0;
        		float Smoothness = 0.5;
        		float Occlusion = 1;
        		float Alpha = 1;
        		float AlphaClipThreshold = 0;

        		// Surface description remap performed by graph
                Albedo = surf.Albedo;
                Normal = surf.Normal;
                Emission = surf.Emission;
                Metallic = surf.Metallic;
                Smoothness = surf.Smoothness;
                Occlusion = surf.Occlusion;
                Alpha = surf.Alpha;
                AlphaClipThreshold = surf.AlphaClipThreshold;

        		InputData inputData;
        		inputData.positionWS = WorldSpacePosition;

        #ifdef _NORMALMAP
        	    inputData.normalWS = TangentToWorldNormal(Normal, WorldSpaceTangent, WorldSpaceBiTangent, WorldSpaceNormal);
        #else
            #if !SHADER_HINT_NICE_QUALITY
                inputData.normalWS = WorldSpaceNormal;
            #else
        	    inputData.normalWS = normalize(WorldSpaceNormal);
            #endif
        #endif

        #if !SHADER_HINT_NICE_QUALITY
        	    // viewDirection should be normalized here, but we avoid doing it as it's close enough and we save some ALU.
        	    inputData.viewDirectionWS = WorldSpaceViewDirection;
        #else
        	    inputData.viewDirectionWS = normalize(WorldSpaceViewDirection);
        #endif

        	    inputData.shadowCoord = IN.shadowCoord;

        	    inputData.fogCoord = IN.fogFactorAndVertexLight.x;
        	    inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;
        	    inputData.bakedGI = SAMPLE_GI(IN.lightmapUV, IN.vertexSH, inputData.normalWS);

        		half4 color = LightweightFragmentPBR(
        			inputData, 
        			Albedo, 
        			Metallic, 
        			Specular, 
        			Smoothness, 
        			Occlusion, 
        			Emission, 
        			Alpha);

        		// Computes fog factor per-vertex
            	ApplyFog(color.rgb, IN.fogFactorAndVertexLight.x);

        #if _AlphaClip
        		clip(Alpha - AlphaClipThreshold);
        #endif
        		return float4(inputData.normalWS, 1); //color;
            }

        	ENDHLSL
        }
        Pass
        {
        	Name "ShadowCaster"
            Tags{"LightMode" = "ShadowCaster"}

            ZWrite On ZTest LEqual

            // Material options generated by graph
            Cull Back

            HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            #pragma vertex ShadowPassVertex
            #pragma fragment ShadowPassFragment

            // Defines generated by graph

            #include "LWRP/ShaderLibrary/Core.hlsl"
            #include "LWRP/ShaderLibrary/Lighting.hlsl"
            #include "ShaderGraphLibrary/Functions.hlsl"
            #include "CoreRP/ShaderLibrary/Color.hlsl"

            TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);
            TEXTURE2D(Texture2D_DE8BF47E); SAMPLER(samplerTexture2D_DE8BF47E);
            float4 _Color;

            struct VertexDescriptionInputs
            {
                float3 ObjectSpacePosition;
            };


            struct VertexDescription
            {
                float3 Position;
            };

            VertexDescription PopulateVertexData(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                description.Position = IN.ObjectSpacePosition;
                return description;
            }

            struct GraphVertexInput
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float4 texcoord1 : TEXCOORD1;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };


        	struct VertexOutput
        	{
        	    float2 uv           : TEXCOORD0;
        	    float4 clipPos      : SV_POSITION;
        	};

            // x: global clip space bias, y: normal world space bias
            float4 _ShadowBias;
            float3 _LightDirection;

            VertexOutput ShadowPassVertex(GraphVertexInput v)
        	{
        	    VertexOutput o;
        	    UNITY_SETUP_INSTANCE_ID(v);

                // Vertex transformations performed by graph
                float3 WorldSpacePosition = mul(UNITY_MATRIX_M,v.vertex);
                float3 WorldSpaceNormal = mul(v.normal,(float3x3)UNITY_MATRIX_I_M);
                float4 uv1 = v.texcoord1;
                float3 ObjectSpacePosition = mul(UNITY_MATRIX_I_M,float4(WorldSpacePosition,1.0));

        		VertexDescriptionInputs vdi = (VertexDescriptionInputs)0;

                // Vertex description inputs defined by graph
                vdi.ObjectSpacePosition = ObjectSpacePosition;

        	    VertexDescription vd = PopulateVertexData(vdi);
                v.vertex.xyz = vd.Position;

        	    o.uv = uv1;
        	    
        	    float3 positionWS = TransformObjectToWorld(v.vertex.xyz);
                float3 normalWS = TransformObjectToWorldDir(v.normal);

                float invNdotL = 1.0 - saturate(dot(_LightDirection, normalWS));
                float scale = invNdotL * _ShadowBias.y;

                // normal bias is negative since we want to apply an inset normal offset
                positionWS = normalWS * scale.xxx + positionWS;
                float4 clipPos = TransformWorldToHClip(positionWS);

                // _ShadowBias.x sign depens on if platform has reversed z buffer
                clipPos.z += _ShadowBias.x;

        	#if UNITY_REVERSED_Z
        	    clipPos.z = min(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
        	#else
        	    clipPos.z = max(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
        	#endif
                o.clipPos = clipPos;

        	    return o;
        	}

            half4 ShadowPassFragment() : SV_TARGET
            {
                return 0;
            }

            ENDHLSL
        }

        Pass
        {
        	Name "DepthOnly"
            Tags{"LightMode" = "DepthOnly"}

            ZWrite On
            ColorMask 0

            // Material options generated by graph
            Cull Back

            HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            #pragma vertex vert
            #pragma fragment frag

            // Defines generated by graph

            #include "LWRP/ShaderLibrary/Core.hlsl"
            #include "LWRP/ShaderLibrary/Lighting.hlsl"
            #include "ShaderGraphLibrary/Functions.hlsl"
            #include "CoreRP/ShaderLibrary/Color.hlsl"

            TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);
            TEXTURE2D(Texture2D_DE8BF47E); SAMPLER(samplerTexture2D_DE8BF47E);
            float4 _Color;

            struct VertexDescriptionInputs
            {
                float3 ObjectSpacePosition;
            };


            struct VertexDescription
            {
                float3 Position;
            };

            VertexDescription PopulateVertexData(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                description.Position = IN.ObjectSpacePosition;
                return description;
            }

            struct GraphVertexInput
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float4 texcoord1 : TEXCOORD1;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };


        	struct VertexOutput
        	{
        	    float2 uv           : TEXCOORD0;
        	    float4 clipPos      : SV_POSITION;
        	};

            VertexOutput vert(GraphVertexInput v)
            {
                VertexOutput o = (VertexOutput)0;
        	    UNITY_SETUP_INSTANCE_ID(v);

        	    // Vertex transformations performed by graph
                float3 WorldSpacePosition = mul(UNITY_MATRIX_M,v.vertex);
                float3 WorldSpaceNormal = mul(v.normal,(float3x3)UNITY_MATRIX_I_M);
                float4 uv1 = v.texcoord1;
                float3 ObjectSpacePosition = mul(UNITY_MATRIX_I_M,float4(WorldSpacePosition,1.0));

        		VertexDescriptionInputs vdi = (VertexDescriptionInputs)0;

                // Vertex description inputs defined by graph
                vdi.ObjectSpacePosition = ObjectSpacePosition;

        	    VertexDescription vd = PopulateVertexData(vdi);
                v.vertex.xyz = vd.Position;

        	    o.uv = uv1;
        	    o.clipPos = TransformObjectToHClip(v.vertex.xyz);
        	    return o;
            }

            half4 frag() : SV_TARGET
            {
                return 0;
            }
            ENDHLSL
        }

        // This pass it not used during regular rendering, only for lightmap baking.
        Pass
        {
        	Name "Meta"
            Tags{"LightMode" = "Meta"}

            Cull Off

            HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0

            #pragma vertex LightweightVertexMeta
            #pragma fragment LightweightFragmentMeta

            #pragma shader_feature _SPECULAR_SETUP
            #pragma shader_feature _EMISSION
            #pragma shader_feature _METALLICSPECGLOSSMAP
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature EDITOR_VISUALIZATION

            #pragma shader_feature _SPECGLOSSMAP

            #include "LWRP/ShaderLibrary/InputSurfacePBR.hlsl"
            #include "LWRP/ShaderLibrary/LightweightPassMetaPBR.hlsl"
            ENDHLSL
        }
    }
    FallBack "Hidden/InternalErrorShader"
}
