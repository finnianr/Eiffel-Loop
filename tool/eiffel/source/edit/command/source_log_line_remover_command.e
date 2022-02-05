note
	description: "[
		Comment out logging lines in eiffel source specified by ''manifest''
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 12:47:50 GMT (Saturday 5th February 2022)"
	revision: "1"

class
	SOURCE_LOG_LINE_REMOVER_COMMAND

inherit
	SOURCE_MANIFEST_EDITOR_COMMAND

feature -- Constants

	Description: STRING = "Comment out logging lines from Eiffel source code tree"

feature {NONE} -- Implementation

	new_editor: LOG_LINE_COMMENTING_OUT_SOURCE_EDITOR
		do
			create Result.make
		end
end