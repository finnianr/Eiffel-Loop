note
	description: "[
		Object that is describeable by a [$source EL_STYLED_TEXT_LIST] list of strings where each string is
		mapped to a text style defined by class [$source EL_TEXT_STYLE].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-26 14:02:14 GMT (Friday 26th February 2021)"
	revision: "7"

deferred class
	EL_DESCRIBEABLE

feature -- Access

	text: EL_STYLED_TEXT_LIST [STRING_GENERAL]
		-- list of styled texts
		deferred
		end

end