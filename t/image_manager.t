use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

use BlipfotoViewer::ImageManager;
use Data::Dumper;

my $image_manager = new BlipfotoViewer::ImageManager;

subtest 'get_image_list' => sub {
    my $image_list = $image_manager->get_image_list;
    ::is @{$image_list}, BlipfotoViewer::ImageManager::VIEW_COUNT, 'count @image_list';
};

subtest 'validation' => sub {
    my $valid_url = 'http://api.blipfoto.com/v3/search.json?query=couple&max=50';
    my @invalid_urls = (
        'ttp://api.blipfoto.com/v3/search.json?query=couple&max=50',
        'http://pi.blipfoto.com/v3/search.json?query=couple&max=50',
        'http://api.lipfoto.com/v3/search.json?query=couple&max=50',
    );
    ::is $image_manager->is_valid_url($valid_url), 1, 'valid_url ok';
    for my $invalid_url (@invalid_urls) {
        ::is $image_manager->is_valid_url($invalid_url), 0, 'invalid_url ok';
    }
};

subtest 'sort' => sub {
    my @list = (
        {
            'entry_id' => '2',
            'title' => 'bbb',
        },
        {
            'entry_id' => '1',
            'title' => 'aaa',
        },
        {
            'entry_id' => '3',
            'title' => 'ccc',
        },
    );
    my @valid_sorted_list = (
        {
            'entry_id' => '3',
            'title' => 'ccc',
        },
        {
            'entry_id' => '2',
            'title' => 'bbb',
        },
        {
            'entry_id' => '1',
            'title' => 'aaa',
        },
    );
    my @sorted_list = $image_manager->sort_data(@list);
    ::is_deeply \@sorted_list, \@valid_sorted_list, 'desc_sort ok';
};

done_testing();

