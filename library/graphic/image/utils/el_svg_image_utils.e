note
	description: "Summary description for {EL_SVG_IMAGE_UTILS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 18:49:03 GMT (Wednesday 16th December 2015)"
	revision: "6"

class
	EL_SVG_IMAGE_UTILS

inherit
	EL_SHARED_IMAGE_UTILS_API

feature -- Basic operations

	write_png_of_height (svg_path, png_path: EL_FILE_PATH; height, background_color: INTEGER)
		require
			svg_path_not_empty: not svg_path.is_empty
			png_path_not_empty: not png_path.is_empty
			windows_path_is_ansi: {PLATFORM}.is_windows
											implies across << svg_path, png_path >> as file_path all  is_ansi_encoded (file_path.item) end
		do
			write_png (svg_path, png_path, Undefined_dimension, height, background_color)
		end

	write_png_of_width (svg_path, png_path: EL_FILE_PATH; width, background_color: INTEGER)
		require
			svg_path_not_empty: not svg_path.is_empty
			png_path_not_empty: not png_path.is_empty
			windows_path_is_ansi: {PLATFORM}.is_windows
											implies across << svg_path, png_path >> as file_path all  is_ansi_encoded (file_path.item) end
		do
			write_png (svg_path, png_path, width, Undefined_dimension, background_color)
		end

feature -- Status query

	last_write_succeeded: BOOLEAN

	last_render_succeeded: BOOLEAN

feature -- Contract Support

	is_ansi_encoded (file_path: EL_FILE_PATH): BOOLEAN
			-- The windows implementation of cairo cannot handle UTF-8 paths
		local
			l_path: ZSTRING
		do
			l_path := file_path
			Result := l_path.count = l_path.to_utf_8.count
		end

feature {NONE} -- Implementation

	write_png (svg_path, png_path: EL_FILE_PATH; width, height, background_color: INTEGER)
		require
			is_width_conversion: width > 0 implies height = Undefined_dimension
			is_height_conversion: height > 0 implies width = Undefined_dimension
		local
			l_svg_path, l_png_path: STRING
		do
			l_svg_path := svg_path.to_string; l_png_path := png_path.to_string
			last_write_succeeded := Image_utils.convert_svg_to_png (
				l_svg_path.area.base_address, l_png_path.area.base_address, width, height, background_color
			)
		ensure
			succeeded: last_write_succeeded
		end

feature -- Constants

	Transparent_color_24_bit: INTEGER = 0x1000000

	Undefined_dimension: INTEGER
		once
			Result := Image_utils.Undefined_dimension
		end

end
