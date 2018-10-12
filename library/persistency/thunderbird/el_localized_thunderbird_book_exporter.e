note
	description: "[
		Merge localized folder of emails into a single HTML book with chapter numbers
		and titled derived from subject line.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-12 14:13:09 GMT (Friday 12th October 2018)"
	revision: "1"

class
	EL_LOCALIZED_THUNDERBIRD_BOOK_EXPORTER

inherit
	EL_LOCALIZED_THUNDERBIRD_ACCOUNT_READER
		export
			{EL_COMMAND_CLIENT} make_from_file
		end

create
	make_from_file

feature {NONE} -- Implementation

	new_reader (a_output_dir: EL_DIR_PATH): EL_THUNDERBIRD_BOOK_EXPORTER
		do
			create Result.make (a_output_dir)
		end

feature {NONE} -- Constants

	Is_language_code_first: BOOLEAN = True

end
