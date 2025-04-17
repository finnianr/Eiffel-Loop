note
	description: "[
		Factory to create the most optimal split-string iterator conforming to ${EL_ITERABLE_SPLIT}
		for the type of the function argument **general** conforming to ${READABLE_STRING_GENERAL}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 18:19:43 GMT (Wednesday 16th April 2025)"
	revision: "11"

frozen expanded class
	EL_ITERABLE_SPLIT_FACTORY_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

	EL_STRING_HANDLER

feature -- Access

	new_split_on_character (
		general: READABLE_STRING_GENERAL; separator: CHARACTER_32

	): EL_SPLIT_ON_CHARACTER [READABLE_STRING_GENERAL, COMPARABLE]
		require
			valid_separator: general.is_string_8 implies separator.is_character_8
		do
			inspect string_storage_type (general)
				when '1' then
					if general.is_immutable and then attached {IMMUTABLE_STRING_8} general as immutable_8 then
						create {EL_SPLIT_IMMUTABLE_STRING_8_ON_CHARACTER} Result.make (immutable_8, separator.to_character_8)

					elseif attached {READABLE_STRING_8} general as str_8 then
						create {EL_SPLIT_ON_CHARACTER_8 [READABLE_STRING_8]} Result.make (str_8, separator.to_character_8)
					end
				when '4' then
					if general.is_immutable and then attached {IMMUTABLE_STRING_32} general as immutable_32 then
						create {EL_SPLIT_IMMUTABLE_STRING_32_ON_CHARACTER} Result.make (immutable_32, separator)

					elseif attached {READABLE_STRING_32} general as str_32 then
						create {EL_SPLIT_ON_CHARACTER_32 [READABLE_STRING_32]} Result.make (str_32, separator)
					end
				when 'X' then
					if attached {ZSTRING} general as zstr then
						create {EL_SPLIT_ZSTRING_ON_CHARACTER} Result.make (zstr, separator)
					end
			end
		end

	new_split_on_string (
		general, separator: READABLE_STRING_GENERAL

	): EL_SPLIT_ON_STRING [READABLE_STRING_GENERAL, COMPARABLE]
		do
			inspect string_storage_type (general)
				when '1' then
					if general.is_immutable and then attached {IMMUTABLE_STRING_8} general as immutable_8 then
						create {EL_SPLIT_STRING_8_ON_STRING [IMMUTABLE_STRING_8]} Result.make (immutable_8, separator)

					elseif attached {STRING_8} general as str_8 then
						create {EL_SPLIT_STRING_8_ON_STRING [STRING_8]} Result.make (str_8, separator)
					end

				when '4' then
					if general.is_immutable and then attached {IMMUTABLE_STRING_32} general as immutable_32 then
						create {EL_SPLIT_STRING_32_ON_STRING [IMMUTABLE_STRING_32]} Result.make (immutable_32, separator)

					elseif attached {STRING_32} general as str_32 then
						create {EL_SPLIT_STRING_32_ON_STRING [STRING_32]} Result.make (str_32, separator)
					end

				when 'X' then
					if attached {ZSTRING} general as zstr then
						create {EL_SPLIT_ZSTRING_ON_STRING} Result.make (zstr, separator)
					end
			else
				create {EL_SPLIT_STRING_32_ON_STRING [STRING_32]} Result.make (general.to_string_32, separator)
			end
		end

end