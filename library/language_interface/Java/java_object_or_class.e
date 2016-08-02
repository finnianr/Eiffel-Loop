note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-30 18:08:23 GMT (Thursday 30th June 2016)"
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

feature {NONE} -- Unimplemented

	obsolete_object_method (mid: POINTER; args: detachable JAVA_ARGS): JAVA_OBJECT
		require else
			never_called: False
		do
		end

	obsolete_object_attribute (fid: POINTER): JAVA_OBJECT
		require else
			never_called: False
		do
		end
end