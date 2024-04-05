note
	description: "[
		Convert instances of ${ZSTRING} to and from ${STRING_32} or ${STRING_8}.
	]"
	notes: "[
		The necessity of these routines is because the routine ${ZSTRING}.z_code 
		implements ${READABLE_STRING_GENERAL}.code and for a small number of characters
		the returned code is not the same as Unicode.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-05 14:07:58 GMT (Friday 5th April 2024)"
	revision: "6"

deferred class
	EL_STRING_GENERAL_ROUTINES

inherit
	EL_SHARED_CLASS_ID

feature {NONE} -- Implementation

	as_zstring (general: READABLE_STRING_GENERAL): ZSTRING
		do
			inspect Class_id.character_bytes (general)
				when 'X' then
					if attached {ZSTRING} general as zstr then
						Result := zstr
					end
			else
				Result := new_zstring (general)
			end
		end

	new_zstring (general: READABLE_STRING_GENERAL): ZSTRING
		do
			create Result.make_from_general (general)
		end

	to_unicode_general (general: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
		do
			inspect Class_id.character_bytes (general)
				when 'X' then
					if attached {EL_READABLE_ZSTRING} general as zstr then
						Result := zstr.to_general
					end
			else
				Result := general
			end
		ensure
			not_zstring: not attached {EL_READABLE_ZSTRING} Result
		end
end