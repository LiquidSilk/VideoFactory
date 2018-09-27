//
//  WaseeSceneRenderer.m
//  testGVR
//
//  Created by 陈忠杰 on 2018/4/9.
//  Copyright © 2018年 陈忠杰. All rights reserved.
//

#import "WaseeSceneRenderer.h"

#define NUM_CUBE_VERTICES 18
#define NUM_CUBE_COLORS 144

static const char *kVertexShaderString =
"#version 100\n"
"\n"
"uniform mat4 uMVP; \n"
"uniform vec3 uPosition; \n"
"attribute vec3 aVertex; \n"
"attribute vec4 aColor;\n"
"varying vec4 vColor;\n"
"varying vec3 vGrid;  \n"
"void main(void) { \n"
"  vGrid = aVertex + uPosition; \n"
"  vec4 pos = vec4(vGrid, 1.0); \n"
"  vColor = aColor;"
"  gl_Position = uMVP * pos; \n"
"    \n"
"}\n";

// Simple pass-through fragment shader.
static const char *kPassThroughFragmentShaderString =
"#version 100\n"
"\n"
"#ifdef GL_ES\n"
"precision mediump float;\n"
"#endif\n"
"varying vec4 vColor;\n"
"\n"
"void main(void) { \n"
"  gl_FragColor = vColor; \n"
"}\n";

static const float kCubeColors[NUM_CUBE_COLORS] = {
    // front, green
    0.0f, 0.5273f, 0.2656f, 1.0f,
    0.0f, 0.5273f, 0.2656f, 1.0f,
    0.0f, 0.5273f, 0.2656f, 1.0f,
    0.0f, 0.5273f, 0.2656f, 1.0f,
    0.0f, 0.5273f, 0.2656f, 1.0f,
    0.0f, 0.5273f, 0.2656f, 1.0f,
    
    // right, blue
    0.0f, 0.3398f, 0.9023f, 1.0f,
    0.0f, 0.3398f, 0.9023f, 1.0f,
    0.0f, 0.3398f, 0.9023f, 1.0f,
    0.0f, 0.3398f, 0.9023f, 1.0f,
    0.0f, 0.3398f, 0.9023f, 1.0f,
    0.0f, 0.3398f, 0.9023f, 1.0f,
    
    // back, also green
    0.0f, 0.5273f, 0.2656f, 1.0f,
    0.0f, 0.5273f, 0.2656f, 1.0f,
    0.0f, 0.5273f, 0.2656f, 1.0f,
    0.0f, 0.5273f, 0.2656f, 1.0f,
    0.0f, 0.5273f, 0.2656f, 1.0f,
    0.0f, 0.5273f, 0.2656f, 1.0f,
    
    // left, also blue
    0.0f, 0.3398f, 0.9023f, 1.0f,
    0.0f, 0.3398f, 0.9023f, 1.0f,
    0.0f, 0.3398f, 0.9023f, 1.0f,
    0.0f, 0.3398f, 0.9023f, 1.0f,
    0.0f, 0.3398f, 0.9023f, 1.0f,
    0.0f, 0.3398f, 0.9023f, 1.0f,
    
    // top, red
    0.8359375f, 0.17578125f, 0.125f, 1.0f,
    0.8359375f, 0.17578125f, 0.125f, 1.0f,
    0.8359375f, 0.17578125f, 0.125f, 1.0f,
    0.8359375f, 0.17578125f, 0.125f, 1.0f,
    0.8359375f, 0.17578125f, 0.125f, 1.0f,
    0.8359375f, 0.17578125f, 0.125f, 1.0f,
    
    // bottom, also red
    0.8359375f, 0.17578125f, 0.125f, 1.0f,
    0.8359375f, 0.17578125f, 0.125f, 1.0f,
    0.8359375f, 0.17578125f, 0.125f, 1.0f,
    0.8359375f, 0.17578125f, 0.125f, 1.0f,
    0.8359375f, 0.17578125f, 0.125f, 1.0f,
    0.8359375f, 0.17578125f, 0.125f, 1.0f,
};

// Cube color when looking at it: Yellow.
static const float kCubeFoundColors[NUM_CUBE_COLORS] = {
    // front, yellow
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    
    // right, yellow
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    
    // back, yellow
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    
    // left, yellow
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    
    // top, yellow
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    
    // bottom, yellow
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
    1.0f, 0.6523f, 0.0f, 1.0f,
};

//播放暂停
static const float squareCoordsPlayAndPause[NUM_CUBE_VERTICES] = {
    // 第一个三角形
    0.35f, 0.05f, -1.50f,   // 右上角
    0.35f, -0.05f, -1.50f,  // 右下角
    -0.35f, 0.05f, -1.50f,  // 左上角
    // 第二个三角形
    0.35f, -0.05f, -1.50f,  // 右下角
    -0.35f, -0.05f, -1.50f, // 左下角
    -0.35f, 0.05f, -1.50f   // 左上角
};

//进度条
static const float squareCoordsProgress[NUM_CUBE_VERTICES] = {
    // 第一个三角形
    0.05f, 0.05f, -0.50f,   // 右上角
    0.05f, -0.05f, -0.50f,  // 右下角
    -0.05f, 0.05f, -0.50f,  // 左上角
    // 第二个三角形
    0.05f, -0.05f, -0.50f,  // 右下角
    -0.05f, -0.05f, -0.50f, // 左下角
    -0.05f, 0.05f, -0.50f   // 左上角
};

// Cube focus angle threshold in radians.
static const float kFocusThresholdRadians = 0.03f;
static const float kFocusThresholdRadiansProgress = 0.15f;
// Maximum azimuth angle in radians to position the cube.
static const float kMaxCubeAzimuthRadians = 2.0f * M_PI;

// Maximum absolute elevation angle in radians to position the cube.
static const float kMaxCubeElevationRadians = 0.25f * M_PI;


static GLuint LoadShader(GLenum type, const char *shader_src) {
    GLint compiled = 0;
    
    // Create the shader object
    const GLuint shader = glCreateShader(type);
    if (shader == 0) {
        return 0;
    }
    // Load the shader source
    glShaderSource(shader, 1, &shader_src, NULL);
    
    // Compile the shader
    glCompileShader(shader);
    // Check the compile status
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    
    if (!compiled) {
        GLint info_len = 0;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &info_len);
        
        if (info_len > 1) {
            char *info_log = ((char *)malloc(sizeof(char) * info_len));
            glGetShaderInfoLog(shader, info_len, NULL, info_log);
            NSLog(@"Error compiling shader:%s", info_log);
            free(info_log);
        }
        glDeleteShader(shader);
        return 0;
    }
    return shader;
}

@interface WaseeSceneRenderer()
{
    float minProgress;
    float maxProgress;
}
@property(nonatomic, weak)NSTimer *timer;
@property(nonatomic, assign)BOOL isFocus;
@property(nonatomic, assign)NSUInteger timeSec;
@end

@implementation WaseeSceneRenderer
{
    bool _is_cube_focused;
    
    GLuint _cube_program;
    GLfloat _cube_position[3];
    
    GLfloat _cube_vertices[NUM_CUBE_VERTICES];
    GLfloat _cube_colors[NUM_CUBE_COLORS];
    GLfloat _cube_found_colors[NUM_CUBE_COLORS];
    
    GLint _cube_vertex_attrib;
    GLint _cube_position_uniform;
    GLint _cube_mvp_matrix;
    GLuint _cube_vertex_buffer;
    GLint _cube_color_attrib;
    GLuint _cube_color_buffer;
    GLuint _cube_found_color_buffer;
}

- (void)dealloc {

}

- (void)initializeGl {
    [super initializeGl];
    
    const GLuint vertex_shader = LoadShader(GL_VERTEX_SHADER, kVertexShaderString);
    NSAssert(vertex_shader != 0, @"Failed to load vertex shader");
    const GLuint fragment_shader = LoadShader(GL_FRAGMENT_SHADER, kPassThroughFragmentShaderString);
    NSAssert(fragment_shader != 0, @"Failed to load fragment shader");

    
    /////// Create the program object for the cube.
    _cube_program = glCreateProgram();
    glAttachShader(_cube_program, vertex_shader);
    glAttachShader(_cube_program, fragment_shader);
    // Link the shader program.
    glLinkProgram(_cube_program);
    
    // Get the location of our attributes so we can bind data to them later.
    _cube_vertex_attrib = glGetAttribLocation(_cube_program, "aVertex");
//    NSAssert(_cube_vertex_attrib != -1, @"glGetAttribLocation failed for aVertex");
    _cube_color_attrib = glGetAttribLocation(_cube_program, "aColor");
//    NSAssert(_cube_color_attrib != -1, @"glGetAttribLocation failed for aColor");

    // After linking, fetch references to the uniforms in our shader.
    _cube_mvp_matrix = glGetUniformLocation(_cube_program, "uMVP");
    _cube_position_uniform = glGetUniformLocation(_cube_program, "uPosition");
//    NSAssert(_cube_mvp_matrix != -1 && _cube_position_uniform != -1,
//             @"Error fetching uniform values for shader.");
    // Initialize the vertex data for the cube mesh.
    for (int i = 0; i < NUM_CUBE_VERTICES; ++i) {
        _cube_vertices[i] = (GLfloat)(squareCoordsPlayAndPause[i] * 1.0);
    }
    glGenBuffers(1, &_cube_vertex_buffer);
    NSAssert(_cube_vertex_buffer != 0, @"glGenBuffers failed for vertex buffer");
    glBindBuffer(GL_ARRAY_BUFFER, _cube_vertex_buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(_cube_vertices), _cube_vertices, GL_STATIC_DRAW);
    
    //颜色
    for (int i = 0; i < NUM_CUBE_COLORS; ++i) {
        _cube_colors[i] = (GLfloat)(kCubeColors[i] * 1.0);
    }
    glGenBuffers(1, &_cube_color_buffer);
    NSAssert(_cube_color_buffer != 0, @"glGenBuffers failed for color buffer");
    glBindBuffer(GL_ARRAY_BUFFER, _cube_color_buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(_cube_colors), _cube_colors, GL_STATIC_DRAW);
    
    //颜色
    for (int i = 0; i < NUM_CUBE_COLORS; ++i) {
        _cube_found_colors[i] = (GLfloat)(kCubeFoundColors[i] * 1.0);
    }
    glGenBuffers(1, &_cube_found_color_buffer);
    NSAssert(_cube_found_color_buffer != 0, @"glGenBuffers failed for color buffer");
    glBindBuffer(GL_ARRAY_BUFFER, _cube_found_color_buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(_cube_found_colors), _cube_found_colors, GL_STATIC_DRAW);
    
    [self setPlayerUIPosition];
}

- (void)clearGl {
    
    [super clearGl];
}

- (void)update:(GVRHeadPose *)headPose {
    [super update:headPose];
    // Update audio listener's head rotation.
    const GLKQuaternion head_rotation =
    GLKQuaternionMakeWithMatrix4(GLKMatrix4Transpose([headPose headTransform]));
   
    GLKVector3 source_cube_position = GLKVector3Make(_cube_position[0], _cube_position[1], _cube_position[2]);
    _is_cube_focused = [self isLookingAtObject:&head_rotation sourcePosition:&source_cube_position];
    
    if (_delegate)
    {
        if(_is_cube_focused)
        {
            if(_isFocus == NO && _timeSec == 0)
            {
                _isFocus = YES;
                
                NSMethodSignature *method = [WaseeSceneRenderer instanceMethodSignatureForSelector:@selector(invocationTimeRun:des:)];
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:method];
                _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 invocation:invocation repeats:YES];
                // 设置方法调用者
                invocation.target = self;
                // 这里的SEL需要和NSMethodSignature中的一致
                invocation.selector = @selector(invocationTimeRun:des:);
                // 设置参数
                // //这里的Index要从2开始，以为0跟1已经被占据了，分别是self（target）,selector(_cmd)
                // 如果有多个参数, 可依次设置3 4 5 ...
                [invocation setArgument:&_timer atIndex:2];
                // 设置第二个参数
                NSString *dsc = @"参数";
                [invocation setArgument:&dsc atIndex:3];
                [invocation invoke];
                
                NSLog(@"start");
                [_delegate WaseeSceneRendererOnLookAt:YES];
            }
        }
        else
        {
            if (_isFocus == YES)
            {
                _isFocus = NO;
                _timeSec = 0;
                [_timer invalidate];
                [_delegate WaseeSceneRendererOnLookAt:NO];
            }
        }
    }
    
   
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_SCISSOR_TEST);
}

- (void)draw:(GVRHeadPose *)headPose {
    [super draw:headPose];
    
    

    
    CGRect viewport = [headPose viewport];
    glViewport(viewport.origin.x, viewport.origin.y, viewport.size.width, viewport.size.height);
    glScissor(viewport.origin.x, viewport.origin.y, viewport.size.width, viewport.size.height);

    glUseProgram(_cube_program);

    // Set the uniform values that will be used by our shader.
    glUniform3fv(_cube_position_uniform, 1, _cube_position);

    // Get this eye's matrices.
    GLKMatrix4 projection_matrix = [headPose projectionMatrixWithNear:0.1f far:100.0f];
    GLKMatrix4 eye_from_head_matrix = [headPose eyeTransform];

    // Compute the model view projection matrix.
    const GLKMatrix4 head_from_start_matrix = [headPose headTransform];
    GLKMatrix4 model_view_projection_matrix = GLKMatrix4Multiply(
                                                                 projection_matrix, GLKMatrix4Multiply(eye_from_head_matrix, head_from_start_matrix));
    glUniformMatrix4fv(_cube_mvp_matrix, 1, false, model_view_projection_matrix.m);

    // Set the cube colors.
    if (_is_cube_focused) {
        glBindBuffer(GL_ARRAY_BUFFER, _cube_found_color_buffer);
    } else {
        glBindBuffer(GL_ARRAY_BUFFER, _cube_color_buffer);
    }
    glVertexAttribPointer(_cube_color_attrib, 4, GL_FLOAT, GL_FALSE, sizeof(float) * 4, 0);
    glEnableVertexAttribArray(_cube_color_attrib);

    // Draw our polygons.
    glBindBuffer(GL_ARRAY_BUFFER, _cube_vertex_buffer);
    glVertexAttribPointer(_cube_vertex_attrib, 3, GL_FLOAT, GL_FALSE,
                          sizeof(float) * 3, 0);
    glEnableVertexAttribArray(_cube_vertex_attrib);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 6);
    glDisableVertexAttribArray(_cube_vertex_attrib);
    glDisableVertexAttribArray(_cube_color_attrib);
}

- (BOOL)handleTrigger:(GVRHeadPose *)headPose
{
    BOOL trigger = [super handleTrigger:headPose];
    if (_is_cube_focused) {
        int a = 0;
    }
    return trigger;
}

// Sets a new position for the cube.
- (void)setPlayerUIPosition
{
    const float distance = 0.5;
    const float azimuth = 14 * M_PI / 180;
    const float elevation = -2 * M_PI / 180; //仰角
//    _cube_position[0] = -cos(elevation) * sin(azimuth) * distance;
//    _cube_position[1] = sin(elevation) * distance;
//    _cube_position[2] = -cos(elevation) * cos(azimuth) * distance;
    
    _cube_position[0] = 0.1;
    _cube_position[1] = -0.02;
    _cube_position[2] = 0;
}

- (bool)isLookingAtObject:(const GLKQuaternion *)head_rotation
           sourcePosition:(GLKVector3 *)position {
    GLKVector3 source_direction = GLKQuaternionRotateVector3(GLKQuaternionInvert(*head_rotation), *position);
    
    bool isLookAt = ABS(source_direction.v[0]) < kFocusThresholdRadiansProgress &&
                    ABS(source_direction.v[1]) < kFocusThresholdRadians;
    if (isLookAt) {
        if (source_direction.v[0] < minProgress) {
            minProgress = source_direction.v[0];
        }
        if (source_direction.v[0] > maxProgress) {
            maxProgress = source_direction.v[0];
        }
    }
    
    return isLookAt;
}

- (void)invocationTimeRun:(NSTimer *)timer des:(NSString *)dsc {
    
    
    _timeSec = _timeSec + 1;
    
    NSLog(@"%ld---%@--%@", (long)_timeSec, timer, dsc);
    
    if (_timeSec > 3) {
        [timer invalidate];
        [_delegate WaseeSceneRendererOnGaze:_is_cube_focused];
    }
}

@end
