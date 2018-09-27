note
	description: "Module image path"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_MODULE_IMAGE_PATH

inherit
	EL_MODULE

feature -- Access

	Image_path: EL_IMAGE_PATH_ROUTINES
			--
		once
			create Result
		end

end