note
	description: "Shared instance of [$source EROS_STOCK_PIXMAPS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "13"

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