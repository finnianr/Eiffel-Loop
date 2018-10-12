note
	description: "Book chapter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-12 17:00:42 GMT (Friday 12th October 2018)"
	revision: "1"

class
	EL_BOOK_CHAPTER

inherit
	EL_THUNDERBIRD_CONSTANTS

	EL_STRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (reader: EL_THUNDERBIRD_BOOK_EXPORTER)
		local
			subject: EL_ZSTRING_LIST
		do
			create subject.make_with_separator (reader.last_header.subject, '.', False)
			if subject.count > 1 and then subject.first.is_natural then
				number := subject.first.to_natural
				subject.start
				subject.remove
				title := subject.joined ('.')
			else
				title := reader.last_header.subject
			end
			create lines.make (reader.html_lines.count)
			lines.extend (Heading_template #$ [number, title])
		end

feature -- Access

	lines: EL_ZSTRING_LIST

	number: NATURAL

	title: ZSTRING

feature {NONE} -- Constants

	Heading_template: ZSTRING
		once
			Result := "    <h1>Chapter %S - %S</h1>"
		end

end
