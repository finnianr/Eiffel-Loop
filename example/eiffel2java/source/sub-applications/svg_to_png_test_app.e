note
	description: "Summary description for {SVG_TO_PNG_TEST_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 11:51:54 GMT (Monday 24th June 2013)"
	revision: "2"

class
	SVG_TO_PNG_TEST_APP

inherit
	TESTABLE_JAVA_APPLICATION

create
	make

feature {NONE} -- Initiliazation

	normal_initialize
			--
		do
			Java_packages.append_jar_locations (<<
				eiffel_loop_dir.joined_dir_steps (<< "contrib", "Java", "batik-1.7" >>)
			>>)
			Java_packages.append_class_locations (<<
				eiffel_loop_dir.joined_dir_path ("Java_library")
			>> )
			Java_packages.open (<< "batik-rasterizer" >>) --, "xml-commons-external"
		end

feature -- Basic operations

	normal_run
		do
		end

	test_run
			--
		do
			normal_initialize
			Test.set_binary_file_extensions (<< "png" >>)
			Test.do_file_test ("svg/yang.svg", agent test_transcoding, 1664357)
			Java_packages.close
		end

feature -- Test

	test_transcoding (svg_path: EL_FILE_PATH)
			--
		local
			transcoder: J_SVG_TO_PNG_TRANSCODER
		do
			log.enter ("test_transcoding")
			create transcoder.make
			across Sizes as size loop
				transcode_to_width_and_color (size.item, size.cursor_index, svg_path, transcoder)
			end
			log.exit
		end

	transcode_to_width_and_color (width, index: INTEGER; svg_path: EL_FILE_PATH; transcoder: J_SVG_TO_PNG_TRANSCODER)
		local
			output_path: EL_FILE_PATH
		do
			log.enter ("transcode_to_width_and_color")
			log.put_integer_field ("width", width)
			log.put_integer_field (" color code", Colors.item (index))
			output_path := svg_path.without_extension
			output_path.add_extension (Colors.item (index).out)
			output_path.add_extension (width.out)
			output_path.add_extension ("png")
			transcoder.set_width (width)
			transcoder.set_background_color_with_24_bit_rgb (Colors [index])
			transcoder.transcode (svg_path.to_string.to_latin1, output_path.to_string.to_latin1)
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

	Option_name: STRING = "svg_to_png"

	Description: STRING = "Test conversion of SVG image files to PNG format"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{SVG_TO_PNG_TEST_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{JAVA_PACKAGE_ENVIRONMENT}, "*"],
				[{JAVA_PACKAGE_ENVIRONMENT}, "*"]
			>>
		end

end
