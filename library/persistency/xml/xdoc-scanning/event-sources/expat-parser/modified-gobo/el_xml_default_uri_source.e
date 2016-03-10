note
	description: "The source of an XML document that has been retrieved via an URI"

	library: "Gobo Eiffel XML Library"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
	revision: "3"

class EL_XML_DEFAULT_URI_SOURCE

inherit

	EL_XML_SOURCE

create
	make

feature {NONE} -- Initialization

	make (a_uri: STRING)
			-- Create a new URI.
		require
			a_uri_not_void: a_uri /= Void
		do
			uri := a_uri
		ensure
			uri_set: uri = a_uri
		end

feature -- Access

	uri: STRING
			-- URI for the source of the XML document

	out: STRING
			--
		do
			create Result.make_empty
		end

end

