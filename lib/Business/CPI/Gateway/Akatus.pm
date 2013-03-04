use strict;
use warnings;
package Business::CPI::Gateway::Akatus;

#ABSTRACT: Business::CPI's Akatus driver

use Moo;
use XML::LibXML;
use XML::Compile::Schema;
use LWP::UserAgent;

extends "Business::CPI::Gateway::Base";

has api_key => (is => 'ro', required => 1);
has "+receiver_email" => (required => 1);

sub _get_xml{
    my ($self, $info)   = @_;
    my $cart            = $info->{cart};
    my $buyer           = $cart->buyer;


    my $hash = {
        recebedor => {
            api_key => $self->api_key,
            email   => $self->receiver_email,
        },
        pagador => {
            nome        => $buyer->name,
            email       => $buyer->email,
            enderecos   => {
                endereco => {
                    tipo        => "entrega",
                    logradouro  => $buyer->address_street,
                    numero      => $buyer->address_number,
                    bairro      => $buyer->address_district,
                    complemento => $buyer->address_complement,
                    cidade      => $buyer->address_city,
                    estado      => $buyer->address_state,
                    cep         => $buyer->address_zip_code,
                    pais        => "BRA",
                },
            },
            telefones => {
                telefone => {
                    tipo    => $buyer->phone_type,
                    numero  => $buyer->phone_number,
                },
            },
        },
        produtos => {
            produto => {
                codigo      => 'ABC123456',
                descricao   => "Espada Ninja do Samurai da Malasia",
                quantidade  => 2,
                preco       => "10000.00",
                peso        => 2.25,
                frete       => 0,
                desconto    => 0,
            }

        },
        transacao => {
            desconto_total      => 0,
            peso_total          => 2.25,
            frete_total         => 0,
            moeda               => "BRL", 
            meio_de_pagamento   => 'boleto',
        },
    };

    my $doc     = XML::LibXML::Document->new('1.0', 'UTF-8');
    my $schema  = XML::Compile::Schema->new("/home/alexandre/Projetos/Business-CPI-Gateway-Akatus/data/cart.xsd");
#    my $schema  = XML::Compile::Schema->new("/Users/garu/Projects/p5-business-cpi-gateway-akatus/data/cart.xsd");

    my $writer = $schema->compile(
        WRITER => '{http://connect.akatus.com/}carrinho',
        use_default_namespace => 1,
    );

    return $writer->($doc, $hash)->serialize;
}

sub get_checkout_code {
    my($self, $info) = @_;

    my $xml = $self->_get_xml($info);
    my $ua  = LWP::UserAgent->new;

    my $response = $ua->post(
        "https://www.akatus.com/api/v1/carrinho.xml",
        Content_Type    => 'application/xml; charset=UTF-8',
        Content         => $xml,
    );
use DDP; p $response;
return;
}



1;
