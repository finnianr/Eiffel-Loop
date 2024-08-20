note
	description: "[
		Character constants that be multiplied as a ${ZSTRING} instance with the * operator
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 13:27:35 GMT (Tuesday 20th August 2024)"
	revision: "4"

deferred class
	EL_CHARACTER_32_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	char (c: CHARACTER_32): EL_CHARACTER_32
		do
			Result := Character_32
			Result.set_item (c)
		end

	comma: EL_CHARACTER_32
		do
			Result := char (',')
		end

	dot: EL_CHARACTER_32
		do
			Result := char ('.')
		end

	hyphen: EL_CHARACTER_32
		do
			Result := char ('-')
		end

	new_line: EL_CHARACTER_32
		do
			Result := char ('%N')
		end

	space: EL_CHARACTER_32
		do
			Result := char (' ')
		end

	tab: EL_CHARACTER_32
		do
			Result := char ('%T')
		end

	underscore: EL_CHARACTER_32
		do
			Result := char ('_')
		end

feature {NONE} -- Constants

	Character_32: EL_CHARACTER_32
		once
			create Result
		end

end