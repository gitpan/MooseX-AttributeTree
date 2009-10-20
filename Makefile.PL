
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => 'MooseX-AttributeTree',
  NAME      => 'MooseX::AttributeTree',
  AUTHOR    => "Christopher\ J\.\ Madsen\ \<perl\@cjmweb\.net\>",
  ABSTRACT  => "Inherit\ attribute\ values\ like\ HTML\+CSS\ does",
  VERSION   => '0.01',
  EXE_FILES => [ qw() ],
  (eval { ExtUtils::MakeMaker->VERSION(6.31) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
    "MooseX::Role::Parameterized" => '0',
  },
  test => {TESTS => 't/*.t'}
);

