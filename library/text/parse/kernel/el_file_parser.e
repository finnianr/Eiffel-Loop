note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-10-06 16:34:46 GMT (Monday 6th October 2014)"
	revision: "6"

deferred class
	EL_FILE_PARSER

inherit
	EL_PARSER
		export
			{NONE} all
			{ANY}	source_text, find_all, match_full,
					at_least_one_match_found, consume_events, is_reset, full_match_succeeded,
					set_source_text, set_pattern_changed
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
		local
			text: STRING_GENERAL; line: ASTRING
		do
 			source_file_path := lines.file_path
 			set_encoding_from_other (lines) -- May have detected UTF-8 BOM
 			create {ASTRING} text.make (lines.byte_count)
			from lines.start until lines.after loop
				line := lines.item
				if not text.is_empty then
					text.append_code (10)
				end
				-- if appending line to EL_ASTRING text overflows the foreign characters then change text to type STRING_32
				if attached {ASTRING} text as el_astring then
					el_astring.append (line)
					if el_astring.has_unencoded_characters then
						el_astring.remove_tail (line.count)
						text := el_astring.to_unicode
						text.append (line.to_unicode) -- text converted to STRING_32
					end
				else
					text.append (line.to_unicode)
				end
				lines.forth
			end
 			set_source_text (text)
		end

feature {NONE} -- Implementation

	source_file_path: EL_FILE_PATH

end -- class EL_LEXICAL_PARSER
