note
	description: "[
		Character constants that be multiplied as a ${STRING_8} instance with * operator.
		Use **char** function for uncommon characters.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-18 13:28:17 GMT (Friday 18th August 2023)"
	revision: "23"

deferred class
	EL_CHARACTER_8_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	char (c: CHARACTER_8): EL_CHARACTER_8
		do
			Result := Character_8
			Result.set_item (c)
		end

	comma: EL_CHARACTER_8
		do
			Result := char (',')
		end

	dot: EL_CHARACTER_8
		do
			Result := char ('.')
		end

	hyphen: EL_CHARACTER_8
		do
			Result := char ('-')
		end

	new_line: EL_CHARACTER_8
		do
			Result := char ('%N')
		end

	space: EL_CHARACTER_8
		do
			Result := char (' ')
		end

	tab: EL_CHARACTER_8
		do
			Result := char ('%T')
		end

feature {NONE} -- Constants

	Character_8: EL_CHARACTER_8
		once
			create Result
		end

end