note
	description: "Library class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-12 14:43:04 GMT (Sunday 12th June 2022)"
	revision: "1"

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

create
	make

feature {NONE} -- Initialization

	make (a_source_path: FILE_PATH)
		do
			make_machine
			source_path := a_source_path
			name := a_source_path.base_sans_extension; name.to_upper
			create class_reference_set.make (20)
			traverse_iterable (agent find_class_definition, File.plain_text_lines (a_source_path))
		end

feature -- Access

	circular_dependent: detachable LIBRARY_CLASS

	class_reference_set: EL_HASH_SET [STRING]

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
			splitter: EL_SPLIT_ON_CHARACTER [STRING]; s: EL_STRING_8_ROUTINES
			word: STRING
		do
			line.left_adjust
			create splitter.make (line, ' ')
			across splitter as split loop
				word := split.item
				if word.count > 0 and then s.is_upper_eiffel_identifier (word) and then word /~ name then
					if not class_reference_set.has (word) then
						class_reference_set.put (word.twin)
					end
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