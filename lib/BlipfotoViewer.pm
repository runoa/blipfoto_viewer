package BlipfotoViewer;
use Mojo::Base 'Mojolicious';

use BlipfotoViewer::Manager;

__PACKAGE__->attr( manager => sub {
    return BlipfotoViewer::Manager->new;
});

# This method will run once at server start
sub startup {
    my $self = shift;

    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer');

    # Router
    my $r = $self->routes;
    $r->namespaces(['BlipfotoViewer::Controller']);

    # Normal route to controller
    $r->get('/')->to('list#main');
}

1;
