#!/usr/bin/perl -w
# Created @ 05.01.2010 by TheFox@fox21.at
# Version: 1.0.0
# Copyright (c) 2010 TheFox

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Description:
# iPhone Doodle Jump hack.
# See more infos: http://fox21.at/iphone-doodle-jump-hack.html


use strict;
use FindBin;
use LWP::Simple;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Request::Common qw(GET POST);
use HTTP::Response;
use Digest::MD5 qw(md5_hex);

$| = 1;


my $NICK = 'TheFox';
my $SCORE = 6410815;
my $BROWSER_USERAGENT = 'DoodleJump/1.13.2 CFNetwork/342.1 Darwin/9.4.1';
my $BINDIP = '';

sub main{
	
	chdir $FindBin::Bin;
	
	my $shash = md5_hex('gombaliste'.$SCORE);
	
	my $url = 'http://www.limasky.com/limasky/webservices/doodle_jump/gethighscores.cfm?s='.$SCORE.'&sn='.$NICK.'&shash='.$shash.'&uid=9fc51f9e64626801981ab594c097477885c128f8&m=1&lng=de&gl2=0';
	
	print "hash: $shash\n";
	print "send request...\n";
	print wget($url)."\n";
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
	$req->header('Accept-Encoding' => ''); # Anti Gzip.
	
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
