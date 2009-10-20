#---------------------------------------------------------------------
package MooseX::AttributeTree;
#
# Copyright 2009 Christopher J. Madsen
#
# Author: Christopher J. Madsen <perl@cjmweb.net>
# Created: October 9, 2009
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See either the
# GNU General Public License or the Artistic License for more details.
#
# ABSTRACT: Inherit attribute values like HTML+CSS does
#---------------------------------------------------------------------

our $VERSION = '0.01';


use MooseX::Role::Parameterized;

use MooseX::AttributeTree::Accessor ();

parameter qw(parent_link
  is      ro
  isa     Str
  default parent
);

# Hook accessor_metaclass to apply the MooseX::AttributeTree::Accessor role:
role {
  my $parent_link = (shift)->parent_link;

  around accessor_metaclass => sub {
    my $orig = shift;
    my $self = shift;

    return Moose::Meta::Class->create_anon_class(
      superclasses => [ $self->$orig(@_) ],
      roles => [ 'MooseX::AttributeTree::Accessor',
                 { parent_link => $parent_link } ],
      cache => 1
    )->name
  };
};

# Register this trait as TreeInherit:
{
  package Moose::Meta::Attribute::Custom::Trait::TreeInherit;
  sub register_implementation {'MooseX::AttributeTree'}
}

#=====================================================================
# Package Return Value:

1;

__END__

=head1 NAME

MooseX::AttributeTree - Inherit attribute values like HTML+CSS does

=head1 VERSION

This document describes version 0.01 of
MooseX::AttributeTree, released October 20, 2009
as part of MooseX-AttributeTree version 0.01.

=head1 SYNOPSIS

  package MyClass;
  use Moose;
  use MooseX::AttributeTree ();

  has parent => (
    is       => 'rw',
    isa      => 'Object',
    weak_ref => 1,
  );

  has value => (
    is     => 'rw',
    traits => [qw/TreeInherit/],
  );

=head1 DESCRIPTION

Classes can inherit attributes from their parent classes.  But
sometimes you want an attribute to be able to inherit its value from a
parent object.  For example, that's how CSS styles work in HTML.

MooseX::AttributeTree allows you to apply the C<TreeInherit> trait to
any attribute in your class.  This changes the way the attribute's
accessor method works.  When reading the attribute's value, if no
value has been set for the attribute in this object, the accessor will
return the value from the parent object (which might itself be
inherited).

The parent object does not need to be the same type as the child
object, but it must have a method with the same name as the
attribute's accessor method.  (The parent's method may be an attribute
accessor method, but it doesn't have to be.)  If the parent doesn't
have the right method, you'll get a runtime error if the child tries
to call it.

By default, MooseX::AttributeTree expects the link to the parent
object to be stored in the C<parent> attribute.  However, you can use
any attribute as the link by passing the appropriate C<parent_link> to
the C<TreeInherit> trait:

  has ancestor => (
    is       => 'rw',
    isa      => 'Object',
    weak_ref => 1,
  );

  has value => (
    is     => 'ro',
    traits => [ TreeInherit => { parent_link => 'ancestor' } ],
  );

If the parent attribute is not set (or is undef), then inheritance
stops and the accessor will behave like a normal accessor.

If your attribute has a predicate method, it reports whether the
attribute has ben set on that object.  The predicate has no knowledge
of any value that might be inherited from a parent.  This means that
C<< $object->has_value >> may return false even though
C<< $object->value >> would return a value (inherited from the parent).

Likewise, the attribute's clearer method (if any) would clear the
attribute only on this object, and would never affect a parent object.

=head1 CONFIGURATION AND ENVIRONMENT

MooseX::AttributeTree requires no configuration files or environment variables.

=head1 DEPENDENCIES

MooseX::AttributeTree depends on L<MooseX::Role::Parameterized>, which
can be found on CPAN.

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

There is no inline version of the accessor methods, so using the
TreeInherit trait will slow down access to that attribute.

No attempt is made to detect circular dependencies, which may cause
an infinite loop.  (This should not be an issue in a proper tree
structure, which should not have circular dependencies.)

=head1 AUTHOR

Christopher J. Madsen  S<< C<< <perl AT cjmweb.net> >> >>

Please report any bugs or feature requests to
S<< C<< <bug-MooseX-AttributeTree AT rt.cpan.org> >> >>,
or through the web interface at
L<http://rt.cpan.org/Public/Bug/Report.html?Queue=MooseX-AttributeTree>

=head1 ACKNOWLEDGMENTS

I'd like to thank Jesse Luehrs, who explained what I needed to do to
get this module to work, and Micro Technology Services, Inc.
L<http://www.mitsi.com>, who sponsored its development.

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Christopher J. Madsen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENSE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

=cut
