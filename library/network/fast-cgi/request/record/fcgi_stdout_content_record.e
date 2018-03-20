note
	description: "Content record for writing content to web server"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-04 12:25:33 GMT (Sunday 4th March 2018)"
	revision: "1"

class
	FCGI_STDOUT_CONTENT_RECORD

inherit
	FCGI_STRING_CONTENT_RECORD
		export
			{NONE} read
		redefine
			write, default_create
		end

feature {NONE} -- Initialization

	default_create
		do
			Precursor
			create byte_content.make (0)
		end

feature -- Element change

	set_content (a_content: like content; start_index: INTEGER)
		require
			valid_start_index: a_content.count > 0 implies 1 <= start_index and start_index <= a_content.count
		do
			content := a_content; offset := start_index  - 1
		end

feature {FCGI_REQUEST_BROKER} -- Basic operations

	write (broker: FCGI_REQUEST_BROKER)
		require else
			header_is_stdout: broker.Header.is_stdout
		local
			l_area: like content.area
		do
			l_area := content.area
			set_padding_and_byte_count (broker.Header)
			check
				check_valid_offset_count: offset + byte_count <= content.count
			end
			byte_content.set_from_pointer (l_area.base_address + offset, byte_count)
			broker.socket.put_managed_pointer (byte_content, 0, byte_count)
		end

feature {NONE} -- Internal attributes

	byte_content: MANAGED_POINTER
end
