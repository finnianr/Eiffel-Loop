note
	description: "Gnome setting command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-02 14:40:10 GMT (Thursday 2nd December 2021)"
	revision: "7"

deferred class
	EL_GNOME_SETTING_COMMAND

inherit
	EL_COMMAND

feature -- Access

	schema_name: STRING

feature {NONE} -- Constants

	Gsettings: STRING = "gsettings"

end