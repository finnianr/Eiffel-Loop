note
	description: "Java object or class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

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