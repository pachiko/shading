uniform mat4 obj2world;                 // object to world space transform

uniform int num_spot_lights;
#define MAX_NUM_LIGHTS 10


uniform mat3 obj2worldNorm;             // object to world transform for normals
uniform vec3 camera_position;           // world space camera position           
uniform mat4 mvp;                       // ModelViewProjection Matrix

uniform bool useNormalMapping;         // true if normal mapping should be used

uniform mat4 world2ShadowLights[MAX_NUM_LIGHTS]; // world to shadow light transforms

// per vertex input attributes 
in vec3 vtx_position;            // object space position
in vec3 vtx_tangent;
in vec3 vtx_normal;              // object space normal
in vec2 vtx_texcoord;
in vec3 vtx_diffuse_color;


// per vertex outputs 
out vec3 position;                  // world space position
out vec3 vertex_diffuse_color;
out vec2 texcoord;
out vec3 dir2camera;                // world space vector from surface point to camera
out vec3 normal;
out mat3 tan2world;                 // tangent space rotation matrix multiplied by obj2WorldNorm

out vec4 lightSpacePos[MAX_NUM_LIGHTS]; // Light-space positions

void main(void)
{
    position = vec3(obj2world * vec4(vtx_position, 1));

    //
    // TODO CS248 Shadow Mapping:
    //
    // After you have computed in client c++ code the transforms from object space to the 
    // light space, bind the values as a uniform array of mat4 into the vertex
    // shader, and cmpute light-space surface position by multiplying object space position
    // (given by vtx_position) with the computed transforms, placing results in
    // an array of vec4 and pass them to the fragment shader.
    //
    // Recall for shadow mapping we need to know the position of the surface relative
    // to each shadowed light source.
    for (int i = 0; i < num_spot_lights; ++i) {
        lightSpacePos[i] = world2ShadowLights[i]*vec4(position, 1);
    }

    // TODO CS248 Normal Mapping: compute 3x3 tangent space to world space matrix here: tan2world
    //
       
    // Tips:
    //
    // (1) Make sure you normalize all columns of the matrix so that it is a rotation matrix.
    //
    // (2) You can initialize a 3x3 matrix using 3 vectors as shown below:
    // vec3 a, b, c;
    // mat3 mymatrix = mat3(a, b, c)
    // (3) obj2worldNorm is a 3x3 matrix transforming object space normals to world space normals
    // compute tangent space to world space matrix

    normal = normalize(obj2worldNorm * vtx_normal);
	vec3 tangent = normalize(obj2worldNorm * vtx_tangent);
	vec3 binormal = normalize(cross(normal, tangent));

    tan2world = mat3(tangent, binormal, normal);

    vertex_diffuse_color = vtx_diffuse_color;
    texcoord = vtx_texcoord;
    dir2camera = camera_position - position;
    gl_Position = mvp * vec4(vtx_position, 1);
}
