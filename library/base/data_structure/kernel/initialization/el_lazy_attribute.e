note
	description: "Object attribute that is created only if it is needed"
	notes: "[
		This is a workaround for the fact that the following construct is buggy in ES version 16.05.9
		
			object: MY_CLASS
				once ("OBJECT")
					create Result
				end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-03 13:19:10 GMT (Monday 3rd August 2020)"
	revision: "1"

deferred class
	EL_LAZY_ATTRIBUTE

feature -- Access

	object: like new_object
		do
			if attached actual_object as obj then
				Result := obj
			else
				Result := new_object
				actual_object := Result
			end
		end

feature {NONE} -- Implementation

	new_object: ANY
		deferred
		end

	actual_object: detachable like new_object
end
