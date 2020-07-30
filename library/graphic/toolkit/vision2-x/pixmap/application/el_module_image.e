note
	description: "Module image"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:06:37 GMT (Monday 1st July 2019)"
	revision: "8"

deferred class
	EL_MODULE_IMAGE

inherit
	EL_MODULE

feature {NONE} -- Constants

	Image: EL_APPLICATION_IMAGE
			--
		once
			create Result
		end

end
