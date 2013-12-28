package BlipfotoViewer::Manager;
use base qw/Class::Accessor::Fast/;

use LWP;
use JSON qw/encode_json decode_json/;

sub get_image_list {
  my $ua = new LWP::UserAgent;
  my $req = HTTP::Request->new(GET => $url1 . "&api_key=${api_key}");
  my $res = $ua->request($req);
  my $responseXML = $res->content;
  my $data = decode_json($responseXML);
  return $data;
}

1;
