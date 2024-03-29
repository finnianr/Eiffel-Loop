note
	description: "Shared instance of ${EROS_STOCK_PIXMAPS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "14"

deferred class
	EROS_SHARED_PIXMAPS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Pixmaps: EROS_STOCK_PIXMAPS
		once
			Result := create {EL_SINGLETON [EROS_STOCK_PIXMAPS]}
		end

end