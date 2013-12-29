package BlipfotoViewer::Controller::List;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub main {
    my $self = shift;

    my $image_list = $self->app->image_manager->get_image_list;

    # Render template "list/main.html.ep" with message
    $self->render(image_list => $image_list);
}

1;
