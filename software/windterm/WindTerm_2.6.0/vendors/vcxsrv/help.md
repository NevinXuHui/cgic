-silent-dup-error      Do not show fatal exit error mesage box
-a #                   default pointer acceleration (factor)
-ac                    disable access control restrictions
-audit int             set audit trail level
-auth file             select authorization file
-br                    create root window with black background
+bs                    enable any backing store support
-bs                    disable any backing store support
-cc int                default color visual class
-nocursor              disable the cursor
-core                  generate core dump on fatal error
-displayfd fd          file descriptor to write display number to when ready to connect
-dpi [auto|int]        screen resolution set to native or this dpi
-dpms                  disables VESA DPMS monitor control
-deferglyphs [none|all|16] defer loading of [no|all|16-bit] glyphs
-f #                   bell base (0-100)
-fakescreenfps #       fake screen default fps (1-600)
-fp string             default font path
-help                  prints message with these options
+iglx                  Allow creating indirect GLX contexts (default)
-iglx                  Prohibit creating indirect GLX contexts
-I                     ignore all remaining arguments
-maxclients n          set maximum number of clients (power of two)
-nolisten string       don't listen on protocol
-listen string         listen on protocol
-noreset               don't reset after last client exists
-background [none]     create root window with no background
-reset                 reset after last client exists
-pn                    accept failure to listen on all ports
-nopn                  reject failure to listen on all ports
-r                     turns off auto-repeat
r                      turns on auto-repeat 
-render [default|mono|gray|color] set render color alloc policy
-retro                 start with classic stipple
-seat string           seat to run on
-t #                   default pointer threshold (pixels/t)
-terminate [delay]     terminate at server reset (optional delay in sec)
-tst                   disable testing extensions
-wr                    create root window with white background
+xinerama              Enable XINERAMA extension
-xinerama              Disable XINERAMA extension
-dumbSched             Disable smart scheduling and threaded input, enable old behavior
-schedInterval int     Set scheduler interval in msec
+extension name        Enable extension
-extension name        Disable extension
 Only the following extensions can be run-time enabled/disabled:
	Generic Event Extension
	XTEST
	SECURITY
	XINERAMA
	XFIXES
	XFree86-Bigfont
	RENDER
	RANDR
	COMPOSITE
	DAMAGE
	MIT-SCREEN-SAVER
	DOUBLE-BUFFER
	RECORD
	DPMS
	X-Resource
	GLX
-vmid GUID             Hyper-V VM GUID to accept VSock connections from
-vsockport port        integer port number to listen for VSock connections.  Default 106000.
-query host-name       contact named host for XDMCP
-broadcast             broadcast for XDMCP
-multicast [addr [hops]] IPv6 multicast for XDMCP
-indirect host-name    contact named host for indirect XDMCP
-port port-num         UDP port number to send messages to
-from local-address    specify the local address to connect from
-once                  Terminate server after one session
-class display-class   specify display class to send in manage
-cookie xdm-auth-bits  specify the magic cookie for XDMCP
-displayID display-id  manufacturer display ID for request
[+-]accessx [ timeout [ timeout_mask [ feedback [ options_mask] ] ] ]
                       enable/disable accessx key sequences

VcXsrv Device Dependent Usage:

-[no]clipboard
	Enable [disable] the clipboard integration. Default is enabled.
-noprimary
	Do not map the PRIMARY selection to the windows clipboard.
	The CLIPBOARD selection is always mapped if -clipboard is enabled.
	Default is mapped.
-clipupdates num_boxes
	Use a clipping region to constrain shadow update blits to
	the updated region when num_boxes, or more, are in the
	updated region.  Diminished effect on current Windows
	versions because they already group GDI operations together
	in a batch, which has a similar effect.
-[no]compositewm
	Enable [Disable] Composite extension. Default is enabled.
	Used in -multiwindow mode.
	Use Composite extension redirection to maintain a bitmap
	image of each top-level X window, so window contents which
	are occluded show correctly in Taskbar and Task Switcher
	previews.
-[no]compositealpha
	X windows with per-pixel alpha are composited into the Windows desktop.
-[no]compositewm
	Use the Composite extension to keep a bitmap image of each top-level
	X window, so window contents which are occluded show correctly in
	task bar and task switcher previews.
-depth bits_per_pixel
	Specify an optional bitdepth to use in fullscreen mode
	with a DirectDraw engine.
-[no]emulate3buttons [timeout]
	Emulate 3 button mouse with an optional timeout in
	milliseconds.
-engine engine_type_id
	Override the server's automatically selected engine type:
		1 - Shadow GDI
		4 - Shadow DirectDraw4 Non-Locking
-fullscreen
	Run the server in fullscreen mode.
-[no]hostintitle
	In multiwindow mode, add remote host names to window titles.
-icon icon_specifier
	Set screen window icon in windowed mode.
-ignoreinput
	Ignore keyboard and mouse input.
-[no]keyhook
	Grab special Windows keypresses like Alt-Tab or the Menu key.
-lesspointer
	Hide the windows mouse pointer when it is over any
	VcXsrv window.  This prevents ghost cursors appearing when
	the Windows cursor is drawn on top of the X cursor
-logfile filename
	Write log messages to <filename>.
-logverbose verbosity
	Set the verbosity of log messages. [NOTE: Only a few messages
	respect the settings yet]
		0 - only print fatal error.
		1 - print additional configuration information.
		2 - print additional runtime information [default].
		3 - print debugging and tracing information.
-[no]multimonitors or -[no]multiplemonitors
	Use the entire virtual screen if multiple
	monitors are present.
-multiwindow
	Run the server in multiwindow mode.  Not to be used
	together with -rootless or -fullscreen.
-nodecoration
	Do not draw a window border, title bar, etc.  Windowed
	mode only i.e. ignored when -fullscreen specified.
-[no]primary
	When clipboard integration is enabled, map the X11 PRIMARY selection
	to the Windows clipboard. Default is enabled.
-refresh rate_in_Hz
	Specify an optional refresh rate to use in fullscreen mode
	with a DirectDraw engine.
-resize=none|scrollbars|randr
	In windowed mode, [don't] allow resizing of the window. 'scrollbars'
	mode gives the window scrollbars as needed, 'randr' mode uses the RANR
	extension to resize the X screen.  'randr' is the default.
-rootless
	Use a transparent root window with an external window
	manager (such as openbox).  Not to be used with
	-multiwindow or with -fullscreen.
-screen scr_num [width height [x y] | [[WxH[+X+Y]][@m]] ]
	Enable screen scr_num and optionally specify a width and
	height and initial position for that screen. Additionally
	a monitor number can be specified to start the server on,
	at which point, all coordinates become relative to that
	monitor. Examples:
	 -screen 0 800x600+100+100@2 ; 2nd monitor offset 100,100 size 800x600
	 -screen 0 1024x768@3        ; 3rd monitor size 1024x768
	 -screen 0 @1 ; on 1st monitor using its full resolution (the default)
-swcursor
	Disable the usage of the Windows cursor and use the X11 software
	cursor instead.
-[no]trayicon
	Do not create a notification area icon.  Default is to create
	one icon per screen.  You can globally disable notification area
	icons with -notrayicon, then enable them for specific screens
	with -trayicon for those screens.
-[no]unixkill
	Ctrl-Alt-Backspace exits the X Server. The Ctrl-Alt-Backspace
	key combo is disabled by default.
-[no]wgl
	Enable the GLX extension to use the native Windows WGL interface for hardware-accelerated OpenGL
-swrastwgl
	Enable the GLX extension to use the native Windows WGL interface based on the swrast interface for accelerated OpenGL
-[no]winkill
	Alt+F4 exits the X Server.
-xkblayout XKBLayout
	Set the layout to use for XKB.  This defaults to a layout
	matching your current layout from Windows or us (i.e. USA)
	if no matching layout was found.
	For example: -xkblayout de
-xkbmodel XKBModel
	Set the model to use for XKB.  This defaults to pc105.
-xkboptions XKBOptions
	Set the options to use for XKB.  This defaults to not set.
-xkbrules XKBRules
	Set the rules to use for XKB.  This defaults to xorg.
-xkbvariant XKBVariant
	Set the variant to use for XKB.  This defaults to not set.
	For example: -xkbvariant nodeadkeys