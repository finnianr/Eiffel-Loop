note
	description: "Summary description for {EL_MODULE_SVG_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:34:59 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_MODULE_SVG_ROUTINES

inherit
	EL_SVG_GRAPHICS_API

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make
		do
			create dynamic_module.make (module_name)
			pointer_convert_svg_to_png := dynamic_module.api_pointer ("convert_svg_to_png")
		end

feature {NONE} -- Implementation

	module_name: STRING
		local
			l_path: EL_FILE_PATH
		do
			l_path := Execution.dynamic_module_name ("svg2png")
			Result := l_path.without_extension.to_string.string
		end

	pointer_convert_svg_to_png: POINTER
		-- Shared object pointer

	dynamic_module: DYNAMIC_MODULE

feature -- Basic operations

	write_png_of_width (svg_path, png_path: EL_FILE_PATH; width, background_color: INTEGER)
		require
			svg_path_not_empty: not svg_path.is_empty
			png_path_not_empty: not png_path.is_empty
		do
			write_png (svg_path, png_path, width, Undefined_dimension, background_color)
		end

	write_png_of_height (svg_path, png_path: EL_FILE_PATH; height, background_color: INTEGER)
		require
			svg_path_not_empty: not svg_path.is_empty
			png_path_not_empty: not png_path.is_empty
		do
			write_png (svg_path, png_path, Undefined_dimension, height, background_color)
		end

feature -- Status query

	last_write_succeeded: BOOLEAN

feature {NONE} -- Implementation

	write_png (svg_path, png_path: EL_FILE_PATH; width, height, background_color: INTEGER)
		require
			is_width_conversion: width > 0 implies height = Undefined_dimension
			is_height_conversion: height > 0 implies width = Undefined_dimension
		local
			l_svg_path, l_png_path: STRING
		do
			l_svg_path := svg_path.to_string; l_png_path := png_path.to_string
			last_write_succeeded := c_convert_svg_to_png (
				pointer_convert_svg_to_png, l_svg_path.area.base_address, l_png_path.area.base_address,
				width, height, background_color
			)
		ensure
			succeeded: last_write_succeeded
		end

feature -- Constants

	Color_transparent: INTEGER
		once
			Result := 0xFFFFFF + 1
		end

end
