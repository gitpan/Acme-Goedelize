package Acme::Goedelize;

use strict;
use warnings;

use Carp;
use Math::BigInt;

require Exporter;

our @ISA = qw(Exporter);

our $VERSION = '0.01';


### Methods

sub new {
  bless {}, shift;
}

sub to_number {
  my ($self, $text) = @_;
  
  my %link =   ( ' ' => '0',
                 'a' => '1',
                 'b' => '2',
                 'c' => '3',
                 'd' => '4',
                 'e' => '5',
                 'f' => '6',
                 'g' => '7',
                 'h' => '8',
                 'i' => '9',
                 'j' => '10',
                 'k' => '11',
                 'l' => '12',
                 'm' => '13',
                 'n' => '14',
                 'o' => '15',
                 'p' => '16',
                 'q' => '17',
                 'r' => '18',
                 's' => '19',
                 't' => '20',
                 'u' => '21',
                 'v' => '22',
                 'w' => '23',
                 'x' => '24',
                 'y' => '25',
                 'z' => '26',
                 '.' => '27'
  );
  
  ### Check the text
  croak "The string must contain only alpha chars and spaces"
    if ($text !~ /^[a-zA-Z\s]*$/); 
  
  ### Append dot
  if ($text !~ /\.$/) { $text .= "."; }

  my @txt = split(//, $text);

  my $current_prime = 2;
  my $result = Math::BigInt->new(1);

  foreach my $char ( @txt ) {
    my $prime = get_next_prime($current_prime);
    my $current = Math::BigInt->new($prime);
    $result *= ($current ** $link{$char});
    $current_prime = $prime + 1;
  }
  return $result;
}


sub to_text {
  my ($self, $number) = @_;

  my %link = ( '0' => ' ',
               '1' => 'a',
               '2' => 'b',
               '3' => 'c',
               '4' => 'd',
               '5' => 'e',
               '6' => 'f',
               '7' => 'g',
               '8' => 'h',
               '9' => 'i',
               '10' => 'j',
               '11' => 'k',
               '12' => 'l',
               '13' => 'm',
               '14' => 'n',
               '15' => 'o',
               '16' => 'p',
               '17' => 'q',
               '18' => 'r',
               '19' => 's',
               '20' => 't',
               '21' => 'u',
               '22' => 'v',
               '23' => 'w',
               '24' => 'x',
               '25' => 'y',
               '26' => 'z',
               '27' => '.'
  );
  ### Check the text
  croak "The string must be number\n"
    if $number !~ /^[0-9]*$/;

  my $goedel = Math::BigInt->new($number);

  my $current_prime = 2;
  my $result;
  
  PROCESS: while (1) {
    my $prime = get_next_prime($current_prime);
  
    my $times = 0;
    my $tmp = $goedel;
    DIVISION: while (1) {
      my $num = ($tmp/$prime);
      last DIVISION if ( ($tmp % $prime) > 0 );
      $times++; 
      $tmp = $num;
    }
    
    last PROCESS if $link{$times} eq ".";
    $result .= $link{$times};
    $current_prime = $prime + 1;
  }
  return $result;
}

sub get_next_prime {
  my $current = shift;
  GUESS: for (my $guess = $current; ; $guess++) 
  {
    for (my $divisor = 2; $divisor < $guess; $divisor++) 
    {
      next GUESS unless $guess % $divisor;
    }
    return $guess;
  }
}
1;
__END__


=head1 NAME

Acme::Goedelize - Goedelize text

=head1 SYNOPSIS

  use Acme::Goedelize;

  my $goedelize = new Acme::Goedelize;
  
  my $number = $goedelize->to_number('text');
  my $text   = $goedelize->to_text($number);

=head1 DESCRIPTION

Transforms text into one big number and vice versa.


=head1 AUTHOR

Todor Todorov, E<lt>acidmax@jambolnet.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Todor Todorov

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut
