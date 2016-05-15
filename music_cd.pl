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
  menu,
  action.


/**
 * header.
 *
 * Show the initial application header.
 */
header :-
  write('MUSIC CD DATABASE'), nl,
  write('by chuckeles'), nl, nl.


/**
 * menu.
 *
 * Shows the main menu.
 */
menu :-
  write('MAIN MENU'), nl.


/**
 * action.
 *
 * Read user input and take an action.
 */
action.
