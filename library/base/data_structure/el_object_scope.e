note
	description: "[
		Defines a scope in which the contents of a once object are temporarily replaced by the contents
		of another object of the same type.
	]"
	instructions: "[
		Usage Pattern:
		
			use_temporary_object
				do
					if attached temporary_scope as scope then
					-- do stuff
						scope.revert
					end
				end

			temporary_scope: EL_OBJECT_SCOPE [MY_CLASS]
				do
					create Result.make (Standard_object, Temporary_object)
				end
		
			Standard_object: MY_CLASS
				once
					create Result.make
				end

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-12-10 11:56:09 GMT (Tuesday 10th December 2024)"
	revision: "1"

class
	EL_OBJECT_SCOPE [G -> ANY create default_create end]

create
	make

feature {NONE} -- Initialization

	make (a_once_object, scope_object: G)
		require
			same_type: a_once_object.same_type (scope_object)
		do
			once_object := a_once_object
			create once_copy
			once_copy.standard_copy (a_once_object)
			a_once_object.standard_copy (scope_object)
		end

feature -- Basic operations

	revert
		-- revert `once_object' back to original state
		do
			once_object.standard_copy (once_copy)
		end

feature {NONE} -- Internal attributes

	once_object: G

	once_copy: G

end