note
	description: "Eiffel tinkering and minor experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-04 0:58:51 GMT (Sunday 4th November 2018)"
	revision: "34"

class EXPERIMENTS_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_HEXADECIMAL

	EL_MODULE_STRING_8

	EL_MODULE_COMMAND

	EL_MODULE_DIRECTORY

	EL_MODULE_EIFFEL

	EL_MODULE_OS

	SYSTEM_ENCODINGS
		rename
			Utf32 as Unicode,
			Utf8 as Utf_8
		export
			{NONE} all
		end

	EL_ZCODE_CONVERSION

create
	make

feature {NONE} -- Initialization

	initialize
		do
		end

feature -- Basic operations

	run
		do
			lio.enter ("abstract_increment")
			abstract_increment
			lio.exit
		end


feature -- Experiments

	abstract_increment
		local
			n: INTEGER_16; number: NUMERIC
		do
			n := 1
			number := n
			number := number + number.one
			lio.put_labeled_string ("number", number.out)
		end

	agent_polymorphism
		local
			append: PROCEDURE [READABLE_STRING_GENERAL]
			general: STRING_GENERAL
			str_8: STRING_8; str_32: STRING_32
		do
			create str_8.make_empty; create str_32.make_empty
			general := str_8
			append := agent general.append
			append ("abc")
			lio.put_string_field ("str_8", str_8)
			lio.put_new_line
			append.set_target (str_32)
			append ("abc")
			lio.put_string_field ("str_32", str_32)
			lio.put_new_line
		end

	alternative_once_naming
		do
			lio.put_line (Mime_type_template)
			lio.put_line (Text_charset_template)
		end

	assign_tuple_string
		local
			tuple: TUPLE [str: READABLE_STRING_GENERAL]
		do
			tuple := ["a"]
			tuple.str := {STRING_32} "b" -- Fails in version 16.05.9.8969 with catcall error. Reported as a bug
		end

	audio_info_parsing
		local
			s: ZSTRING; parts: EL_ZSTRING_LIST
		do
			s := "Stream #0.0(und): Audio: aac, 44100 Hz, stereo, fltp, 253 kb/s"
			create parts.make_with_separator (s, ',', True)
			across parts as part loop
				lio.put_string_field (part.cursor_index.out, part.item)
				lio.put_new_line
			end
		end

	boolean_ref
		local
			b1: BOOLEAN
			b1_ref, b2_ref: BOOLEAN
		do
			b1_ref := b1.to_reference
			b2_ref := not b1_ref
			lio.put_string ("b2_ref.item: ")
			lio.put_boolean (b2_ref.item)
		end

	char_compression
		local
			a_fold: ARRAY [CHARACTER]
			fold_i_m_1_i: NATURAL; i: INTEGER
		do
			io.put_string ("Constant: "); io.put_natural ((('W').natural_32_code |<< 8) | ('W').natural_32_code)
			a_fold := << 'N', 'W' >>
			i := 2
			inspect ((a_fold [i - 1]).natural_32_code |<< 8) | (a_fold [i]).natural_32_code
				when Dir_n_n then
				when Dir_n_w then
				when Dir_w_w then

				-- and so forth
			else
			end
		end

	circular_list_iteration
		local
			list: ARRAYED_CIRCULAR [INTEGER]
		do
			create list.make (3)
			across 1 |..| 3 as n loop
				list.extend (n.item)
			end
			list.do_all (agent (n: INTEGER)
				do
					lio.put_integer (n)
					lio.put_new_line
				end
			)
		end

	circular_removal
		local
			list: TWO_WAY_CIRCULAR [STRING]
		do
			create list.make
			list.extend ("a")
			list.extend ("b")
--			list.extend ("c")

			list.start
			list.remove
			list.start
			lio.put_string_field ("first item", list.item)
			lio.put_new_line
		end

	compare_tuple_types
		local
			t1: TUPLE [x, y: INTEGER]
			t2: TUPLE [STRING, INTEGER]
			t3: TUPLE [INTEGER]
			t4: TUPLE [STRING]
			t5: TUPLE [x1, y1: INTEGER]
		do
			create t1; t2 := ["", 1]; create t3; create t4; create t5


			across << t1, t2, t3, t4, t5, [1, 2] >> as tuple loop
				lio.put_integer_field (tuple.item.generator, tuple.item.generating_type.type_id)
				lio.put_new_line
			end
			-- t1 and t5 are same type
		end

	container_extension
		do
			extend_container (create {ARRAYED_LIST [EL_DIR_PATH]}.make (0))
		end

	date_time_duration
		local
			this_year, last_year, now: DATE_TIME; elapsed: EL_DATE_TIME_DURATION
			timer: EL_EXECUTION_TIMER
		do
			create this_year.make (2017, 6, 11, 23, 10, 10)
			create last_year.make (2016, 6, 11, 23, 10, 10)

			lio.put_integer_field ("Year days", this_year.relative_duration (last_year).date.day)
			lio.put_new_line

			create now.make_now
			elapsed := now.relative_duration (this_year)
			lio.put_labeled_string ("TIME", elapsed.out)
			lio.put_new_line

			create timer.make
			lio.put_labeled_string ("TIME", timer.elapsed_time.out)
			lio.put_new_line
			timer.start
			execution.sleep (500)
			timer.stop
			timer.resume
			execution.sleep (500)
			timer.stop
			lio.put_labeled_string ("TIME", timer.elapsed_time.out)
		end

	date_time_format
		local
			now: DATE_TIME; const: DATE_CONSTANTS
			day_text: ZSTRING
		do
			create const
			create now.make_now
			day_text := const.days_text.item (now.date.day_of_the_week)
			day_text.to_proper_case
			lio.put_labeled_string ("Time", day_text + now.formatted_out (", yyyy-[0]mm-[0]dd hh:[0]mi:[0]ss") + " GMT")
			lio.put_new_line
		end

	date_validity_check
		local
			checker: DATE_VALIDITY_CHECKER; str: STRING
		do
			create checker
			str := "2015-12-50"
			lio.put_labeled_string (str, checker.date_valid (str, "yyyy-[0]mm-[0]dd").out)
		end

	default_tuple_comparison
		do
			if ["one"] ~ ["one"] then
				lio.put_string ("is_object_comparison")
			else
				lio.put_string ("is_reference_comparison")
			end
		end

	type_default_create
		local
			key_pair: AIA_CREDENTIAL
		do
			key_pair := ({AIA_CREDENTIAL}).default
		end

	encode_string_for_console
		local
			str: STRING_32; str_2: STRING
		do
			across << System_encoding, Console_encoding, Utf_8, Iso_8859_1 >> as encoding loop
				lio.put_line (encoding.item.code_page)
			end
			str := {STRING_32} "Dún Búinne"
			Unicode.convert_to (Console_encoding, str)
			if Unicode.last_conversion_successful then
				str_2 := Unicode.last_converted_string_8
				io.put_string (str_2)
			end
		end

	equality_question
		local
			s1: STRING; s2: READABLE_STRING_GENERAL
			s1_equal_to_s2: BOOLEAN
		do
			s1 := "abc"; s2 := "abc"
			s1_equal_to_s2 := s1 ~ s2
			lio.put_labeled_string ("s1 is equal to s2", s1_equal_to_s2.out)
		end

	escaping_text
		do
			lio.put_string_field ("&aa&bb&", escaped_text ("&aa&bb&").as_string_8)
		end

	file_date_setting
		local
			file, file_copy: RAW_FILE
		do
			create file.make_open_read ("data\01.png")
			create file_copy.make_open_write ("data\01(copy).png")
			file.copy_to (file_copy)
			file.close; file_copy.close
			file_copy.stamp (1418308263)
		end

	file_position
		local
			file: PLAIN_TEXT_FILE
		do
			create file.make_open_write ("test.txt")
			file.put_string ("one two three")
			lio.put_integer_field ("file.position", file.position)
			file.close
			file.delete
		end

	file_stamp
		local
			file: PLAIN_TEXT_FILE
			date: DATE_TIME
		do
			create file.make_open_write ("data\file.txt")
			file.put_string ("hello"); file.close
--			file.add_permission ("u", "Write Attributes")
			create date.make_from_epoch (1418308263)
			lio.put_labeled_string ("Date", date.out)
			file.set_date (1418308263)
		end

	find_console_encoding
		local
			system: SYSTEM_ENCODINGS
			message: STRING_32
		do
			create system
			lio.put_string (system.console_encoding.code_page)
			lio.put_new_line
			message := "Euro sign: "
			message.append_code (0x20AC)
			lio.put_line (message)
		end

	find_directories
		local
			find_cmd: like Command.new_find_directories
		do
			find_cmd := Command.new_find_directories ("source")
			find_cmd.set_depth (1 |..| 1)
			find_cmd.execute
			across find_cmd.path_list as dir loop
				lio.put_path_field ("", dir.item)
				lio.put_new_line
			end
		end

	find_iteration_order_of_linked_queue
			--
		local
			queue: LINKED_QUEUE [INTEGER]
		do
			create queue.make
			queue.extend (1)
			queue.extend (2)
			queue.extend (3)
			queue.linear_representation.do_all (
				agent (n: INTEGER) do
					lio.put_integer (n)
					lio.put_new_line
				end
			)
		end

	finite_iteration
		local
			part_array: ARRAY [INTEGER]
			finite: FINITE [INTEGER]; list: LINEAR [INTEGER]
		do
			create part_array.make_filled (0, 3, 4)
			part_array [3] := 3
			part_array [4] := 4
			finite := part_array
			list := finite.linear_representation
			from list.start until list.after loop
				lio.put_integer_field (list.index.out, list.item)
				lio.put_new_line
				list.forth
			end
		end

	generic_type_check
		local
			list: LIST [STRING_GENERAL]
			type: TYPE [ANY]
		do
			create {EL_ZSTRING_LIST} list.make (0)
			type := list.generating_type.generic_parameter_type (1)
		end

	generic_types
		local
			type_8, type_32: TYPE [LIST [READABLE_STRING_GENERAL]]
		do
			type_8 := {ARRAYED_LIST [STRING]}
			type_32 := {ARRAYED_LIST [STRING_32]}
		end

	hash_table_reference_lookup
		local
			table: HASH_TABLE [INTEGER, STRING]
			one, two, three, four, five: STRING
			numbers: ARRAY [STRING]
		do
			one := "one"; two := "two"; three := "three"; four := "four"; five := "five"
			numbers := << one, two, three, four, five >>
			create table.make (5)
			across numbers as n loop
				table [n.item] := n.cursor_index
			end
			across numbers as n loop
				lio.put_integer_field (n.item, table [n.item])
				lio.put_new_line
			end
			across numbers as n loop
				n.item.wipe_out
			end
			across numbers as n loop
				lio.put_integer_field (n.item, table [n.item])
				lio.put_new_line
			end
		end

	hash_table_plus
		local
			table: EL_STRING_HASH_TABLE [INTEGER, STRING]
		do
			table := table + ["one", 1]
		end

	hash_table_removal
		local
			table: HASH_TABLE [STRING, INTEGER]
		do
			create table.make (10)
			across (1 |..| 10) as n loop
				table [n.item] := n.item.out
			end
			-- remove all items except number 1
			across table.current_keys as n loop
				if n.item = 5 then
					table.remove (n.item)
				end
			end
			across table as n loop
				lio.put_integer (n.key); lio.put_character (':'); lio.put_string (n.item)
				lio.put_new_line
			end
		end

	hexadecimal_to_natural_64
		do
			lio.put_string (Hexadecimal.to_natural_64 ("0x00000A987").out)
			lio.put_new_line
		end

	launch_remove_files_script
		local
			script: EL_FILE_PATH; file: PLAIN_TEXT_FILE
		do
--			script := "/tmp/eros removal.sh"
			script := Directory.temporary + "eros remove files.bat"
			create file.make_with_name (script)
			file.add_permission ("uog", "x")
			Execution_environment.launch ("call " + script.escaped)
		end

	make_directory_path
		local
			dir: EL_DIR_PATH; temp: EL_FILE_PATH
		do
			dir := "E:/"
			temp := dir + "temp"
			lio.put_string_field ("Path", temp.as_windows.to_string)
		end

	make_date
		local
			date_1, date_2, date_3: DATE_TIME; date_iso: EL_SHORT_ISO_8601_DATE_TIME
		do
			create date_1.make_from_string ("20171216113300", "yyyy[0]mm[0]dd[0]hh[0]mi[0]ss")
			create date_2.make_from_string ("2017-12-16 11:33:00", "yyyy-[0]mm-[0]dd [0]hh:[0]mi:[0]ss") -- Fails
			create date_iso.make ("20171216T113300Z")
			create date_3.make_from_string ("19:35:01 Apr 09, 2016", "[0]hh:[0]mi:[0]ss Mmm [0]dd, yyyy")
		end

	negative_integer_32_in_integer_64
			-- is it possible to store 2 negative INTEGER_32's in one INTEGER_64
		local
			n: INTEGER_64
		do
			n := ((10).to_integer_64 |<< 32) | -10
			lio.put_integer_field ("low", n.to_integer_32) -- yes you can
			lio.put_integer_field (" hi", (n |>> 32).to_integer_32) -- yes you can
		end

	once_order_test (a_first: BOOLEAN)
		local
--			a, b: A; c: CHARACTER
			a: A; b: B; c: CHARACTER
		do
--			create a; create {B} b
			create a; create b
			if a_first then
				c := a.character; c := b.character
			else
				c := b.character; c := a.character
			end

			lio.put_string ("a.character: " + a.character.out)
			lio.put_string (" b.character: " + b.character.out)
			lio.put_new_line
		end


	open_function_target
		local
			duration: FUNCTION [AUDIO_EVENT, REAL]
			event: AUDIO_EVENT
		do
			duration := agent {AUDIO_EVENT}.duration
			lio.put_string ("duration.is_target_closed: ")
			lio.put_boolean (duration.is_target_closed)
			lio.put_new_line
			lio.put_integer_field ("duration.open_count", duration.open_count)
			lio.put_new_line
			create event.make (1, 3)
			duration.set_operands ([event])
			duration.apply
			lio.put_double_field ("duration.last_result", duration.item ([event]))
		end

	print_os_user_list
		local
			dir_path: EL_DIR_PATH; user_info: like command.new_user_info
		do
			user_info := command.new_user_info
			across << user_info.configuration_dir_list, user_info.data_dir_list >> as dir_list loop
				across dir_list.item as dir loop
					lio.put_path_field ("", dir.item)
					lio.put_new_line
				end
			end
		end

	pointer_width
		local
			ptr: POINTER
		do
			ptr := $pointer_width
			lio.put_integer_field (ptr.out, ptr.out.count)
		end

	problem_with_function_returning_real_with_assignment
			--
		local
			event: AUDIO_EVENT
		do
			create event.make (1.25907 ,1.38513)
			lio.put_string ("Is threshold exceeded: ")
			if event.is_threshold_exceeded (0.12606) then
				lio.put_string ("true")
			else
				lio.put_string ("false")
			end
			lio.put_new_line
		end

	problem_with_function_returning_result_with_set_item
			-- if {AUDIO_EVENT}
		local
			event_list: LINKED_LIST [AUDIO_EVENT]
			event: AUDIO_EVENT
		do
			create event_list.make
			create event.make (1.25907 ,1.38513)
			event_list.extend (event)

			lio.put_real_field ("event_list.last.duration", event_list.last.duration)
			lio.put_new_line
		end

	procedure_call
		local
			procedure: PROCEDURE
		do
			procedure := agent log_integer (?, "n")
			procedure (2)
		end

	put_execution_environment_variables
		do
			Execution_environment.put ("sausage", "SSL_PW")
			Execution_environment.system ("echo Password: $SSL_PW")
		end

	random_sequence
			--
		local
			random: RANDOM; odd, even: INTEGER; time: TIME
		do
			create time.make_now
			create random.make
			random.set_seed (time.compact_time)
			lio.put_integer_field ("random.seed", random.seed)
			lio.put_new_line
			from  until random.index > 200 loop
				lio.put_integer_field (random.index.out, random.item)
				lio.put_new_line
				if random.item \\ 2 = 0 then
					even := even + 1
				else
					odd := odd + 1
				end
				random.forth
			end
			lio.put_new_line
			lio.put_integer_field ("odd", odd)
			lio.put_new_line
			lio.put_integer_field ("even", even)
			lio.put_new_line
		end

	real_rounding
		local
			r: REAL
		do
			r := ("795").to_real
			lio.put_integer_field ("(r * 100).rounded", (r * 100).rounded)
		end

	remove_from_list
		local
			my_list: TWO_WAY_LIST[INTEGER]
			i: INTEGER
		do
			create my_list.make
			from i := 1
			until i > 9
			loop
				my_list.extend (i)
				i := i + 1
			end
			print ("%NList contents: ")
			across my_list as m loop print (m.item.out + " ") end

			print ("%NRemoving item where contents = 3 within across")
			from my_list.start until my_list.exhausted loop
				my_list.prune (3)
			end
--			across my_list as m loop
--				if m.item.is_equal (3) then
--					my_list.go_i_th (m.cursor_index)
--					my_list.remove; my_list.back
--				end
--				print ("%Nloop number " + m.target_index.out)
--			end
			print ("%N(across loop is terminated after element removal)")
			print ("%N3 removed correctly, List contents: ")
			across my_list as m loop print (m.item.out + " ") end
			print ('%N')

		end

	replace_delimited_substring_general
		local
			email: ZSTRING
		do
			across << "freilly8@gmail.com", "finnian@gmail.com", "finnian-buyer@eiffel-loop.com" >> as address loop
				email := address.item
				lio.put_string (email)
				email.replace_delimited_substring_general ("finnian", "@eiffel", "", False, 1)
				lio.put_string (" -> "); lio.put_string (email)
				lio.put_new_line
			end
		end

	self_deletion_from_batch
		do
			Execution_environment.launch ("cmd /C D:\Development\Eiffel\Eiffel-Loop\test\uninstall.bat")
		end

	set_tuple_values
		local
			color: TUPLE [foreground, background: STRING_GENERAL]
		do
			create color
			color.foreground := "blue"
			color.put_reference ("red", 2)
			lio.put_labeled_string ("color.foreground", color.foreground)
			lio.put_new_line
			lio.put_labeled_string ("color.background", color.background)
			lio.put_new_line
		end

	string_to_integer_conversion
		local
			str: ZSTRING
		do
			str := ""
			lio.put_string ("str.is_integer: ")
			lio.put_boolean (str.is_integer)
		end

	substitute_template_with_string_8
		local
			type: STRING
		do
			type := "html"
			lio.put_string_field ("Content", Mime_type_template #$ [type, "UTF-8"])
			lio.put_new_line
			lio.put_string_field ("Content", Mime_type_template #$ [type, "UTF-8"])
		end

	substitution
		local
			template: EL_STRING_8_TEMPLATE
		do
			create template.make ("from $var := 1 until $var > 10 loop")
			template.set_variable ("var", "i")
			lio.put_line (template.substituted)
		end

	substitution_template
			--
		local
			l_template: EL_STRING_8_TEMPLATE
		do
			create l_template.make ("x=$x, y=$y")
			l_template.set_variable ("x", "100")
			l_template.set_variable ("y", "200")
			lio.put_line (l_template.substituted)
		end

	system_path
		do
			Execution_environment.system ("cp /home/finnian/Music/Foxtrot/Cristian\ Vasile/Saruta-Ma\!.01.mp3 ~/Desktop/Music")
		end

	test_has_repeated_hexadecimal_digit
		do
			lio.put_boolean (has_repeated_hexadecimal_digit (0xAAAAAAAAAAAAAAAA)); lio.put_new_line
			lio.put_boolean (has_repeated_hexadecimal_digit (0x1AAAAAAAAAAAAAAA)); lio.put_new_line
			lio.put_boolean (has_repeated_hexadecimal_digit (0xAAAAAAAAAAAAAAA1)); lio.put_new_line
		end

	time_input_formats
		local
			from_time, to_time: TIME; duration: TIME_DURATION
			format, from_str, to_str: STRING
		do
			format := "mi:ss.ff3"
--			from_str := "1:01.500"; to_str := "1:03.001"
			from_str := "0:05.452"; to_str := "5:34.49"
			if is_valid_time (from_str) and is_valid_time (to_str) then
				create from_time.make_from_string (from_str, format)
				create to_time.make_from_string (to_str, format)
				lio.put_labeled_string ("From", from_str); lio.put_labeled_string (" to", to_str)
				lio.put_new_line
				lio.put_labeled_string ("From", from_time.out); lio.put_labeled_string (" to", to_time.out)
				lio.put_new_line
				duration := to_time.relative_duration (from_time)
				lio.put_double_field ("Fine seconds", duration.fine_seconds_count)
			else
				lio.put_line ("Invalid time format")
			end
		end

	time_parsing
		local
			time_str, format: STRING; time: TIME
			checker: TIME_VALIDITY_CHECKER
		do
			time_str := "21:15"; format := "hh:mi"
			create checker
			if True or checker.time_valid (time_str, format) then
				create time.make_from_string (time_str, format)
			else
				create time.make (0, 0, 0)
			end
			lio.put_labeled_string ("Time", time.formatted_out ("hh:[0]mi"))
			lio.put_new_line
		end

	transient_fields
		local
			field_count, i: INTEGER
		do
			field_count := Eiffel.field_count (Current)
			from i := 1 until i > field_count loop
				lio.put_labeled_string (i.out, Eiffel.field_name (i, Current))
				lio.put_character (' '); lio.put_boolean (Eiffel.is_field_transient (i, Current))
				lio.put_new_line
				i := i + 1
			end
		end

	twin_tuple
		local
			t1, t2: TUPLE [name: STRING]
		do
			t1 := ["eiffel"]
			t2 := t1.deep_twin
		end

	twinning_procedures
		local
			action, action_2: PROCEDURE [STRING]
		do
			action := agent hello_routine
			action_2 := action.twin
			action_2.set_operands (["wonderful"])
			action_2.apply
		end

	tuple_creation_from_type
		local
			type: TYPE [TUPLE]
		do
			type := {TUPLE [INTEGER, STRING]}
			lio.put_integer_field ("generic_parameter_count", type.generic_parameter_count)
			lio.put_labeled_string (" generic_parameter_type [1]", type.generic_parameter_type (1).name)
		end

	type_id_comparison
		local
			list: ARRAYED_LIST [STRING]
			list_integer: ARRAYED_LIST [INTEGER]
		do
			create list.make (0)
			create list_integer.make (0)
			lio.put_integer_field ("type_id", ({ARRAYED_LIST [STRING]}).type_id)
			lio.put_integer_field (" dynamic_type", Eiffel.dynamic_type (list))
			lio.put_integer_field (" dynamic_type list_integer", Eiffel.dynamic_type (list_integer))
			lio.put_new_line
			lio.put_integer_field ("({EL_MAKEABLE_FROM_STRING [ZSTRING]}).type_id", ({EL_MAKEABLE_FROM_ZSTRING}).type_id)
			lio.put_new_line
			lio.put_integer_field ("({EL_MAKEABLE_FROM_STRING [STRING_GENERAL]}).type_id", ({EL_MAKEABLE_FROM_STRING_GENERAL}).type_id)
		end

	type_conformance_test
		do
		end

	url_string
		local
			str: EL_URL_STRING_8
		do
			create str.make_empty
			str.append_general ("freilly8@gmail.com")
		end

feature {NONE} -- Implementation

	escaped_text (s: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
			-- `text' with doubled ampersands.
		local
			n, l_count: INTEGER; l_amp_code: NATURAL_32; l_string_32: STRING_32
		do
			l_amp_code := ('&').code.as_natural_32
			l_count := s.count
			n := s.index_of_code (l_amp_code, 1)

			if n > 0 then
					-- There is an ampersand present in `s'.
					-- Replace all occurrences of "&" with "&&".
					--| Cannot be replaced with `{STRING_32}.replace_substring_all' because
					--| we only want it to happen once, not forever.
				from
					create l_string_32.make (l_count + 1)
					l_string_32.append_string_general (s)
				until
					n > l_count
				loop
					n := l_string_32.index_of_code (l_amp_code, n)
					if n > 0 then
						l_string_32.insert_character ('&', n)
							-- Increase count local by one as a character has been inserted.
						l_count := l_count + 1
						n := n + 2
					else
						n := l_count + 1
					end
				end
				Result := l_string_32
			else
				Result := s
			end
		ensure
			ampersand_occurrences_doubled: Result.as_string_32.occurrences ('&') =
				(old s.twin.as_string_32).occurrences ('&') * 2
		end

	extend_container (container: LIST [EL_PATH])
		do
			container.extend (Directory.current_working)
		end

	has_repeated_hexadecimal_digit (n: NATURAL_64): BOOLEAN
		local
			first, hex_digit: NATURAL_64
			i: INTEGER
		do
			first := n & 0xF
			hex_digit := first
			from i := 1 until hex_digit /= first or i > 15 loop
				hex_digit := n.bit_shift_right (i * 4) & 0xF
				i := i + 1
			end
			Result := i = 16 and then hex_digit = first
		end

	hello_routine (a_arg: STRING)
		do
			lio.enter_with_args ("hello_routine", << a_arg >>)
			lio.exit
		end

	is_valid_time (str: STRING): BOOLEAN
		local
			parts: LIST [STRING]; mins, secs: STRING
		do
			parts := str.split (':')
			if parts.count = 2 then
				mins := parts [1]; secs := parts [2]
				secs.prune_all_leading ('0')
				Result := mins.is_integer and secs.is_real
			end
		end

	log_integer (n: INTEGER; str: STRING)
		do
			lio.put_integer_field (str, n)
			lio.put_new_line
		end

	pi: DOUBLE
			-- Given that Pi can be estimated using the function 4 * (1 - 1/3 + 1/5 - 1/7 + ..)
			-- with more terms giving greater accuracy, write a function that calculates Pi to
			-- an accuracy of 5 decimal places.
		local
			limit, term, four: DOUBLE; divisor: INTEGER
		do
			lio.enter ("pi")
			four := 4.0; limit := 0.5E-5; divisor := 1
			from term := four until term.abs < limit loop
				Result := Result + term
				four := four.opposite
				divisor := divisor + 2
				term := four / divisor
			end
			lio.put_integer_field ("divisor", divisor)
			lio.put_new_line
			lio.exit
		end

	se_array: SE_ARRAY2 [BOOLEAN]

	storable_string_list: STORABLE_STRING_LIST

feature {NONE} -- Constants

	Description: STRING = "Experiment with Eiffel code to fix bugs"

	Dir_n_n: NATURAL = 20046

	Dir_n_w: NATURAL = 20055

	Dir_w_w: NATURAL = 22359

	Mime_type_template, Text_charset_template: ZSTRING
		once
			Result := "text/%S; charset=%S"
		end

	Option_name: STRING = "experiments"

end
