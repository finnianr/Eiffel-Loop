note
	description: "The Python None object. Denoting the lack of value"
	author: "Daniel Rodriguez"
	file: "$Workfile: $"
	date: "$Date$"
	revision: "$Revision$"

class
	PYTHON_NONE

inherit
	PYTHON_OBJECT
		

create
	new_none,
	borrowed_none
	
feature -- Initialization

	new_none
			-- Initialize `Current' as a reference hold by Eiffel.
		do
			new (c_py_none)
		end
		
	borrowed_none
			-- Initialize `Current' as a reference hold by Python.
		do
			borrowed (c_py_none)
		end

invariant
	unique_ptr: py_obj_ptr = c_py_none

end -- class PYTHON_NONE
