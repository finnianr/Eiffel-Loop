note
	description: "Python boolean objects"
	author: "Paul Cohen"
	file: "$Workfile: $"
	date: "$Date: 2008-01-08 08:25:22 +0100 (Tue, 08 Jan 2008) $"
	revision: "$Revision: 479 $"

class
	PYTHON_BOOLEAN

inherit
	PYTHON_OBJECT
		redefine
			py_type_ptr,
			to_eiffel_type
		end

create
	borrowed,
	new,
	from_boolean

feature -- Initialization

	from_boolean (bool: BOOLEAN)
			-- Initialize `Current' from eiffel INTEGER `i'.
		do
			new (c_py_bool_from_long (bool.to_integer))
		end

feature -- Access

	py_type_ptr: POINTER
			-- Python object pointer
		do
			Result := c_py_bool_type
		end

	boolean: BOOLEAN
			-- Eiffel BOOLEAN
		do
			Result := py_obj_ptr = c_py_true
		end

feature -- Conversion

	to_eiffel_type: ANY
			--
		do
			Result := boolean
		end


end -- class PYTHON_BOOLEAN
