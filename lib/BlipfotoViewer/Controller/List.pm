package BlipfotoViewer::Controller::List;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub main {
  my $self = shift;

  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'This is a sample application');
}

1;
