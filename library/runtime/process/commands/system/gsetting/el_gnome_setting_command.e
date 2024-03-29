note
	description: "Gnome setting command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "8"

deferred class
	EL_GNOME_SETTING_COMMAND

inherit
	EL_COMMAND

feature -- Access

	schema_name: STRING

feature {NONE} -- Constants

	Gsettings: STRING = "gsettings"

end