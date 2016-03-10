note
	description: "An instace of a Python interpreter"
	author: "Daniel Rodríguez"
	file: "$Workfile: $"
	date: "$Date$"
	revision: "$Revision$"

class
	PYTHON_INTERPRETER

inherit
	PYTHON_API

create
	initialize

feature -- Initialization

	initialize
			-- Initialize  a Python interpreter.
			-- This initializes the table of loaded modules,
			-- and creates the fundamental modules __builtin__ , __main__ , sys and exceptions.
			-- It also initializes the module search path (sys.path).
			-- No effect if ran twice
		do
			c_py_initialize
			namespace := main_module.dict
		ensure
			initialized: is_initialized
		end

	finalize
			-- Finalize the Python interpretator
		require
			initialized: is_initialized
		local
			retried: BOOLEAN
		do
			if not retried then
				c_py_finalize
			end
			namespace := Void
		rescue
			retried := True
			retry
		end


feature -- Access

	namespace: PYTHON_DICTIONARY
			-- Local namespace for the interpreter

	modules: PYTHON_DICTIONARY
			-- Return the dictionary used by the module administration (a.k.a. sys.modules).
			-- Note that this is a per-interpreter variable.
		require
			initialized: is_initialized
		do
			create Result.borrowed (c_py_import_get_module_dict)
		end

	module (n: STRING): PYTHON_MODULE
			-- Module named `n'
		require
			n_not_void: n /= Void
			initialized: is_initialized
			module_exists: modules.has_string (n)
		do
			Result ?= modules.item_at_string (n)
		ensure
			result_not_void: Result /= Void
		end


	main_module: PYTHON_MODULE
			-- "__main__" module
		require
			initialized: is_initialized
		do
			Result := module (main_module_name)
		end

	main_symbols: DS_HASH_TABLE [PYTHON_OBJECT, STRING]
			-- Defined symbols in "__main__"
		require
			initialized: is_initialized
		do
			Result := main_module.dict.hash_table
		end

	value (s: STRING): PYTHON_OBJECT
			-- Value of variable represented by the symbol `s' in "__main__"
		require
			s_not_void: s /= Void
			initialized: is_initialized
			symbol_exists: has_symbol (s)
		do
			Result := main_module.dict.item_at_string (s)
		end

	last_imported: PYTHON_MODULE
			-- Last imported Python module

	last_exception: STRING
			-- Last exceptions text

feature -- Status report

	is_initialized: BOOLEAN
			-- Is `Current' initialized?
		do
			Result := c_py_is_initialized = 1
		end

	has_symbol (s: STRING): BOOLEAN
			-- Is there a symbol `s' in `main_symbols'?
		require
			s_not_void: s/= Void
			initialized: is_initialized
		do
			Result := main_module.dict.has_string (s)
		end

	print_errors: BOOLEAN
			-- Shuld errors be printed in stderr?

feature -- Status setting

	set_print_errors (f: BOOLEAN)
			-- Enable or disable error printing to stderr.
		do
			print_errors := f
		end


feature -- Status setting

	set_namespace (d: PYTHON_DICTIONARY)
			-- Set namepace for executing programs to `d'. Add "__builtins__" if necessary.
		require
			d_not_void: d /= Void
			initialized: is_initialized
		do
			if not d.has_string ("__builtins__") then
				d.set_string_item ("__builtins__", value ("__builtins__") )
			end
			namespace := d
		end

	attach_symbol (s: STRING; v: PYTHON_OBJECT)
			-- Attach symbol `s' to the value represented by the Python object `v'.
		require
			s_not_void: s /= Void
			v_not_Void: s /= Void
			initialized: is_initialized
		do
			namespace.set_string_item (s, v)
		ensure
			symbol_in_namespace: namespace.has_string (s)
		end


feature -- Basic routines

	run_program (s: STRING): INTEGER
			-- Execute `s' as a Python program in the scope of `namespace'
			-- Returns 0 on success or -1 if an exception was raised by Python.
		require
			s_not_void: s /= Void
			initialized: is_initialized
		local
			o: PYTHON_OBJECT
			retried: BOOLEAN
		do
			if not retried then
				o := run_string (s,namespace)
				namespace := main_module.dict
				Result := 0
			else
				Result := -1
			end
		rescue
			retried := True
			c_py_err_clear
			retry
		end

	 run_program_file (s: STRING): INTEGER
			--  Execute the Python program in the file s.
		require
			s_not_void: s /= void
			file_exists: file_exists (s)
    		initialized: is_initialized
		local
			f: KL_TEXT_INPUT_FILE
			c: INTEGER
			buff: STRING
		do
			create f.make (s)
			c := f.count
			create buff.make (c + 1)
			buff.fill_blank
			f.open_read
			c := f.read_to_string (buff, 1, c)
			f.close
			Result := run_program (buff)
		end


	evaluate_expression (s: STRING): PYTHON_OBJECT
			-- Evaluate expression `s' in the scope of `namespace'.
			-- Returns a `Void' if an exception was raised by Python.
		local
			retried: BOOLEAN
		do
			if not retried then
				Result := evaluate_string (s, namespace)
				namespace := main_module.dict
			end
		rescue
			retried := True
			-- c_py_err_clear
			last_exception := ocurred_python_exception
			c_py_err_print
			c_py_err_clear
			retry
		end

	import_module (s: STRING)
			-- Import the module named `s' and add it to the current namespace.
		require
			s_not_void: s /= Void
		local
			p: POINTER
		do
			p := c_py_import_import_module (s2p (s))
			if p /= default_pointer then
				last_imported ?= new_python_object (p)
				attach_symbol (s, last_imported)
			else
				last_exception := ocurred_python_exception
				c_py_err_print
				raise (last_exception)
			end
		ensure
			module_in_namespace: namespace.has_string (s)
		end


feature {NONE}-- Implementation

	run_string (s: STRING; d: PYTHON_DICTIONARY): PYTHON_OBJECT
			-- Execute `s' as a python program in the context of the dictionary `d'
			-- Returns a PYTHON_OBJECT on success or a `Void' if an exception was raised by Python.
		require
			s_not_void: s /= Void
			d_not_void: d /= Void
			d_has_builtins: d.has_string ("__builtins__")
		local
			p: POINTER
		do
			p := c_py_run_string (s2p (s), c_py_file_input, d.py_obj_ptr, d.py_obj_ptr)
			if p = default_pointer then
				last_exception := ocurred_python_exception
				if print_errors then
					c_py_err_print
				end
				raise (last_exception)
			else
				Result := new_python_object (p)
			end
		end

	evaluate_string (s: STRING; d: PYTHON_DICTIONARY): PYTHON_OBJECT
			-- Evaluate `s' as a python expression in the context of the dictionary `d'
			-- Returns the result of the evaluation on success. Raises an exception if an exception was raised by Python.
		require
			s_not_void: s /= Void
			d_not_void: d /= Void
			d_has_builtins: d.has_string ("__builtins__")
		local
			p: POINTER
		do
			p := c_py_run_string (s2p (s), c_py_eval_input, d.py_obj_ptr, d.py_obj_ptr)
			if p = default_pointer then
				last_exception := ocurred_python_exception
				if print_errors then
					c_py_err_print
				end
				raise (last_exception)
			else
				Result := new_python_object (p)
			end
		end

	run_simple_string (s: STRING): INTEGER
			-- Execute `s' as a python program in the "__main__ module.
			-- Returns 0 on success or -1 if an exception was raised by Python.
		require
			s_not_void: s /= Void
			initialized: is_initialized
		do
			Result := c_py_run_simple_string (s2p (s))
		end

	run_simple_file (f: PLAIN_TEXT_FILE): INTEGER
			-- Executes the file `f' as a python program the "__main__ module.
			-- Returns 0 on success or -1 if an exception was raised by Python.
		require
			f_not_void: f /= Void
			exists: f.exists
			is_closed: f.is_closed
			initialized: is_initialized
		do
			f.open_read
			Result := c_py_run_simple_file (f.file_pointer, s2p (f.name))
			f.close
		ensure
			closed: f.is_closed
		end

feature -- Implementation (public)

		file_exists (s: STRING): BOOLEAN
				--
			local
				f: KL_BINARY_INPUT_FILE
			do
				create f.make (s)
				Result := f.exists
			end

invariant
	has_namespace: is_initialized implies namespace /= Void

end -- class PYTHON_INTERPRETER
