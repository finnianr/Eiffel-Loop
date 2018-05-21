note
	description: "Shared image utils api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_SHARED_IMAGE_UTILS_API

feature -- Access

	Image_utils: EL_IMAGE_UTILS_API
		once
			create Result.make
		end
end