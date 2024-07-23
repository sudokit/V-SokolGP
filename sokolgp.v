module sokolgp

import sokol
import sokol.gfx

#include "@VMODROOT/sokol_gp.h"

// defines
const sgp_uniform_content_slots = 4
const sgp_texture_slots = 4
// enums
enum SgpError {
	no_error                    = 0
	sokol_invalid
	vertices_full
	uniforms_full
	commands_full
	vertices_overflow
	transform_stack_overflow
	transform_stack_underflow
	state_stack_overflow
	state_stack_underflow
	alloc_failed
	make_vertex_buffer_failed
	make_white_image_failed
	make_nearest_sampler_failed
	make_common_shader_failed
	make_common_pipeline_failed
}

enum BlendMode {
	@none = 0 /* nO BLENDING.
                               DSTrgba = SRCrgba */
	blend /* aLPHA BLENDING.
                               DSTrgb = (SRCrgb * SRCa) + (DSTrgb * (1-SRCa))
                               DSTa = SRCa + (DSTa * (1-SRCa)) */
	add /* cOLOR ADD.
                               DSTrgb = (SRCrgb * SRCa) + DSTrgb
                               DSTa = DSTa */
	mod /* cOLOR MODULATE.
                               DSTrgb = SRCrgb * DSTrgb
                               DSTa = DSTa */
	mul /* cOLOR MULTIPLY.
                               DSTrgb = (SRCrgb * DSTrgb) + (DSTrgb * (1-SRCa))
                               DSTa = (SRCa * DSTa) + (DSTa * (1-SRCa)) */
	num
}

enum VsAttrLocation {
	coord = 0
	color = 1
}

// structs

// typedef struct sgp_isize {
//     int w, h;
// } sgp_isize;
struct C.sgp_isize {
pub mut:
	w int
	h int
}

type ISize = C.sgp_isize

// typedef struct sgp_irect {
//     int x, y, w, h;
// } sgp_irect;
struct C.sgp_irect {
pub mut:
	x int
	y int
	w int
	h int
}

type IRect = C.sgp_irect

// typedef struct sgp_rect {
//     float x, y, w, h;
// } sgp_rect;
struct C.sgp_rect {
pub mut:
	x f32
	y f32
	w f32
	h f32
}

type Rect = C.sgp_rect

// typedef struct sgp_textured_rect {
//     sgp_rect dst;
//     sgp_rect src;
// } sgp_textured_rect;
struct C.sgp_textured_rect {
	// pub mut:
	dst Rect
	src Rect
}

type TexturedRect = C.sgp_textured_rect

// typedef struct sgp_vec2 {
//     float x, y;
// } sgp_vec2;
struct C.sgp_vec2 {
	// pub mut:
	x f32
	y f32
}

type Vec2 = C.sgp_vec2

// typedef sgp_vec2 sgp_point;
// sgp_vec2 sgp_point; {}
type Point = C.sgp_vec2

// typedef struct sgp_line {
//     sgp_point a, b;
// } sgp_line;
struct C.sgp_line {
	// pub mut:
	a Point
	b Point
}

type Line = C.sgp_line

// typedef struct sgp_triangle {
//     sgp_point a, b, c;
// } sgp_triangle;
struct C.sgp_triangle {
	// pub mut:
	a Point
	b Point
	c Point
}

type Triangle = C.sgp_triangle

// typedef struct sgp_mat2x3 {
//     float v[2][3];
// } sgp_mat2x3;
struct C.sgp_mat2x3 {
	// pub mut:
	v [2][3]f32
}

type Mat2x3 = C.sgp_mat2x3

// typedef struct sgp_color {
//     float r, g, b, a;
// } sgp_color;
struct C.sgp_color {
	// pub mut:
	r f32
	g f32
	b f32
	a f32
}

type Color = C.sgp_color

// typedef struct sgp_color_ub4 {
//     uint8_t r, g, b, a;
// } sgp_color_ub4;
struct C.sgp_color_ub4 {
	// pub mut:
	r u8
	g u8
	b u8
	a u8
}

type ColorUb4 = C.sgp_color_ub4

// typedef struct sgp_vertex {
//     sgp_vec2 position;
//     sgp_vec2 texcoord;
//     sgp_color_ub4 color;
// } sgp_vertex;
struct C.sgp_vertex {
	// pub mut:
	position Vec2
	texcoord Vec2
	color    ColorUb4
}

type Vertex = C.sgp_vertex

// typedef struct sgp_uniform {
//     uint32_t size;
//     float content[SGP_UNIFORM_CONTENT_SLOTS]
// } sgp_uniform;
struct C.sgp_uniform {
	// pub mut:
	size    u32
	content [sgp_uniform_content_slots]f32
}

type Uniform = C.sgp_uniform

// typedef struct sgp_textures_uniform {
//     uint32_t count;
//     sg_image images[SGP_TEXTURE_SLOTS];
//     sg_sampler samplers[SGP_TEXTURE_SLOTS];
// } sgp_textures_uniform;
struct C.sgp_textures_uniform {
	// pub mut:
	count    u32
	images   [sgp_texture_slots]gfx.Image
	samplers [sgp_texture_slots]gfx.Sampler
}

type TexturesUniform = C.sgp_textures_uniform

// /* SGP draw state. */
// typedef struct sgp_state {
//     sgp_isize frame_size;
//     sgp_irect viewport;
//     sgp_irect scissor;
//     sgp_mat2x3 proj;
//     sgp_mat2x3 transform;
//     sgp_mat2x3 mvp;
//     float thickness;
//     sgp_color_ub4 color;
//     sgp_textures_uniform textures;
//     sgp_uniform uniform;
//     sgp_blend_mode blend_mode;
//     sg_pipeline pipeline;
//     uint32_t _base_vertex;
//     uint32_t _base_uniform;
//     uint32_t _base_command;
// } sgp_state;
struct C.sgp_state {
	// pub mut:
	frame_size    ISize
	viewport      IRect
	scissor       IRect
	proj          Mat2x3
	transform     Mat2x3
	mvp           Mat2x3
	thickness     f32
	color         ColorUb4
	textures      TexturesUniform
	uniform       Uniform
	blend_mode    BlendMode
	pipeline      gfx.Pipeline
	_base_vertex  u32
	_base_uniform u32
	_base_command u32
}

type State = C.sgp_state

// /* Structure that defines SGP setup parameters. */
// typedef struct sgp_desc {
//     uint32_t max_vertices;
//     uint32_t max_commands;
//     sg_pixel_format color_format; /* Color format for creating pipelines, defaults to the same as the Sokol GFX context. *
//     sg_pixel_format depth_format; /* Depth format for creating pipelines, defaults to the same as the Sokol GFX context. */
//     int sample_count;             /* Sample count for creating pipelines, defaults to the same as the Sokol GFX context. */
// } sgp_desc;
struct C.sgp_desc {
	// pub mut:
	max_vertices u32
	max_commands u32
	color_format gfx.PixelFormat
	depth_format gfx.PixelFormat
	sample_count int
}

pub type Desc = C.sgp_desc

// /* Structure that defines SGP custom pipeline creation parameters. */
// typedef struct sgp_pipeline_desc {
//     sg_shader shader;                   /* Sokol shader. */
//     sg_primitive_type primitive_type;   /* Draw primitive type (triangles, lines, points, etc). Default is triangles. */
//     sgp_blend_mode blend_mode;          /* Color blend mode. Default is no blend. *
//     sg_pixel_format color_format;       /* Color format, defaults to the value used when creating Sokol GP context. *
//     sg_pixel_format depth_format;       /* Depth format, defaults to the value used when creating Sokol GP context. */
//     int sample_count;                   /* Sample count, defaults to the value used when creating Sokol GP context. */
//     bool has_vs_color;                  /* If true, the current color state will be passed as an attribute to the vertex shader. */
// } sgp_pipeline_desc;
struct C.sgp_pipeline_desc {
	// pub mut:
	shader         gfx.Shader
	primitive_type gfx.PrimitiveType
	blend_mode     BlendMode
	color_format   gfx.PixelFormat
	depth_format   gfx.PixelFormat
	sample_count   int
	has_vs_color   bool
}

pub type Pipeline_Desc = C.sgp_pipeline_desc

// functions

// Initialization and de-initialization. */
// SOKOL_GP_API_DECL void sgp_setup(const sgp_desc* desc);                 /* Initializes the SGP context, and should be called after `sg_setup`. */
fn C.sgp_setup(desc &Desc)
pub fn setup(desc &Desc) {
	C.sgp_setup(desc)
}

// SOKOL_GP_API_DECL void sgp_shutdown(void);                              /* Destroys the SGP context. */
fn C.sgp_shutdown()
pub fn shutdown() {
	C.sgp_shutdown()
}

// SOKOL_GP_API_DECL bool sgp_is_valid(void);                              /* Checks if SGP context is valid, should be checked after `sgp_setup`. */
fn C.sgp_is_valid() bool
pub fn is_valid() bool {
	return C.sgp_is_valid()
}

// /* Error handling. */
// SOKOL_GP_API_DECL sgp_error sgp_get_last_error(void);                   /* Returns last SGP error. */
fn C.sgp_get_last_error() SgpError
pub fn get_last_error() SgpError {
	return C.sgp_get_last_error()
}

// SOKOL_GP_API_DECL const char* sgp_get_error_message(sgp_error error);   /* Returns a message with SGP error description. */
fn C.sgp_get_error_message(error SgpError) &char
pub fn get_error_message(error SgpError) &char {
	return C.sgp_get_error_message(error)
}

// /* Custom pipeline creation. */
// SOKOL_GP_API_DECL sg_pipeline sgp_make_pipeline(const sgp_pipeline_desc* desc); /* Creates a custom shader pipeline to be used with SGP. */
fn C.sgp_make_pipeline(desc &Desc) gfx.Pipeline
pub fn make_pipeline(desc &Desc) gfx.Pipeline {
	return C.sgp_make_pipeline(desc)
}

// /* Draw command queue management. */
// SOKOL_GP_API_DECL void sgp_begin(int width, int height);    /* Begins a new SGP draw command queue. */
fn C.sgp_begin(width int, height int)
@[inline]
pub fn begin(width int, height int) {
	C.sgp_begin(width, height)
}

// SOKOL_GP_API_DECL void sgp_flush(void);                     /* Dispatch current Sokol GFX draw commands. */
fn C.sgp_flush()
@[inline]
pub fn flush() {
	C.sgp_flush()
}

// SOKOL_GP_API_DECL void sgp_end(void);                       /* End current draw command queue, discarding it. */
fn C.sgp_end()
@[inline]
pub fn end() {
	C.sgp_end()
}

// /* 2D coordinate space projection */
// SOKOL_GP_API_DECL void sgp_project(float left, float right, float top, float bottom); /* Set the coordinate space boundary in the current viewport. */
fn C.sgp_project(left f32, right f32, top f32, bottom f32)
pub fn project(left f32, right f32, top f32, bottom f32) {
	C.sgp_project(left, right, top, bottom)
}

// SOKOL_GP_API_DECL void sgp_reset_project(void);                                       /* Resets the coordinate space to default (coordinate of the viewport). */
fn C.sgp_reset_project()
pub fn reset_project() {
	C.sgp_reset_project()
}

// /* 2D coordinate space transformation. */
// SOKOL_GP_API_DECL void sgp_push_transform(void);                            /* Saves current transform matrix, to be restored later with a pop. */
fn C.sgp_push_transform()
pub fn push_transform() {
	C.sgp_push_transform()
}

// SOKOL_GP_API_DECL void sgp_pop_transform(void);                             /* Restore transform matrix to the same value of the last push. */
fn C.sgp_pop_transform()
pub fn pop_transform() {
	C.sgp_pop_transform()
}

// SOKOL_GP_API_DECL void sgp_reset_transform(void);                           /* Resets the transform matrix to identity (no transform). */
fn C.sgp_reset_transform()
pub fn reset_transform() {
	C.sgp_reset_transform()
}

// SOKOL_GP_API_DECL void sgp_translate(float x, float y);                     /* Translates the 2D coordinate space. */
fn C.sgp_translate(x f32, y f32)
pub fn translate(x f32, y f32) {
	C.sgp_translate(x, y)
}

// SOKOL_GP_API_DECL void sgp_rotate(float theta);                             /* Rotates the 2D coordinate space around the origin. */
fn C.sgp_rotate(theta f32)
pub fn rotate(theta f32) {
	C.sgp_rotate(theta)
}

// SOKOL_GP_API_DECL void sgp_rotate_at(float theta, float x, float y);        /* Rotates the 2D coordinate space around a point. */
fn C.sgp_rotate_at(theta f32, x f32, y f32)
pub fn rotate_at(theta f32, x f32, y f32) {
	C.sgp_rotate_at(theta, x, y)
}

// SOKOL_GP_API_DECL void sgp_scale(float sx, float sy);                       /* Scales the 2D coordinate space around the origin. */
fn C.sgp_scale(sx f32, sy f32)
pub fn scale(sx f32, sy f32) {
	C.sgp_scale(sx, sy)
}

// SOKOL_GP_API_DECL void sgp_scale_at(float sx, float sy, float x, float y);  /* Scales the 2D coordinate space around a point. */
fn C.sgp_scale_at(sx f32, sy f32, x f32, y f32)
pub fn scale_at(sx f32, sy f32, x f32, y f32) {
	C.sgp_scale_at(sx, sy, x, y)
}

// /* State change for custom pipelines. */
// SOKOL_GP_API_DECL void sgp_set_pipeline(sg_pipeline pipeline);              /* Sets current draw pipeline. */
fn C.sgp_set_pipeline(pipeline gfx.Pipeline)
pub fn set_pipeline(pipeline gfx.Pipeline) {
	C.sgp_set_pipeline(pipeline)
}

// SOKOL_GP_API_DECL void sgp_reset_pipeline(void);                            /* Resets to the current draw pipeline to default (builtin pipelines). */
fn C.sgp_reset_pipeline()
pub fn reset_pipeline() {
	C.sgp_reset_pipeline()
}

// SOKOL_GP_API_DECL void sgp_set_uniform(const void* data, uint32_t size);    /* Sets uniform buffer for a custom pipeline. */
fn C.sgp_set_uniform(data voidptr, size u32)
pub fn set_uniform(data voidptr, size u32) {
	C.sgp_set_uniform(data, size)
}

// SOKOL_GP_API_DECL void sgp_reset_uniform(void);                             /* Resets uniform buffer to default (current state color). */
fn C.sgp_reset_uniform()
pub fn reset_uniform() {
	C.sgp_reset_uniform()
}

// /* State change functions for the common pipelines. */
// SOKOL_GP_API_DECL void sgp_set_blend_mode(sgp_blend_mode blend_mode);       /* Sets current blend mode. */
fn C.sgp_set_blend_mode(blend_mode BlendMode)
pub fn set_blend_mode(blend_mode BlendMode) {
	C.sgp_set_blend_mode(blend_mode)
}

// SOKOL_GP_API_DECL void sgp_reset_blend_mode(void);                          /* Resets current blend mode to default (no blending). */
fn C.sgp_reset_blend_mode()
pub fn reset_blend_mode() {
	C.sgp_reset_blend_mode()
}

// SOKOL_GP_API_DECL void sgp_set_color(float r, float g, float b, float a);   /* Sets current color modulation. */
fn C.sgp_set_color(r f32, g f32, b f32, a f32)
pub fn set_color(r f32, g f32, b f32, a f32) {
	C.sgp_set_color(r, g, b, a)
}

// SOKOL_GP_API_DECL void sgp_reset_color(void);                               /* Resets current color modulation to default (white). */
fn C.sgp_reset_color()
pub fn reset_color() {
	C.sgp_reset_color()
}

// SOKOL_GP_API_DECL void sgp_set_image(int channel, sg_image image);          /* Sets current bound image in a texture channel. */
fn C.sgp_set_image(channel int, image gfx.Image)
pub fn set_image(channel int, image gfx.Image) {
	C.sgp_set_image(channel, image)
}

// SOKOL_GP_API_DECL void sgp_unset_image(int channel);                        /* Remove current bound image in a texture channel (no texture). */
fn C.sgp_unset_image(channel int)
pub fn unset_image(channel int) {
	C.sgp_unset_image(channel)
}

// SOKOL_GP_API_DECL void sgp_reset_image(int channel);                        /* Resets current bound image in a texture channel to default (white texture). */
fn C.sgp_reset_image(channel int)
pub fn reset_image(channel int) {
	C.sgp_reset_image(channel)
}

// SOKOL_GP_API_DECL void sgp_set_sampler(int channel, sg_sampler sampler);    /* Sets current bound sampler in a texture channel. */
fn C.sgp_set_sampler(channel int, sampler gfx.Sampler)
pub fn set_sampler(channel int, sampler gfx.Sampler) {
	C.sgp_set_sampler(channel, sampler)
}

// SOKOL_GP_API_DECL void sgp_reset_sampler(int channel);                      /* Resets current bound sampler in a texture channel to default (nearest sampler). */
fn C.sgp_reset_sampler(channel int)
pub fn reset_sampler(channel int) {
	C.sgp_reset_sampler(channel)
}

// /* State change functions for all pipelines. */
// SOKOL_GP_API_DECL void sgp_viewport(int x, int y, int w, int h);            /* Sets the screen area to draw into. */
fn C.sgp_viewport(x int, y int, w int, h int)
pub fn viewport(x int, y int, w int, h int) {
	C.sgp_viewport(x, y, w, h)
}

// SOKOL_GP_API_DECL void sgp_reset_viewport(void);                            /* Reset viewport to default values (0, 0, width, height). */
fn C.sgp_reset_viewport()
pub fn reset_viewport() {
	C.sgp_reset_viewport()
}

// SOKOL_GP_API_DECL void sgp_scissor(int x, int y, int w, int h);             /* Set clip rectangle in the viewport. */
fn C.sgp_scissor(x int, y int, w int, h int)
pub fn scissor(x int, y int, w int, h int) {
	C.sgp_scissor(x, y, w, h)
}

// SOKOL_GP_API_DECL void sgp_reset_scissor(void);                             /* Resets clip rectangle to default (viewport bounds). */
fn C.sgp_reset_scissor()
pub fn reset_scissor() {
	C.sgp_reset_scissor()
}

// SOKOL_GP_API_DECL void sgp_reset_state(void);                               /* Reset all state to default values. */
fn C.sgp_reset_state()
pub fn reset_state() {
	C.sgp_reset_state()
}

// /* Drawing functions. */
// SOKOL_GP_API_DECL void sgp_clear(void);                                                                         /* Clears the current viewport using the current state color. */
fn C.sgp_clear()
@[inline]
pub fn clear() {
	C.sgp_clear()
}

// SOKOL_GP_API_DECL void sgp_draw(sg_primitive_type primitive_type, const sgp_vertex* vertices, uint32_t count);  /* Low level drawing function, capable of drawing any primitive. */
fn C.sgp_draw(primitive_type gfx.PrimitiveType, vertices &Vertex, count u32)
@[inline]
pub fn draw(primitive_type gfx.PrimitiveType, vertices &Vertex, count u32) {
	C.sgp_draw(primitive_type, vertices, count)
}

// SOKOL_GP_API_DECL void sgp_draw_points(const sgp_point* points, uint32_t count);                                /* Draws points in a batch. */
fn C.sgp_draw_points(points &Point, count u32)
@[inline]
pub fn draw_points(points &Point, count u32) {
	C.sgp_draw_points(points, count)
}

// SOKOL_GP_API_DECL void sgp_draw_point(float x, float y);                                                        /* Draws a single point. */
fn C.sgp_draw_point(x f32, y f32)
@[inline]
pub fn draw_point(x f32, y f32) {
	C.sgp_draw_point(x, y)
}

// SOKOL_GP_API_DECL void sgp_draw_lines(const sgp_line* lines, uint32_t count);                                   /* Draws lines in a batch. */
fn C.sgp_draw_lines(lines &Line, count u32)
@[inline]
pub fn draw_lines(lines &Line, count u32) {
	C.sgp_draw_lines(lines, count)
}

// SOKOL_GP_API_DECL void sgp_draw_line(float ax, float ay, float bx, float by);                                   /* Draws a single line. */
fn C.sgp_draw_line(ax f32, ay f32, bx f32, by f32)
@[inline]
pub fn draw_line(ax f32, ay f32, bx f32, by f32) {
	C.sgp_draw_line(ax, ay, bx, by)
}

// SOKOL_GP_API_DECL void sgp_draw_lines_strip(const sgp_point* points, uint32_t count);                           /* Draws a strip of lines. */
fn C.sgp_draw_lines_strip(points &Point, count u32)
@[inline]
pub fn draw_lines_strip(points &Point, count u32) {
	C.sgp_draw_lines_strip(points, count)
}

// SOKOL_GP_API_DECL void sgp_draw_filled_triangles(const sgp_triangle* triangles, uint32_t count);                /* Draws triangles in a batch. */
fn C.sgp_draw_filled_triangles(triangles &Triangle, count u32)
@[inline]
pub fn draw_filled_triangles(triangles &Triangle, count u32) {
	C.sgp_draw_filled_triangles(triangles, count)
}

// SOKOL_GP_API_DECL void sgp_draw_filled_triangle(float ax, float ay, float bx, float by, float cx, float cy);    /* Draws a single triangle. */
fn C.sgp_draw_filled_triangle(ax f32, ay f32, bx f32, by f32, cx f32, cy f32)
@[inline]
pub fn draw_filled_triangle(ax f32, ay f32, bx f32, by f32, cx f32, cy f32) {
	C.sgp_draw_filled_triangle(ax, ay, bx, by, cx, cy)
}

// SOKOL_GP_API_DECL void sgp_draw_filled_triangles_strip(const sgp_point* points, uint32_t count);                /* Draws strip of triangles. */
fn C.sgp_draw_filled_triangles_strip(points &Point, count u32)
@[inline]
pub fn draw_filled_triangles_strip(points &Point, count u32) {
	C.sgp_draw_filled_triangles_strip(points, count)
}

// SOKOL_GP_API_DECL void sgp_draw_filled_rects(const sgp_rect* rects, uint32_t count);                            /* Draws a batch of rectangles. */
fn C.sgp_draw_filled_rects(rects &Rect, count u32)
@[inline]
pub fn draw_filled_rects(rects &Rect, count u32) {
	C.sgp_draw_filled_rects(rects, count)
}

// SOKOL_GP_API_DECL void sgp_draw_filled_rect(float x, float y, float w, float h);                                /* Draws a single rectangle. */
fn C.sgp_draw_filled_rect(x f32, y f32, w f32, h f32)
@[inline]
pub fn draw_filled_rect(x f32, y f32, w f32, h f32) {
	C.sgp_draw_filled_rect(x, y, w, h)
}

// SOKOL_GP_API_DECL void sgp_draw_textured_rects(int channel, const sgp_textured_rect* rects, uint32_t count);    /* Draws a batch textured rectangle, each from a source region. */
fn C.sgp_draw_textured_rects(channel int, rects &TexturedRect, count u32)
@[inline]
pub fn draw_textured_rects(channel int, rects &TexturedRect, count u32) {
	C.sgp_draw_textured_rects(channel, rects, count)
}

// SOKOL_GP_API_DECL void sgp_draw_textured_rect(int channel, sgp_rect dest_rect, sgp_rect src_rect);              /* Draws a single textured rectangle from a source region. */
fn C.sgp_draw_textured_rect(channel int, dest_rect Rect, src_rect Rect)
@[inline]
pub fn draw_textured_rect(channel int, dest_rect Rect, src_rect Rect) {
	C.sgp_draw_textured_rect(channel, dest_rect, src_rect)
}

// /* Querying functions. */
// SOKOL_GP_API_DECL sgp_state* sgp_query_state(void); /* Returns the current draw state. */
fn C.sgp_query_state() &State
pub fn query_state() &State {
	return C.sgp_query_state()
}

// SOKOL_GP_API_DECL sgp_desc sgp_query_desc(void);    /* Returns description of the current SGP context.
fn C.sgp_query_desc() Desc
pub fn query_desc() Desc {
	return C.sgp_query_desc()
}
