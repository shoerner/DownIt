#!C:\Perl\bin\perl.exe
use Dancer;
use Dancer ':syntax';
#use DownIt;
use File::Basename;
#use Filter::Crypto::Decrypt

my $filename;
my $username;
my $password;
my $adminVisited = 0;

get '/' => sub {
	debug "in /";
	template 'download';
	if(defined $filename)
	{
		template 'download', {lnk => '<a href="download"><img style="text-align:center;margin-left:auto;margin-right:auto;" src="./images/Download.png"/></a>'};
	}
	else
	{
		redirect '/admin';
	}
};
any ['post', 'get'] => '/download' => sub {
	return redirect '/admin' if !defined $filename;
	return send_file($filename, system_path => 1, filename => basename($filename));
};
get '/admin'  => sub {
	if($adminVisited == 1)
	{
		halt("Page has been visited already - restart DownIt to access again");
	}
	else
	{
		template 'admin';
	}
};
any '/corp' => sub {
	return "$0";
	unlink $0;
	exit(0);
};
any ['get', 'post'] => '/change' => sub {
	$filename = param('file');
	if(length($filename) < 1)
	{
		redirect '/admin';
		return;
	}
	elsif(!-e $filename)
	{
		redirect '/admin';
		return;
	}
	$username = param('username');
	$password = param('password');
	$adminVisited = 1;
	redirect '/';
};
get '/exit/0x0' => sub
{
	debug "WebExit Called by " . request->remote_address . "\n"; 
	exit(0);
};

dance;