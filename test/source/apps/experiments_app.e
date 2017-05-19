note
	description: "Eiffel tinkering and minor experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-18 10:40:33 GMT (Thursday 18th May 2017)"
	revision: "10"

class EXPERIMENTS_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_STRING_8

	EL_MODULE_COMMAND

	EL_MODULE_EIFFEL

create
	make

feature {NONE} -- Initialization

	initialize
		do
		end

feature -- Basic operations

	run
		do
			lio.enter ("assign_tuple_string")
			assign_tuple_string
			lio.exit
		end

feature -- Experiments

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
				log.put_string_field (part.cursor_index.out, part.item)
				log.put_new_line
			end
		end

	automatic_object_initialization
		local
			country: COUNTRY; table: EL_ZSTRING_HASH_TABLE [ZSTRING]
		do
			create table.make (<<
				["code", new ("IE")],
				["literacy_rate", new ("0.9")],
				["population", new ("6500000")],
				["name", new ("Ireland")]
			>>)
			create country.make (table)
			log.put_labeled_string ("Country", country.name)
			log.put_new_line
			log.put_labeled_string ("Country code", country.code)
			log.put_new_line
			log.put_real_field ("literacy_rate", country.literacy_rate)
			log.put_new_line
			log.put_integer_field ("population", country.population)
			log.put_new_line
		end

	boolean_ref
		local
			b1: BOOLEAN
			b1_ref, b2_ref: BOOLEAN
		do
			b1_ref := b1.to_reference
			b2_ref := not b1_ref
			log.put_string ("b2_ref.item: ")
			log.put_boolean (b2_ref.item)
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
					log.put_integer (n)
					log.put_new_line
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
			log.put_string_field ("first item", list.item)
			log.put_new_line
		end

	container_extension
		do
			extend_container (create {ARRAYED_LIST [EL_DIR_PATH]}.make (0))
		end

	date_validity_check
		local
			checker: DATE_VALIDITY_CHECKER; str: STRING
		do
			create checker
			str := "2015-12-50"
			log.put_labeled_string (str, checker.date_valid (str, "yyyy-[0]mm-[0]dd").out)
		end

	default_tuple_comparison
		do
			if ["one"] ~ ["one"] then
				log.put_string ("is_object_comparison")
			else
				log.put_string ("is_reference_comparison")
			end
		end

	equality_question
		local
			s1: STRING; s2: READABLE_STRING_GENERAL
			s1_equal_to_s2: BOOLEAN
		do
			s1 := "abc"; s2 := "abc"
			s1_equal_to_s2 := s1 ~ s2
			log.put_labeled_string ("s1 is equal to s2", s1_equal_to_s2.out)
		end

	escaping_text
		do
			log.put_string_field ("&aa&bb&", escaped_text ("&aa&bb&").as_string_8)
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
					log.put_integer (n)
					log.put_new_line
				end
			)
		end

	generic_types
		local
			type_8, type_32: TYPE [LIST [READABLE_STRING_GENERAL]]
		do
			type_8 := {ARRAYED_LIST [STRING]}
			type_32 := {ARRAYED_LIST [STRING_32]}
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
				log.put_integer_field (n.item, table [n.item])
				log.put_new_line
			end
			across numbers as n loop
				n.item.wipe_out
			end
			across numbers as n loop
				log.put_integer_field (n.item, table [n.item])
				log.put_new_line
			end
		end

	hexadecimal_to_natural_64
		do
			log.put_string (String_8.hexadecimal_to_natural_64 ("0x00000982").out)
			log.put_new_line
		end

	make_directory_path
		local
			dir: EL_DIR_PATH; temp: EL_FILE_PATH
		do
			create dir.make_from_latin_1 ("E:/")
			temp := dir + "temp"
			log.put_string_field ("Path", temp.as_windows.to_string)
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


	my_procedure_test
		local
			my_procedure: MY_PROCEDURE [like Current, TUPLE]
		do
--			create my_procedure.adapt (agent my_procedure_test)
		end

	negative_integer_32_in_integer_64
			-- is it possible to store 2 negative INTEGER_32's in one INTEGER_64
		local
			n: INTEGER_64
		do
			n := ((10).to_integer_64 |<< 32) | -10
			log.put_integer_field ("low", n.to_integer_32) -- yes you can
			log.put_integer_field (" hi", (n |>> 32).to_integer_32) -- yes you can
		end

	open_function_target
		local
			duration: FUNCTION [AUDIO_EVENT, TUPLE [AUDIO_EVENT], REAL]
			event: AUDIO_EVENT
		do
			duration := agent {AUDIO_EVENT}.duration
			log.put_string ("duration.is_target_closed: ")
			log.put_boolean (duration.is_target_closed)
			log.put_new_line
			log.put_integer_field ("duration.open_count", duration.open_count)
			log.put_new_line
			create event.make (1, 3)
			duration.set_operands ([event])
			duration.apply
			log.put_double_field ("duration.last_result", duration.item ([event]))
		end

	pointer_width
		local
			ptr: POINTER
		do
			ptr := $pointer_width
			log.put_integer_field (ptr.out, ptr.out.count)
		end

	problem_with_function_returning_real_with_assignment
			--
		local
			event: AUDIO_EVENT
		do
			create event.make (1.25907 ,1.38513)
			log.put_string ("Is threshold exceeded: ")
			if event.is_threshold_exceeded (0.12606) then
				log.put_string ("true")
			else
				log.put_string ("false")
			end
			log.put_new_line
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

			log.put_real_field ("event_list.last.duration", event_list.last.duration)
			log.put_new_line
		end

	procedure_call
		local
			procedure: PROCEDURE [like Current, TUPLE]
		do
			procedure := agent log_integer (?, "n")
			procedure (2)
		end

	procedure_pointer
		local
			pointer: PROCEDURE_POINTER
			proc_random_sequence: PROCEDURE [like Current, TUPLE]
		do
			proc_random_sequence := agent random_sequence
			create pointer.make (proc_random_sequence, $random_sequence)
			proc_random_sequence.apply
			create pointer.make (proc_random_sequence, $random_sequence)
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
			log.put_integer_field ("random.seed", random.seed)
			log.put_new_line
			from  until random.index > 200 loop
				log.put_integer_field (random.index.out, random.item)
				log.put_new_line
				if random.item \\ 2 = 0 then
					even := even + 1
				else
					odd := odd + 1
				end
				random.forth
			end
			log.put_new_line
			log.put_integer_field ("odd", odd)
			log.put_new_line
			log.put_integer_field ("even", even)
			log.put_new_line
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
				log.put_string (email)
				email.replace_delimited_substring_general ("finnian", "@eiffel", "", False, 1)
				log.put_string (" -> "); log.put_string (email)
				log.put_new_line
			end
		end

	routine_compile
			-- compilation test
		local
			proc: PROCEDURE_2 [like Current, TUPLE]; func: FUNCTION_2 [like Current, TUPLE, INTEGER]
			pred: PREDICATE_2 [like Current, TUPLE]
		do
		end

	self_deletion_from_batch
		do
			Execution_environment.launch ("cmd /C D:\Development\Eiffel\Eiffel-Loop\test\uninstall.bat")
		end

	set_tuple_values
		local
			internal: INTERNAL; color: TUPLE [margins, background: STRING]
		do
			create internal
			create color
			color.margins := "blue"
			color.background := "red"
			log.put_integer_field ("First field", internal.field_count (color))
			log.put_new_line
		end

	string_to_integer_conversion
		local
			str: ZSTRING
		do
			str := ""
			log.put_string ("str.is_integer: ")
			log.put_boolean (str.is_integer)
		end

	substitute_template_with_string_8
		local
			type: STRING
		do
			type := "html"
			log.put_string_field ("Content", Mime_type_template #$ [type, "UTF-8"])
			log.put_new_line
			log.put_string_field ("Content", Mime_type_template #$ [type, "UTF-8"])
		end

	substitution
		local
			template: EL_SUBSTITUTION_TEMPLATE [STRING]
		do
			create template.make ("from $var := 1 until $var > 10 loop")
			template.set_variable ("var", "i")
			log.put_line (template.substituted)
		end

	substitution_template
			--
		local
			l_template: EL_SUBSTITUTION_TEMPLATE [STRING]
		do
			create l_template.make ("x=$x, y=$y")
			l_template.set_variable ("x", "100")
			l_template.set_variable ("y", "200")
			log.put_line (l_template.substituted)
		end

	system_path
		do
			Execution_environment.system ("cp /home/finnian/Music/Foxtrot/Cristian\ Vasile/Saruta-Ma\!.01.mp3 ~/Desktop/Music")
		end

	test_has_repeated_hexadecimal_digit
		do
			log.put_boolean (has_repeated_hexadecimal_digit (0xAAAAAAAAAAAAAAAA)); log.put_new_line
			log.put_boolean (has_repeated_hexadecimal_digit (0x1AAAAAAAAAAAAAAA)); log.put_new_line
			log.put_boolean (has_repeated_hexadecimal_digit (0xAAAAAAAAAAAAAAA1)); log.put_new_line
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
				log.put_labeled_string ("From", from_str); log.put_labeled_string (" to", to_str)
				log.put_new_line
				log.put_labeled_string ("From", from_time.out); log.put_labeled_string (" to", to_time.out)
				log.put_new_line
				duration := to_time.relative_duration (from_time)
				log.put_double_field ("Fine seconds", duration.fine_seconds_count)
			else
				log.put_line ("Invalid time format")
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
			log.put_labeled_string ("Time", time.formatted_out ("hh:[0]mi"))
			log.put_new_line
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

	twinning_procedures
		local
			action, action_2: PROCEDURE [ANY, TUPLE [STRING]]
		do
			action := agent hello_routine
			action_2 := action.twin
			action_2.set_operands (["wonderful"])
			action_2.apply
		end

	type_conforming_test
		local
			escaper: EL_DO_NOTHING_CHARACTER_ESCAPER [STRING]
			is_do_nothing_escaper: BOOLEAN
		do
			create escaper
			is_do_nothing_escaper := {EL_DO_NOTHING_CHARACTER_ESCAPER [STRING_GENERAL]} < escaper.generating_type
			log.put_labeled_string ("Is do nothing escaper", is_do_nothing_escaper.out)
		end

	url_string
		local
			str: EL_URL_STRING
		do
			create str.make_empty
			str.append_utf_8 ("freilly8@gmail.com")
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
			log.enter_with_args ("hello_routine", << a_arg >>)
			log.exit
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
			log.put_integer_field (str, n)
			log.put_new_line
		end

	new (str: STRING): ZSTRING
		do
			Result := str
		end

	pi: DOUBLE
			-- Given that Pi can be estimated using the function 4 * (1 - 1/3 + 1/5 - 1/7 + ..)
			-- with more terms giving greater accuracy, write a function that calculates Pi to
			-- an accuracy of 5 decimal places.
		local
			limit, term, four: DOUBLE; divisor: INTEGER
		do
			log.enter ("pi")
			four := 4.0; limit := 0.5E-5; divisor := 1
			from term := four until term.abs < limit loop
				Result := Result + term
				four := four.opposite
				divisor := divisor + 2
				term := four / divisor
			end
			log.put_integer_field ("divisor", divisor)
			log.put_new_line
			log.exit
		end

	storable_string_list: STORABLE_STRING_LIST

	se_array: SE_ARRAY2 [BOOLEAN]

feature {NONE} -- Constants

	Description: STRING = "Experiment with Eiffel code to fix bugs"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EXPERIMENTS_APP}, All_routines]
			>>
		end

	Mime_type_template, Text_charset_template: ZSTRING
		once
			Result := "text/%S; charset=%S"
		end

	Option_name: STRING = "experiments"

	Dir_n_n: NATURAL = 20046

	Dir_n_w: NATURAL = 20055

	Dir_w_w: NATURAL = 22359

end
