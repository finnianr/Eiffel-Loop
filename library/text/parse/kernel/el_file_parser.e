note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-28 12:34:25 GMT (Sunday 28th July 2013)"
	revision: "4"

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
			make
		end

	EL_MODULE_ASCII
		export
			{NONE} all
		end

	EL_MODULE_UTF
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			create source_file_path
		end

feature -- Status query

	is_utf8_source: BOOLEAN

feature -- Status setting

	set_is_utf8_source (flag: BOOLEAN)
		do
			is_utf8_source := flag
		end

feature -- Element Change

  	set_source_text_from_file (file_path: EL_FILE_PATH)
 			--
 		local
 			file: PLAIN_TEXT_FILE
 		do
 			create file.make_open_read (file_path.unicode)
 			set_source_text_from_line_source (file)
 			file.close
 		end

	set_source_text_from_line_source (file: PLAIN_TEXT_FILE)
			--
		local
			text: STRING_GENERAL
			is_utf8: BOOLEAN
		do
 			source_file_path := file.path
 			if not is_utf8_source then
 				is_utf8_source := has_bom_mark (file)
 			end
 			is_utf8 := is_utf8_source
 			if is_utf8 then
	 			create {STRING_32} text.make (file.count)
 			else
	 			create {STRING} text.make (file.count)
 			end
			from file.start until file.end_of_file loop
				if not text.is_empty then
					text.append_code (10)
				end
				text.append (file_line (file, is_utf8))
			end
 			set_source_text (text)
		end

feature {NONE} -- Implementation

	has_bom_mark (file: PLAIN_TEXT_FILE): BOOLEAN
		do
			file.start
			file.read_stream (3)
			Result := file.last_string ~ UTF.utf_8_bom_to_string_8
		end

	file_line (file: PLAIN_TEXT_FILE; is_utf8: BOOLEAN): READABLE_STRING_GENERAL
		local
			l_result: STRING
		do
			file.read_line
			l_result := file.last_string
			l_result.prune_all_trailing ('%R')
			if is_utf8 then
				Result := UTF.utf_8_string_8_to_string_32 (l_result)
			else
				Result := l_result
			end
		end

	source_file_path: EL_FILE_PATH

end -- class EL_LEXICAL_PARSER
