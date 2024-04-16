note
	description: "[
		Factory to create the most optimal split-string iterator conforming to ${EL_ITERABLE_SPLIT}
		for the type of the function argument **general** conforming to ${READABLE_STRING_GENERAL}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-15 9:58:11 GMT (Monday 15th April 2024)"
	revision: "8"

expanded class
	EL_ITERABLE_SPLIT_FACTORY_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

	EL_SHARED_CLASS_ID

feature -- Access

	new_split_on_character (
		general: READABLE_STRING_GENERAL; separator: CHARACTER_32

	): EL_SPLIT_ON_CHARACTER [READABLE_STRING_GENERAL]
		do
			inspect Class_id.string_storage_type (general)
				when '1' then
					if general.is_immutable and then attached {IMMUTABLE_STRING_8} general as immutable_8 then
						create {EL_SPLIT_IMMUTABLE_STRING_8_ON_CHARACTER} Result.make (immutable_8, separator)

					elseif attached {STRING_8} general as str_8 then
						create {EL_SPLIT_ON_CHARACTER_8 [STRING_8]} Result.make (str_8, separator)
					else
						create Result.make (general, separator)
					end
				when '4' then
					if general.is_immutable and then attached {IMMUTABLE_STRING_32} general as immutable_32 then
						create {EL_SPLIT_IMMUTABLE_STRING_32_ON_CHARACTER} Result.make (immutable_32, separator)

					elseif attached {STRING_32} general as str_32 then
						create {EL_SPLIT_ON_CHARACTER_32 [STRING_32]} Result.make (str_32, separator)
					else
						create Result.make (general, separator)
					end
				when 'X' then
					if attached {ZSTRING} general as zstr then
						create {EL_SPLIT_ZSTRING_ON_CHARACTER} Result.make (zstr, separator)
					else
						create Result.make (general, separator)
					end
			end
		end

	new_split_on_string (general, separator: READABLE_STRING_GENERAL): EL_SPLIT_ON_STRING [READABLE_STRING_GENERAL]
		do
			inspect Class_id.string_storage_type (general)
				when 'X' then
					if attached {ZSTRING} general as zstr then
						create {EL_SPLIT_ZSTRING_ON_STRING} Result.make (zstr, separator)
					end
			else
				create Result.make (general, separator)
			end
		end

end