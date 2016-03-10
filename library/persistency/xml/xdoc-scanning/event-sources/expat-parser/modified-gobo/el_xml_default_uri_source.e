note
	description: "The source of an XML document that has been retrieved via an URI"

	library: "Gobo Eiffel XML Library"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

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
		end
	
end

