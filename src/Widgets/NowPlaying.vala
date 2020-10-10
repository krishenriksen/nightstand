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
    public class NowPlayingWidget : Gtk.Box {
        public NowPlayingWidget () {
            var wrapper = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            wrapper.get_style_context ().add_class ("nowplaying");

			var nowplaying_box = new Box (Orientation.HORIZONTAL, 0);
			nowplaying_box.get_style_context().add_class ("today_box_horizontal");

			var nowplaying_image = new Image();
			nowplaying_image.get_style_context().add_class ("today_image");
			nowplaying_image.set_from_icon_name("gnome-music", IconSize.SMALL_TOOLBAR);

			var nowplaying_app_name_label = new Gtk.Label("NOW PLAYING");
			nowplaying_app_name_label.get_style_context().add_class ("today_app_name");

            nowplaying_box.add(nowplaying_image);
            nowplaying_box.add(nowplaying_app_name_label);

			var nowplaying_body_box = new Box (Orientation.HORIZONTAL, 0);
			nowplaying_body_box.get_style_context().add_class ("today_box_body");

            var label = new Label ("No Info");
            // Mode to compress the text and add "..."
            label.set_ellipsize (Pango.EllipsizeMode.START);
            label.set_alignment(0.0f, 0.5f);
            label.selectable = true;
            label.can_focus = false;
            label.set_single_line_mode (true);

            nowplaying_body_box.add(label);

			wrapper.add(nowplaying_box);
			wrapper.add(nowplaying_body_box);            

            this.add(wrapper);
        }
    }
}