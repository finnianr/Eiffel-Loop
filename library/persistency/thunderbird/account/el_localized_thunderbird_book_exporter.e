note
	description: "[
		Merge localized folder of emails into a single HTML book with chapter numbers
		and titled derived from subject line.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 11:19:09 GMT (Wednesday 17th October 2018)"
	revision: "2"

class
	EL_LOCALIZED_THUNDERBIRD_BOOK_EXPORTER

inherit
	EL_LOCALIZED_THUNDERBIRD_ACCOUNT_READER

create
	make_from_file

feature {NONE} -- Implementation

	new_reader: EL_THUNDERBIRD_BOOK_EXPORTER
		do
			create Result.make (Current)
		end

end
