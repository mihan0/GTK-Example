#include <gtk/gtk.h>

static void activate(GtkApplication *app, gpointer user_data) {
    GtkBuilder *builder;
    GtkWidget *window;
    GtkCssProvider *provider;
    GError *error = NULL;

    g_print("Starting activation...\n");

    

    // Load the CSS file
    provider = gtk_css_provider_new();
    if (!gtk_css_provider_load_from_path(provider, "style.css", NULL)) {
        g_print("Error loading CSS file: style.css\n");
        return;
    } else {
        g_print("CSS file loaded successfully.\n");
    }

    GdkDisplay *display = gdk_display_get_default();
    GdkScreen *screen = gdk_display_get_default_screen(display);
    gtk_style_context_add_provider_for_screen(screen, GTK_STYLE_PROVIDER(provider), GTK_STYLE_PROVIDER_PRIORITY_USER);

    g_print("Applying CSS to screen.\n");

    // Check if the UI file exists
    if (!g_file_test("demo.ui", G_FILE_TEST_EXISTS)) {
        g_print("UI file demo.ui not found.\n");
        return;
    } else {
        g_print("UI file exists.\n");
    }

    builder = gtk_builder_new();
    if (!gtk_builder_add_from_file(builder, "demo.ui", &error)) {
        g_print("Error loading UI file: %s\n", error->message);
        g_clear_error(&error);
        return;
    } else {
        g_print("UI file loaded successfully.\n");
    }

    window = GTK_WIDGET(gtk_builder_get_object(builder, "main_window"));
    if (window == NULL) {
        g_print("Could not get main window.\n");
        return;
    } else {
        g_print("Main window obtained.\n");
    }

    gtk_widget_show_all(window);
    g_print("Widgets should now be visible.\n");
}

int main(int argc, char **argv) {
    GtkApplication *app;
    int status;

    g_print("Starting application...\n");

    app = gtk_application_new("com.example.GtkApp", G_APPLICATION_FLAGS_NONE);
    g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);

    status = g_application_run(G_APPLICATION(app), argc, argv);
    g_print("GTK application run finished.\n");
    g_object_unref(app);

    g_print("Application exited with status %d.\n", status);

    return status;
}
