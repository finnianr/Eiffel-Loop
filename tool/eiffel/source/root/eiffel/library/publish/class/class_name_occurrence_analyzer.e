note
	description: "[
		Compile set of class names that occur in a class source text, but excluding
		names inside curly brackets (feature export lists).
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-14 9:17:58 GMT (Friday 14th November 2025)"
	revision: "8"

class
	CLASS_NAME_OCCURRENCE_ANALYZER

inherit
	EIFFEL_SOURCE_READER
		redefine
			initialize, make
		end

	EL_STRING_HANDLER

create
	make_from_zstring, make_from_file

feature {NONE} -- Initialization

	make_from_zstring (source: ZSTRING)
		do
			make_encoding (Latin_1)
			initialize
			analyze (source.area, 0, source.count - 1)
			create class_name_set.make_from (Name_buffer, True)
		end

	make (source: READABLE_STRING_8; a_encoding: NATURAL)
		do
			Precursor (source, a_encoding)
			create class_name_set.make_from (Name_buffer, True)
		end

	initialize
		do
			Name_buffer.wipe_out
			class_name_set := Name_buffer
		end

feature -- Access

	class_name_set: EL_HASH_SET [IMMUTABLE_STRING_8]

feature {NONE} -- Events

	on_comment (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
		end

	on_identifier (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		local
			put_class: BOOLEAN
		do
			if is_class_name (area, i, count) then
			-- ignore names in curly brackets: {MY_CLASS}
			-- except for constructs: agent {MY_CLASS} OR attached {MY_CLASS}
				if has_character ('{', area, i - 1) or else has_character ('}', area, i + count) then
					put_class := attached_or_agent (area, i)
				else
					put_class := True
				end
				if put_class then
					class_name_set.put (new_global_name (Immutable_8.new_substring (area, i, count)))
				end
			end
		end

	on_keyword (area: SPECIAL [CHARACTER]; i, count: INTEGER; type: INTEGER_64)
		-- find first feature in  class before filling `class_name_set'
		do
		end

	on_manifest_string (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
		end

	on_numeric_constant (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
		end

	on_quoted_character (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
		end

	on_quoted_string (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
		end

feature {NONE} -- Implementation

	attached_or_agent (area: SPECIAL [CHARACTER]; index: INTEGER): BOOLEAN
		-- agent {MY_CLASS} OR attached {MY_CLASS} to left of `index'
		local
			i, j: INTEGER; keyword: STRING
		do
			from until i > 1 or Result loop
				keyword := Keywords_agent_and_attached [i]
				j := index - keyword.count - 2 -- (" {").count = 2
				if area.valid_index (j) then
					Result := area.same_items (keyword.area, 0, j, keyword.count)
				end
				i := i + 1
			end
		end

	has_character (c: CHARACTER; area: SPECIAL [CHARACTER]; i: INTEGER): BOOLEAN
		do
			Result := area.valid_index (i) and then area [i] = c
		end

	new_global_name (a_name: IMMUTABLE_STRING_8): IMMUTABLE_STRING_8
		do
			if attached Global_name_set as name_set then
				if not name_set.has_key (a_name) then
					name_set.put (create {IMMUTABLE_STRING_8}.make_from_string (a_name))
				end
				Result := name_set.found_item
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Constants

	Keywords_agent_and_attached: SPECIAL [STRING]
		once
			create Result.make_filled ("agent", 2)
			Result [1] := "attached"
		end

	Name_buffer: EL_HASH_SET [IMMUTABLE_STRING_8]
		once
			create Result.make_equal (100)
		end

	Global_name_set: EL_HASH_SET [IMMUTABLE_STRING_8]
		once
			create Result.make_equal (100)
		end

end