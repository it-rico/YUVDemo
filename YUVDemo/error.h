//
//  error.h
//  OpenGLES
//
//  Created by 王振旺 on 2017/4/25.
//  Copyright © 2017年 王振旺. All rights reserved.
//

#ifndef error_h
#define error_h


#define GetError( )\
        {\
            for ( GLenum Error = glGetError( ); ( GL_NO_ERROR != Error ); Error = glGetError( ) )\
            {\
                switch ( Error )\
                {\
                    case GL_INVALID_ENUM:      printf( "\n%s\n\n", "GL_INVALID_ENUM"      ); assert( 0 ); break;\
                    case GL_INVALID_VALUE:     printf( "\n%s\n\n", "GL_INVALID_VALUE"     ); assert( 0 ); break;\
                    case GL_INVALID_OPERATION: printf( "\n%s\n\n", "GL_INVALID_OPERATION" ); assert( 0 ); break;\
                    case GL_OUT_OF_MEMORY:     printf( "\n%s\n\n", "GL_OUT_OF_MEMORY"     ); assert( 0 ); break;\
                    default:                                                                              break;\
                }\
            }\
        }

#endif /* error_h */
