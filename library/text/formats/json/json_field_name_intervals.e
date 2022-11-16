note
	description: "List of JSON field name substring interval"
	notes: "[
		Assumes that each JSON field is on a separate line. This class ensures very efficient linear search
		of a field name without the creation of any objects.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	JSON_FIELD_NAME_INTERVALS

inherit
	EL_SEQUENTIAL_INTERVALS
		rename
			make as make_intervals
		end

create
	make

feature {NONE} -- Initialization

	make (a_utf_8_json: STRING)
		local
			splitter: EL_SPLIT_ON_CHARACTER [STRING]; i, start_index, end_index: INTEGER
		do
			utf_8_json := a_utf_8_json
			make_intervals (a_utf_8_json.occurrences ('%N') + 1)
			create splitter.make (a_utf_8_json, '%N')
			across splitter as split loop
				i := index_of_character (a_utf_8_json, '"', split.item_lower, split.item_upper)
				if i > 0 and then i + 1 <= split.item_upper then
					start_index := i + 1
					i := index_of_character (a_utf_8_json, '"', start_index, split.item_upper)
					if i > 0 then
						end_index := i - 1
						i := index_of_character (a_utf_8_json, ':', i + 1, split.item_upper.min (i + 2))
						-- find ':'
						if i > 0 then
							extend (start_index, end_index)
						end
					end
				end
			end
			create internal_utf_8_item.make (50)
			create internal_name.make (20)
		end

feature -- Access

	item_name: STRING
		require
			valid_item: not off
		do
			Result := internal_name
			Result.wipe_out
			Result.append_substring (utf_8_json, item_lower, item_upper)
		end

	item_utf_8_value: STRING
		-- item value encoded as UTF-8
		require
			valid_item: not off
		local
			new_line_index, i: INTEGER; s: EL_STRING_8_ROUTINES; json: STRING
		do
			json := utf_8_json
			Result := internal_utf_8_item
			Result.wipe_out
			i := item_upper + 2 -- to right of quote
			new_line_index := index_of_character (json, '%N', i, utf_8_json.count)
			if new_line_index = 0 then
				new_line_index := utf_8_json.count
			end
			i := index_of_character (json, ':', i, new_line_index.min (i + 2))
			if i > 0 then
				Result.wipe_out; Result.append_substring (utf_8_json, i + 1, new_line_index)
				Result.adjust; Result.prune_all_trailing (',')
				s.remove_double_quote (Result)
			end
		end

feature -- Basic operations

	find_field (name: STRING)
		local
			l_found: BOOLEAN
		do
			from start until l_found or else after loop
				if item_count = name.count and then utf_8_json.same_characters (name, 1, name.count, item_lower) then
					l_found := True
				else
					forth
				end
			end
		end

feature {NONE} -- Implementation

	index_of_character (a_utf_8_json: STRING; c: CHARACTER; a_lower, a_upper: INTEGER): INTEGER
		local
			i: INTEGER
		do
			from i := a_lower until Result.to_boolean or else i > a_upper loop
				if a_utf_8_json [i] = c then
					Result := i
				else
					i := i + 1
				end
			end
		end

feature {NONE} -- Internal attributes

	utf_8_json: STRING

	internal_utf_8_item: STRING

	internal_name: STRING

end