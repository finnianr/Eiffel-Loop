note
	description: "Shared instance of [$source EROS_STOCK_PIXMAPS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 8:07:46 GMT (Thursday 16th June 2022)"
	revision: "12"

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