note
	description: "Selects between commands avconv and ffmpeg depending on what's installed"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	EL_AVCONV_OS_COMMAND_I

inherit
	EL_OS_COMMAND_I

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["command_name", agent: ZSTRING do Result := command_name end]
			>>)
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
			Result := Execution_environment.executable_search_list.has_executable (Avconv_command)
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