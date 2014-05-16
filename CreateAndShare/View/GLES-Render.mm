// Copyright (c) 2012, HTW Berlin / Project HardMut
// (http://www.hardmut-projekt.de)
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
// * Neither the name of the HTW Berlin / INKA Research Group nor the names
//   of its contributors may be used to endorse or promote products derived
//   from this software without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
/*
* Copyright (c) 2006-2007 Erin Catto http://www.gphysics.com
*
* iPhone port by Simon Oliver - http://www.simonoliver.com - http://www.handcircus.com
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/

//
// File modified for cocos2d integration
// http://www.cocos2d-iphone.org
//

#import "cocos2d.h"
#include "GLES-Render.h"
//#include "OpenGLES/ES1/gl.h"


#include <cstdio>
#include <cstdarg>

#include <cstring>

GLESDebugDraw::GLESDebugDraw()
	: mRatio( 1.0f )
{
}
GLESDebugDraw::GLESDebugDraw( float32 ratio )
	: mRatio( ratio )
{
}

void GLESDebugDraw::DrawPolygon(const b2Vec2* old_vertices, int32 vertexCount, const b2Color& color)
{
    CGPoint* vertices;
    vertices = new CGPoint[vertexCount];
	
	for( int i=0;i<vertexCount;i++) {
		b2Vec2 tmp = old_vertices[i];
		tmp *= mRatio;
		vertices[i].x = tmp.x;
		vertices[i].y = tmp.y;
	}
    
	ccDrawColor4F(color.r, color.g, color.b,1);
    ccDrawPoly(vertices, vertexCount,FALSE);
	
}

void GLESDebugDraw::DrawSolidPolygon(const b2Vec2* old_vertices, int32 vertexCount, const b2Color& color)
{
	CGPoint* vertices;
    vertices = new CGPoint[vertexCount];
	
	for( int i=0;i<vertexCount;i++) {
		b2Vec2 tmp = old_vertices[i];
		tmp = old_vertices[i];
		tmp *= mRatio;
		vertices[i].x = tmp.x;
		vertices[i].y = tmp.y;
	}
	
    ccDrawPoly(vertices, vertexCount, TRUE);
}

void GLESDebugDraw::DrawCircle(const b2Vec2& center, float32 radius, const b2Color& color)
{
		
	const float32 k_segments = 16.0f;
	int vertexCount=16;
	float32 theta = 0.0f;

	glDrawArrays(GL_LINE_LOOP, 0, vertexCount);
    
    CGPoint centre = CGPointMake(center.x, center.y);
    ccDrawCircle(centre, radius, theta, k_segments, FALSE);
}

void GLESDebugDraw::DrawSolidCircle(const b2Vec2& center, float32 radius, const b2Vec2& axis, const b2Color& color)
{
		
	const float32 k_segments = 16.0f;
//	int vertexCount=16;
//	const float32 k_increment = 2.0f * b2_pi / k_segments;
//	float32 theta = 0.0f;
//	
//	GLfloat				glVertices[vertexCount*2];
//	for (int32 i = 0; i < k_segments; ++i)
//	{
//		b2Vec2 v = center + radius * b2Vec2(cosf(theta), sinf(theta));
//		glVertices[i*2]=v.x * mRatio;
//		glVertices[i*2+1]=v.y * mRatio;
//		theta += k_increment;
//	}
    
    ccDrawSolidCircle(CGPointMake(center.x, center.y), radius, k_segments);
//    
//	
//	glColor4f(color.r *0.5f, color.g*0.5f, color.b*0.5f,0.5f);
//	glVertexPointer(2, GL_FLOAT, 0, glVertices);
//	glDrawArrays(GL_TRIANGLE_FAN, 0, vertexCount);
//	glColor4f(color.r, color.g, color.b,1);
//	glDrawArrays(GL_LINE_LOOP, 0, vertexCount);
//	
//	// Draw the axis line
//	DrawSegment(center,center+radius*axis,color);
}

void GLESDebugDraw::DrawSegment(const b2Vec2& p1, const b2Vec2& p2, const b2Color& color)
{
//	glColor4f(color.r, color.g, color.b,1);
//	GLfloat				glVertices[] = {
//		p1.x * mRatio, p1.y * mRatio,
//		p2.x * mRatio, p2.y * mRatio
//	};
//	glVertexPointer(2, GL_FLOAT, 0, glVertices);
//	glDrawArrays(GL_LINES, 0, 2);
    
    ccDrawColor4F(color.r, color.g, color.b, 1);
    ccDrawRect(CGPointMake(p1.x, p1.y), CGPointMake(p2.x, p2.y));
}

void GLESDebugDraw::DrawTransform(const b2Transform& xf)
{
	b2Vec2 p1 = xf.p, p2;
	const float32 k_axisScale = 0.4f;

	p2 = p1;
    p2.x += k_axisScale * xf.q.s;
    p2.y += k_axisScale * xf.q.s;
	DrawSegment(p1,p2,b2Color(1,0,0));
    
    p2 = p1;
    p2.x += k_axisScale * xf.q.c;
    p2.y += k_axisScale * xf.q.c;
	DrawSegment(p1,p2,b2Color(0,1,0));
}

void GLESDebugDraw::DrawPoint(const b2Vec2& p, float32 size, const b2Color& color)
{
//  glColor4f(color.r, color.g, color.b,1);
//	glPointSize(size);
//	GLfloat				glVertices[] = {
//		p.x * mRatio, p.y * mRatio
//	};
//	glVertexPointer(2, GL_FLOAT, 0, glVertices);
//	glDrawArrays(GL_POINTS, 0, 1);
//	glPointSize(1.0f);
//    
	ccDrawColor4F(color.r, color.g, color.b,1);
    ccPointSize(size);
    
    ccDrawPoint(CGPointMake(p.x, p.y));
}

void GLESDebugDraw::DrawString(int x, int y, const char *string, ...)
{
//	NSLog(@"DrawString: unsupported: %s", string);
	//printf(string);
	/* Unsupported as yet. Could replace with bitmap font renderer at a later date */
}

void GLESDebugDraw::DrawAABB(b2AABB* aabb, const b2Color& c)
{
	ccDrawColor4F(c.r, c.g, c.b,1);

	CGPoint				glVertices[] = {
		aabb->lowerBound.x * mRatio, aabb->lowerBound.y * mRatio,
		aabb->upperBound.x * mRatio, aabb->lowerBound.y * mRatio,
		aabb->upperBound.x * mRatio, aabb->upperBound.y * mRatio,
		aabb->lowerBound.x * mRatio, aabb->upperBound.y * mRatio
	};
//	glVertexAttribPointer(kCCVertexAttrib_Position,2, GL_FLOAT,GL_FALSE, 0, glVertices);
//	glDrawArrays(GL_LINE_LOOP, 0, 8);
//    
    ccDrawPoly(glVertices,4,TRUE);
}
