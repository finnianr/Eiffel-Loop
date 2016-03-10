/*
   svg-convert.h: Eiffel bridge

   Copyright (C) 2011

   Author: Finnian Reilly <finnian@eiffel-loop.com>
*/

#ifndef _SVG_TO_PNG_H
#define _SVG_TO_PNG_H

#include <glib-object.h>

#if defined(_MSC_VER)
extern __declspec(dllexport)
#endif
gboolean convert_svg_to_png (const char *input_path, const char *output_path, int width, int height, unsigned int background_color);

#endif

