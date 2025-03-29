note
	description: "Class name split on underscore"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-29 13:58:54 GMT (Saturday 29th March 2025)"
	revision: "1"

class
	EL_CLASS_NAME_WORDS

inherit
	EL_SPLIT_IMMUTABLE_STRING_8_LIST
		rename
			make as make_split
		end

	EL_MODULE_NAMING

create
	make, make_from_type, make_from_name

feature {NONE} -- Initialization

	make (object: ANY)
		do
			make_from_type (object.generating_type)
		end

	make_from_type (type: TYPE [ANY])
		do
			make_from_name (type.name)
		end

	make_from_name (name: IMMUTABLE_STRING_8)
		local
			bracket_index: INTEGER
		do
			bracket_index := name.index_of ('[', 1)
			if bracket_index > 0 then
				make_split (name.shared_substring (1, bracket_index - 2) , '_')
				parameters := name.shared_substring (bracket_index - 1, name.count)
			else
				make_split (name, '_')
				parameters := name.shared_substring (1, 0)
			end
		end

feature -- Access

	parameters: IMMUTABLE_STRING_8

	description: STRING
		local
			i, l_count: INTEGER; s: EL_STRING_8_ROUTINES
		do
			create Result.make (character_count + count - 1 + parameters.count)
			if attached area as a then
				from until i = a.count loop
					if i > 0 then
						Result.append_character (' ')
					end
					l_count := a [i + 1] - a [i] + 1
					Result.append_substring (target_string, a [i], a [i + 1])
					if l_count > 3 then
						s.set_substring_lower (Result, Result.count - l_count + 1, Result.count)
					end
					i := i + 2
				end
			end
			s.set_upper (Result, 1)
			if parameters.count > 0 then
				Result.append (once " for type ")
				Result.append_substring (parameters, 3, parameters.count - 1)
			end
		end

feature -- Removal

	remove_words (word_list: ITERABLE [STRING_8])
		do
			push_cursor
			from start until after loop
				if across word_list as list some list.item.same_string (item) end then
					remove
				else
					forth
				end
			end
			pop_cursor
		end

	remove_el_prefix
		do
			remove_prefix (Naming.EL_prefix)
		end

	remove_prefix (a_prefix: STRING)
		do
			if count > 0 and then first_item.same_string (a_prefix) then
				remove_head (1)
			end
		end

	remove_suffix (suffix_list: ARRAY [STRING])
		do
			across suffix_list as list loop
				if count > 0 and then last_item.same_string (list.item) then
					remove_tail (1)
				end
			end
		end
end