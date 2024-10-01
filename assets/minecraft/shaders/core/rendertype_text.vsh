#version 150

#moj_import <fog.glsl>

// so I can use it in the switch statement
#define RESCALE_TRIGGER (42 << 8) | 69
#define RESCALE_TRIGGER_SHADOW (10 << 8) | 17

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;
uniform vec2 ScreenSize;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    int guiScale = (round(ScreenSize.x * ProjMat[0][0] / 2));

    // blue is currently unused; may use it later.
    ivec3 iColor = ivec3(Color.rgb * 255.0);
    switch ((iColor.x << 8) | iColor.y) {
        case RESCALE_TRIGGER:
        gl_Position.xy *= 0.25;
        gl_Position.y += -1.0 + 123.5/ScreenSize.y*guiScale;
        vertexColor = vec4(vec3(1.0), Color.a);
        break;

        case RESCALE_TRIGGER_SHADOW:
        gl_Position.xy *= 0.25;
        gl_Position.y += -1.0 + 123.5/ScreenSize.y*guiScale;
        vertexColor = vec4(vec3(0.25), Color.a);
        break;

        default:
        vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
        break;
    }

    vertexDistance = fog_distance(Position, FogShape);
    texCoord0 = UV0;
}
