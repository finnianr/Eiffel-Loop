note
	description: "[
		Convert [$source ZSTRING] to [$source READABLE_STRING_GENERAL] as [$source STRING_32]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-25 13:46:37 GMT (Saturday 25th November 2023)"
	revision: "3"

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
					if attached {ZSTRING} general as zstr then
						Result := zstr.to_general
					end
			else
				Result := general
			end
		end
end