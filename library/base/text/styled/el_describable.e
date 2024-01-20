note
	description: "[
		Object that is describable by a ${EL_STYLED_TEXT_LIST} list of strings where each string is
		mapped to a text style defined by class ${EL_TEXT_STYLE}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "10"

deferred class
	EL_DESCRIBABLE

feature -- Access

	text: EL_STYLED_TEXT_LIST [STRING_GENERAL]
		-- list of styled texts
		deferred
		end

end