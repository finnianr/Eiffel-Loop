note
	description: "Create optimal [$source EL_ITERABLE_SPLIT] instance for [$source READABLE_STRING_GENERAL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

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
			else
				create Result.make (str, separator)
			end
		end

	new_split_on_string (
		str: READABLE_STRING_GENERAL; separator: READABLE_STRING_GENERAL

	): EL_SPLIT_ON_STRING [READABLE_STRING_GENERAL]
		do
			if attached {ZSTRING} str as zstr then
				create {EL_SPLIT_ZSTRING_ON_STRING} Result.make (zstr, separator)

			else
				create Result.make (str, separator)
			end
		end

end