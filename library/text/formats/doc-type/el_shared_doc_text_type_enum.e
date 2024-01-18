note
	description: "Shared instance of ${EL_DOC_TEXT_TYPE_ENUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-24 15:21:14 GMT (Sunday 24th December 2023)"
	revision: "1"

deferred class
	EL_SHARED_DOC_TEXT_TYPE_ENUM

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Text_type: EL_DOC_TEXT_TYPE_ENUM
		once
			create Result.make
		end
end