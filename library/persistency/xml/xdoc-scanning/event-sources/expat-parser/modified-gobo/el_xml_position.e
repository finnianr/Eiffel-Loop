note
	description: "Abstract definition of positions in XML documents"

	library: "Gobo Eiffel XML Library"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class EL_XML_POSITION

inherit

	ANY
		redefine
			out
		end

feature -- Access

	source: EL_XML_SOURCE
			-- Source from where position is taken
		deferred
		end

feature -- Output

	out: STRING
			-- Textual representation
		do
			Result := source.out
		end

invariant

	source_not_void: source /= Void

end

