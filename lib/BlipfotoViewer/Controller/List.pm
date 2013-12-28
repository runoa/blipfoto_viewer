package BlipfotoViewer::Controller::List;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub main {
  my $self = shift;

  my $data = $self->app->manager->get_image_list;

  # Render template "example/welcome.html.ep" with message
  $self->render(img_url => $data->{data}[0]->{thumbnail});
}

1;
