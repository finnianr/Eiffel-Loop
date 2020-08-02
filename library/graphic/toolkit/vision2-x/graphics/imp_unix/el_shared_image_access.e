note
	description: "Shared access to routines of [$source EL_IMAGE_ACCESS_IMP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-01 11:25:54 GMT (Saturday 1st August 2020)"
	revision: "2"

deferred class
	EL_SHARED_IMAGE_ACCESS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Image_access: EL_IMAGE_ACCESS_IMP
		-- Provides access to unexported image data
		once
			create Result.make
		end
end
