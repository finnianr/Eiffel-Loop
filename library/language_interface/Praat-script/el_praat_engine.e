note
	description: "Initializes and tears down the Praat analysis engine"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_PRAAT_ENGINE

inherit
	ARGUMENTS
		export
			{NONE} all
		end

	EL_MEMORY
		redefine
			dispose
		end

	EL_LOGGING

create
	make

feature {NONE} -- Initialization

	make
		-- Equivalent to function main in main_Praat.c up as far as the line in function praat_run:

		-- 		if (Melder_batch) {

		-- (Except for call to praat_setLogo)

		--| main_Praat.c
		--| int main (int argc, char *argv []) {
		--|		praat_setLogo (130, 130*0.66, logo);
		--|		praat_init ("Praat", argc, argv);
		--|		INCLUDE_LIBRARY (praat_uvafon_init)
		--|		praat_run ();
		--|		return 0;
		--|	}

		local
			c_praat_title, c_praat_arguments: ANY
		do
			c_praat_title := Praat_title.to_c
			c_praat_arguments := Praat_arguments.to_c
			c_praat_init ($c_praat_title, Praat_arguments.count, $c_praat_arguments)

			c_INCLUDE_LIBRARY_praat_uvafon_init
			c_praat_run

			create interpreter_internal
			interpreter_internal.set_item (
				c_interpreter_create (Default_pointer, Default_pointer)
			)

			create script_interpreter.make_from_pointer (interpreter_internal.item)
		end

feature -- Access

	script_interpreter: EL_PRAAT_INTERPRETER

feature -- Basic operations

	reset
			--
		do
			c_clear_error
			c_thing_forget ($interpreter_internal)
			interpreter_internal.set_item (
				c_interpreter_create (Default_pointer, Default_pointer)
			)
			create script_interpreter.make_from_pointer (interpreter_internal.item)
		end

feature {NONE} -- Disposal

	dispose
			--
		do
			log.enter ("dispose")
			c_thing_forget ($interpreter_internal)
			c_praat_exit (0)
			log.exit
		end

feature {NONE} -- Implementation

	Praat_arguments: ARRAY [POINTER]
			-- Arguments to satisfy praat_init
		local
			c_program_name, c_praat_script_name: ANY
		once
			c_program_name := argument_array.item (0).to_c
			c_praat_script_name := Praat_script_name.to_c
			Result := << $c_program_name,  $c_praat_script_name >>
		end

	Praat_title: STRING = "Praat"

	Praat_script_name: STRING = "eiffel.praat"
			-- Dummy script name to satisfy praat_init

	interpreter_internal: POINTER_REF
			-- Using a reference because we need to take the address of the pointer for disposal
			-- See Thing.h:
			-- #define forget(thing)  _Thing_forget ((Thing *) & (thing))

feature {NONE} -- C externals

	c_praat_init (title: POINTER; argc: INTEGER; argv: POINTER)
			-- void praat_init (const char *title, unsigned int argc, char **argv)

		external
			"C (const char *, unsigned int, char **) | <praat_script.h>"
		alias
			"praat_init"
		end

	c_INCLUDE_LIBRARY_praat_uvafon_init
			-- INCLUDE_LIBRARY (praat_uvafon_init)
		external
			"C inline use <praat.h>"
		alias
			"INCLUDE_LIBRARY (praat_uvafon_init)"
		end

	c_praat_run
			-- Does same initialization as in praat_run (up until interpreting the script)

			--| void praat_run (void)
		external
			"C () | <praat.h>"
		alias
			"praat_run"
		end

	c_praat_exit (exit_code: INTEGER)
			-- Does same clean up as in praat_exit but does not exit application

		external
			"C (int) | <praat.h>"
		alias
			"praat_exit"
		end

	c_interpreter_create (environment_name, editor_class: POINTER): POINTER
			-- Creates praat interpreter object

			--| Interpreter Interpreter_create (char *environmentName, Any editorClass)
		external
			"C (char*, Any): EIF_POINTER | <Interpreter.h>"
		alias
			"Interpreter_create"
		end

	c_thing_forget (ptr_to_praat_object_ptr: POINTER)
			-- Reclaims a Praat class object

			--| Takes a pointer to a pointer as an argument. See macro in Thing.h
			--| #define forget(thing)  _Thing_forget ((Thing *) & (thing))

			--| void _Thing_forget (Thing *me);
		external
			"C (Thing) | <Thing.h>"
		alias
			"_Thing_forget"
		end

	c_clear_error
			-- void Melder_clearError (void);
		external
			"C () | <Melder.h>"
		alias
			"Melder_clearError"
		end



end



