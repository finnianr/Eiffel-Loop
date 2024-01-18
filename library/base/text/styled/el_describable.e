note
	description: "[
		Object that is describable by a ${EL_STYLED_TEXT_LIST} list of strings where each string is
		mapped to a text style defined by class ${EL_TEXT_STYLE}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 13:18:57 GMT (Thursday 17th August 2023)"
	revision: "9"

deferred class
	EL_DESCRIBABLE

feature -- Access

	text: EL_STYLED_TEXT_LIST [STRING_GENERAL]
		-- list of styled texts
		deferred
		end

end