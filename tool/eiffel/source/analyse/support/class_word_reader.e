note
	description: "Object that reads code words ignoring comments and quoted strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-07 18:10:08 GMT (Thursday 7th September 2023)"
	revision: "2"

class
	CLASS_WORD_READER
inherit
	ANY

	EL_MODULE_FILE

	EL_SHARED_STRING_8_CURSOR

create
	make

feature {NONE} -- Initialization

	make (source_path: FILE_PATH)
		local
			i, first_index, last_index: INTEGER; area: SPECIAL [CHARACTER]
		do
			if attached File.plain_text_bomless (source_path) as source
				and then attached cursor_8 (source) as c8
			then
				area := c8.area; first_index := c8.area_first_index
				last_index := c8.area_last_index
				from i := first_index until i > last_index loop
					inspect area [i]
						when '-' then
							if is_comment (area, i, last_index) then
								i := i + comment_skip_count (area, i, last_index)
							end
						when '"' then
						when '%'' then
					else
						i := i + 1
					end
				end
			end
		end

feature {NONE} -- Implementation

	is_comment (area: SPECIAL [CHARACTER]; i, last_index: INTEGER): BOOLEAN
		do
			if i + 1 <= last_index then
				Result := area [i] = '-'
			end
		end

	is_string_manifest (area: SPECIAL [CHARACTER]; i, last_index: INTEGER): BOOLEAN
		local
			c: CHARACTER
		do
			if i + 2 <= last_index and then area [i + 1] = '[' then
				c := area [i + 3]
				Result := c = '%R' or c = '%N'
			end
		end

	comment_skip_count (area: SPECIAL [CHARACTER]; i, last_index: INTEGER): INTEGER
		local
			done: BOOLEAN; j: INTEGER
		do
			from j := i + 2 until j > last_index or done loop
				if area [j] = '%N' then
					done := True
				end
				j := j + 1
			end
			Result := i - j
		end
end