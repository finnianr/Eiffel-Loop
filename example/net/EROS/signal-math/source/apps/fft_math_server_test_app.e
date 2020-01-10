note
	description: "Installable version of [$source FOURIER_MATH_SERVER_TEST_APP]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FFT_MATH_SERVER_TEST_APP

inherit
	FOURIER_MATH_SERVER_TEST_APP

	INSTALLABLE_EROS_SUB_APPLICATION
		redefine
			Name
		end

create
	make

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
