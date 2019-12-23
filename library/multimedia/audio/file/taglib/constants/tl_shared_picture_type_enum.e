note
	description: "Tl shared picture type enum"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-22 13:27:04 GMT (Sunday 22nd December 2019)"
	revision: "1"

deferred class
	TL_SHARED_PICTURE_TYPE_ENUM

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Picture_type: TL_PICTURE_TYPE_ENUM
		once
			create Result.make
		end
end
