#!/usr/bin/perl

use FileHandle;
use File::Copy;
my($fh_orig,$fh_new);

$detectedfile = 0;
$files = 0;
foreach $filename (@ARGV){
	$virus_count = 0;
	$fh_orig = FileHandle->new($filename,O_RDONLY);
	$fh_new = FileHandle->new($filename.'.tmp',O_CREAT|O_WRONLY|O_TRUNC);
	while(my $line = <$fh_orig>){
		if($line =~ /<script>var [a-zA-Z]*=.*replace.*split.*();<\/script>/ ){
			print "Detect Virus(".++$virus_count.") on ". $filename. "\n";
		} else {
			$fh_new->print($line);
		}
	}
	$fh_orig->close;
	$fh_new->close;
	move($filename.".tmp",$filename);
	if($virus_count > 0){
		$detectedfile++;
	}
	$files++;

}

print $detectedfile . " files infected(on " . $files . " files)\n";
