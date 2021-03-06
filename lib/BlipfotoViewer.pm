package BlipfotoViewer;
use Mojo::Base 'Mojolicious';

use BlipfotoViewer::ImageManager;

__PACKAGE__->attr( image_manager => sub {
    return BlipfotoViewer::ImageManager->new;
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
