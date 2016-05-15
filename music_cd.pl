/** <module> music_cd
 *
 * MUSIC CD DATABASE
 * -----------------
 *
 * This program is a database of good ol' music CDs.
 * It allows the user to add and remove CD, search for
 * a CD and filter and sort CDs.
 * It can also save the database to a file and later
 * restore from this file.
 *
 * @author chuckeles
 * @license MIT
 *
 */


:-
  dynamic(music_cd/6).


/**
 * application.
 *
 * Runs the application.
 *
 * @see menu
 * @see action
 */
application :-
  header,
  repeat,
  (
    menu,
    action
  ).


/**
 * header.
 *
 * Show the initial application header.
 */
header :-
  write('MUSIC CD DATABASE'), nl,
  write('by chuckeles'), nl.


/**
 * menu.
 *
 * Shows the main menu.
 */
menu :-
  nl,
  write('MAIN MENU'), nl,
  write('  [add]    Add a new CD.'), nl,
  write('  [remove] Remove a CD.'), nl,
  write('  [list]   List all CDs in the database.'), nl,
  write('  [exit]   Exit the application.'), nl.


/**
 * action.
 *
 * Read user input and take an action.
 */
action :-
  write('Your choice: '),
  read(Choice),
  (
    Choice = 'add' ->
      add_cd,
      fail;

    Choice = 'remove' ->
      remove_cd,
      fail;

    Choice = 'list' ->
      list_cds,
      fail;

    Choice = 'exit' ->
      write('Exiting the application!'), nl,
      !;

    write('What does that mean? I don\'t understand!'), nl,
    fail
  ).


/**
 * add_cd.
 *
 * Add a new music CD to the database.
 */
add_cd :-
  write('Please provide information about this CD:'), nl,
  (
    repeat,
    write('ID number: '),
    read(ID_number),
    (
      not(music_cd(ID_number, _, _, _, _, _)),
      !;
      write('A CD with that ID already exists!'), nl,
      write('Please provide a different one.'), nl,
      fail
    )
  ),
  write('Name: '),
  read(Name),
  write('Author: '),
  read(Author),
  write('Studio: '),
  read(Studio),
  write('Date: '),
  read(Date),
  write('Length: '),
  read(Length),
  asserta(
    music_cd(
      ID_number,
      Name,
      Author,
      Studio,
      Date,
      Length
    )
  ),
  write('Added the new CD to the database.'), nl.


/**
 * remove_cd.
 *
 * Remove a CD from the database.
 */
remove_cd :-
  write('What is the ID number of the CD you want to remove?'), nl,
  write('ID number: '),
  read(ID_number),
  retract(
    music_cd(ID_number, _, _, _, _, _)
  ),
  write('Removed a CD with ID '),
  write(ID_number),
  write(' from the database.'), nl.


/**
 * list_cds.
 *
 * List all CDs in the database.
 */
list_cds :-
  write('CDs in the database:'),
  repeat,
  (
    music_cd(
      ID_number,
      Name,
      Author,
      Studio,
      Date,
      Length
    );
    !,
    fail
  ),
  nl,
  write('ID_number: '),
  write(ID_number), nl,
  write('Name: '),
  write(Name), nl,
  write('Author: '),
  write(Author), nl,
  write('Studio: '),
  write(Studio), nl,
  write('Date: '),
  write(Date), nl,
  write('Length: '),
  write(Length), nl,
  fail.
