/*
   svg-convert.h: Eiffel bridge

   Copyright (C) 2011

   Author: Finnian Reilly <finnian@eiffel-loop.com>
*/

#ifndef _SVG_TO_PNG_H
#define _SVG_TO_PNG_H

#include <c_to_eiffel.h>
#include <glib-object.h>
#include "rsvg.h"

typedef struct {
	gchar *base_uri;
	guint8 *data;
	unsigned int data_count;
} SVG_image_t;

#if defined(_MSC_VER)
	#define DLLEXPORT(RESULT_TYPE) extern __declspec(dllexport) RESULT_TYPE
#else
	#define DLLEXPORT(RESULT_TYPE) RESULT_TYPE
#endif

DLLEXPORT (void)
	el_image_format_ARGB_to_ABGR (unsigned int *image_data, int size);

DLLEXPORT (gboolean)
	el_image_convert_svg_to_png (const char *input_path, const char *output_path, int width, int height, unsigned int background_color);

DLLEXPORT (gboolean)
	el_image_render_svg (
		const SVG_image_t *svg_image, Eiffel_procedure_t *eiffel_write_procedure,
		int width, int height, unsigned int background_color
	);

// CAIRO routines

DLLEXPORT (cairo_status_t)
	el_image_save_cairo_image (cairo_surface_t *image, Eiffel_procedure_t *eiffel_write_procedure);

DLLEXPORT (cairo_surface_t *)
	el_image_read_cairo_image (Eiffel_procedure_t *eiffel_read_procedure);

// RSVG_IMAGE routines

DLLEXPORT (void)
	el_image_rsvg_initialize ();

DLLEXPORT (void)
	el_image_rsvg_terminate ();

DLLEXPORT (RsvgHandle *)
	el_image_rsvg_new_image (const SVG_image_t *svg_image);

DLLEXPORT (void)
	el_image_rsvg_set_dimensions (RsvgHandle *handle, RsvgDimensionData *dimensions, int width, int height);

DLLEXPORT (gboolean)
	el_image_rsvg_render_to_cairo (RsvgHandle *handle, cairo_t *cairo_ctx);

#endif

