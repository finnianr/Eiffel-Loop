note
	description: "Library class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-08 13:15:33 GMT (Tuesday 8th April 2025)"
	revision: "9"

class
	LIBRARY_CLASS

inherit
	EL_STRING_STATE_MACHINE [STRING]
		rename
			make as make_machine
		redefine
			call
		end

	EL_MODULE_FILE

	EL_STRING_GENERAL_ROUTINES_I

create
	make

feature {NONE} -- Initialization

	make (a_source_path: FILE_PATH)
		do
			make_machine
			source_path := a_source_path
			name := a_source_path.base_name; name.to_upper
			create class_reference_set.make_equal (20)
			do_with_iterable_lines (agent find_class_definition, File.plain_text_lines (a_source_path))
		end

feature -- Access

	circular_dependent: detachable LIBRARY_CLASS

	class_reference_set: EL_NAME_SET

	name: STRING

	source_path: FILE_PATH

feature -- Element change

	try_bind (candidate: LIBRARY_CLASS)
		do
			if class_reference_set.has (candidate.name) and then candidate.class_reference_set.has (name) then
				circular_dependent := candidate
				class_reference_set.merge (candidate.class_reference_set)
				class_reference_set.prune (name)
			end
		end

feature {NONE} -- Line state

	compile_class_names (line: STRING)
		local
			split_list: EL_SPLIT_IMMUTABLE_STRING_8_LIST
		do
			line.left_adjust
			create split_list.make_shared_adjusted (line, ' ', 0)
			if attached split_list as list then
				from list.start until list.after loop
					if not list.item_same_as (name) and then attached list.item as word then
						if super_readable_8 (word).is_eiffel_upper and then not class_reference_set.has (word) then
							class_reference_set.put (word)
						end
					end
					list.forth
				end
			end
		end

	find_class_definition (line: STRING)
		do
			if across Class_start_words as word some line.starts_with (word.item) end then
				state := agent compile_class_names
			end
		end

feature {NONE} -- Implementation

	call (line: STRING)
		-- call state procedure with item
		local
			hyphen_pos: INTEGER
		do
			hyphen_pos := line.last_index_of ('-', line.count)
			hyphen_pos := hyphen_pos - 1
			if hyphen_pos >= 1 and then line [hyphen_pos] = '-' then
				line.keep_head (hyphen_pos - 1)
			end
			line.right_adjust
			if line.count > 0 then
				state (line)
			end
		end

feature {NONE} -- Constants

	Class_start_words: EL_STRING_8_LIST
		once
			Result := "frozen, deferred, expanded, class"
		end
end