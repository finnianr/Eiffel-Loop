note
	description: "Summary description for {EL_DEFAULT_EROS_REQUEST_OBJECT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_EROS_DEFAULT_ARGUMENT

inherit
	EVOLICITY_SERIALIZEABLE_AS_XML
		rename
			make_default as make
		end

create
	make

feature {NONE} -- Evolicity

	getter_function_table: like getter_functions
			--
		do
			create Result
		end

	Template: STRING =
		--
	"[
		<?xml version="1.0" encoding="iso-8859-1"?>
		<default/>
	]"

end