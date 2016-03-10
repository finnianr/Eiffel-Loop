/*
   Author: Finnian Reilly <finnian@eiffel-loop.com>
   Copyright (C) Dec 2014
*/


#include "gtk-init.h"

//#include <stdio.h>

static void set_rectangle (GtkWidget *widget, GdkEvent* event, int *rectangle)
{
	gtk_window_get_position((GtkWindow *)widget, rectangle, rectangle + 1);
	gtk_window_get_size((GtkWindow *)widget, rectangle + 2, rectangle + 3);
	gtk_widget_destroy(widget);
}

void gtk_get_useable_screen_area (gint *rectangle)
	// returns useable screen area in rectangle
{
	GtkWidget *window;

	gtk_init(NULL, NULL);
	window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
	gtk_window_set_opacity((GtkWindow *)window, 0.0);
	gtk_window_set_decorated((GtkWindow *)window, (gboolean)FALSE);
	gtk_window_maximize((GtkWindow *)window);

	g_signal_connect(G_OBJECT(window), "map-event", G_CALLBACK(set_rectangle), rectangle);
	g_signal_connect (G_OBJECT(window), "destroy", G_CALLBACK(gtk_main_quit), NULL);

	gtk_widget_show(window);
	
	gtk_main();
}

/*int main( int argc, char *argv[])
{
	int rectangle [4];
	gtk_get_useable_screen_area (rectangle);
	printf ("width: %d height: %d\n", rectangle [2], rectangle [3]);
	return 0;
}*/



