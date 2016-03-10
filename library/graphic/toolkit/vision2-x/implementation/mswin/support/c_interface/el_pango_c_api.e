note
	description: "Summary description for {EL_PANGO_C_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_PANGO_C_API

inherit
	EL_MEMORY

feature -- Access

	frozen pango_layout_get_indent (function, layout: POINTER): INTEGER
			-- int pango_layout_get_indent (PangoLayout *layout);
		external
			"C inline use <pango/pango.h>"
		alias
			"[
				return (
					FUNCTION_CAST(int, (PangoLayout *))$function
				) (
					(PangoLayout *)$layout
				)
			]"
		end

	frozen pango_layout_get_pixel_size, pango_layout_get_size (function, layout, width_ptr, height_ptr: POINTER)
			-- void pango_layout_get_pixel_size (PangoLayout *layout, int *width, int *height);
		require
			function_attached: is_attached (function)
		external
			"C inline use <pango/pango.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (PangoLayout *, int *, int *))$function
				) (
					(PangoLayout *)$layout, (int *)$width_ptr, (int *)$height_ptr
				)
			]"
		end

	frozen pango_layout_get_text (function, layout: POINTER): POINTER
			-- const char * pango_layout_get_text (PangoLayout *layout);
		external
			"C inline use <pango/pango.h>"
		alias
			"[
				return (
					FUNCTION_CAST(const char *, (PangoLayout *))$function
				) (
					(PangoLayout *)$layout
				)
			]"
		end

	frozen pango_scale: INTEGER
		external
			"C inline use <pango/pango.h>"
		alias
			"[
				return PANGO_SCALE
			]"
		end

feature -- Factory

	frozen pango_font_description_new (function: POINTER): POINTER
			-- PangoFontDescription * pango_font_description_new (void);
		require
			function_attached: is_attached (function)
		external
			"C inline use <pango/pango.h>"
		alias
			"[
				return (
					FUNCTION_CAST(PangoFontDescription *, ())$function
				) ()
			]"
		end

	frozen pango_font_description_from_string (function, str: POINTER): POINTER
			-- PangoFontDescription * pango_font_description_from_string (const char *str);
		require
			function_attached: is_attached (function)
		external
			"C inline use <pango/pango.h>"
		alias
			"[
				return (
					FUNCTION_CAST(PangoFontDescription *, (const char *))$function
				) (
					(const char *)$str
				)
			]"
		end

feature -- Element change

	frozen pango_layout_set_text (function, layout: POINTER; a_text: POINTER; a_length: INTEGER_32)
			-- void pango_layout_set_text (PangoLayout *layout, const char *text, int length);
		require
			function_attached: is_attached (function)
		external
			"C inline use <pango/pango.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (PangoLayout *, const char *, int))$function
				) (
					(PangoLayout *)$layout, (const char *)$a_text, (int)$a_length
				)
			]"
		end

	frozen pango_layout_set_font_description (function, layout, font_description: POINTER)
			-- void pango_layout_set_font_description (PangoLayout *layout, const PangoFontDescription *desc);
		require
			function_attached: is_attached (function)
		external
			"C inline use <pango/pango.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (PangoLayout *, const PangoFontDescription *))$function
				) (
					(PangoLayout *)$layout, (const PangoFontDescription *)$font_description
				)
			]"
		end

	frozen pango_layout_set_width (function, font_description: POINTER; width: INTEGER)
			-- void pango_layout_set_width (PangoLayout *layout, int width);
		external
			"C inline use <pango/pango.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (PangoLayout *, double))$function
				) (
					(PangoLayout *)$font_description, (double)$width
				)
			]"
		end

	frozen pango_font_description_set_absolute_size (function, font_description: POINTER; size: DOUBLE)
			-- void pango_font_description_set_absolute_size (PangoFontDescription *desc, double size);
		external
			"C inline use <pango/pango.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (PangoFontDescription *, double))$function
				) (
					(PangoFontDescription *)$font_description, (double)$size
				)
			]"
		end

	frozen pango_font_description_set_family (function, font_description: POINTER; a_family: POINTER)
			-- void pango_font_description_set_family (PangoFontDescription *desc, const char *family);
		require
			function_attached: is_attached (function)
		external
			"C inline use <pango/pango.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (PangoFontDescription *, const char *))$function
				) (
					(PangoFontDescription *)$font_description, (const char *)$a_family
				)
			]"
		end

	frozen pango_font_description_set_stretch (function, font_description: POINTER; a_value: INTEGER)
			-- void pango_font_description_set_stretch (PangoFontDescription *desc, PangoStretch stretch);
		external
			"C inline use <pango/pango.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (PangoFontDescription *, PangoStretch))$function
				) (
					(PangoFontDescription *)$font_description, (PangoStretch)$a_value
				)
			]"
		end

	frozen pango_font_description_set_style (function, font_description: POINTER; a_style: INTEGER_32)
			-- void pango_font_description_set_style (PangoFontDescription *desc, PangoStyle style);
		require
			function_attached: is_attached (function)
		external
			"C inline use <pango/pango.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (PangoFontDescription *, PangoStyle))$function
				) (
					(PangoFontDescription *)$font_description, (PangoStyle)$a_style
				)
			]"
		end

	frozen pango_font_description_set_weight (function, font_description: POINTER; a_weight: INTEGER_32)
			-- void pango_font_description_set_weight (PangoFontDescription *desc, PangoWeight weight);
		require
			function_attached: is_attached (function)
		external
			"C inline use <pango/pango.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (PangoFontDescription *, PangoWeight))$function
				) (
					(PangoFontDescription *)$font_description, (PangoWeight)$a_weight
				)
			]"
		end

	frozen pango_font_description_set_size (function, font_description: POINTER; a_size: INTEGER_32)
			-- void pango_font_description_set_size (PangoFontDescription *desc, gint size);
		require
			function_attached: is_attached (function)
		external
			"C inline use <pango/pango.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (PangoFontDescription *, gint))$function
				) (
					(PangoFontDescription *)$font_description, (gint)$a_size
				)
			]"
		end

feature -- Memory release

	frozen pango_font_description_free (function, font_description: POINTER)
			-- void pango_font_description_free (PangoFontDescription *desc);
		require
			function_attached: is_attached (function)
		external
			"C inline use <pango/pangocairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (PangoFontDescription *))$function
				) (
					(PangoFontDescription *)$font_description
				)
			]"
		end

end
