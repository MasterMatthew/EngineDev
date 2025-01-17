@VERTEX
#version 330 core
  
layout (location = 0) in vec3 position;
layout (location = 1) in vec3 normal;
//layout (location = 4) in vec3 tangent;//Switch with 2 for normal mapping
//layout (location = 3) in vec3 bitangent;

out vec3 FragPos;
out vec3 Normal;
//out mat3 TBN;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main()
{
	//mat4 viewModel = view * model;
	vec4 worldPos = model * vec4(position, 1.0f);
    
    //vec3 T = normalize(vec3(viewModel * vec4(tangent, 0.0)));
    //vec3 B = normalize(vec3(viewModel * vec4(bitangent, 0.0)));
    //vec3 N = normalize(vec3(viewModel * vec4(normal, 0.0)));
    
    //TBN = mat3(T,B,N);
    
    FragPos = worldPos.xyz;
    Normal = transpose(inverse(mat3(model))) * normal;
    gl_Position = projection * view * worldPos;
}

@FRAGMENT
#version 330 core
layout (location = 0) out vec3 gPositionDepth;
layout (location = 1) out vec3 gNormal;
layout (location = 2) out vec4 gAlbedoSpec;

in vec3 FragPos;
in vec3 Normal;

uniform vec3 color;

void main()
{
    // store the fragment position vector in the first gbuffer texture
    gPositionDepth = FragPos;
    
    // also store the per-fragment normals into the gbuffer
    
    gNormal = normalize(Normal);
    
    // and the diffuse per-fragment color
    gAlbedoSpec.rgb = color;
    
    // store specular intensity in gAlbedoSpec's alpha component
    gAlbedoSpec.a = 0.5;
} 