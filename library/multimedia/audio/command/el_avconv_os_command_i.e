note
	description: "Selects between commands avconv and ffmpeg depending on what's installed"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "9"

deferred class
	EL_AVCONV_OS_COMMAND_I

inherit
	EL_OS_COMMAND_I
		undefine
			getter_function_table, make_default, Transient_fields
		end

feature {NONE} -- Evolicity reflection

	command_name_assignment: TUPLE [STRING, FUNCTION [ANY]]
		do
			Result := ["command_name", agent: ZSTRING do Result := command_name end]
		end

feature {NONE} -- Implementation

	command_name: ZSTRING
		do
			if Has_avconv then
				Result := AVCONV_command
			else
				-- Compatible alternative? Maybe.
				Result := FFMPEG_command
			end
		end

feature {NONE} -- Constants

	Has_avconv: BOOLEAN
		once
			Result := Executable.search_path_has (Avconv_command)
		end

	AVCONV_command: ZSTRING
		once
			Result := "avconv"
		end

	FFMPEG_command: ZSTRING
		once
			Result := "ffmpeg"
		end
end