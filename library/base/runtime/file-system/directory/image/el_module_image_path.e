note
	description: "Module image path"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 8:54:02 GMT (Monday 1st July 2019)"
	revision: "7"

deferred class
	EL_MODULE_IMAGE_PATH

inherit
	EL_MODULE

feature {NONE} -- Constants

	Image_path: EL_IMAGE_PATH_ROUTINES
			--
		once
			create Result
		end

end
