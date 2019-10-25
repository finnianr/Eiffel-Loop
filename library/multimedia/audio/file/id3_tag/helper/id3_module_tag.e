note
	description: "Module tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-08 9:43:48 GMT (Tuesday   8th   October   2019)"
	revision: "7"

deferred class
	ID3_MODULE_TAG

inherit
	EL_MODULE

feature {NONE} -- Constants

	Tag: ID3_TAGS
		once
			create Result
		end

end
