note
	description: "Path constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-24 12:18:45 GMT (Wednesday 24th November 2021)"
	revision: "10"

deferred class
	EL_PATH_CONSTANTS

inherit
	EL_SHARED_ZSTRING_CODEC

feature -- Constants

	Back_dir_step: ZSTRING
		once
			Result := "../"
		end

	Separator: CHARACTER_32
		once
			Result := Operating_environment.Directory_separator
		end

	Separator_z_code: NATURAL
		once
			Result := codec.as_z_code (Separator)
		end

	Unix_separator: CHARACTER_32 = '/'

	Windows_separator: CHARACTER_32 = '\'

end