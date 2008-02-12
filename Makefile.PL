use 5.006;
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME              => 'Test::Environment',
	VERSION_FROM      => 'lib/Test/Environment.pm', # finds $VERSION
	PREREQ_PM    => {
		Carp::Clan         => 0,
		Test::More         => 0,
		Test::Differences  => 0,
		File::Slurp        => 0,
		String::ShellQuote => 0,
		File::Basename     => 0,
		List::MoreUtils    => 0,
		DBI                => 0,
	},
	($] >= 5.005 ?     ## Add these new keywords supported since 5.005
		(ABSTRACT_FROM => 'lib/Test/Environment.pm', # retrieve abstract from module
		AUTHOR         => 'Jozef Kutej <jozef@kutej.net>') : ()),
	(MM->can('signature_target') ? (SIGN => 1) : ()),
);

