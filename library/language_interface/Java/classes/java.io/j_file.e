note
	description: "J file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-13 10:14:25 GMT (Saturday 13th March 2021)"
	revision: "5"

class
	J_FILE

inherit
	J_OBJECT
		undefine
			Package_name
		end

	JAVA_IO_JPACKAGE

create
	default_create,
	make, make_from_pointer,
	make_from_java_method_result, make_from_java_attribute, make_from_path

feature {NONE} -- Initialization

	make_from_path (s: J_STRING)
			--
		do
			make_from_pointer (Jagent_make_from_path.java_object_id (Current, [s]))
		end

feature -- Basic operations

	delete_on_exit
		-- Requests that the file or directory denoted by this abstract pathname be deleted
		-- when the virtual machine terminates.
		do
			Jagent_delete_on_exit.call (Current, [])
		end

feature {NONE} -- Implementation

	Jagent_delete_on_exit: JAVA_PROCEDURE
		once
			create Result.make ("deleteOnExit", agent delete_on_exit)
		end

	Jagent_make_from_path: JAVA_CONSTRUCTOR
			--
		once
			create Result.make (agent make_from_path)
		end

end