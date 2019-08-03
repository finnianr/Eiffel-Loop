note
	description: "Module geographic"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-03 18:02:39 GMT (Saturday 3rd August 2019)"
	revision: "1"

deferred class
	EL_MODULE_GEOGRAPHIC

inherit
	EL_MODULE

feature {NONE} -- Constants

	Geographic: EL_GEOGRAPHIC
		once
			create Result.make (17)
		end
end
