note
	description: "Eros default argument"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
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