note
	description: "Dictionary type in Python"
	author: "Daniel Rodriguez"
	date: "$Date$"
	file: "$Workfile:$"
	revision: "$Revision$"

class
	PYTHON_DICTIONARY

inherit
	PYTHON_OBJECT
		redefine
			py_type_ptr,
			to_eiffel_type
		end

create
	borrowed,
	new,
	new_empty

feature {NONE} -- Initialization

	new_empty
			-- Create a empty dictionary
		do
			new (c_py_dict_new)
		end

feature -- Access

	py_type_ptr: POINTER
			-- Python type object
		do
			Result := c_py_dict_type
		end

	size: INTEGER
			-- Key count
		do
			Result := c_py_dict_size (py_obj_ptr)
		end

	item_at (key: PYTHON_OBJECT): PYTHON_OBJECT
			-- Item associated with `key', if present
		require
			key_not_void: key /= Void
			exists: has (key)
		local
			r: POINTER
		do
			r := c_py_dict_get_item (py_obj_ptr, key.py_obj_ptr)
			if r /= default_pointer then
				Result := borrowed_python_object (r)
			end
		end

	item_at_string (key: STRING): PYTHON_OBJECT
			-- Item associated with string `key', if present
		require
			key_not_void: key /= Void
			exists: has_string (key)
		local
			a: ANY
			r: POINTER
		do
			a := key.to_c
			r := c_py_dict_get_item_string (py_obj_ptr, $a)
			if r /= default_pointer then
				Result := borrowed_python_object (r)
			end
		end

	keys: PYTHON_LIST
			-- Keys list
		do
			Result ?= new_python_object (c_py_dict_keys (py_obj_ptr))
		end

	hash_table: DS_HASH_TABLE [PYTHON_OBJECT, STRING]
			-- Representation of `Current' PYTHON_DICTIONARY as a HASH_TABLE
		local
			i: INTEGER
			o: PYTHON_OBJECT
			ps: PYTHON_STRING
			ks: PYTHON_LIST
			s: STRING
		do
			ks := keys
			create Result.make (size + 1)
			from
				i := 0
			until
				i >= size
			loop
				o := ks.item_at (i)
				if o.is_string then
					ps ?= o
					s := ps.string
				else
					s := o.str.string
				end
				Result.force (item_at (o), s)
				i := i + 1
			end
		end

feature -- Conversion

	to_eiffel_type: DS_HASH_TABLE [ANY, UC_STRING]
			-- Creates and returns a hash table of eiffel typed objects
			-- from this python dict. Each contained PYTHON_OBJECT
			-- item in this dict is converted using the to_eiffel_type		
		local
			i: INTEGER
			o: PYTHON_OBJECT
			ps: PYTHON_STRING
			ks: PYTHON_LIST
			s: STRING
			utils: UC_UNICODE_FACTORY
		do
			ks := keys
			create utils
			create Result.make (size + 1)
			from
				i := 0
			until
				i >= size
			loop
				o := ks.item_at (i)
				if o.is_string then
					ps ?= o
					s := ps.string
				else
					s := o.str.string
				end
				Result.force (item_at (o).to_eiffel_type, utils.new_unicode_string (s))
				i := i + 1
			end
		end

feature -- Status report

	has (key: PYTHON_OBJECT): BOOLEAN
			-- Is `key' in `keys'?
		require
			key_not_void: key /= Void
		local
			r: POINTER
		do
			r := c_py_dict_get_item (py_obj_ptr, key.py_obj_ptr)
			Result := r /= default_pointer
		end

	has_string (key: STRING): BOOLEAN
			-- Is string `kay' in `keys'?
		require
			key_not_void: key /= Void
		local
			r: POINTER
		do
			r := c_py_dict_get_item_string (py_obj_ptr, s2p (key))
			Result :=  r /= default_pointer
		end

feature -- Status setting

	set_string_item (s: STRING; o: PYTHON_OBJECT)
			-- Set item `o' with key `s'.
		require
			s_not_void: s /= Void
			o_not_void: o /= Void
		local
			r: INTEGER
		do
			r := c_py_dict_set_item_string (py_obj_ptr, s2p (s), o.py_obj_ptr)
		ensure
			exists: has_string (s)
		end

	delete_string_item (s: STRING)
			-- Set item `o' with key `s'.
		require
			s_not_void: s /= Void
		local
			r: INTEGER
		do
			r := c_py_dict_del_item_string (py_obj_ptr, s2p (s))
		ensure
			does_not_exist: not has_string (s)
		end

	set_item (k, o: PYTHON_OBJECT)
			-- Set Item `o' with key `k'.
		require
			k_not_void: k /= Void
			o_not_void: o /= Void
		local
			r: INTEGER
		do
			r := c_py_dict_set_item (py_obj_ptr, k.py_obj_ptr, o.py_obj_ptr)
		ensure
			exists: has (o)
		end

invariant
	right_object: is_dictionary

end -- class PYTHON_DICTIONARY
