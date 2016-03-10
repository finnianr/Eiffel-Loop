note
	description: "Loads module and call svg conversion function"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-02-12 14:10:05 GMT (Tuesday 12th February 2013)"
	revision: "2"

class
	EL_SVG_GRAPHICS_API

inherit
	EL_MEMORY

feature {NONE} -- C Externals

	frozen c_convert_svg_to_png (fn_ptr, svg_in_path, png_out_path: POINTER; width, height, background_color: INTEGER): BOOLEAN
			-- gboolean convert_svg_to_png (
			--		const char *input_path, const char *output_path, int width, int height, unsigned int background_color
			-- );
		require
			fn_ptr_not_null: is_attached (fn_ptr)
			svg_in_path_not_null: is_attached (svg_in_path)
			png_out_path_not_null: is_attached (png_out_path)
			width_conversion: width > 0 implies height = Undefined_dimension
			height_conversion: height > 0 implies width = Undefined_dimension
		external
			"C inline use <svg2png.h>"
		alias
			"[
				return (
					FUNCTION_CAST(gboolean, (const char *, const char *, int, int, unsigned int))$fn_ptr
				) (
					(const char *)$svg_in_path, (const char *)$png_out_path, (int)$width, (int)$height, (unsigned int)$background_color
				)
			]"
		end

feature {NONE} -- Constants

	Undefined_dimension: INTEGER = -1

end
