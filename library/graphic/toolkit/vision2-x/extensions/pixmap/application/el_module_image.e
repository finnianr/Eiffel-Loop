note
	description: "Module image"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:18:55 GMT (Monday 12th November 2018)"
	revision: "6"

class
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
