note
	description: "Shared image utils api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:24:39 GMT (Monday 1st July 2019)"
	revision: "6"

deferred class
	EL_SHARED_IMAGE_UTILS_API

inherit
	EL_ANY_SHARED

feature -- Access

	Image_utils: EL_IMAGE_UTILS_API
		once
			create Result.make
		end
end
