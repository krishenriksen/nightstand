/*
* Copyright (c) 2011-2020 NightStand
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Kris Henriksen <krishenriksen.work@gmail.com>
*/

using Gtk;

public class NightStandWindow : Window {
    private static string user_home = GLib.Environment.get_variable ("HOME");

    private Gdk.Rectangle monitor_dimensions;

    private Gtk.ToolButton today;
    private Gtk.ToolButton notifications;

    private uint clockTimerID;
    private Gtk.ToolButton app_clock;

    private bool nightmode;

    private void on_clicked_notifications (Box cbox) {
		GLib.List<weak Gtk.Widget> children = cbox.get_children ();
		foreach (Gtk.Widget element in children) {
			cbox.remove(element);
		}

	    try {
	    	string? res = "";

	        var file = File.new_for_path (user_home + "/.cache/xfce4/notifyd/log");

	        if (file.query_exists ()) {
	            var dis = new DataInputStream (file.read ());
	            string line;

	            while ((line = dis.read_line (null)) != null) {
	            	res += line + ",";

	            	if (line == "") {
	            		string[] lines = res.split (",");
	            		res = "";

	            		string? date = lines[0];
	            		string? app_name = lines[1].replace ("app_name=", "");
	            		string? summary = lines[2].replace ("summary=", "");
	            		string? body = lines[3].replace ("body=", "");
	            		string? app_icon = lines[4].replace ("app_icon=", "");

						var image = new Image();
						image.get_style_context().add_class ("notification_image");

						image.set_from_icon_name(app_icon, IconSize.SMALL_TOOLBAR);

	            		var packingBox_horizontal = new Box (Orientation.HORIZONTAL, 0);
	            		packingBox_horizontal.get_style_context().add_class ("notification_box_horizontal");

	            		// parse date/time
	            		string? parse_date = date.replace("[", "");
	            		string[] time = parse_date.split ("-");

						var date_label = new Gtk.Label (time[0] + "-" + time[1]);
						date_label.get_style_context().add_class ("notification_date");

						var app_name_label = new Gtk.Label (app_name);
						app_name_label.get_style_context().add_class ("notification_app_name");

						var box_summary = new Box (Orientation.HORIZONTAL, 0);
						box_summary.get_style_context().add_class ("notification_box_summary");

						var summary_label = new Gtk.Label (summary);
						summary_label.get_style_context().add_class ("notification_summary");

						var box_body = new Box (Orientation.HORIZONTAL, 0);
						box_body.get_style_context().add_class ("notification_box_body");


				        var notification_body = new Label(body);
			            notification_body.selectable = true;
			            notification_body.can_focus = false;
				        notification_body.set_line_wrap(true);
				        notification_body.get_style_context().add_class ("notification_body");

						packingBox_horizontal.add(image);
	            		packingBox_horizontal.add(app_name_label);
	            		packingBox_horizontal.add(date_label);

	            		box_summary.add(summary_label);
	            		box_body.add(notification_body);

	    				cbox.add(packingBox_horizontal);
	    				cbox.add(box_summary);
	    				cbox.add(box_body);
	            	}
	            }
	        }
	    } catch (Error e) {
	    	warning (e.message);
	    }		

	    cbox.show_all();
    }

    private void on_clicked_today (Box cbox) {
		GLib.List<weak Gtk.Widget> children = cbox.get_children ();
		foreach (Gtk.Widget element in children) {
			cbox.remove(element);
		}

		/* Show Today date */
		var now = new DateTime.now_local ();
		var today_date = new Gtk.Label (now.format ("%A, %d %B"));
		today_date.get_style_context().add_class ("today_date");

		cbox.add(today_date);

		/* NowPlaying */
		var nowplaying = new NightStand.NowPlayingWidget();
		cbox.add(nowplaying);

		/* Calendar */
		var calendar = new NightStand.CalendarWidget();
		cbox.add(calendar);


		cbox.show_all();
    }

    public NightStandWindow () {
        this.set_title ("NightStand");
        this.set_skip_pager_hint (true);
        this.set_skip_taskbar_hint (true); // Not display the window in the task bar
        this.set_decorated (false); // No window decoration
        this.set_app_paintable (true); // Suppress default themed drawing of the widget's background
        this.set_visual (this.get_screen ().get_rgba_visual ());
        this.set_type_hint (Gdk.WindowTypeHint.NORMAL);
        this.resizable = false;

        Gdk.Screen default_screen = Gdk.Screen.get_default ();
        monitor_dimensions = default_screen.get_display ().get_primary_monitor ().get_geometry ();

        // set size, and slide out from right to left
        this.set_default_size (monitor_dimensions.width,  monitor_dimensions.height);

        this.fullscreen();

        // left container
        var lbox = new Box (Orientation.VERTICAL, 0);
        lbox.get_style_context().add_class ("left_box");

        clockTimerID = Timeout.add (1, on_timer_create_event);

		var now = new DateTime.now_local ();
		var app_clock = new Gtk.Label (now.format ("%R"));
		app_clock.get_style_context().add_class ("app_clock");

        lbox.add(app_clock);

        // ---

		var lcbox = new Box (Orientation.HORIZONTAL, 0);



	    var pixbuf = new Gdk.Pixbuf.from_file("/usr/local/share/nightstand/Nightstand-moon.png");
	    pixbuf = pixbuf.scale_simple(100, 100, Gdk.InterpType.BILINEAR);
		var app_moon_image = new Gtk.Image();
		app_moon_image.set_from_pixbuf(pixbuf);
		var app_moon = new Gtk.Button();
		app_moon.clicked.connect ( () => {
			if (this.nightmode) {
				this.nightmode = false;
				this.get_style_context().remove_class("nightmode");
			}
			else {
				this.nightmode = true;
				this.get_style_context().add_class ("nightmode");
			}
		});
		app_moon.add(app_moon_image);

		lcbox.pack_start (app_moon, true, true, 0);


	    pixbuf = new Gdk.Pixbuf.from_file("/usr/local/share/nightstand/Nightstand-clock.png");
	    pixbuf = pixbuf.scale_simple(100, 100, Gdk.InterpType.BILINEAR);
		var app_alarm_image = new Gtk.Image();
		app_alarm_image.set_from_pixbuf(pixbuf);
		var app_alarm = new Gtk.Button();
		app_alarm.clicked.connect ( () => {
			
		});
		app_alarm.add(app_alarm_image);


		lcbox.pack_start (app_alarm, true, true, 0);


	    pixbuf = new Gdk.Pixbuf.from_file("/usr/local/share/nightstand/Nightstand-close.png");
	    pixbuf = pixbuf.scale_simple(100, 100, Gdk.InterpType.BILINEAR);
		var app_close_image = new Gtk.Image();
		app_close_image.set_from_pixbuf(pixbuf);
		var app_close = new Gtk.Button();
		app_close.clicked.connect ( () => {
			this.destroy ();
		});
		app_close.add(app_close_image);


		lcbox.pack_start (app_close, true, true, 0);

		lbox.add(lcbox);

        // right container
        // container for today and notifications
        var cbox = new Box (Orientation.VERTICAL, 0);

		var toolbar = new Toolbar ();
		toolbar.get_style_context ().add_class (STYLE_CLASS_PRIMARY_TOOLBAR);

    	today = new Gtk.ToolButton(null, "Today");
    	today.is_important = true;
    	today.clicked.connect ( () => {
    		notifications.get_style_context ().remove_class ("active");
    		today.get_style_context ().add_class ("active");

    		this.on_clicked_today(cbox);
    	});
    	today.get_style_context ().add_class ("active");

    	// make today show on launch
    	this.on_clicked_today(cbox);

    	notifications = new Gtk.ToolButton(null, "Notifications");
    	notifications.is_important = true;
    	notifications.clicked.connect ( () => {
    		today.get_style_context ().remove_class ("active");
    		notifications.get_style_context ().add_class ("active");

    		this.on_clicked_notifications(cbox);
    	});

		toolbar.add (today);
		toolbar.add (notifications);

		var scroll = new ScrolledWindow (null, null);
		scroll.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
		scroll.add(cbox);

        // container for settings
        var bottombar = new Toolbar ();
        bottombar.get_style_context ().add_class ("bottombar");

	    var edit_button = new Gtk.ToolButton(null, "Edit");
	    edit_button.clicked.connect (() => {
            
	    });
	    bottombar.add(edit_button);

	    var settings_icon = new Gtk.Image.from_icon_name ("settings-configure", IconSize.BUTTON);
	    var settings_button = new Gtk.ToolButton(settings_icon, "");
	    settings_button.get_style_context ().add_class ("settings_button");
	    settings_button.clicked.connect (() => {
            try {
                GLib.AppInfo.create_from_commandline ("xfce4-notifyd-config", null, GLib.AppInfoCreateFlags.NONE).launch (null, null);
            } catch (GLib.Error e) {
                warning ("Error! Load application: " + e.message);
            }
	    });
	    bottombar.add(settings_button);


		var vbox = new Box (Orientation.VERTICAL, 0);
		vbox.pack_start (toolbar, false, true, 0);
		vbox.pack_start (scroll, true, true, 0);
		vbox.pack_start (bottombar, false, false, 0);
		vbox.get_style_context().add_class ("right_box");

		var abox = new Box (Orientation.HORIZONTAL, 0);
		abox.pack_start (lbox, true, true, 0);
		abox.pack_start (vbox, true, true, 0);
		this.add (abox);

		this.show_all();

        this.draw.connect (this.draw_background);	
    }

    private bool draw_background (Gtk.Widget widget, Cairo.Context ctx) {
        widget.get_style_context().add_class ("nightstand");
        return false;
    }

    // Override destroy for fade out and stuff
    private new void destroy () {
		base.destroy();
		Gtk.main_quit();
    }

	private bool on_timer_create_event () {

		var now = new DateTime.now_local ();

		app_clock.label = now.format ("%R");
		return true;
	}    

    // Keyboard shortcuts
    public override bool key_press_event (Gdk.EventKey event) {
        switch (Gdk.keyval_name (event.keyval)) {
            case "Escape":
                this.destroy ();
                return true;
        }

        base.key_press_event (event);
        return false;
    }
}

static int main (string[] args) {
    Gtk.init (ref args);
    Gtk.Application app = new Gtk.Application ("com.github.krishenriksen.nightstand", GLib.ApplicationFlags.FLAGS_NONE);

    string css_file = Config.PACKAGE_SHAREDIR +
        "/" + Config.PROJECT_NAME +
        "/" + "nightstand.css";
    var css_provider = new Gtk.CssProvider ();

    try {
        css_provider.load_from_path (css_file);
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default(), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
    } catch (GLib.Error e) {
        warning ("Could not load CSS file: %s",css_file);
    }

    app.activate.connect( () => {
        if (app.get_windows ().length () == 0) {
            var main_window = new NightStandWindow ();
            main_window.set_application (app);
            main_window.show();
            Gtk.main ();
        }
    });
    app.run (args);
    return 1;
}
