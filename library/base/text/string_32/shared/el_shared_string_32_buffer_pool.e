note
	description: "Shared instance of ${EL_STRING_BUFFER_POOL [EL_STRING_32_BUFFER]}"
	notes: "[
		Usage pattern:

			if attached String_32_pool.borrowed_item as borrowed loop
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
	date: "2024-11-08 9:05:47 GMT (Friday 8th November 2024)"
	revision: "2"

deferred class
	EL_SHARED_STRING_32_BUFFER_POOL

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	String_32_pool: EL_STRING_BUFFER_POOL [EL_STRING_32_BUFFER]
		once
			create Result.make (5)
		end
end