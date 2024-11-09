note
	description: "Shared instance of ${EL_STRING_BUFFER_POOL [EL_ZSTRING_BUFFER]}"
	notes: "[
		Usage pattern:

			if attached String_pool.borrowed_item as borrowed loop
				if attached borrowed.empty as str then
					...
				end
				borrowed.return
			end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-08 9:04:47 GMT (Friday 8th November 2024)"
	revision: "2"

deferred class
	EL_SHARED_ZSTRING_BUFFER_POOL

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	String_pool: EL_STRING_BUFFER_POOL [EL_ZSTRING_BUFFER]
		once
			create Result.make (5)
		end
end