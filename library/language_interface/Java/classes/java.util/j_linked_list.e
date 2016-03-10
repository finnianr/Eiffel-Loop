note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2011-07-24 9:48:02 GMT (Sunday 24th July 2011)"
	revision: "1"

class
	J_LINKED_LIST

inherit
	JAVA_UTIL_JPACKAGE

	J_OBJECT
		undefine
			Jclass, Package_name
		end

create
	make, default_create, make_from_java_method_result

feature -- Element change

	remove_first: J_OBJECT
			--
		do
			log.enter ("remove_first")
			Result := jagent_remove_first.item (Current, [])
			log.exit
		end

	add_last_string (string: J_STRING)
			--
		do
			add_last (string)
		end

	add_last (obj: J_OBJECT)
			--
		do
			log.enter ("add_last")
			jagent_add_last.call (Current, [obj])
			log.exit
		end

feature -- Status query

	is_empty: J_BOOLEAN
			--
		do
			log.enter ("is_empty")
			Result := jagent_is_empty.item (Current, [])
			log.exit
		end

feature {NONE} -- Implementation

	jagent_remove_first: JAVA_FUNCTION [J_LINKED_LIST, J_OBJECT]
			--
		once
			create Result.make ("removeFirst", agent remove_first)
		end

	jagent_add_last: JAVA_PROCEDURE [J_LINKED_LIST]
			--
		once
			create Result.make ("addLast", agent add_last)
		end

	jagent_is_empty: JAVA_FUNCTION [J_LINKED_LIST, J_BOOLEAN]
			--
		once
			create Result.make ("isEmpty", agent is_empty)
		end

feature {NONE} -- Constant

	Jclass: JAVA_CLASS_REFERENCE
			--
		once
			create Result.make (Package_name, "LinkedList")
		end

end -- class J_LINKED_LIST
