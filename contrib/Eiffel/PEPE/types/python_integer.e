note
	description: "Python integer objects"
	author: "Daniel Rodriguez"
	file: "$Workfile: $"
	date: "$Date$"
	revision: "$Revision$"

class
	PYTHON_INTEGER

inherit
	PYTHON_OBJECT
		redefine
			py_type_ptr,
			to_eiffel_type
		end
	
create
	borrowed,
	new,
	from_integer
	
feature -- Initialization

	from_integer (i: INTEGER)
			-- Initialize `Current' from eiffel INTEGER `i'.
		do
			new (c_py_int_from_long (i))
		end
		
feature -- Access

	py_type_ptr: POINTER
			-- Python object pointer
		do
			Result := c_py_int_type
		end
		
	integer: INTEGER
			-- Eiffel INTEGER
		do
			Result := c_py_int_as_long (py_obj_ptr)
		end
		
feature -- Conversion

	to_eiffel_type: ANY
			-- Eiffel INTEGER
		do
			Result := integer
		end

end -- class PYTHON_INTEGER
