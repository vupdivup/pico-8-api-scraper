---@meta

---Load or save a cartridge
---
---When loading from a running cartridge, the loaded cartridge is immediately run with parameter string PARAM_STR (accessible with STAT(6)), and a menu item is inserted and named BREADCRUMB, that returns the user to the previous cartridge.
---
---Filenames that start with '#' are taken to be a BBS cart id, that is immediately downloaded and run:
---
---```
---> LOAD("#MYGAME_LEVEL2", "BACK TO MAP", "LIVES="..LIVES)
---```
---
---If the id is the cart's parent post, or a revision number is not specified, then the latest version is fetched. BBS carts can be loaded from other BBS carts or local carts, but not from  exported carts.
---@param filename any
---@param breadcrumb any?
---@param param_str any?
function load(filename, breadcrumb, param_str) end

---Load or save a cartridge
---
---When loading from a running cartridge, the loaded cartridge is immediately run with parameter string PARAM_STR (accessible with STAT(6)), and a menu item is inserted and named BREADCRUMB, that returns the user to the previous cartridge.
---
---Filenames that start with '#' are taken to be a BBS cart id, that is immediately downloaded and run:
---
---```
---> LOAD("#MYGAME_LEVEL2", "BACK TO MAP", "LIVES="..LIVES)
---```
---
---If the id is the cart's parent post, or a revision number is not specified, then the latest version is fetched. BBS carts can be loaded from other BBS carts or local carts, but not from  exported carts.
---@param filename any
function save(filename) end

---Open the carts folder in the host operating system.
function folder() end

---List .p8 and .p8.png files in given directory (folder), relative to the current directory. Items that are directories end in a slash (e.g. "foo/").
---
---When called from a running cartridge, LS can only be used locally and returns a table of the results. When called from a BBS cart, LS returns nil.
---
---Directories can only resolve inside of PICO-8's virtual drive; LS("..") from the root directory will resolve to the root directory.
---@param directory any?
function ls(directory) end

---Run from the start of the program.
---
---RUN() Can be called from inside a running program to reset.
---
---When PARAM_STR is supplied, it can be accessed during runtime with STAT(6)
---@param param_str any?
function run(param_str) end

---Stop the cart and optionally print a message.
---@param message any?
function stop(message) end

---Resume the program. Use R for short.
---
---Use a single "." from the commandline to advance a single frame. This enters frame-by-frame mode, that can be read with stat(110). While frame-by-frame mode is active, entering an empty command (by pressing enter) advances one frames.
function resume() end

---If CONDITION is false, stop the program and print MESSAGE if it is given. This can be useful for debugging cartridges, by ASSERT()'ing that things that you expect to be true are indeed true.
---
---```
---ASSERT(ADDR >= 0 AND ADDR <= 0x7FFF, "OUT OF RANGE")
---POKE(ADDR, 42) -- THE MEMORY ADDRESS IS OK, FOR SURE!
---```
---@param condition any
---@param message any?
function assert(condition, message) end

---Reboot the machine Useful for starting a new project
function reboot() end

---Reset the values in RAM from 0x5f00..0x5f7f to their default values.  This includes the palette, camera position, clipping and fill pattern. If you get lost at the command prompt because the draw state makes viewing text  impossible, try typing RESET! It can also be called from a running program.
function reset() end

---Print out some information about the cartridge: Code size, tokens, compressed size
---
---Also displayed:
---
---UNSAVED CHANGES   When the cartridge in memory differs to the one on disk
---EXTERNAL CHANGES  When the cartridge on disk has changed since it was loaded
---  (e.g. by editing the program using a separate text editor)
function info() end

---Flip the back buffer to screen and wait for next frame. This call is not needed when there is a _DRAW() or _UPDATE() callback defined, as the flip is performed automatically. But when using a custom main loop, a call to FLIP is normally needed:
---
---```
---::_::
---CLS()
---FOR I=1,100 DO
---  A=I/50 - T()
---  X=64+COS(A)*I
---  Y=64+SIN(A)*I
---  CIRCFILL(X,Y,1,8+(I/4)%8)
---END
---FLIP()GOTO _
---```
---
---If your program does not call FLIP before a frame is up, and a _DRAW() callback is not in progress, the current contents of the back buffer are copied to screen.
function flip() end

---Print a string to the host operating system's console for debugging.
---
---If filename is set, append the string to a file on the host operating system (in the current directory by default -- use FOLDER to view).
---
---Setting OVERWRITE to true causes that file to be overwritten rather than appended.
---
---Setting SAVE_TO_DESKTOP to true saves to the desktop instead of the current path.
---
---Use a filename of "@clip" to write to the host's clipboard.
---
---Use stat(4) to read the clipboard, but the contents of the clipboard are only available after pressing CTRL-V during runtime (for security).
---@param str any
---@param filename any?
---@param overwrite any?
---@param save_to_desktop any?
function printh(str, filename, overwrite, save_to_desktop) end

---Returns the number of seconds elapsed since the cartridge was run.
---
---This is not the real-world time, but is calculated by counting the number of times
---
---the same result.
function time() end

---Returns the number of seconds elapsed since the cartridge was run.
---
---This is not the real-world time, but is calculated by counting the number of times
---
---the same result.
function t() end

---Get system status where X is:
---
---```
---0  Memory usage (0..2048)
---1  CPU used since last flip (1.0 == 100% CPU)
---4  Clipboard contents (after user has pressed CTRL-V)
---6  Parameter string
---7  Current framerate
--- 
---46..49  Index of currently playing SFX on channels 0..3
---50..53  Note number (0..31) on channel 0..3
---54      Currently playing pattern index
---55      Total patterns played
---56      Ticks played on current pattern
---57      (Boolean) TRUE when music is playing
--- 
---80..85  UTC time: year, month, day, hour, minute, second
---90..95  Local time
--- 
---100     Current breadcrumb label, or nil
---110     Returns true when in frame-by-frame mode
---```
---
---Audio values 16..26 are the legacy version of audio state queries 46..56. They only report on the current state of the audio mixer, which changes only ~20 times a second (depending on the host sound driver and other factors). 46..56 instead stores a history of mixer state at each tick to give a higher resolution estimate of the currently audible state.
---@param x any
function stat(x) end

---Special system command, where CMD_STR is a string:
---
---"pause"         request the pause menu be opened
---"reset"         request a cart reset
---"go_back"       return to the previous cart if there is one
---"label"         set cart label to contents of screen
---"screen"        save a screenshot
---"rec"           set video start point
---"rec_frames"    set video start point in frames mode
---"video"         save a .gif to desktop
---"audio_rec"     start recording audio
---"audio_end"     save recorded audio to desktop (no supported from web)
---"shutdown"      quit cartridge (from exported binary)
---"folder"        open current working folder on the host operating system
---"set_filename"  set the filename for screenshots / gifs / audio recordings
---"set_title"     set the host window title
---
---Some commands have optional number parameters:
---
---"video" and "screen": P1: an integer scaling factor that overrides the system setting. P2: when > 0, save to the current folder instead of to desktop
---
---"audio_end" P1: when > 0, save to the current folder instead of to desktop
---@param cmd_str any
---@param p1 any?
---@param p2 any?
function extcmd(cmd_str, p1, p2) end

---Sets the clipping rectangle in pixels. All drawing operations will be clipped to the rectangle at x, y with a width and height of w,h.
---
---CLIP() to reset.
---
---When CLIP_PREVIOUS is true, clip the new clipping region by the old one.
---@param x any
---@param y any
---@param w any
---@param h any
---@param clip_previous any?
function clip(x, y, w, h, clip_previous) end

---Sets the pixel at x, y to colour index COL (0..15).
---
---When COL is not specified, the current draw colour is used.
---
---```
---FOR Y=0,127 DO
---  FOR X=0,127 DO
---    PSET(X, Y, X*Y/8)
---  END
---END
---```
---@param x any
---@param y any
---@param col any?
function pset(x, y, col) end

---Returns the colour of a pixel on the screen at (X, Y).
---
---```
---WHILE (TRUE) DO
---  X, Y = RND(128), RND(128)
---  DX, DY = RND(4)-2, RND(4)-2
---  PSET(X, Y, PGET(DX+X, DY+Y))
---END
---```
---
---When X and Y are out of bounds, PGET returns 0. A custom return value can be specified with:
---
---```
---POKE(0x5f36, 0x10)
---POKE(0x5f5B, NEWVAL)
---```
---@param x any
---@param y any
function pget(x, y) end

---Get or set the colour (COL) of a sprite sheet pixel.
---
---When X and Y are out of bounds, SGET returns 0. A custom value can be specified with:
---
---```
---POKE(0x5f36, 0x10)
---POKE(0x5f59, NEWVAL)
---```
---@param x any
---@param y any
function sget(x, y) end

---Get or set the colour (COL) of a sprite sheet pixel.
---
---When X and Y are out of bounds, SGET returns 0. A custom value can be specified with:
---
---```
---POKE(0x5f36, 0x10)
---POKE(0x5f59, NEWVAL)
---```
---@param x any
---@param y any
---@param col any?
function sset(x, y, col) end

---Get or set the value (VAL) of sprite N's flag F.
---
---F is the flag index 0..7.
---
---VAL is TRUE or FALSE.
---
---The initial state of flags 0..7 are settable in the sprite editor, so can be used to create custom sprite attributes. It is also possible to draw only a subset of map tiles by providing a mask in MAP().
---
---When F is omitted, all flags are retrieved/set as a single bitfield.
---
---```
---FSET(2, 1 | 2 | 8)   -- SETS BITS 0,1 AND 3
---FSET(2, 4, TRUE)     -- SETS BIT 4
---PRINT(FGET(2))       -- 27 (1 | 2 | 8 | 16)
---```
---@param n any
---@param f any?
function fget(n, f) end

---Get or set the value (VAL) of sprite N's flag F.
---
---F is the flag index 0..7.
---
---VAL is TRUE or FALSE.
---
---The initial state of flags 0..7 are settable in the sprite editor, so can be used to create custom sprite attributes. It is also possible to draw only a subset of map tiles by providing a mask in MAP().
---
---When F is omitted, all flags are retrieved/set as a single bitfield.
---
---```
---FSET(2, 1 | 2 | 8)   -- SETS BITS 0,1 AND 3
---FSET(2, 4, TRUE)     -- SETS BIT 4
---PRINT(FGET(2))       -- 27 (1 | 2 | 8 | 16)
---```
---@param n any
---@param f any?
---@param val any
function fset(n, f, val) end

---Print a string STR and optionally set the draw colour to COL.
---
---Shortcut: written on a single line, ? can be used to call print without brackets:
---
---```
---?"HI"
---```
---
---When X, Y are not specified, a newline is automatically appended. This can be omitted by ending the string with an explicit termination control character:
---
---```
---?"THE QUICK BROWN FOX\0"
---```
---
---Additionally, when X, Y are not specified, printing text below 122 causes  the console to scroll. This can be disabled during runtime with POKE(0x5f36,0x40).
---
---PRINT returns the right-most x position that occurred while printing. This can be used to find out the width of some text by printing it off-screen:
---
---```
---W = PRINT("HOGE", 0, -20) -- returns 16
---```
---
---See Appendix A (P8SCII) for information about control codes and custom fonts.
---@param str any
---@param x any
---@param y any
---@param col any?
function print(str, x, y, col) end

---Print a string STR and optionally set the draw colour to COL.
---
---Shortcut: written on a single line, ? can be used to call print without brackets:
---
---```
---?"HI"
---```
---
---When X, Y are not specified, a newline is automatically appended. This can be omitted by ending the string with an explicit termination control character:
---
---```
---?"THE QUICK BROWN FOX\0"
---```
---
---Additionally, when X, Y are not specified, printing text below 122 causes  the console to scroll. This can be disabled during runtime with POKE(0x5f36,0x40).
---
---PRINT returns the right-most x position that occurred while printing. This can be used to find out the width of some text by printing it off-screen:
---
---```
---W = PRINT("HOGE", 0, -20) -- returns 16
---```
---
---See Appendix A (P8SCII) for information about control codes and custom fonts.
---@param str any
---@param col any?
function print(str, col) end

---Set the cursor position.
---
---If COL is specified, also set the current colour.
---@param x any
---@param y any
---@param col any?
function cursor(x, y, col) end

---Set the current colour to be used by drawing functions.
---
---If COL is not specified, the current colour is set to 6
---@param col any?
function color(col) end

---Clear the screen and reset the clipping rectangle.
---
---COL defaults to 0 (black)
---@param col any?
function cls(col) end

---Set a screen offset of -x, -y for all drawing operations
---
---CAMERA() to reset
---@param x any?
---@param y any?
function camera(x, y) end

---Draw a circle or filled circle at x,y with radius r
---
---If r is negative, the circle is not drawn.
---
---When bits 0x1800.0000 are set in COL, and 0x5F34 & 2 == 2, the circle is drawn inverted.
---@param x any
---@param y any
---@param r any
---@param col any?
function circ(x, y, r, col) end

---Draw a circle or filled circle at x,y with radius r
---
---If r is negative, the circle is not drawn.
---
---When bits 0x1800.0000 are set in COL, and 0x5F34 & 2 == 2, the circle is drawn inverted.
---@param x any
---@param y any
---@param r any
---@param col any?
function circfill(x, y, r, col) end

---Draw an oval that is symmetrical in x and y (an ellipse), with the given bounding rectangle.
---@param x0 any
---@param y0 any
---@param x1 any
---@param y1 any
---@param col any?
function oval(x0, y0, x1, y1, col) end

---Draw an oval that is symmetrical in x and y (an ellipse), with the given bounding rectangle.
---@param x0 any
---@param y0 any
---@param x1 any
---@param y1 any
---@param col any?
function ovalfill(x0, y0, x1, y1, col) end

---Draw a line from (X0, Y0) to (X1, Y1)
---
---If (X1, Y1) are not given, the end of the last drawn line is used.
---
---LINE() with no parameters means that the next call to LINE(X1, Y1) will only set the end points without drawing.
---
---```
---CLS()
---LINE()
---FOR I=0,6 DO
---  LINE(64+COS(I/6)*20, 64+SIN(I/6)*20, 8+I)
---END
---```
---@param x0 any
---@param y0 any
---@param x1 any?
---@param y1 any
---@param col any?
function line(x0, y0, x1, y1, col) end

---Draw a rectangle or filled rectangle with corners at (X0, Y0), (X1, Y1).
---@param x0 any
---@param y0 any
---@param x1 any
---@param y1 any
---@param col any?
function rect(x0, y0, x1, y1, col) end

---Draw a rectangle or filled rectangle with corners at (X0, Y0), (X1, Y1).
---@param x0 any
---@param y0 any
---@param x1 any
---@param y1 any
---@param col any?
function rectfill(x0, y0, x1, y1, col) end

---PAL() swaps colour c0 for c1 for one of three palette re-mappings (p defaults to 0):
---
---0: Draw Palette
---
---The draw palette re-maps colours when they are drawn. For example, an orange flower sprite can be drawn as a red flower by setting the 9th palette value to 8:
---
---```
---PAL(9,8)     -- draw subsequent orange (colour 9) pixels as red (colour 8)
---SPR(1,70,60) -- any orange pixels in the sprite will be drawn with red instead
---```
---
---Changing the draw palette does not affect anything that was already drawn to the screen.
---
---1: Display Palette
---
---The display palette re-maps the whole screen when it is displayed at the end of a frame. For example, if you boot PICO-8 and then type PAL(6,14,1), you can see all of the gray (colour 6) text immediate change to pink (colour 14) even though it has already been drawn. This is useful for screen-wide effects such as fading in/out.
---
---2: Secondary Palette
---
---Used by FILLP() for drawing sprites. This provides a mapping from a single 4-bit colour index to two 4-bit colour indexes.
---
---PAL()  resets all palettes to system defaults (including transparency values)
---PAL(P) resets a particular palette (0..2) to system defaults
---@param c0 any
---@param c1 any
---@param p any?
function pal(c0, c1, p) end

---When the first parameter of pal is a table, colours are assigned for each entry. For example, to re-map colour 12 and 14 to red:
---
---```
---PAL({[12]=9, [14]=8})
---```
---
---Or to re-colour the whole screen shades of gray (including everything that is already drawn):
---
---```
---PAL({1,1,5,5,5,6,7,13,6,7,7,6,13,6,7,1}, 1)
---```
---
---Because table indexes start at 1, colour 0 is given at the end in this case.
---@param tbl any
---@param p any?
function pal(tbl, p) end

---Set transparency for colour index to T (boolean) Transparency is observed by SPR(), SSPR(), MAP() AND TLINE()
---
---```
---PALT(8, TRUE) -- RED PIXELS NOT DRAWN IN SUBSEQUENT SPRITE/TLINE DRAW CALLS
---```
---
---PALT() resets to default: all colours opaque except colour 0
---
---When C is the only parameter, it is treated as a bitfield used to set all 16 values. For example: to set colours 0 and 1 as transparent:
---
---```
---PALT(0B1100000000000000)
---```
---@param c any
---@param t any?
function palt(c, t) end

---Draw sprite N (0..255) at position X,Y
---
---W (width) and H (height) are 1, 1 by default and specify how many sprites wide to blit.
---
---Colour 0 drawn as transparent by default (see PALT())
---
---When FLIP_X is TRUE, flip horizontally.
---
---When FLIP_Y is TRUE, flip vertically.
---@param n any
---@param x any
---@param y any
---@param w any?
---@param h any?
---@param flip_x any?
---@param flip_y any?
function spr(n, x, y, w, h, flip_x, flip_y) end

---Stretch a rectangle of the sprite sheet (sx, sy, sw, sh) to a destination rectangle on the screen (dx, dy, dw, dh). In both cases, the x and y values are coordinates (in pixels) of the rectangle's top left corner, with a width of w, h.
---
---Colour 0 drawn as transparent by default (see PALT())
---
---dw, dh defaults to sw, sh
---
---When FLIP_X is TRUE, flip horizontally.
---
---When FLIP_Y is TRUE, flip vertically.
---@param sx any
---@param sy any
---@param sw any
---@param sh any
---@param dx any
---@param dy any
---@param dw any?
---@param dh any?
---@param flip_x any?
---@param flip_y any?
function sspr(sx, sy, sw, sh, dx, dy, dw, dh, flip_x, flip_y) end

---The PICO-8 fill pattern is a 4x4 2-colour tiled pattern observed by: CIRC() CIRCFILL() RECT() RECTFILL() OVAL() OVALFILL() PSET() LINE()
---
---P is a bitfield in reading order starting from the highest bit. To calculate the value of P for a desired pattern, add the bit values together:
---
---.-----------------------.
---  |32768|16384| 8192| 4096|
---  |-----|-----|-----|-----|
---  | 2048| 1024| 512 | 256 |
---  |-----|-----|-----|-----|
---  | 128 |  64 |  32 |  16 |
---  |-----|-----|-----|-----|
---  |  8  |  4  |  2  |  1  |
---  '-----------------------'
---
---For example, FILLP(4+8+64+128+  256+512+4096+8192) would create a checkerboard pattern.
---
---This can be more neatly expressed in binary: FILLP(0b0011001111001100).
---
---The default fill pattern is 0, which means a single solid colour is drawn.
---
---To specify a second colour for the pattern, use the high bits of any colour parameter:
---
---```
---FILLP(0b0011010101101000)
---CIRCFILL(64,64,20, 0x4E) -- brown and pink
---```
---
---Additional settings are given in bits 0b0.111:
---
---0b0.100 Transparency
---
---When this bit is set, the second colour is not drawn
---
---```
----- checkboard with transparent squares
---FILLP(0b0011001111001100.1)
---```
---
---0b0.010 Apply to Sprites
---
---When set, the fill pattern is applied to sprites (spr, sspr, map, tline), using a colour mapping provided by the secondary palette.
---
---Each pixel value in the sprite (after applying the draw palette as usual) is taken to be an index into the secondary palette. Each entry in the secondary palette contains the two colours used to render the fill pattern. For example, to draw a white and red (7 and 8) checkerboard pattern for only blue pixels (colour 12) in a sprite:
---
---```
---FOR I=0,15 DO PAL(I, I+I*16, 2) END  --  all other colours map to themselves
---PAL(12, 0x87, 2)                     --  remap colour 12 in the secondary palette
--- 
---FILLP(0b0011001111001100.01)         --  checkerboard palette, applied to sprites
---SPR(1, 64,64)                        --  draw the sprite
---```
---
---0b0.001 Apply Secondary Palette Globally
---
---When set, the secondary palette mapping is also applied by all draw functions that respect fill patterns (circfill, line etc). This can be useful when used in  conjunction with sprite drawing functions, so that the colour index of each sprite  pixel means the same thing as the colour index supplied to the drawing functions.
---
---```
---FILLP(0b0011001111001100.001)
---PAL(12, 0x87, 2)
---CIRCFILL(64,64,20,12)                -- red and white checkerboard circle
---```
---
---The secondary palette mapping is applied after the regular draw palette mapping. So the following would also draw a red and white checkered circle:
---
---```
---PAL(3,12)
---CIRCFILL(64,64,20,3)
---```
---
---The fill pattern can also be set by setting bits in any colour parameter (for example, the parameter to COLOR(), or the last parameter to LINE(), RECT() etc.
---
---POKE(0x5F34, 0x3) -- 0x1 enable fillpattern in high bits  0x2 enable inversion mode
---CIRCFILL(64,64,20, 0x114E.ABCD) -- sets fill pattern to ABCD
---
---When using the colour parameter to set the fill pattern, the following bits are used:
---
---bit  0x1000.0000 this needs to be set: it means "observe bits 0xf00.ffff"
---bit  0x0100.0000 transparency
---bit  0x0200.0000 apply to sprites
---bit  0x0400.0000 apply secondary palette globally
---bit  0x0800.0000 invert the drawing operation (circfill/ovalfill/rectfill)
---bits 0x00FF.0000 are the usual colour bits
---bits 0x0000.FFFF are interpreted as the fill pattern
---@param p any
function fillp(p) end

---Add value VAL to the end of table TBL. Equivalent to:
---
---```
---TBL[#TBL + 1] = VAL
---```
---
---If index is given then the element is inserted at that position:
---
---```
---FOO={}        -- CREATE EMPTY TABLE
---ADD(FOO, 11)
---ADD(FOO, 22)
---PRINT(FOO[2]) -- 22
---```
---@param tbl any
---@param val any
---@param index any?
function add(tbl, val, index) end

---Delete the first instance of value VAL in table TBL. The remaining entries are shifted left one index to avoid holes.
---
---Note that VAL is the value of the item to be deleted, not the index into the table. (To remove an item at a particular index, use DELI instead). DEL returns the deleted item, or returns no value when nothing was deleted.
---
---```
---A={1,10,2,11,3,12}
---FOR ITEM IN ALL(A) DO
---  IF (ITEM < 10) THEN DEL(A, ITEM) END
---END
---FOREACH(A, PRINT) -- 10,11,12
---PRINT(A[3])       -- 12
---```
---@param tbl any
---@param val any
function del(tbl, val) end

---Like DEL(), but remove the item from table TBL at index I When I is not given, the last element of the table is removed and returned.
---@param tbl any
---@param i any?
function deli(tbl, i) end

---Returns the length of table t (same as #TBL) When VAL is given, returns the number of instances of VAL in that table.
---@param tbl any
---@param val any?
function count(tbl, val) end

---Used in FOR loops to iterate over all items in a table (that have a 1-based integer index),  in the order they were added.
---
---```
---T = {11,12,13}
---ADD(T,14)
---ADD(T,"HI")
---FOR V IN ALL(T) DO PRINT(V) END -- 11 12 13 14 HI
---PRINT(#T) -- 5
---```
---@param tbl any
function all(tbl) end

---For each item in table TBL, call function FUNC with the item as a single parameter.
---
---```
---> FOREACH({1,2,3}, PRINT)
---```
---@param tbl any
---@param func any
function foreach(tbl, func) end

---Used in FOR loops to iterate over table TBL, providing both the key and value for each item. Unlike ALL(), PAIRS() iterates over every item regardless of indexing scheme. Order is not guaranteed.
---
---```
---T = {["HELLO"]=3, [10]="BLAH"}
---T.BLUE = 5;
---FOR K,V IN PAIRS(T) DO
---  PRINT("K: "..K.."  V:"..V)
---END
---```
---
---Output:
---
---```
---K: 10  v:BLAH
---K: HELLO  v:3
---K: BLUE  v:5
---```
---@param tbl any
function pairs(tbl) end

---Get button B state for player PL (default 0)
---
---B: 0..5: left right up down button_o button_x PL: player index 0..7
---
---Instead of using a number for B, it is also possible to use a button glyph. (In the coded editor, use Shift-L R U D O X)
---
---If no parameters supplied, returns a bitfield of all 12 button states for player 0 & 1 // P0: bits 0..5  P1: bits 8..13
---
---Default keyboard mappings to player buttons:
--- 
---  player 0: [DPAD]: cursors, [O]: Z C N   [X]: X V M
---  player 1: [DPAD]: SFED,    [O]: LSHIFT  [X]: TAB W  Q A
---
---Although PICO-8 accepts all button combinations, note that it is generally impossible to press both LEFT and RIGHT at the same time on a physical game controller. On some controllers, UP + LEFT/RIGHT is also awkward if [X] or [O] could be used instead of UP (e.g. to jump / accelerate).
---@param b any?
---@param pl any?
function btn(b, pl) end

---BTNP is short for "Button Pressed"; Instead of being true when a button is held down,  BTNP returns true when a button is down AND it was not down the last frame. It also repeats after 15 frames, returning true every 4 frames after that (at 30fps -- double that at 60fps). This can be used for things like menu navigation or grid-wise player  movement.
---
---The state that BTNP reads is reset at the start of each call to _UPDATE or _UPDATE60, so it is preferable to use BTNP from inside one of those functions.
---
---Custom delays (in frames  30fps) can be set by poking the following memory addresses:
---
---```
---POKE(0X5F5C, DELAY) -- SET THE INITIAL DELAY BEFORE REPEATING. 255 MEANS NEVER REPEAT.
---POKE(0X5F5D, DELAY) -- SET THE REPEATING DELAY.
---```
---
---In both cases, 0 can be used for the default behaviour (delays 15 and 4)
---@param b any
---@param pl any?
function btnp(b, pl) end

---Play sfx N (0..63) on CHANNEL (0..3) from note OFFSET (0..31 in notes) for LENGTH notes.
---
---Using negative CHANNEL values have special meanings:
---
---CHANNEL -1: (default) to automatically choose a channel that is not being used
---CHANNEL -2: to stop the given sound from playing on any channel
---
---N can be a command for the given CHANNEL (or all channels when CHANNEL < 0):
---
---N -1: to stop sound on that channel
---N -2: to release sound on that channel from looping
---
---```
---SFX(3)    --  PLAY SFX 3
---SFX(3,2)  --  PLAY SFX 3 ON CHANNEL 2
---SFX(3,-2) --  STOP SFX 3 FROM PLAYING ON ANY CHANNEL
---SFX(-1,2) --  STOP WHATEVER IS PLAYING ON CHANNEL 2
---SFX(-2,2) --  RELEASE LOOPING ON CHANNEL 2
---SFX(-1)   --  STOP ALL SOUNDS ON ALL CHANNELS
---SFX(-2)   --  RELEASE LOOPING ON ALL CHANNELS
---```
---@param n any
---@param channel any?
---@param offset any?
---@param length any?
function sfx(n, channel, offset, length) end

---Play music starting from pattern N (0..63)
---N -1 to stop music
--- 
---FADE_LEN is in ms (default: 0). So to fade pattern 0 in over 1 second:
---
---```
---MUSIC(0, 1000)
---```
---
---CHANNEL_MASK specifies which channels to reserve for music only. For example, to play only on channels 0..2:
---
---MUSIC(0, NIL, 7) -- 1 | 2 | 4
---
---Reserved channels can still be used to play sound effects on, but only when that channel index is explicitly requested by SFX().
---@param n any
---@param fade_len any?
---@param channel_mask any?
function music(n, fade_len, channel_mask) end

---Get or set map value (VAL) at X,Y
---
---When X and Y are out of bounds, MGET returns 0, or a custom return value that can be specified with:
---
---```
---POKE(0x5f36, 0x10)
---POKE(0x5f5a, NEWVAL)
---```
---@param x any
---@param y any
function mget(x, y) end

---Get or set map value (VAL) at X,Y
---
---When X and Y are out of bounds, MGET returns 0, or a custom return value that can be specified with:
---
---```
---POKE(0x5f36, 0x10)
---POKE(0x5f5a, NEWVAL)
---```
---@param x any
---@param y any
---@param val any
function mset(x, y, val) end

---Draw section of map (starting from TILE_X, TILE_Y) at screen position SX, SY (pixels).
---
---To draw a 4x2 blocks of tiles starting from 0,0 in the map, to the screen at 20,20:
---
---```
---MAP(0, 0, 20, 20, 4, 2)
---```
---
---TILE_W and TILE_H default to the entire map (including shared space when applicable).
---
---MAP() is often used in conjunction with CAMERA(). To draw the map so that a player object (at PL.X in PL.Y in pixels) is centered:
---
---```
---CAMERA(PL.X - 64, PL.Y - 64)
---MAP()
---```
---
---LAYERS is a bitfield. When given, only sprites with matching sprite flags are drawn. For example, when LAYERS is 0x5, only sprites with flag 0 and 2 are drawn.
---
---Sprite 0 is taken to mean "empty" and is not drawn. To disable this behaviour, use: POKE(0x5F36, 0x8)
---@param tile_x any
---@param tile_y any
---@param sx any?
---@param sy any?
---@param tile_w any?
---@param tile_h any?
---@param layers any?
function map(tile_x, tile_y, sx, sy, tile_w, tile_h, layers) end

---Draw a textured line from (X0,Y0) to (X1,Y1), sampling colour values from the map. When LAYERS is specified, only sprites with matching flags are drawn (similar to MAP())
---
---MX, MY are map coordinates to sample from, given in tiles. Colour values are sampled from the 8x8 sprite present at each map tile. For example:
---
---2.0, 1.0  means the top left corner of the sprite at position 2,1 on the map
---2.5, 1.5  means pixel (4,4) of the same sprite
---
---MDX, MDY are deltas added to mx, my after each pixel is drawn. (Defaults to 0.125, 0)
---
---The map coordinates (MX, MY) are masked by values calculated by subtracting 0x0.0001 from the values at address 0x5F38 and 0x5F39. In simpler terms, this means you can loop a section of the map by poking the width and height you want to loop within, as  long as they are powers of 2 (2,4,8,16..)
---
---For example, to loop every 8 tiles horizontally, and every 4 tiles vertically:
---
---```
---POKE(0x5F38, 8)
---POKE(0x5F39, 4)
---TLINE(...)
---```
---
---The default values (0,0) gives a masks of 0xff.ffff, which means that the samples will loop every 256 tiles.
---
---An offset to sample from (also in tiles) can also be specified at addresses 0x5f3a, 0x5f3b:
---
---```
---POKE(0x5F3A, OFFSET_X)
---POKE(0x5F3B, OFFSET_Y)
---```
---
---Sprite 0 is taken to mean "empty" and not drawn. To disable this behaviour, use: POKE(0x5F36, 0x8)
---@param x0 any
---@param y0 any
---@param x1 any
---@param y1 any
---@param mx any
---@param my any
---@param mdx any?
---@param mdy any?
---@param layers any?
function tline(x0, y0, x1, y1, mx, my, mdx, mdy, layers) end

---Read a byte from an address in base ram. If N is specified, PEEK() returns that number of results (max: 8192). For example, to read the first 2 bytes of video memory:
---
---```
---A, B = PEEK(0x6000, 2)
---```
---
---Write one or more bytes to an address in base ram. If more than one parameter is provided, they are written sequentially (max: 8192).
---
---16-bit and 32-bit versions of PEEK and POKE. Read and write one number (VAL) in little-endian format:
---
---16 bit: 0xffff.0000
---  32 bit: 0xffff.ffff
---
---ADDR does not need to be aligned to 2 or 4-byte boundaries.
---
---Alternatively, the following operators can be used to peek (but not poke), and are slightly faster:
---
---```
---@ADDR  -- PEEK(ADDR)
---%ADDR  -- PEEK2(ADDR)
---$ADDR  -- PEEK4(ADDR)
---```
---@param addr any
---@param n any?
function peek(addr, n) end

---Copy LEN bytes of base ram from source to dest. Sections can be overlapping
---@param dest_addr any
---@param source_addr any
---@param len any
function memcpy(dest_addr, source_addr, len) end

---Same as MEMCPY, but copies from cart rom.
---
---The code section ( >= 0x4300) is protected and can not be read.
---
---If filename specified, load data from a separate cartridge. In this case, the cartridge must be local (BBS carts can not be read in this way).
---@param dest_addr any
---@param source_addr_len any
---@param filename any?
function reload(dest_addr, source_addr_len, filename) end

---Same as memcpy, but copies from base ram to cart rom.
---
---CSTORE() is equivalent to CSTORE(0, 0, 0x4300)
---
---The code section ( >= 0x4300) is protected and can not be written to.
---
---If FILENAME is specified, the data is written directly to that cartridge on disk. Up to 64 cartridges can be written in one session. See Cartridge Data for more information.
---@param dest_addr any
---@param source_addr any
---@param len any
---@param filename any?
function cstore(dest_addr, source_addr, len, filename) end

---Write the 8-bit value VAL into memory starting at DEST_ADDR, for LEN bytes.
---
---For example, to fill half of video memory with 0xC8:
---
---```
---> MEMSET(0x6000, 0xC8, 0x1000)
---```
---@param dest_addr any
---@param val any
---@param len any
function memset(dest_addr, val, len) end

---Returns the maximum, minimum, or middle value of parameters
---
---```
---> ?MID(7,5,10) -- 7
---```
---@param x any
---@param y any
function max(x, y) end

---Returns the maximum, minimum, or middle value of parameters
---
---```
---> ?MID(7,5,10) -- 7
---```
---@param x any
---@param y any
function min(x, y) end

---Returns the maximum, minimum, or middle value of parameters
---
---```
---> ?MID(7,5,10) -- 7
---```
---@param x any
---@param y any
---@param z any
function mid(x, y, z) end

---```
---> ?FLR ( 4.1) -->  4		
---> ?FLR (-2.3) --> -3
---```
---@param x any
function flr(x) end

---Returns the closest integer that is equal to or below x
---
---```
---> ?CEIL( 4.1) -->  5
---> ?CEIL(-2.3) --> -2
---```
---@param x any
function ceil(x) end

---Returns the cosine or sine of x, where 1.0 means a full turn. For example, to animate a dial that turns once every second:
---
---```
---FUNCTION _DRAW()
---  CLS()
---  CIRC(64, 64, 20, 7)
---  X = 64 + COS(T()) * 20
---  Y = 64 + SIN(T()) * 20
---  LINE(64, 64, X, Y)	
---END
---```
---
---PICO-8's SIN() returns an inverted result to suit screenspace (where Y means "DOWN", as opposed  to mathematical diagrams where Y typically means "UP").
---
---```
---> SIN(0.25) -- RETURNS -1
---```
---
---To get conventional radian-based trig functions without the y inversion,  paste the following snippet near the start of your program:
---
---```
---P8COS = COS FUNCTION COS(ANGLE) RETURN P8COS(ANGLE/(3.1415*2)) END
---P8SIN = SIN FUNCTION SIN(ANGLE) RETURN -P8SIN(ANGLE/(3.1415*2)) END
---```
---
---Converts DX, DY into an angle from 0..1
---
---As with cos/sin, angle is taken to run anticlockwise in screenspace. For example:
---
---```
---> ?ATAN(0, -1) -- RETURNS 0.25
---```
---
---ATAN2 can be used to find the direction between two points:
---
---```
---X=20 Y=30
---FUNCTION _UPDATE()
---  IF (BTN(0)) X-=2
---  IF (BTN(1)) X+=2
---  IF (BTN(2)) Y-=2
---  IF (BTN(3)) Y+=2	
---END
--- 
---FUNCTION _DRAW()
---  CLS()
---  CIRCFILL(X,Y,2,14)
---  CIRCFILL(64,64,2,7)
---   
---  A=ATAN2(X-64, Y-64)
---  PRINT("ANGLE: "..A)
---  LINE(64,64,
---    64+COS(A)*10,
---    64+SIN(A)*10,7)
---END
---```
---@param x any
function cos(x) end

---Returns the cosine or sine of x, where 1.0 means a full turn. For example, to animate a dial that turns once every second:
---
---```
---FUNCTION _DRAW()
---  CLS()
---  CIRC(64, 64, 20, 7)
---  X = 64 + COS(T()) * 20
---  Y = 64 + SIN(T()) * 20
---  LINE(64, 64, X, Y)	
---END
---```
---
---PICO-8's SIN() returns an inverted result to suit screenspace (where Y means "DOWN", as opposed  to mathematical diagrams where Y typically means "UP").
---
---```
---> SIN(0.25) -- RETURNS -1
---```
---
---To get conventional radian-based trig functions without the y inversion,  paste the following snippet near the start of your program:
---
---```
---P8COS = COS FUNCTION COS(ANGLE) RETURN P8COS(ANGLE/(3.1415*2)) END
---P8SIN = SIN FUNCTION SIN(ANGLE) RETURN -P8SIN(ANGLE/(3.1415*2)) END
---```
---
---Converts DX, DY into an angle from 0..1
---
---As with cos/sin, angle is taken to run anticlockwise in screenspace. For example:
---
---```
---> ?ATAN(0, -1) -- RETURNS 0.25
---```
---
---ATAN2 can be used to find the direction between two points:
---
---```
---X=20 Y=30
---FUNCTION _UPDATE()
---  IF (BTN(0)) X-=2
---  IF (BTN(1)) X+=2
---  IF (BTN(2)) Y-=2
---  IF (BTN(3)) Y+=2	
---END
--- 
---FUNCTION _DRAW()
---  CLS()
---  CIRCFILL(X,Y,2,14)
---  CIRCFILL(64,64,2,7)
---   
---  A=ATAN2(X-64, Y-64)
---  PRINT("ANGLE: "..A)
---  LINE(64,64,
---    64+COS(A)*10,
---    64+SIN(A)*10,7)
---END
---```
---@param x any
function sin(x) end

---Return the square root of x
---@param x any
function sqrt(x) end

---Returns the absolute (positive) value of x
---@param x any
function abs(x) end

---Returns a random number n, where 0 <= n < x
---
---If you want an integer, use flr(rnd(x)). If x is an array-style table, return a random element between table[1] and table[#table].
---@param x any
function rnd(x) end

---Sets the random number seed. The seed is automatically randomized on cart startup.
---
---```
---FUNCTION _DRAW()
---  CLS()
---  SRAND(33)
---  FOR I=1,100 DO
---    PSET(RND(128),RND(128),7)
---  END
---END
---```
---@param x any
function srand(x) end

---Add or update an item to the pause menu.
---
---INDEX should be 1..5 and determines the order each menu item is displayed.
---
---LABEL should be a string up to 16 characters long
---
---CALLBACK is a function called when the item is selected by the user. If the callback returns true, the pause menu remains open.
---
---When no label or function is supplied, the menu item is removed.
---
---```
---MENUITEM(1, "RESTART PUZZLE",
---  FUNCTION() RESET_PUZZLE() SFX(10) END
---)
---```
---
---The callback takes a single argument that is a bitfield of L,R,X button presses.
---
---```
---MENUITEM(1, "FOO", 
---  FUNCTION(B) IF (B&1 > 0) THEN PRINTH("LEFT WAS PRESSED") END END
---)
---```
---
---To filter button presses that are able to trigger the callback, a mask can be  supplied in bits 0xff00 of INDEX. For example, to disable L, R for a particular menu item, set bits 0x300 in the index:
---
---```
---MENUITEM(2 | 0x300, "RESET PROGRESS",
---  FUNCTION() DSET(0,0) END
---)
---```
---
---Menu items can be updated, added or removed from within callbacks:
---
---```
---MENUITEM(3, "SCREENSHAKE: OFF",
---  FUNCTION()
---    SCREENSHAKE = NOT SCREENSHAKE
---    MENUITEM(NIL, "SCREENSHAKE: "..(SCREENSHAKE AND "ON" OR "OFF"))
---    RETURN TRUE -- DON'T CLOSE
---  END
---)
---```
---@param index any
---@param label any?
---@param callback any?
function menuitem(index, label, callback) end

---Convert VAL to a string.
---
---FORMAT_FLAGS is a bitfield:
---
---0x1: Write the raw hexadecimal value of numbers, functions or tables.
---  0x2: Write VAL as a signed 32-bit integer by shifting it left by 16 bits.
---
---TOSTR(NIL) returns "[nil]"
---
---TOSTR() returns ""
---
---```
---TOSTR(17)       -- "17"
---TOSTR(17,0x1)   -- "0x0011.0000"
---TOSTR(17,0x3)   -- "0x00110000"
---TOSTR(17,0x2)   -- "1114112"
---```
---@param val any
---@param format_flags any?
function tostr(val, format_flags) end

---Converts VAL to a number.
---
---```
---TONUM("17.5")  -- 17.5
---TONUM(17.5)    -- 17.5
---TONUM("HOGE")  -- NO RETURN VALUE
---```
---
---FORMAT_FLAGS is a bitfield:
---
---0x1: Read the string as written in (unsigned, integer) hexadecimal without the "0x" prefix
---       Non-hexadecimal characters are taken to be '0'.
---  0x2: Read the string as a signed 32-bit integer, and shift right 16 bits.
---  0x4: When VAL can not be converted to a number, return 0
---
---```
---TONUM("FF",       0x1)  -- 255
---TONUM("1114112",  0x2)  -- 17
---TONUM("1234abcd", 0x3)  -- 0x1234.abcd
---```
---
---Convert one or more ordinal character codes to a string.
---
---```
---CHR(64)                    -- "@"
---CHR(104,101,108,108,111)   -- "hello"
---```
---@param val any
---@param format_flags any?
function tonum(val, format_flags) end

---Convert one or more characters from string STR to their ordinal (0..255) character codes.
---
---Use the INDEX parameter to specify which character in the string to use. When INDEX is out of range or str is not a string, ORD returns nil.
---
---When NUM_RESULTS is given, ORD returns multiple values starting from INDEX.
---
---```
---ORD("@")         -- 64
---ORD("123",2)     -- 50 (THE SECOND CHARACTER: "2")
---ORD("123",2,3)   -- 50,51,52
---```
---@param str any
---@param index any?
---@param num_results any?
function ord(str, index, num_results) end

---Grab a substring from string str, from pos0 up to and including pos1. When POS1 is not specified, the remainder of the string is returned. When POS1 is specified, but not a number, a single character at POS0 is returned.
---
---```
---S = "THE QUICK BROWN FOX"
---PRINT(SUB(S,5,9))    --> "QUICK"
---PRINT(SUB(S,5))      --> "QUICK BROWN FOX"
---PRINT(SUB(S,5,TRUE)) --> "Q"
---```
---@param str any
---@param pos0 any
---@param pos1 any?
function sub(str, pos0, pos1) end

---Split a string into a table of elements delimited by the given separator (defaults to ","). When separator is a number n, the string is split into n-character groups. When convert_numbers is true, numerical tokens are stored as numbers (defaults to true). Empty elements are stored as empty strings.
---
---```
---SPLIT("1,2,3")               -- {1,2,3}
---SPLIT("ONE:TWO:3",":",FALSE) -- {"ONE","TWO","3"}
---SPLIT("1,,2,")               -- {1,"",2,""}
---```
---@param str any
---@param separator any?
---@param convert_numbers any?
function split(str, separator, convert_numbers) end

---Returns the type of val as a string.
---
---```
---> PRINT(TYPE(3))
---NUMBER
---> PRINT(TYPE("3"))
---STRING
---```
---@param val any
function type(val) end

---Opens a permanent data storage slot indexed by ID that can be used to store and retrieve up to 256 bytes (64 numbers) worth of data using DSET() and DGET().
---
---```
---CARTDATA("ZEP_DARK_FOREST")
---DSET(0, SCORE)
---```
---
---ID is a string up to 64 characters long, and should be unusual enough that  other cartridges do not accidentally use the same id. Legal characters are a..z, 0..9 and underscore (_)
---
---Returns true if data was loaded, otherwise false.
---
---CARTDATA can be called once per cartridge execution, and so only a single data slot can be used.
---
---Once a cartdata ID has been set, the area of memory 0X5E00..0X5EFF is mapped  to permanent storage, and can either be accessed directly or via DGET()/@DSET().
---
---There is no need to flush written data -- it is automatically saved to permanent storage even if modified by directly POKE()'ing 0X5E00..0X5EFF.
---@param id any
function cartdata(id) end

---Get the number stored at INDEX (0..63)
---
---Use this only after you have called CARTDATA()
---@param index any
function dget(index) end

---Set the number stored at index (0..63)
---
---Use this only after you have called CARTDATA()
---@param index any
---@param value any
function dset(index, value) end

---CHANNEL:
---  0x000..0x0fe    corresponds to gpio pin numbers; send 0x00 for LOW or 0xFF for HIGH
---  0x0ff           delay; length is taken to mean "duration" in microseconds (excl. overhead)
---  0x400..0x401    ws281x LED string (experimental)
---
---ADDRESS: The PICO-8 memory location to read from / write to.
---
---LENGTH:  Number of bytes to send. 1/8ths are allowed to send partial bit strings.
---
---For example, to send a byte one bit at a time to a typical APA102 LED string:
---
---```
---VAL = 42          -- VALUE TO SEND
---DAT = 16 CLK = 15 -- DATA AND CLOCK PINS DEPEND ON DEVICE
---POKE(0X4300,0)    -- DATA TO SEND (SINGLE BYTES: 0 OR 0XFF)
---POKE(0X4301,0XFF)
---FOR B=0,7 DO
---  -- SEND THE BIT (HIGH FIRST)
---  SERIAL(DAT, BAND(VAL, SHL(1,7-B))>0 AND 0X4301 OR 0X4300, 1)
---  -- CYCLE THE CLOCK
---  SERIAL(CLK, 0X4301)
---  SERIAL(0XFF, 5) -- DELAY 5
---  SERIAL(CLK, 0X4300)
---  SERIAL(0XFF, 5) -- DELAY 5
---END
---```
---
---Additional channels are available for bytestreams to and from the host operating system. These are intended to be most useful for UNIX-like environments while developing toolchains, and are not available while running a BBS or exported cart [1]. Maximum transfer rate in all  cases is 64k/sec (blocks cpu).
---
---0x800  dropped file   //  stat(120) returns TRUE when data is available
---0x802  dropped image  //  stat(121) returns TRUE when data is available
---0x804  stdin
---0x805  stdout
---0x806  file specified with: pico8 -i filename
---0x807  file specified with: pico8 -o filename
---
---Image files dropped into PICO-8 show up on channel 0x802 as a bytestream with a special format: The first 4 bytes are the image's width and height (2 bytes each little-endian, like PEEK2), followed by the image in reading order, one byte per pixel, colour-fitted to the display palette at the time the file was dropped.
---
---[1]	Channels 0x800 and 0x802 are available from exported binaries, but with a maximum file size of 256k, or 128x128 for images.
---@param channel any
---@param address any
---@param length any
function serial(channel, address, length) end

---Set table TBL metatable to M
---@param tbl any
---@param m any
function setmetatable(tbl, m) end

---return the current metatable for table t, or nil if none is set
---@param tbl any
function getmetatable(tbl) end

---Raw access to the table, as if no metamethods were defined.
---@param tbl any
---@param key any
---@param value any
function rawset(tbl, key, value) end

---Raw access to the table, as if no metamethods were defined.
---@param tbl any
---@param key any
function rawget(tbl, key) end

---Raw access to the table, as if no metamethods were defined.
---@param tbl any
function rawlen(tbl) end

---Create a coroutine for function f.
---
---Run or continue the coroutine c. Parameters p0, p1.. are passed to the coroutine's function.
---
---Returns true if the coroutine completes without any errors Returns false, error_message if there is an error.
---
---** Runtime errors that occur inside coroutines do not cause the program to stop running. It is a good idea to wrap CORESUME() inside an ASSERT(). If the assert fails, it will print the error message generated by  coresume.
---@param f any
function cocreate(f) end

---Return the status of coroutine C as a string:
---  "running"
---  "suspended"
---  "dead"
---@param c any
function costatus(c) end

---Suspend execution and return to the caller.
function yield() end
