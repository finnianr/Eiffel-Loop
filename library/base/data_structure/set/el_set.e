note
	description: "Abstract set of objects with membership test"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-04 14:46:25 GMT (Thursday 4th April 2024)"
	revision: "2"

deferred class
	EL_SET [G]

feature -- Status query

	has (v: G): BOOLEAN
		-- `True' if `v' is a member of set
		deferred
		end

note
	descendants: "[
			EL_SET* [G]
				${EL_NT_FILE_SYSTEM_ROUTINES}
				${EL_HASH_SET [H -> HASHABLE]}
					${EL_MEMBER_SET [G -> EL_SET_MEMBER [G]]}
					${EL_FIELD_NAME_SET}
				${EL_EIFFEL_CLASS_NAME_CHARACTER_SET}
					${EL_EIFFEL_TYPE_NAME_CHARACTER_SET}
						${EL_EIFFEL_TYPE_DEFINITION_CHARACTER_SET}
				${EL_EIFFEL_FIRST_LETTER_CHARACTER_SET}
					${EL_EIFFEL_IDENTIFIER_CHARACTER_SET}
	]"
end