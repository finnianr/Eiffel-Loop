note
	description: "Loads module and call svg conversion function"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-07-06 17:27:56 GMT (Monday 6th July 2015)"
	revision: "5"

deferred class
	EL_IMAGE_UTILS_C_API

inherit
	EL_MEMORY

feature {NONE} -- C Externals

	frozen el_image_format_ARGB_to_ABGR (function, image_data: POINTER; size: INTEGER)
			-- void el_image_format_ARGB_to_ABGR (unsigned int *image_data, int size)
		require
			function_attached: is_attached (function)
			image_data_attached: is_attached (image_data)
		external
			"C inline use <image-utils.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (unsigned int *, int))$function
				) (
					(unsigned int *)$image_data, (int)$size
				)
			]"
		end

	frozen el_image_convert_svg_to_png (
		function, svg_in_path, png_out_path: POINTER; width, height, background_color: INTEGER
	): BOOLEAN
			-- gboolean el_image_convert_svg_to_png (
			--		const char *input_path, const char *output_path, int width, int height, unsigned int background_color
			-- );
		require
			function_attached: is_attached (function)
			svg_in_path_attached: is_attached (svg_in_path)
			png_out_path_attached: is_attached (png_out_path)
			width_conversion: width > 0 implies height = Undefined_dimension
			height_conversion: height > 0 implies width = Undefined_dimension
		external
			"C inline use <image-utils.h>"
		alias
			"[
				return (
					FUNCTION_CAST(gboolean, (const char *, const char *, int, int, unsigned int))$function
				) (
					(const char *)$svg_in_path, (const char *)$png_out_path, (int)$width, (int)$height, (unsigned int)$background_color
				)
			]"
		end

	frozen el_image_render_svg (
		function, svg_image, eiffel_write_procedure: POINTER; width, height, background_color: INTEGER
	): BOOLEAN
			-- gboolean
			--	el_image_render_svg (
			--		const SVG_image_t *svg_image, Eiffel_procedure_t *eiffel_write_procedure,
			--		int width, int height, unsigned int background_color
			--	)
		require
			function_attached: is_attached (function)
			svg_image_attached: is_attached (svg_image)
			eiffel_write_procedure_attached: is_attached (eiffel_write_procedure)
			width_conversion: width > 0 implies height = Undefined_dimension
			height_conversion: height > 0 implies width = Undefined_dimension
		external
			"C inline use <image-utils.h>"
		alias
			"[
				return (
					FUNCTION_CAST(gboolean, (const SVG_image_t *, Eiffel_procedure_t *, int, int, unsigned int))$function
				) (
					(const SVG_image_t *)$svg_image, (Eiffel_procedure_t *)$eiffel_write_procedure,
					(int)$width, (int)$height, (unsigned int)$background_color
				)
			]"
		end

feature {NONE} -- SVG_image_t C externals

	frozen c_sizeof_svg_image_t: INTEGER_32
		external
			"C macro use <image-utils.h>"
		alias
			"sizeof(SVG_image_t)"
		end

	frozen c_set_svg_base_uri (svg_struct, base_uri: POINTER)
		external
			"C [struct <image-utils.h>] (SVG_image_t, gchar *)"
		alias
			"base_uri"
		end

	frozen c_set_svg_data (svg_struct, data: POINTER)
		external
			"C [struct <image-utils.h>] (SVG_image_t, guint8 *)"
		alias
			"data"
		end

	frozen c_set_svg_data_count (svg_struct: POINTER; data_count: NATURAL)
		external
			"C [struct <image-utils.h>] (SVG_image_t, unsigned int)"
		alias
			"data_count"
		end

feature {NONE} -- Cairo Externals

	frozen el_image_save_cairo_image (function, image, file_write_callback: POINTER): INTEGER
			-- cairo_status_t el_image_rsvg_save_image (cairo_surface_t *image, Eiffel_procedure_t *eiffel_write_procedure)
		require
			function_attached: is_attached (function)
			image_attached: is_attached (image)
			file_write_callback_attached: is_attached (file_write_callback)
		external
			"C inline use <image-utils.h>"
		alias
			"[
				return (
					FUNCTION_CAST(cairo_status_t, (cairo_surface_t *, Eiffel_procedure_t *))$function
				) (
					(cairo_surface_t *)$image, (Eiffel_procedure_t *)$file_write_callback
				)
			]"
		end

	frozen el_image_read_cairo_image (function, file_read_callback: POINTER): POINTER
			-- cairo_surface_t *el_image_read_cairo_image (Eiffel_procedure_t *eiffel_read_procedure)
		require
			function_attached: is_attached (function)
			file_read_callback_attached: is_attached (file_read_callback)
		external
			"C inline use <image-utils.h>"
		alias
			"[
				return (
					FUNCTION_CAST(cairo_surface_t *, (Eiffel_procedure_t *))$function
				) (
					(Eiffel_procedure_t *)$file_read_callback
				)
			]"
		end

feature {NONE} -- RSVG C externals

	frozen c_rsvg_initialize (function: POINTER)
			-- void rsvg_initialize ();
		require
			function_attached: is_attached (function)
		external
			"C inline use <image-utils.h>"
		alias
			"[
				return (FUNCTION_CAST(void, ())$function) ()
			]"
		end

	frozen c_rsvg_new_image (function, svg_image: POINTER): POINTER
			-- RsvgHandle *el_image_rsvg_new_image (const SVG_image_t *svg_image)

		require
			function_attached: is_attached (function)
			svg_image_attached: is_attached (svg_image)
		external
			"C inline use <image-utils.h>"
		alias
			"[
				return (
					FUNCTION_CAST(RsvgHandle *, (const SVG_image_t *))$function
				) (
					(const SVG_image_t *)$svg_image
				)
			]"
		end

	frozen c_rsvg_render_to_cairo (function, handle, cairo_ctx: POINTER): BOOLEAN
			-- gboolean rsvg_render_to_cairo (RsvgHandle *handle, cairo_t *cr);
		require
			function_attached: is_attached (function)
			handle_attached: is_attached (handle)
			cairo_image_attached: is_attached (cairo_ctx)
		external
			"C inline use <image-utils.h>"
		alias
			"[
				return (
					FUNCTION_CAST(gboolean, (RsvgHandle *, cairo_t *))$function
				) (
					(RsvgHandle *)$handle, (cairo_t *)$cairo_ctx
				)
			]"
		end

	frozen c_rsvg_set_dimensions (function, handle, dimensions: POINTER; width, height: INTEGER)
			-- void el_image_rsvg_set_dimensions (RsvgHandle *handle, RsvgDimensionData *dimensions, int width, int height)
		require
			function_attached: is_attached (function)
			handle_attached: is_attached (handle)
			dimensions_attached: is_attached (dimensions)
		external
			"C inline use <image-utils.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (RsvgHandle *, RsvgDimensionData *, int, int))$function
				) (
					(RsvgHandle *)$handle, (RsvgDimensionData *)$dimensions, (int)$width, (int)$height
				)
			]"
		end

	frozen c_rsvg_terminate (function: POINTER)
			-- void rsvg_terminate ();
		require
			function_attached: is_attached (function)
		external
			"C inline use <image-utils.h>"
		alias
			"[
				return (FUNCTION_CAST(void, ())$function) ()
			]"
		end
feature {NONE} -- Implementation

	undefined_dimension: INTEGER
		deferred
		end

end
