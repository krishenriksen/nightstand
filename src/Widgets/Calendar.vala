/*
* Copyright (c) 2011-2020 NotificationCenter
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

namespace NightStand {
    public class CalendarWidget : Gtk.Box {
        public CalendarWidget () {
            var wrapper = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            wrapper.get_style_context ().add_class ("calendar");

			var calendar_box = new Box (Orientation.HORIZONTAL, 0);
			calendar_box.get_style_context().add_class ("today_box_horizontal");

			var calendar_image = new Image();
			calendar_image.get_style_context().add_class ("today_image");
			calendar_image.set_from_icon_name("calendar", IconSize.SMALL_TOOLBAR);

			var calendar_app_name_label = new Gtk.Label("CALENDAR");
			calendar_app_name_label.get_style_context().add_class ("today_app_name");

            calendar_box.add(calendar_image);
            calendar_box.add(calendar_app_name_label);

			var calendar_body_box = new Box (Orientation.HORIZONTAL, 0);
			calendar_body_box.get_style_context().add_class ("today_box_body");

            var label = new Label ("No Events");
            // Mode to compress the text and add "..."
            label.set_ellipsize (Pango.EllipsizeMode.START);
            label.set_alignment(0.0f, 0.5f);
            label.selectable = true;
            label.can_focus = false;
            label.set_single_line_mode (true);

            calendar_body_box.add(label);

			wrapper.add(calendar_box);
			wrapper.add(calendar_body_box);            

            this.add(wrapper);
        }
    }
}