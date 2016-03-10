note
	description: "Summary description for {EL_UNIQUE_ARRAYED_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_UNIQUE_ARRAYED_LIST [G -> HASHABLE]

inherit
	ARRAYED_LIST [G]
		export
			{NONE} all
			{ANY} count, Extendible
		redefine
			make, extend
		end

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
			--
		do
			Precursor (n)
			create table.make (n)
		end

feature -- Element change

	extend (v: like item)
			--
		do
			table.put (count + 1, v)
			if not table.inserted then
				Precursor (v)
			end
		end

feature {NONE} -- Implementation

	table: EL_CODE_TABLE [G]

end
