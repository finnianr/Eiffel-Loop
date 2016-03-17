note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-21 19:04:07 GMT (Monday 21st December 2015)"
	revision: "8"

deferred class
	EL_FILE_PARSER

inherit
	EL_PARSER
		export
			{NONE} all
			{ANY}	source_text, match_full, call_actions, is_reset, fully_matched, set_source_text, set_pattern_changed
		redefine
			make_default
		end

	EL_ENCODEABLE_AS_TEXT

	EL_MODULE_ASCII
		export
			{NONE} all
		end

	EL_MODULE_UTF
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			make_utf_8
			create source_file_path
		end

feature -- Element Change

  	set_source_text_from_file (file_path: EL_FILE_PATH)
 			--
 		local
 			lines: EL_FILE_LINE_SOURCE; input: PLAIN_TEXT_FILE
 		do
 			create input.make_open_read (file_path)
 			create lines.make_from_file (input)
 			lines.set_encoding_from_other (Current)
 			set_source_text_from_line_source (lines)
 			input.close
 		end

	set_source_text_from_line_source (lines: EL_FILE_LINE_SOURCE)
			--
		do
 			source_file_path := lines.file_path
 			set_encoding_from_other (lines) -- May have detected UTF-8 BOM
 			set_source_text (new_source_text (lines))
		end

feature {NONE} -- Implementation

	new_source_text (lines: EL_FILE_LINE_SOURCE): ZSTRING
		do
 			create Result.make (lines.byte_count)
			from lines.start until lines.after loop
				if not Result.is_empty then
					Result.append_z_code (10)
				end
				Result.append_string (lines.item)
				lines.forth
			end
		end

	source_file_path: EL_FILE_PATH

end -- class EL_LEXICAL_PARSER
