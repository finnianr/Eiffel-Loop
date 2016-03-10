/*
   image-utiles.c: Eiffel bridge

   Copyright (C) 2011-2015

   Author: Finnian Reilly <finnian@eiffel-loop.com>
*/

//#include "config.h" not needed?

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <locale.h>

/*
	NOTE
	The original linux header will not compile with MSVC, so we duplicate local excerpts of the headers
	with modifications. Hence the use of "" rather than <> for includes.
*/

//#include "rsvg-css.h"
#include "rsvg.h"
#include "rsvg-cairo.h"
//#include "rsvg-private.h"
#include "rsvg-size-callback.h"

#ifdef CAIRO_HAS_SVG_SURFACE
#include <cairo-svg.h>
#endif

#ifdef CAIRO_HAS_XML_SURFACE
#include <cairo-xml.h>
#endif

#include "image-utils.h"

static void
	display_error (GError * err)
{
    if (err) {
        g_printerr ("%s\n", err->message);
        g_error_free (err);
    }
}

static void
	rsvg_cairo_size_callback (int *width, int *height, gpointer data)
{
	RsvgDimensionData *dimensions = data;
	*width = dimensions->width;
	*height = dimensions->height;
}
/* Cairo write routines */

static cairo_status_t
	rsvg_cairo_write_func (void *closure, const unsigned char *data, unsigned int length)
{
	if (fwrite (data, 1, length, (FILE *) closure) == length)
		return CAIRO_STATUS_SUCCESS;
	return CAIRO_STATUS_WRITE_ERROR;
}

static cairo_status_t
	write_image_data (void *closure, unsigned char *data, unsigned int length)
{
	Eiffel_procedure_t *call_back = (Eiffel_procedure_t *)closure;
	(call_back->p_procedure) (call_back->p_object, data, length);
	return CAIRO_STATUS_SUCCESS;
}

static cairo_status_t
	read_image_data (void *closure, unsigned char *data, unsigned int length)
{
	cairo_status_t result = CAIRO_STATUS_SUCCESS;
	gboolean eof = FALSE;
	Eiffel_procedure_t *call_back = (Eiffel_procedure_t *)closure;
	(call_back->p_procedure) (call_back->p_object, &eof, data, length);
	if (eof) result = CAIRO_STATUS_READ_ERROR;
	return result;
}

static gboolean
	rsvg_handle_fill_with_data (RsvgHandle * handle,
                            const guint8 * data, gsize data_len, GError ** error)
{
	if (!rsvg_handle_write (handle, data, data_len, error))
		return FALSE;
	if (!rsvg_handle_close (handle, error))
		return FALSE;

	return TRUE;
}

static unsigned int Transparent = 0x1000000;

static void
	set_background_color (cairo_t *cr, RsvgDimensionData *dimensions, unsigned int background_color)
{
	double red = ((background_color >> 16) & 0xff) / 255.0;
	double green = ((background_color >> 8) & 0xff) / 255.0;
	double blue = ((background_color >> 0) & 0xff) / 255.0;
	if (background_color != Transparent){
	   cairo_set_source_rgb (cr, red, green, blue);
		cairo_rectangle (cr, 0, 0, dimensions->width, dimensions->height);
		cairo_fill (cr);
	}
}

void
	el_image_format_ARGB_to_ABGR (unsigned int *image_data, int size)
	// Swap red and blue color channels
{
	unsigned int i, blue_red_bits, blue_bits, red_bits, pixel, green_alpha_bits;
	for (i = 0; i < size; i++){
		pixel = image_data [i];
		red_bits = pixel & 0x00FF0000; 
		blue_bits = pixel & 0x000000FF;
		blue_red_bits = (blue_bits << 16) | (red_bits >> 16);
		green_alpha_bits = pixel & 0xFF00FF00;
		image_data [i] = blue_red_bits | green_alpha_bits;
	}
}

gboolean
	el_image_convert_svg_to_png (
		const char *input_path, const char *output_path, int width, int height, unsigned int background_color
	)
	// One dimension (width or height) is set to -1
{
	GError *error = NULL;

	RsvgHandle *rsvg;
	cairo_surface_t *surface = NULL;	cairo_t *cr = NULL;
	RsvgDimensionData dimensions;
	FILE *output_file = NULL;
	gboolean result = FALSE;

	rsvg = rsvg_handle_new_from_file (input_path, &error);

   if (rsvg) {
		el_image_rsvg_set_dimensions (rsvg, &dimensions, width, height);
		surface = cairo_image_surface_create (CAIRO_FORMAT_ARGB32, dimensions.width, dimensions.height);
		cr = cairo_create (surface);
      set_background_color (cr, &dimensions, background_color);
		result = rsvg_handle_render_cairo (rsvg, cr);
		output_file = fopen (output_path, "wb");
		cairo_surface_write_to_png_stream (surface, rsvg_cairo_write_func, output_file);

		cairo_destroy (cr);
		cairo_surface_destroy (surface);
		fclose (output_file);
	}
	return result;
}

gboolean
	el_image_render_svg (
		const SVG_image_t *svg_image, Eiffel_procedure_t *eiffel_write_procedure,
		int width, int height, unsigned int background_color
	)
	// One dimension (width or height) is set to -1
{
	RsvgHandle *rsvg;
	cairo_surface_t *surface = NULL; cairo_t *cr = NULL;
	RsvgDimensionData dimensions;
	gboolean result = FALSE;

	rsvg = el_image_rsvg_new_image (svg_image);

   if (rsvg) {
		el_image_rsvg_set_dimensions (rsvg, &dimensions, width, height);
		surface = cairo_image_surface_create (CAIRO_FORMAT_ARGB32, dimensions.width, dimensions.height);
		cr = cairo_create (surface);

      set_background_color (cr, &dimensions, background_color);
		result = rsvg_handle_render_cairo (rsvg, cr);
		if (result){
			if (el_image_save_cairo_image (surface, eiffel_write_procedure) != CAIRO_STATUS_SUCCESS){
				result = FALSE;
			}
		}

		cairo_destroy (cr); cairo_surface_destroy (surface);
	}
	//rsvg_term ();
	return result;
}

// CAIRO routines

cairo_status_t
	el_image_save_cairo_image (cairo_surface_t *image, Eiffel_procedure_t *eiffel_write_procedure)
{
	return cairo_surface_write_to_png_stream (image, write_image_data, eiffel_write_procedure);
}

cairo_surface_t *
	el_image_read_cairo_image (Eiffel_procedure_t *eiffel_read_procedure)
{
	cairo_surface_t * result = NULL;
	result = cairo_image_surface_create_from_png_stream (read_image_data, eiffel_read_procedure);
	if (cairo_surface_status (result) != CAIRO_STATUS_SUCCESS) result = NULL;
	return result;
}

// RSVG_IMAGE routines

void
	el_image_rsvg_initialize ()
{
	rsvg_init (); rsvg_set_default_dpi_x_y (-1.0, -1.0);
}

void
	el_image_rsvg_terminate ()
{
	rsvg_term ();
}

RsvgHandle *
	el_image_rsvg_new_image (const SVG_image_t *svg_image)
{
	RsvgHandle *result; GError *error = NULL;

	result = rsvg_handle_new ();
	if (result){
		rsvg_handle_set_base_uri (result, svg_image->base_uri);
		if (!rsvg_handle_fill_with_data (result, svg_image->data, svg_image->data_count, &error)) {
			display_error (error);
			g_object_unref (result);
			result = NULL;
		}
	}
	return result;
}

void
	el_image_rsvg_set_dimensions (RsvgHandle *handle, RsvgDimensionData *dimensions, int width, int height)
	// Only on dimension is set as argument. The other is -1.
	// On return the dimension that is -1 is set to correct size for image
{
	struct RsvgSizeCallbackData size_data;
	/* in the case of multi-page output, all subsequent SVGs are scaled to the first's size */
	rsvg_handle_set_size_callback (handle, rsvg_cairo_size_callback, dimensions, NULL);

	rsvg_handle_get_dimensions (handle, dimensions);

	/* if one dimension is unspecified, assume user wants to keep the aspect ratio */
	size_data.type = RSVG_SIZE_WH_MAX;
	size_data.width = width;
	size_data.height = height;
	size_data.keep_aspect_ratio = FALSE; // does not scale exactly if this is set to TRUE

	_rsvg_size_callback (&dimensions->width, &dimensions->height, &size_data);
}

gboolean
	el_image_rsvg_render_to_cairo (RsvgHandle *handle, cairo_t *cairo_ctx)
{
	return rsvg_handle_render_cairo (handle, cairo_ctx);
}


