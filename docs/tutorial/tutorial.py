#!/usr/bin/env python3
import gi
import os
import subprocess

gi.require_version('Gtk', '3.0')
gi.require_version('WebKit2', '4.0')

from gi.repository import Gtk, WebKit2, Gdk, GLib

WINDOW_W = 960
WINDOW_H = 620


class TutorialWindow(Gtk.Window):
    def __init__(self):
        super().__init__(title="TnEOS Tutorial")
        self.set_default_size(WINDOW_W, WINDOW_H)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.set_resizable(False)
        self.set_decorated(False)

        # Rounded-corner visual (compositor required)
        screen = self.get_screen()
        visual = screen.get_rgba_visual()
        if visual and screen.is_composited():
            self.set_visual(visual)
        self.set_app_paintable(True)
        self.connect("draw", self._on_draw)

        self.connect("destroy", Gtk.main_quit)
        self.connect("key-press-event", self._on_key_press)

        manager = WebKit2.UserContentManager()
        manager.connect("script-message-received::close", lambda _m, _r: Gtk.main_quit())
        manager.register_script_message_handler("close")

        web_view = WebKit2.WebView.new_with_user_content_manager(manager)
        settings = web_view.get_settings()
        settings.set_enable_javascript(True)
        settings.set_allow_file_access_from_file_urls(True)

        script_dir = os.path.dirname(os.path.abspath(__file__))
        html_path = os.path.join(script_dir, "tutorial.html")
        web_view.load_uri(f"file://{html_path}")

        web_view.connect("decide-policy", self._on_decide_policy)

        self.add(web_view)
        self.show_all()

    def _on_decide_policy(self, web_view, decision, decision_type):
        if decision_type == WebKit2.PolicyDecisionType.NAVIGATION_ACTION:
            uri = decision.get_navigation_action().get_request().get_uri()
            if uri.startswith("http://") or uri.startswith("https://"):
                subprocess.Popen(["xdg-open", uri])
                decision.ignore()
                return True
        return False

    def _on_draw(self, widget, cr):
        cr.set_source_rgba(0, 0, 0, 0)
        cr.set_operator(1)  # CAIRO_OPERATOR_SOURCE
        cr.paint()
        return False

    def _on_key_press(self, widget, event):
        if event.keyval == Gdk.KEY_Escape:
            Gtk.main_quit()


if __name__ == "__main__":
    win = TutorialWindow()
    Gtk.main()
