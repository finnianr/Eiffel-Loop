note
	description: "Test set for class ${J_SVG_TO_PNG_TRANSCODER}. See ''java_code'' note for Java source."
	notes: "[
		[https://issues.apache.org/jira/browse/BATIK-1304 Reported Issue]

		The test `workarea' directory could not be deleted after executing the test. This was traced to a file
		opened by Batik to render an PNG image linked to within the SVG test file. Batik does not close the
		PNG file after it has finished rendering it as part of the SVG image.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "6"

class
	SVG_TO_PNG_TEST_SET

obsolete "Bug in Batik, see notes"

inherit
	COPIED_SVG_DIRECTORY_DATA_TEST_SET

	EL_MODULE_JAVA

	SHARED_JNI_ENVIRONMENT undefine default_create end

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["svg_format_conversion", agent test_svg_format_conversion]
			>>)
		end

feature -- Tests

	test_svg_format_conversion
		do
			Java.append_jar_locations (<< Dev_environ.Eiffel_loop_dir #+ "contrib/Java/batik-1.6.1" >>)
			Java.append_class_locations (<< "test-data/java_classes" >>)
			Java.open (<< "batik-rasterizer" >>)

			do_svg_format_conversion

			Java.close
			assert ("all Java objects released", jorb.object_count = 0)
		end

feature {NONE} -- Implementation

	do_svg_format_conversion
		local
			linked_file: J_FILE; linked_path: J_STRING
		do
			if attached (Directory.current_working + (work_area_data_dir + Edit_icon_png)) as edit_icon_abs_path then
				-- Failed workaround attempt for bug in Batik where linked png file is not closed after rendering
				-- preventing it's deletion
				linked_path := edit_icon_abs_path.to_string
				create linked_file.make_from_path (linked_path)
				linked_file.delete_on_exit
			end

			do_svg_to_png_conversion (agent transcode_to_width_and_color)
		end

	transcode_to_width_and_color (width, a_color: INTEGER; output_path: EL_FILE_PATH)
		local
			transcoder: J_SVG_TO_PNG_TRANSCODER
		do
			create transcoder.make
			transcoder.set_width (width)
			transcoder.set_background_color_with_24_bit_rgb (a_color)
			transcoder.transcode (svg_path.to_string, output_path.to_string)
			print_digest (output_path)
		end

feature {NONE} -- Constants

	Check_sums: ARRAY [NATURAL]
		once
			Result := << 3150682063, 3891377219, 2878863059 >>
		end

note
	java_code: "[
		Code for Java class SVG_TO_PNG_TRANSCODER

			public class SVG_TO_PNG_TRANSCODER extends PNGTranscoder {

				public void set_width (int width){
					addTranscodingHint (PNGTranscoder.KEY_WIDTH, new Float (width));
				}
				public void set_height (int height){
					addTranscodingHint (PNGTranscoder.KEY_HEIGHT, new Float (height));
				}
				public void set_background_color (Color color){
					addTranscodingHint (PNGTranscoder.KEY_BACKGROUND_COLOR, color);
				}

				public void set_background_color_with_24_bit_rgb (int rgb_24_bit){
					set_background_color (new Color (rgb_24_bit));
				}

				public void transcode (String input_path, String output_path) throws Exception {
					File input_file = new File (input_path);
					TranscoderInput input = new TranscoderInput (input_file.toURL().toString());

					// Create the transcoder output.
					FileOutputStream ostream = new FileOutputStream (output_path);
					TranscoderOutput output = new TranscoderOutput (ostream);

					// Save the image.
					transcode (input, output);

					// Flush and close the stream.
					ostream.flush ();
					ostream.close ();
				 }

			}
	]"

end