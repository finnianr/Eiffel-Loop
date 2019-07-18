note
	description: "Module tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:11:39 GMT (Monday 1st July 2019)"
	revision: "6"

deferred class
	EL_MODULE_TAG

inherit
	EL_MODULE

feature {NONE} -- Constants

	Tag: EL_ID3_TAGS
		once
			create Result
		end

end
