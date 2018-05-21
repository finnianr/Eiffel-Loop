note
	description: "Module c decoder"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_MODULE_C_DECODER

inherit
	EL_MODULE

feature -- Access

	c_decoder: EL_C_DECODER
			--
		once
			create Result
		end

end