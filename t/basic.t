use strict;
use warnings;

use Test::More;
use Business::CPI;

my $akatus = Business::CPI->new(
    gateway         => 'Akatus',
    receiver_email  => 'aa.borba@yahoo.com.br',
    api_key         => '29D4EB49-735E-429D-A5C3-B19DF50ADC47',
    currency        => 'BRL'
    );

ok($akatus);

isa_ok $akatus, "Business::CPI::Gateway::Akatus";

can_ok $akatus, qw(
                   query_transactions get_transaction_details 
                   notify get_hidden_inputs get_checkout_code
                );



my $cart = $akatus->new_cart({
        buyer => {
            name                => 'Alexandre',
            email               => 'ale.alvesborba@gmail.com',
            address_street      => 'Rua dos Tolos',
            address_number      => 13,
            address_district    => 'Liberdade',
            address_complement  => 'Casa',
            address_city        => 'São Paulo',
            address_state       => 'SP',
            address_zip_code    => '01419101',
            phone_type          => 'celular',
            phone_number        => '1199999999',
        }
    });

my $buyer = $cart->buyer;

isa_ok $buyer, "Business::CPI::Buyer::Akatus";

can_ok $buyer, qw(phone_type phone_number);


$cart->add_item({
    id          => "ABC1234567",
    price       => "100000.00",
    description => "Espada Ninja do Samurai da Malasia",
    quantity    => 2,
    weight      => 2.25,
    });

my $response = $cart->get_checkout_code;

done_testing;