note
	description: "[
		${EL_APPLICATION_COMMAND} to compress an indented manifest table and output as an
		Eiffel code fragment.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-22 13:02:06 GMT (Thursday 22nd August 2024)"
	revision: "33"

class
	COMPRESS_MANIFEST_COMMAND

inherit
	EL_APPLICATION_COMMAND

	EL_MODULE_BASE_64; EL_MODULE_FILE; EL_MODULE_LIO

create
	make

feature {EL_APPLICATION} -- Initialization

	make (a_source_path, a_output_path: FILE_PATH)
		do
			source_path := a_source_path
			output_path := a_source_path.related (a_output_path, "e")
		end

feature -- Access

	output_path: FILE_PATH

feature -- Constants

	Description: STRING = "Compress an indented manifest table and output as Eiffel code fragment"

feature -- Basic operations

	execute
		local
			text, output_text: STRING; zlib: EL_ZLIB_ROUTINES; compressed: SPECIAL [NATURAL_8]
			compressed_lines: EL_STRING_8_LIST; is_utf_encoded: BOOLEAN; utf_8: EL_UTF_8_CONVERTER
			s: EL_STRING_8_ROUTINES
		do
			text := File.plain_text_bomless (source_path)
			text.right_adjust
			is_utf_encoded := not s.is_ascii_string_8 (text) and then utf_8.is_valid_string_8 (text)
			compressed := zlib.compressed_string (text, 9, 0.327)
			create compressed_lines.make_with_lines (Base_64.encoded_special (compressed, True))
			compressed_lines.indent (4)
			compressed_lines.first.left_adjust
			output_text := Template #$ [source_path.base, '[', compressed_lines.joined_lines, ']', is_utf_encoded, text.count]
			File.write_text (output_path, output_text)
			lio.put_path_field ("Generated", output_path)
			lio.put_new_line
		end

feature {NONE} -- Internal attributes

	compression_ratio: DOUBLE

	source_path: FILE_PATH

feature {NONE} -- Constants

	Template: ZSTRING
		once
			Result := "[
				feature {NONE} -- Implementation
				
					compressed_manifest: STRING
						-- zlib compressed: # 
						do
							Result := "#
								#
							#"
						end
				
				feature {NONE} -- Constants
				
					Is_utf_8_encoded: BOOLEAN = #
				
					Text_count: INTEGER = #
			]"
		end

end