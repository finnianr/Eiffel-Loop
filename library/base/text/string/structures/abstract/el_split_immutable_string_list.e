note
	description: "Splits strings conforming to ${IMMUTABLE_STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-06 6:55:32 GMT (Sunday 6th April 2025)"
	revision: "10"

deferred class
	EL_SPLIT_IMMUTABLE_STRING_LIST [
		GENERAL -> STRING_GENERAL create make end, IMMUTABLE -> IMMUTABLE_STRING_GENERAL create make end
	]

inherit
	EL_SPLIT_READABLE_STRING_LIST [IMMUTABLE]
		rename
			target_substring as shared_target_substring
		undefine
			extended_string
		redefine
			double_item, integer_item, natural_item
		end

	EL_MODULE_CONVERT_STRING

	EL_SHARED_CLASS_ID

feature {NONE} -- Initialization

	make_shared (a_target: GENERAL; delimiter: CHARACTER_32)
		do
			make (new_shared (a_target), delimiter)
		end

	make_shared_adjusted (a_target: GENERAL; delimiter: CHARACTER_32; a_adjustments: INTEGER)
		do
			make_adjusted (new_shared (a_target), delimiter, a_adjustments)
		end

	make_shared_adjusted_by_string (a_target: GENERAL; delimiter: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			make_adjusted_by_string (new_shared (a_target), delimiter, a_adjustments)
		end

	make_shared_by_string (a_target: GENERAL; delimiter: READABLE_STRING_GENERAL)
		do
			make_by_string (new_shared (a_target), delimiter)
		end

feature -- Numeric items

	double_item: DOUBLE
		do
			if attached {DOUBLE} Convert_string.to_type_of_type (item, Class_id.REAL_64) as real_64 then
				Result := real_64
			end
		end

	integer_item: INTEGER
		do
			Result := Convert_string.to_integer (item)
		end

	natural_item: NATURAL
		do
			if attached {NATURAL_32} Convert_string.to_type_of_type (item, Class_id.NATURAL_32) as n32 then
				Result := n32
			end
		end

feature -- Conversion

	joined_with (separator: CHARACTER_32): GENERAL
		local
			i: INTEGER; code: NATURAL
		do
			create Result.make (character_count + count - 1)
			code := separator.natural_32_code
			if attached area as a then
				from until i = a.count loop
					if i > 0 then
						Result.append_code (code)
					end
					Result.append_substring (target_string, a [i], a [i + 1])
					i := i + 2
				end
			end
		end

	as_word_string: GENERAL
		do
			Result := joined_with (' ')
		end

feature {NONE} -- Implementation

	new_shared (a_target: GENERAL): IMMUTABLE
		deferred
		end

end