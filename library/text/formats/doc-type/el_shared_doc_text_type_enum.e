note
	description: "Shared instance of ${EL_DOC_TEXT_TYPE_ENUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "2"

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