unit class Geo::Coder::OpenCage;
use Geo::Coder::OpenCage::Response;
use HTTP::UserAgent;
use JSON::Unmarshal;
use URI::Escape;

has $.endpoint = "http://api.opencagedata.com/geocode/v1/json";
has $.ua       = HTTP::UserAgent.new;
has $.api-key
    = die "api-key is a required attribute in Geo::Coder::OpenCage";

method make-request(Str $place-name, %params) returns Str {
    my $url = $.endpoint   ~ "?q=" ~ uri-escape($place-name);
    $url   ~= "&key="      ~ $.api-key;
    for %params.keys -> $k {
        $url ~= "&$k=" ~ uri-escape(%params{$k})
    }
    my $res = $.ua.get($url);
    return $res.content;
}

method geocode(Str $place-name, *%params)
       returns Geo::Coder::OpenCage::Response {
    my $json = self.make-request($place-name, %params);
    return unmarshal $json, Geo::Coder::OpenCage::Response;
}
