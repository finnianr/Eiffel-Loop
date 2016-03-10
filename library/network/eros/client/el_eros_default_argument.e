note
	description: "Summary description for {EL_DEFAULT_EROS_REQUEST_OBJECT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-03-11 17:44:43 GMT (Wednesday 11th March 2015)"
	revision: "3"

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
