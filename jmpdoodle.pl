#!/usr/bin/perl -w
# Created @ 30.09.2010
# Version: 1.1.0
# Copyright (C) 2010 Christian Mayer <http://fox21.at>

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

# GET /limasky/webservices/doodle_jump/gethighscores.cfm?s=26244&sn=TheFox&shash=12a860c6f11c8c146e92f94aa3ae93df&uid=&m=1&lng=en&gl2=1&tp=2&tm=2&v=312.000000 HTTP/1.1\r\n

my $BINDIP = '';
my $NICK = 'TheFox';
my $SCORE = 755621;

#$NICK = '<!--ChkYourInpt';
#$NICK = 'k94</span><!--';
#$NICK = '<h1>CHECK</h1>'; $SCORE = 196500;
#$NICK = '<h1>YOUR</h1>'; $SCORE = 196400;
#$NICK = '<h1>INPUT</h1>'; $SCORE = 196300;
#$NICK = '<h1>VARIA</h1>'; $SCORE = 196200;
#$NICK = '<h1>BLES</h1>'; $SCORE = 196100;
#$NICK = 'PerlJunkie'; $SCORE = 1582636;
#$NICK = 'hey<br>you'; $SCORE = 137802;
#$NICK = '</span><span>12'; $SCORE = 137805;
#$NICK = 'REMOVED<!--'; $SCORE = 150061;
#$NICK = '-->OK'; $SCORE = 147028;

#$SCORE = 755621;
#$SCORE = 153356;
#$SCORE = 8019432;
#$SCORE = 32838475;
#$SCORE = 145733;
#$SCORE = 149998;
#$SCORE = 150021;
#$SCORE = 160422;
#$SCORE = 170538;

my $UID = '76C6D1DD-38FA-44D8-BC78-B6F4445ED7A9';
#$UID = '8ACA1C0D-E567-41C6-87F6-AB752628315D';
#$UID = 'B359AC0F-990B-4EA3-83BE-0223D2E47CAF';
#$UID = '69ADBE92-EF7A-45C7-9000-A2218669FB4C';
#$UID = 'E13A2A6A-5D04-4B2B-99AF-3865BE43EF6D';
#$UID = '32E8C353-3A87-42FA-91E8-6B637ED049D6';

my $BROWSER_USERAGENT = 'DoodleJump/3.12.3 CFNetwork/711.1.16 Darwin/14.0.0';
#$BROWSER_USERAGENT = 'DoodleJump/3.11.0 CFNetwork/711.1.16 Darwin/13.0.0';
#$BROWSER_USERAGENT = 'DoodleJump/3.10.0 CFNetwork/711.1.16 Darwin/13.0.0';

$NICK = 'TheFox'; $SCORE = 8019432; $UID = '76C6D1DD-38FA-44D8-BC78-B6F4445ED7A9'; # 2015-01-05
$NICK = 'TheFox'; $SCORE = 4927999; $UID = '76C6D1DD-38FA-44D8-BC78-B6F4445ED7A9'; # 2015-01-20



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
	
	print "[+] end\n";
	
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
	#$req->header('Cookie' => 'CFID=81132177; CFTOKEN=97476570');
	
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
