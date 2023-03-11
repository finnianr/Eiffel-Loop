note
	description: "[
		Test routine `write_png_of_width' from class [$source EL_SVG_IMAGE_UTILS]. Found in `image-utils.ecf'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 17:29:39 GMT (Friday 10th March 2023)"
	revision: "14"

class
	IMAGE_UTILS_TEST_SET

inherit
	COPIED_SVG_DIRECTORY_DATA_TEST_SET
		redefine
			Color_code_table
		end

	EL_MODULE_SVG

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["svg_to_png_conversion",	agent test_svg_to_png_conversion]
			>>)
		end

feature -- Tests

	test_svg_to_png_conversion
		do
			do_svg_to_png_conversion (agent convert_to_width_and_color)
		end

feature {NONE} -- Implementation

	convert_to_width_and_color (width, a_color: INTEGER; output_path: FILE_PATH)
		do
			SVG.write_png_of_width (svg_path, output_path, width, a_color)
			print_digest (output_path)
		end

feature {NONE} -- Constants

	Check_sums: ARRAY [NATURAL]
		once
			Result := << 2753381884, 2779540968, 1599381434, 3289788556 >>
		end

	Color_code_table: EL_HASH_TABLE [INTEGER, STRING]
		once
			Result := Precursor
			Result [Color.transparent] := SVG.Transparent_color_24_bit
		end

end