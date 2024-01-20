note
	description: "[
		Convert ${ZSTRING} to ${READABLE_STRING_GENERAL} as ${STRING_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "5"

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
				create Result.make_from_general (general)
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