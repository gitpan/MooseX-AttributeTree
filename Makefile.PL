
use strict;
use warnings;

BEGIN { require 5.8.0; }

use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'Inherit attribute values like HTML+CSS does',
  'AUTHOR' => 'Christopher J. Madsen <perl@cjmweb.net>',
  'BUILD_REQUIRES' => {
    'Test::More' => '0.88'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31'
  },
  'DISTNAME' => 'MooseX-AttributeTree',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'MooseX::AttributeTree',
  'PREREQ_PM' => {
    'MooseX::Role::Parameterized' => '0'
  },
  'VERSION' => '0.03',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



