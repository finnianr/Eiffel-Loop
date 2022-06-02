note
	description: "Shared instance of object [$source EL_IMAGE_UTILS_API]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-02 14:50:19 GMT (Thursday 2nd June 2022)"
	revision: "7"

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