note
	description: "[
		Duplication of
		[https://www.eiffel.org/files/doc/static/16.05/libraries/vision2/ev_dialog_constants_chart.html EV_DIALOG_CONSTANTS]
		constants and renamed for the locale verification program
		[$source EL_CHECK_LOCALE_STRINGS_APP]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-12 10:41:52 GMT (Saturday 12th August 2017)"
	revision: "1"

class
	EL_DIALOG_CONSTANTS

feature -- Button Texts

	Eng_ok: STRING
			-- Text displayed on "ok" buttons.
		do
			Result := "OK"
		end

	Eng_open: STRING
			-- Text displayed on "open" buttons.
		do
			Result := "Open"
		end

	Eng_save: STRING
			-- Text displayed on "save" buttons.
		do
			Result := "Save"
		end

	Eng_print: STRING
			-- Text displayed on "print" buttons.
		do
			Result := "Print"
		end

	Eng_cancel: STRING
			-- Text displayed on "cancel" buttons.
		do
			Result := "Cancel"
		end

	Eng_yes: STRING
			-- Text displayed on "yes" buttons.
		do
			Result := "Yes"
		end

	Eng_no: STRING
			-- Text displayed on "no" buttons.
		do
			Result := "No"
		end

	Eng_abort: STRING
			-- Text displayed on "abort" buttons.
		do
			Result := "Abort"
		end

	Eng_retry: STRING
			-- Text displayed on "retry" buttons.
		do
			Result := "Retry"
		end

	Eng_ignore: STRING
			-- Text displayed on "ignore" buttons.
		do
			Result := "Ignore"
		end

feature -- Titles

	Eng_warning_dialog_title: STRING
			-- Title of EV_WARNING_DIALOG.
		do
			Result := "Warning"
		end

	Eng_question_dialog_title: STRING
			-- Title of EV_QUESTION_DIALOG.
		do
			Result := "Question"
		end

	Eng_information_dialog_title: STRING
			-- Title of EV_INFORMATION_DIALOG.
		do
			Result := "Information"
		end

	Eng_error_dialog_title: STRING
			-- Title of EV_ERROR_DIALOG.
		do
			Result := "Error"
		end

	Eng_confirmation_dialog_title: STRING
			-- Title of EV_CONFIRMATION_DIALOG.
		do
			Result := "Confirmation"
		end

end
