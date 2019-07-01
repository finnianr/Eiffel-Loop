note
	description: "Module c decoder"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:10:14 GMT (Monday 12th November 2018)"
	revision: "6"

deferred class
	EL_MODULE_C_DECODER

inherit
	EL_MODULE

feature {NONE} -- Constants

	C_decoder: EL_C_DECODER
			--
		once
			create Result
		end

end
