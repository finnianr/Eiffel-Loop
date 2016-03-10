note
	description: "Summary description for {TEST_IMAGE_MAGICK_CONVERT_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-22 12:27:27 GMT (Saturday 22nd June 2013)"
	revision: "2"

class
	SVG_TO_PNG_CONVERSION_TEST_APP

inherit
	TEST_APPLICATION
		redefine
			Option_name
		end

	EL_MODULE_SVG

create
	make

feature -- Basic operations

	run
			--
		do
			Test.set_binary_file_extensions (<< "png" >>)
			Test.do_file_test ({STRING_32} "svg/yang.svg", agent test_conversion, 1504452279)
		end

feature -- Tests

	test_conversion (svg_path: EL_FILE_PATH)
			--
		local
			svg_background_path: EL_FILE_PATH
		do
			log.enter ("test_conversion")
			Sizes.do_all_with_index (
				agent convert_to_width_and_color (?, ?, svg_path)
			)
			log.exit
		end

	convert_to_width_and_color (width, index: INTEGER; svg_path: EL_FILE_PATH)
		local
			output_path: EL_FILE_PATH
		do
			log.enter ("convert_to_width_and_color")
			log.put_integer_field ("width", width)
			log.put_integer_field (" color code", Colors.item (index))
			output_path := svg_path.without_extension
			output_path.add_extension (Colors.item (index).out)
			output_path.add_extension (width.out)
			output_path.add_extension ("png")
			SVG.write_png_of_width (svg_path, output_path, width, Colors [index])
			log.exit
		end

feature {NONE} -- Constants

	Sizes: ARRAY [INTEGER]
		once
			Result := << 200, 400, 800, 1600 >>
		end

	Colors: ARRAY [INTEGER]
		once
			Result := << 0xFFFFFF, 0, 0xA52A2A, 0x008B8B >>
		end

feature {NONE} -- Constants

	Option_name: STRING = "test_svg_to_png"

	Description: STRING = "Test SVG to PNG conversion"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{SVG_TO_PNG_CONVERSION_TEST_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"]

			>>
		end

end
