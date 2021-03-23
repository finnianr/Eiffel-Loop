note
	description: "Repository test publisher"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-22 18:40:34 GMT (Monday 22nd March 2021)"
	revision: "3"

class
	REPOSITORY_TEST_PUBLISHER

inherit
	REPOSITORY_PUBLISHER
		redefine
			new_ftp_protocol, ok_to_synchronize
		end

create
	make

feature -- Status query

	ok_to_synchronize: BOOLEAN
		do
			Result := True
		end

feature {NONE} -- Implementation

	new_ftp_protocol: FAUX_FTP_PROTOCOL
		do
			create Result.make_write (ftp_configuration)
		end

end