note
	description: "Test class [$source EL_SVG_IMAGE_UTILS] from `image-utils.ecf'"
	notes: "[
		Test sets conforming to [$source EL_EQA_REGRESSION_TEST_SET] (like this one) can only be run
		from a sub-application conforming to [$source EL_REGRESSION_AUTOTEST_SUB_APPLICATION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-18 12:29:33 GMT (Tuesday 18th February 2020)"
	revision: "4"

class
	IMAGE_UTILS_TEST_SET

inherit
	EL_GENERATED_FILE_DATA_TEST_SET
		rename
			new_file_tree as new_empty_file_tree
		redefine
			on_prepare, Work_area_dir
		end

	EIFFEL_LOOP_TEST_CONSTANTS

	EL_EQA_REGRESSION_TEST_SET
		undefine
			on_prepare, on_clean
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_SVG

	EL_MODULE_EVOLICITY_TEMPLATES

feature {NONE} -- Initialization

	on_prepare
		local
			svg_file: EL_PLAIN_TEXT_FILE; icon_path: EL_FILE_PATH
			context: EVOLICITY_CONTEXT_IMP
		do
			Precursor {EL_GENERATED_FILE_DATA_TEST_SET}
			svg_path := Work_area_dir + Button_svg_path.base
			icon_path := Work_area_dir + Edit_icon_path.base
			OS.copy_file (Edit_icon_path, icon_path)

			create context.make
			context.put_string ("png_path", icon_path)
			Evolicity_templates.put_file (Button_svg_path, Utf_8_encoding)
			create svg_file.make_open_write (svg_path)
			Evolicity_templates.merge_to_file (Button_svg_path, context, svg_file)
		end

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("svg_to_png_conversion",	agent test_svg_to_png_conversion)
		end

feature -- Tests

	test_svg_to_png_conversion
		local
			name: STRING; checksum: NATURAL
			i, size: INTEGER
		do
			-- 6 Feb 2020
			name := "convert_to_width_and_color"
			from i := 1; size := 64 until i > Colors.count loop
				inspect i
					when 1 then checksum := 427064073
					when 2 then checksum := 1898336435
					when 3 then checksum := 2457900068
					when 4 then checksum := 3645165896
				else end
				do_test (name, checksum, agent convert_to_width_and_color, [size, Colors [i]])
				i := i + 1; size := size * 2
			end
		end
feature {NONE} -- Implementation

	convert_to_width_and_color (width, color: INTEGER)
		local
			output_path: EL_FILE_PATH; name: STRING
		do
			output_path := svg_path.without_extension
			inspect color
				when Black then name := "black"
				when White then name := "white"
				when Red then name := "red"
			else
				name := "transparent"
			end
			output_path.base.append (Png_name_template #$ [name, width, width])
			SVG.write_png_of_width (svg_path, output_path, width, color)

			log.put_labeled_string ("Digest " + output_path.base, file_digest (output_path).to_base_64_string)
			log.put_new_line
		end

feature {NONE} -- Internal attributes

	svg_path: EL_FILE_PATH

feature {NONE} -- Constants

	Button_svg_path: EL_FILE_PATH
		once
			Result := EL_test_data_dir + "svg/button.svg"
		end

	Edit_icon_path: EL_FILE_PATH
		once
			Result := EL_test_data_dir + "svg/edit-icon.png"
		end

	Colors: ARRAY [INTEGER]
		once
			Result := << Black, White, Red, SVG.Transparent_color_24_bit >>
		end

	Utf_8_encoding: EL_ENCODEABLE_AS_TEXT
		once
			create Result.make_utf_8
		end

feature {NONE} -- Constants

	Black: INTEGER = 0

	White: INTEGER = 0xFFFFFF

	Red: INTEGER = 0xA52A2A

	Work_area_dir: EL_DIR_PATH
		once
			Result := Directory.current_working.joined_dir_path ("workarea")
		end

	Png_name_template: ZSTRING
		once
			Result := "-%S-%Sx%S.png"
		end
end
