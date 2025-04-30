note
	description: "[
		Notion of a table with ${IMMUTABLE_STRING_8} keys that are translateable from a foreign format
		by an object conforming to ${EL_NAME_TRANSLATER}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-30 10:18:21 GMT (Wednesday 30th April 2025)"
	revision: "1"

deferred class
	EL_TRANSLATEABLE_KEY_TABLE

inherit
	EL_SHARED_IMMUTABLE_8_MANAGER

feature {NONE} -- Implementation

	translated_key (foreign_name: READABLE_STRING_GENERAL): IMMUTABLE_STRING_8
		local
			l_result: STRING_8
		do
			if attached translater as l_translater then
				l_result := l_translater.imported_general (foreign_name)
			else
				l_result := foreign_name.as_string_8
			end
			Result := Immutable_8.as_shared (l_result)
		end

feature {NONE} -- Internal attributes

	translater: detachable EL_NAME_TRANSLATER
		-- name translater
		deferred
		end

end