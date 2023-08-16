note
	description: "Installable version of [$source FOURIER_MATH_SERVER_TEST_APP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-22 19:48:21 GMT (Saturday 22nd July 2023)"
	revision: "3"

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
			Result.set_command_line_options (<< Log_option.Name_logging >>)
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