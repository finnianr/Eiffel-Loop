note
	description: "Object for obtaining code names from code fields via object reflection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-05 17:44:45 GMT (Sunday 5th November 2017)"
	revision: "2"

deferred class
	EL_STATUS_CODE_REFLECTION [N -> {NUMERIC, HASHABLE}]

inherit
	EL_REFLECTION

feature {NONE} -- Initialization

	make
		local
			object: like current_object
			i, field_count, numeric_type_id: INTEGER
		do
			initialize

			object := current_object; field_count := object.field_count
			create field_index_table.make (field_count)
			numeric_type_id := Numeric_types [{N}]
			from i := 1 until i > field_count loop
				if object.field_type (i) = numeric_type_id then
					field_index_table.put (i, field_value (object, i))
					has_duplicate_code := has_duplicate_code or field_index_table.conflict
				end
				i := i + 1
			end
		end

	initialize
		-- initialize fields
		deferred
		end

feature -- Access

	code_name (code: N): STRING
		require
			has_code: is_valid_code (code)
		local
			name: ZSTRING
		do
			field_index_table.search (code)
			if field_index_table.found then
				name := current_object.field_name (field_index_table.found_item)
				create Result.make (name.count)
				name.do_with_splits (Underscore, agent append_word (?, Result))
				Result [1] := Result.item (1).as_upper
			else
				create Result.make_empty
			end
		end

feature -- Status query

	has_duplicate_code: BOOLEAN

	is_valid_code (code: N): BOOLEAN
		do
			Result := field_index_table.has_key (code)
		end

feature {NONE} -- Implementation

	append_word (word: ZSTRING; str: STRING)
		do
			if not str.is_empty then
				if str.ends_with (once "non") then
					str.append_character ('-')
				else
					str.append_character (' ')
				end
			end
			if Upper_case_words.has (word) then
				word.as_upper.append_to_string_8 (str)
			else
				word.append_to_string_8 (str)
			end
		end

	field_value (object: like current_object; i: INTEGER): N
		deferred
		end

feature {NONE} -- Internal attributes

	field_index_table: HASH_TABLE [INTEGER, N]
		-- map field values to field index

feature {NONE} -- Constants

	Upper_case_words: ARRAY [ZSTRING]
		-- words to be upper cased in `code_name'
		-- (must be listed in lowercase)
		once
			create Result.make_empty
			Result.compare_objects
		ensure
			object_comparison: Result.object_comparison
		end

	Underscore: ZSTRING
		once
			Result := "_"
		end

	Numeric_types: EL_HASH_TABLE [INTEGER, TYPE [NUMERIC]]
		once
			create Result.make (<<
				[{NATURAL_8}, Natural_8_type],
				[{NATURAL_16}, Natural_16_type],
				[{NATURAL_32}, Natural_32_type],
				[{NATURAL_64}, Natural_64_type],

				[{INTEGER_8}, Integer_8_type],
				[{INTEGER_16}, Integer_16_type],
				[{INTEGER_32}, Integer_32_type],
				[{INTEGER_64}, Integer_64_type],

				[{REAL_32}, Real_32_type],
				[{REAL_64}, Real_64_type]
			>>)
		end

invariant
	no_duplicate_codes: not has_duplicate_code
end
