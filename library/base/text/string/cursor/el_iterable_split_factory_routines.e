note
	description: "Create optimal [$source EL_ITERABLE_SPLIT] instance for [$source READABLE_STRING_GENERAL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-23 13:18:20 GMT (Tuesday 23rd May 2023)"
	revision: "3"

expanded class
	EL_ITERABLE_SPLIT_FACTORY_ROUTINES

feature -- Access

	new_split_on_character (
		str: READABLE_STRING_GENERAL; separator: CHARACTER_32

	): EL_SPLIT_ON_CHARACTER [READABLE_STRING_GENERAL]
		do
			if attached {ZSTRING} str as zstr then
				create {EL_SPLIT_ZSTRING_ON_CHARACTER} Result.make (zstr, separator)

			elseif attached {IMMUTABLE_STRING_8} str as immutable_8 then
				create {EL_SPLIT_IMMUTABLE_STRING_8_ON_CHARACTER} Result.make (immutable_8, separator)

			elseif attached {STRING_8} str as str_8 then
				create {EL_SPLIT_ON_CHARACTER_8 [STRING_8]} Result.make (str_8, separator)

			elseif attached {STRING_32} str as str_32 then
				create {EL_SPLIT_ON_CHARACTER_32 [STRING_32]} Result.make (str_32, separator)
			else
				create Result.make (str, separator)
			end
		end

	new_split_on_string (str, separator: READABLE_STRING_GENERAL): EL_SPLIT_ON_STRING [READABLE_STRING_GENERAL]
		do
			if attached {ZSTRING} str as zstr then
				create {EL_SPLIT_ZSTRING_ON_STRING} Result.make (zstr, separator)

			else
				create Result.make (str, separator)
			end
		end

end