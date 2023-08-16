note
	description: "Character constants that be multiplied as a [$source STRING_8] instance with * operator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-14 13:13:44 GMT (Monday 14th August 2023)"
	revision: "22"

deferred class
	EL_CHARACTER_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Dot: EL_CHARACTER_8
		once
			Result := '.'
		end

	Hyphen: EL_CHARACTER_8
		once
			Result := '-'
		end

	Comma: EL_CHARACTER_8
		once
			Result := ','
		end

	New_line: EL_CHARACTER_8
		once
			Result := '%N'
		end

	Space: EL_CHARACTER_8
		once
			Result := ' '
		end

	Tab: EL_CHARACTER_8
		once
			Result := '%T'
		end

	Underscore: EL_CHARACTER_8
		once
			Result := '_'
		end

end