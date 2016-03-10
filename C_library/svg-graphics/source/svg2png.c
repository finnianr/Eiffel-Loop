/*

   svg2png.c: Eiffel bridge

   Copyright (C) 2011

   Author: Finnian Reilly <finnian@eiffel-loop.com>
*/

//#include "config.h" not needed?

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <locale.h>

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

#include "svg2png.h"

static void
rsvg_cairo_size_callback (int *width, int *height, gpointer data)
{
	RsvgDimensionData *dimensions = data;
	*width = dimensions->width;
	*height = dimensions->height;
}

static cairo_status_t
rsvg_cairo_write_func (void *closure, const unsigned char *data, unsigned int length)
{
	if (fwrite (data, 1, length, (FILE *) closure) == length)
		return CAIRO_STATUS_SUCCESS;
	return CAIRO_STATUS_WRITE_ERROR;
}

static unsigned int Transparent = 0xFFFFFF + 1;

gboolean convert_svg_to_png (const char *input_path, const char *output_path, int width, int height, unsigned int background_color)
	// Once dimension (width or height) is set to -1
{
	double dpi_x = -1.0;
	double dpi_y = -1.0;
	GError *error = NULL;

	RsvgHandle *rsvg;
	cairo_surface_t *surface = NULL;
	cairo_t *cr = NULL;
	RsvgDimensionData dimensions;
	FILE *output_file = NULL;
	gboolean result = FALSE;

	rsvg_init ();
	rsvg_set_default_dpi_x_y (dpi_x, dpi_y);

	rsvg = rsvg_handle_new_from_file (input_path, &error);

   if (rsvg) {
		struct RsvgSizeCallbackData size_data;
		/* in the case of multi-page output, all subsequent SVGs are scaled to the first's size */
		rsvg_handle_set_size_callback (rsvg, rsvg_cairo_size_callback, &dimensions, NULL);

		rsvg_handle_get_dimensions (rsvg, &dimensions);

		/* if one dimension is unspecified, assume user wants to keep the aspect ratio */
		size_data.type = RSVG_SIZE_WH_MAX;
		size_data.width = width;
		size_data.height = height;
		size_data.keep_aspect_ratio = FALSE; // does not scale exactly if this is set to TRUE

		_rsvg_size_callback (&dimensions.width, &dimensions.height, &size_data);
		surface = cairo_image_surface_create (CAIRO_FORMAT_ARGB32, dimensions.width, dimensions.height);
		cr = cairo_create (surface);

      // Set background color
		if (background_color != Transparent){
		   cairo_set_source_rgb (
				cr,
				((background_color >> 16) & 0xff) / 255.0, 
				((background_color >> 8) & 0xff) / 255.0, 
				((background_color >> 0) & 0xff) / 255.0
			);
			cairo_rectangle (cr, 0, 0, dimensions.width, dimensions.height);
			cairo_fill (cr);
		}

		result = rsvg_handle_render_cairo (rsvg, cr);
		output_file = fopen (output_path, "wb");
		cairo_surface_write_to_png_stream (surface, rsvg_cairo_write_func, output_file);

		cairo_destroy (cr);
		cairo_surface_destroy (surface);
		fclose (output_file);
	}
	rsvg_term ();
	return result;
}

