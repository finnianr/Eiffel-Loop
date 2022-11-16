note
	description: "SVG image utils"
	notes: "[
		The Windows C implementation hangs if you try to render a UTF-8 encoded `svg_path' so for this reason
		using `{[$source EL_PNG_IMAGE_FILE]}.render_svg_of_width' is the recommended alternative.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	EL_SVG_IMAGE_UTILS

inherit
	ANY

	EL_SHARED_IMAGE_UTILS_API

feature -- Basic operations

	write_png_of_height (svg_path, png_path: FILE_PATH; height, background_color: INTEGER)
		require
			svg_path_not_empty: not svg_path.is_empty
			png_path_not_empty: not png_path.is_empty
			windows_path_is_ansi: {PLATFORM}.is_windows
											implies across << svg_path, png_path >> as file_path all  is_ansi_encoded (file_path.item) end
		do
			write_png (svg_path, png_path, Undefined_dimension, height, background_color)
		end

	write_png_of_width (svg_path, png_path: FILE_PATH; width, background_color: INTEGER)
		require
			svg_path_not_empty: not svg_path.is_empty
			png_path_not_empty: not png_path.is_empty
			windows_path_is_ansi: {PLATFORM}.is_windows
											implies across << svg_path, png_path >> as file_path all is_ansi_encoded (file_path.item) end
		do
			write_png (svg_path, png_path, width, Undefined_dimension, background_color)
		end

feature -- Status query

	last_write_succeeded: BOOLEAN

	last_render_succeeded: BOOLEAN

feature -- Contract Support

	is_ansi_encoded (file_path: FILE_PATH): BOOLEAN
			-- The windows implementation of cairo cannot handle UTF-8 paths
		do
			Result := file_path.to_string.is_ascii
		end

feature {NONE} -- Implementation

	write_png (svg_path, png_path: FILE_PATH; width, height, background_color: INTEGER)
		require
			is_width_conversion: width > 0 implies height = Undefined_dimension
			is_height_conversion: height > 0 implies width = Undefined_dimension
		local
			l_svg_path, l_png_path: STRING; c_svg_path, c_png_path: ANY
		do
			if {PLATFORM}.is_windows then
				l_svg_path := svg_path.to_string; l_png_path := png_path.to_string
			else
				l_svg_path := svg_path.to_utf_8; l_png_path := png_path.to_utf_8
			end
			c_svg_path := l_svg_path.to_c; c_png_path := l_png_path.to_c
			last_write_succeeded := Image_utils.convert_svg_to_png ($c_svg_path, $c_png_path, width, height, background_color)
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