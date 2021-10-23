note
	description: "Shared access to routines of class [$source EL_IMAGE_PATH_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-23 14:09:30 GMT (Saturday 23rd October 2021)"
	revision: "9"

deferred class
	EL_MODULE_IMAGE_PATH

inherit
	EL_MODULE

feature {NONE} -- Constants

	Image_path: EL_IMAGE_PATH_ROUTINES
			--
		once
			create Result.make
		end

end