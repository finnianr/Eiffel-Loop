note
	description: "[
		Reformat class links in source notes to use style: ${MY_CLASS}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-18 19:04:09 GMT (Thursday 18th January 2024)"
	revision: "2"

class
	CLASS_NOTE_LINK_REFORMATTING_COMMAND

inherit
	SOURCE_MANIFEST_COMMAND
		redefine
			make_default
		end

	EL_MODULE_FILE_SYSTEM; EL_MODULE_FILE

	EL_SHARED_STRING_8_CURSOR

	PUBLISHER_CONSTANTS

	EL_CHARACTER_32_CONSTANTS

create
	make

feature {EL_APPLICATION} -- Initialization

	make_default
		do
			Precursor
			source_pattern := Wiki_source_link + char (' ')
		end

feature -- Constants

	Description: STRING = "Reformat class hyperlinks in notes to ${MY_CLASS}"

feature -- Measurement

	updated_count: INTEGER

feature {NONE} -- Implementation

	do_with_file (source_path: FILE_PATH)
		local
			modification_time, pattern_index, end_index: INTEGER; updated: BOOLEAN
		do
			if attached File.plain_text (source_path) as source_text then
				modification_time := source_path.modification_time
				from pattern_index := 1 until pattern_index = 0 loop
					pattern_index := source_text.substring_index (source_pattern, pattern_index)
					if pattern_index > 0 then
						end_index := cursor_8 (source_text).matching_bracket_index (pattern_index)
						if end_index > 0 then
							source_text [end_index] := '}'
							source_text.replace_substring (
								Dollor_left_brace.to_latin_1, pattern_index, pattern_index + source_pattern.count - 1
							)
							updated := True
							pattern_index := end_index - source_pattern.count + 3
						else
							pattern_index := 0
						end
					end
				end
				if updated then
					File.write_text (source_path, source_text)
					File.set_modification_time (source_path, modification_time)
					updated_count := updated_count + 1
				end
			end
		end

feature {NONE} -- Internal attributes

	source_pattern: STRING

end