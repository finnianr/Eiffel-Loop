note
	description: "Test set using SVG button image found in directory: `test/data/svg'"
	notes: "[
		Common class for testing both Java Batik and librsvg
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:01:50 GMT (Tuesday 18th March 2025)"
	revision: "19"

deferred class
	COPIED_SVG_DIRECTORY_DATA_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET
		undefine
			new_lio
		redefine
			on_prepare
		end

	EL_CRC_32_TESTABLE

	EL_MODULE_DIRECTORY; EL_MODULE_TUPLE

	SHARED_DEV_ENVIRON

	EVC_SHARED_TEMPLATES

feature {NONE} -- Initialization

	on_prepare
		local
			context: EVC_CONTEXT_IMP
		do
			Precursor
			svg_path := file_path (Edit_button_svg)
			create context.make
			context.put_string ("png_path", Directory.current_working.plus_file (file_path (Edit_icon_png)))
			Evolicity_templates.put_file (file_path (Button_svg), Utf_8_encoding)
			if attached open (svg_path, Write) as svg_file then
				Evolicity_templates.merge_to_file (file_path (Button_svg), context, svg_file)
			end
		end

feature {NONE} -- Implementation

	do_svg_to_png_conversion (write_png: PROCEDURE [INTEGER, INTEGER, FILE_PATH])
		local
			name: STRING; size: INTEGER; output_path: FILE_PATH
		do
			-- 11 March 2021
			name := "convert_to_width_and_color"
			size := 64
			across Color_code_table as table loop
				output_path := svg_path.without_extension
				output_path.set_base (output_path.base + Png_name_template #$ [table.key, size, size])

				do_test (name, Check_sums [table.cursor_index], write_png, [size, table.item, output_path])
				size := size * 2
			end
		end

	check_sums: ARRAY [NATURAL]
		deferred
		end

	print_digest (output_path: FILE_PATH)
		do
			lio.put_labeled_string ("Digest " + output_path.base, raw_file_digest (output_path).to_base_64_string)
			lio.put_new_line
		end

	source_dir: DIR_PATH
		do
			Result := Dev_environ.EL_test_data_dir #+ "svg"
		end

feature {NONE} -- Internal attributes

	svg_path: FILE_PATH

feature {NONE} -- Constants

	Button_svg: STRING = "button.svg"

	Color: TUPLE [black, white, red, transparent: STRING]
		once
			create Result
			Tuple.fill (Result, "black, white, red, transparent")
		end

	Color_code_table: EL_HASH_TABLE [INTEGER, STRING]
		once
			Result := <<
				[Color.black, 0], [Color.white, 0xFFFFFF], [Color.red, 0xA52A2A]
			>>
		end

	Edit_button_svg: STRING
		once
			Result := "edit-" + Button_svg
		end

	Edit_icon_png: STRING = "edit-icon.png"

	Png_name_template: ZSTRING
		once
			Result := "-%S-%Sx%S.png"
		end

	Utf_8_encoding: EL_ENCODEABLE_AS_TEXT
		once
			create Result.make_default -- UTF-8
		end

end