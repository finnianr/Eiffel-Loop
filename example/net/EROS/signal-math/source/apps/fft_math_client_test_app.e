note
	description: "Installable version of [$source FOURIER_MATH_CLIENT_TEST_APP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-22 19:48:21 GMT (Saturday 22nd July 2023)"
	revision: "3"

class
	FFT_MATH_CLIENT_TEST_APP

inherit
	FOURIER_MATH_CLIENT_TEST_APP

	INSTALLABLE_EROS_SUB_APPLICATION

create
	make

feature {NONE} -- Installer constants

	Desktop_launcher: EL_DESKTOP_MENU_ITEM
		once
			Result := new_launcher ("fourier-client.png")
		end

	Desktop: EL_CONSOLE_APP_MENU_DESKTOP_ENV_I
			--
		once
			Result := new_console_app_menu_desktop_environment
			Result.set_command_line_options (<< Log_option.Name_logging, "duration 20" >>)
			Result.set_terminal_position (200, 400)
		end

end