note
	description: "Summary description for {SVG_TO_PNG_TEST_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVG_TO_PNG_TEST_SET

inherit
	COPIED_SVG_DIRECTORY_DATA_TEST_SET

	EL_MODULE_JAVA

	SHARED_JNI_ENVIRONMENT undefine default_create end

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("svg_format_conversion", agent test_svg_format_conversion)
		end

feature -- Tests

	test_svg_format_conversion
		do
			Java.append_jar_locations (<< Eiffel_loop_dir.joined_dir_path ("contrib/Java/batik-1.6.1") >>)
			Java.append_class_locations (<< "test-data/java_classes" >>)
			Java.open (<< "batik-rasterizer", "batik-transcoder" >>) --, "xml-commons-external"

			do_svg_to_png_conversion (agent transcode_to_width_and_color)

			Java.close
			assert ("all Java objects released", jorb.object_count = 0)
		end

feature {NONE} -- Implementation

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
					ostream.flush();
					ostream.close();
				 }

			}
	]"

end
