package BlipfotoViewer::ImageManager;
use base qw/Class::Accessor::Fast/;

use LWP;
use JSON qw/decode_json/;
use Parallel::ForkManager;
use Data::Dumper;
use YAML;

use constant VIEW_COUNT => 50;

sub is_valid_url {
    my ($self, $url) = @_;
    return 1 if ($url =~ m/^http:\/\/api\.blipfoto\.com\//);
    return 0;
}

sub get_data {
    my ($self, $url) = @_;
    return unless $self->is_valid_url($url);
    my $api_key = '204caf772d87ddb7a51fe389b954253f';
    my $ua = new LWP::UserAgent;
    my $req = HTTP::Request->new(GET => $url . "&api_key=${api_key}");
    my $res = $ua->request($req);
    my $responseXML = $res->content;
    my $data = decode_json($responseXML);
    return $data->{data};
}

sub get_data_parallel {
    my ($self, @urls) = @_;
    my @image_list;
    my $pm = Parallel::ForkManager->new($#urls + 1);
    $pm->run_on_finish( sub { #並列に取ってきたデータを@image_listにためておく
        my ($pid, $exit_code, $ident, $exit_signal, $core_dump, $data) = @_;
        push @image_list, @{$data->{index}} if $data;
    });
    for my $url (@urls) {
        $pm->start and next;
        my $data = $self->get_data($url);
        $pm->finish(0, { pid => $$, index => $data });
    }
    $pm->wait_all_children;
    return @image_list;
}

sub sort_data {
    my ($self, @image_list) = @_;
    return sort { $b->{entry_id} <=> $a->{entry_id} } @image_list;
}

sub get_image_list {
    my $self = shift;
    my $conf = YAML::LoadFile("config/config.yaml");
    my @urls = @{$conf->{api_list}};
    my @image_list = $self->get_data_parallel(@urls);
    @image_list = $self->sort_data(@image_list);
    $#image_list = VIEW_COUNT - 1; #表示件数をVIEW_COUNT件に制限する
    return \@image_list;
}

1;
