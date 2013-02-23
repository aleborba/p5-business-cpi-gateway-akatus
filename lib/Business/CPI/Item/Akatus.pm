package Business::CPI::Item::Akatus;

use strict;
use warnings;
use Moo;

extends "Business::CPI::Item";

has "+weight"   => (required => 1);
has "+shipping" => (required => 1);

has discount    => ( is => 'ro', required => 1);

42;