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
	date: "2021-02-02 11:12:32 GMT (Tuesday 2nd February 2021)"
	revision: "9"

class
	IMAGE_UTILS_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET
		undefine
			new_lio
		redefine
			on_prepare
		end

	EL_EQA_REGRESSION_TEST_SET
		undefine
			on_prepare, on_clean
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_SVG

	EL_MODULE_EVOLICITY_TEMPLATES

	EIFFEL_LOOP_TEST_CONSTANTS

feature {NONE} -- Initialization

	on_prepare
		local
			context: EVOLICITY_CONTEXT_IMP
		do
			Precursor {EL_COPIED_DIRECTORY_DATA_TEST_SET}
			svg_path := file_path (Edit_button_svg)
			create context.make
			context.put_string ("png_path", Directory.current_working + file_path (Edit_icon))
			Evolicity_templates.put_file (file_path (Button_svg), Utf_8_encoding)
			if attached open (svg_path, Write) as svg_file then
				Evolicity_templates.merge_to_file (file_path (Button_svg), context, svg_file)
			end
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
			-- 12 September 2020
			name := "convert_to_width_and_color"
			from i := 1; size := 64 until i > Colors.count loop
				inspect i
					when 1 then checksum := 2564124925
					when 2 then checksum := 1593938914
					when 3 then checksum := 4059851870
					when 4 then checksum := 123522188
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

	Edit_button_svg: STRING
		once
			Result := "edit-" + Button_svg
		end

	Button_svg: STRING = "button.svg"

	Edit_icon: STRING = "edit-icon.png"

	Colors: ARRAY [INTEGER]
		once
			Result := << Black, White, Red, SVG.Transparent_color_24_bit >>
		end

	Utf_8_encoding: EL_ENCODEABLE_AS_TEXT
		once
			create Result.make_default -- UTF-8
		end

feature {NONE} -- Constants

	Black: INTEGER = 0

	White: INTEGER = 0xFFFFFF

	Red: INTEGER = 0xA52A2A

	Source_dir: EL_DIR_PATH
		once
			Result := EL_test_data_dir.joined_dir_path ("svg")
		end

	Png_name_template: ZSTRING
		once
			Result := "-%S-%Sx%S.png"
		end
end