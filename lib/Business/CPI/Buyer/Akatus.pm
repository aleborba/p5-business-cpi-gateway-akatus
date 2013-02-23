package Business::CPI::Buyer::Akatus;

use strict;
use warnings;
use Moo;

extends "Business::CPI::Buyer";

has "+name"                 => (required => 1);
has "+email"                => (required => 1);
has "+address_street"       => (required => 1);
has "+address_number"       => (required => 1);
has "+address_district"     => (required => 1);
has "+address_complement"   => (required => 1);
has "+address_city"         => (required => 1);
has "+address_state"        => (required => 1);
has "+address_zip_code"     => (required => 1);

has phone_type      => ( is => 'ro', required => 1);
has phone_number    => ( is => 'ro', required => 1);

42;