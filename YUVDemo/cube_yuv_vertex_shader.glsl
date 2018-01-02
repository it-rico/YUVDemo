attribute vec4 vPosition;
uniform mat4 vMatrix;
attribute vec2 a_texCoord;
varying vec2 tc;

void main() {
    gl_Position = vMatrix*vPosition;
    tc = a_texCoord;
}