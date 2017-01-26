class evpn_vxlan::bgp::leaf(
$as_number = '',
$router_id='default',
$set_as_spine_neighbor=undef,
){

    cisco_bgp { $as_number:
        ensure => present,
        router_id => $router_id,
    }

    Cisco_bgp_neighbor <<| tag=="spine_neighbor" |>>
    Cisco_bgp_neighbor_af <<| tag=="spine_neighbor" |>>

    if ( $set_as_spine_neighbor['route_reflector_client'] ){


        @@cisco_bgp_neighbor { "${as_number} default ${set_as_spine_neighbor['neighbor_address']}":
            ensure                 => present,
            asn                    => $as_number,
            vrf                    => $set_as_spine_neighbor['vrf'],
            remote_as              => $as_number,
            update_source          => $set_as_spine_neighbor['update_source'],
            tag                    => "leaf_neighbor",
        }

        @@cisco_bgp_neighbor_af { "${as_number} default ${set_as_spine_neighbor['neighbor_address']} ${set_as_spine_neighbor['address_family']['afi']} ${set_as_spine_neighbor['address_family']['safi']}":
            ensure                 => "present",
            asn                    => $as_number,
            vrf                    => $set_as_spine_neighbor['vrf'],
            neighbor               => $set_as_spine_neighbor['neighbor_address'],
            afi                    => $set_as_spine_neighbor['address_family']['afi'],
            safi                   => $set_as_spine_neighbor['address_family']['safi'],
            send_community         => $set_as_spine_neighbor['send_community'],
            route_reflector_client => $set_as_spine_neighbor['route_reflector_client'],
            tag                    => "leaf_neighbor",
        }
    }
}

