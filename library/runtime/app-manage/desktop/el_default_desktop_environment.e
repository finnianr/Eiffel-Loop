note
	description: "Default desktop environment"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-24 10:16:16 GMT (Tuesday 24th September 2024)"
	revision: "11"

class
	EL_DEFAULT_DESKTOP_ENVIRONMENT

inherit
	EL_DESKTOP_ENVIRONMENT_I

	EL_NEUTRAL_IMPLEMENTATION

create
	make_default

feature -- Basic operations

	install
			--
		do
		end

	uninstall
			--
		do
		end

feature {NONE} -- Implementation

	new_script_path (path: FILE_PATH): FILE_PATH
		do
			Result := path
		end

	set_app_compatibility (flags: STRING)
		-- set Windows registry compatibility mode flags Eg. ~WIN7RTM
		do
		end

feature {NONE} -- Constants

	Command_args_template: STRING = "none"

end