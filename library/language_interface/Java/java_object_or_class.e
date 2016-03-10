note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2011-07-24 9:48:03 GMT (Sunday 24th July 2011)"
	revision: "1"

deferred class
	JAVA_OBJECT_OR_CLASS

inherit
	JAVA_ENTITY
		rename
			object_method as obsolete_object_method,
			object_attribute as obsolete_object_attribute
		end

feature -- Access

	object_method (mid: POINTER; args: JAVA_ARGS): POINTER
			-- Call an instance function that returns a java pointer
		deferred
		end

	object_attribute (fid: POINTER): POINTER
			--
		deferred
		end

feature {NONE} -- Obsolete

	obsolete_object_method (mid: POINTER; args: JAVA_ARGS): OBSOLETE_JAVA_OBJECT

		obsolete "class OBSOLETE_JAVA_OBJECT is not used in Java Eiffel Tango"
		do
		end

	obsolete_object_attribute (fid: POINTER): OBSOLETE_JAVA_OBJECT

		obsolete "class OBSOLETE_JAVA_OBJECT is not used in Java Eiffel Tango"
		do
		end

end -- class JAVA_OBJECT_OR_CLASS
