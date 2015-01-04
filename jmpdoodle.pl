#!/usr/bin/perl -w
# Created @ 30.09.2010
# Version: 1.0.0
# Copyright (C) 2010 - 2015 Christian Mayer <http://fox21.at>

# Description:
# iPhone Doodle Jump hack.
# See more infos: http://blog.fox21.at/2010/01/05/doodle-jump-hack.html


use strict;
use FindBin;
use LWP::Simple;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Request::Common qw(GET POST);
use HTTP::Response;
use Digest::MD5 qw(md5_hex);

$| = 1;


my $NICK = 'TheFox21';
my $SCORE = 666777;
my $UID = '76C6D1DD-38FA-44D8-BC78-B6F4445ED7A9';
my $BROWSER_USERAGENT = 'DoodleJump/3.12.3 CFNetwork/711.1.16 Darwin/14.0.0';
my $BINDIP = '';

sub main{
	
	chdir $FindBin::Bin;
	
	my $shash = md5_hex('gombaliste'.$SCORE);
	
	my $url = 'http://www.limasky.com/limasky/webservices/doodle_jump/gethighscores.cfm';
	$url .= '?s='.$SCORE.'&sn='.$NICK.'&shash='.$shash.'&uid='.$UID.'&m=1&lng=en&gl2=1&tp=2&tm=2&v=312.000000';
	
	print "[+] nick: $NICK\n";
	print "[+] score: $SCORE\n";
	print "[+] hash: $shash\n";
	print "[+] url: $url\n";
	
	print "[ ] send request... "; wget($url);
	print "OK \r[+]\n";
	
	print "end\n";
	
}

sub setLocalAddr{
	my($ip) = @_;
	return 0 if $ip eq '';
	push(@LWP::Protocol::http::EXTRA_SOCK_OPTS, 'LocalAddr' => $ip);
	push(@LWP::Protocol::http::EXTRA_SOCK_OPTS, 'LocalPort' => (int rand 20000) + 20000);
}

sub wget{
	my($url, $method, $content, $referer, $type, $asstr) = @_;
	$method = 'GET' unless defined $method;
	$content = '' unless defined $content;
	$referer = '' unless defined $referer;
	$type = '' unless defined $type;
	$asstr = 0 unless defined $asstr;
	
	setLocalAddr $BINDIP;
	
	my $ua = LWP::UserAgent->new('max_redirect' => 0);
	my $req = HTTP::Request->new($method => $url);
	
	$req->content($content) if $content ne '';
	$req->content_type($type) if $type ne '';
	$req->referer($referer) if $referer ne '';
	$req->header('Accept-Encoding' => 'gzip, deflate');
	$req->header('Accept' => '*/*');
	$req->header('Accept-Language' => 'en-us');
	$req->header('Connection' => 'keep-alive');
	
	#print $req->as_string();
	
	$ua->agent($BROWSER_USERAGENT);
	my $res = $ua->request($req);

	if($res->is_success()){
		if($asstr){
			return $res->as_string();
		}
		else{
			return $res->content() || '';
		}
	}
	else{
		if($asstr){
			return $res->as_string();
		}
		else{
			return 0;
		}
	}
}

main();

# EOF
