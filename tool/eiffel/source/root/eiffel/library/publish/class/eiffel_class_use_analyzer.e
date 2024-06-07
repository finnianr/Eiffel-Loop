note
	description: "[
		Compile set of class names used in a class source text, but excluding
		class names inside curly brackets.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-07 7:36:44 GMT (Friday 7th June 2024)"
	revision: "2"

class
	EIFFEL_CLASS_USE_ANALYZER

inherit
	EIFFEL_SOURCE_READER
		rename
			make as make_reader
		end

	STRING_HANDLER

create
	make

feature {NONE} -- Initialization

	make (source: ZSTRING)
		do
			make_encoding (Latin_1)
			Use_set_buffer.wipe_out
			class_name_set := Use_set_buffer
			analyze (source.area, 0, source.count - 1)
			create class_name_set.make (Use_set_buffer.count)
			across Use_set_buffer as set loop
				class_name_set.put (set.item)
			end
		end

feature -- Access

	class_name_set: EL_HASH_SET [IMMUTABLE_STRING_8]

feature {NONE} -- Events

	on_comment (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
		end

	on_identifier (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
			if is_class_name (area, i, count) then
			-- ignore names in curly brackets: {CLASS}
				if area.valid_index (i - 1) and then area [i - 1] = '{' then
					do_nothing

				elseif area.valid_index (i + count) and then area [i + count] = '}' then
					do_nothing
				else
					class_name_set.put (Immutable_8.new_substring (area, i, count))
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

feature {NONE} -- Constants

	Use_set_buffer: EL_HASH_SET [IMMUTABLE_STRING_8]
		once
			create Result.make (100)
		end
end