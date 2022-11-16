note
	description: "Installable version of [$source FOURIER_MATH_SERVER_TEST_APP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	FFT_MATH_SERVER_TEST_APP

inherit
	FOURIER_MATH_SERVER_TEST_APP

	INSTALLABLE_EROS_SUB_APPLICATION
		redefine
			Name
		end

feature {NONE} -- Installer constants

	Desktop: EL_DESKTOP_ENVIRONMENT_I
			--
		once
			Result := new_console_app_menu_desktop_environment
			Result.set_command_line_options (<< Log_option.Name.Logging >>)
		end

	Desktop_launcher: EL_DESKTOP_MENU_ITEM
		once
			Result := new_launcher ("fourier-server-lite.png")
		end

	Name: ZSTRING
		once
			Result := "Fourier math server-lite"
		end

end