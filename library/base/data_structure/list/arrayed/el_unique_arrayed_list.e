note
	description: "List of unique hashable items"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-20 11:53:18 GMT (Tuesday 20th February 2018)"
	revision: "4"

class
	EL_UNIQUE_ARRAYED_LIST [G -> HASHABLE]

inherit
	EL_ARRAYED_LIST [G]
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

feature -- Status query

	inserted: BOOLEAN
		do
			Result := table.inserted
		end

feature -- Element change

	extend (v: like item)
			--
		do
			table.put (count + 1, v)
			if table.inserted then
				Precursor (v)
			end
		end

feature {NONE} -- Implementation

	table: EL_CODE_TABLE [G]

end
