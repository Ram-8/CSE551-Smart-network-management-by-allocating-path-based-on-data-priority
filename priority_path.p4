header_type ethernet_t {
    fields {
        dstAddr : 48;
        srcAddr : 48;
        etherType : 16;
    }
}

header_type ipv4_t {
    fields {
        version : 4;
        ihl : 4;
        diffserv : 8;
        totalLen : 16;
        identification : 16;
        flags : 3;
        fragOffset : 13;
        ttl : 8;
        protocol : 8;
        hdrChecksum : 16;
        srcAddr : 32;
        dstAddr : 32;
    }
}

struct headers {
    ethernet_t ethernet;
    ipv4_t ipv4;
}

parser start {
    extract(ethernet);
    return select(latest.ethernet.etherType) {
        0x0800: parse_ipv4;
        default: ingress;
    }
}

parser parse_ipv4 {
    extract(ipv4);
    return ingress;
}

control ingress {
    table priority_table {
        reads {
            ipv4.diffserv: exact;
        }
        actions {
            set_path_high;
            set_path_medium;
            set_path_low;
            drop;
        }
        size: 3;
        default_action: drop;
    }

    action set_path_high() {
        
        modify_field(standard_metadata.egress_spec, 6);  // Port 6 for high-priority path (DALL)
    }

    action set_path_medium() {
        modify_field(standard_metadata.egress_spec, 2);  // Ports 1->5->2 for medium priority path (NEWY, MAX, ATLA)
    }

    action set_path_low() {
        modify_field(standard_metadata.egress_spec, 3);  // Ports 1->5->4->3->2 for low priority path (NEWY, MAX, UCSD, ATLA)
    }

    action drop() {
        drop();
    }

    apply {
        if (valid(ipv4)) {
            priority_table.apply();
        }
    }
}

deparser deparser {
    emit(ethernet);
    emit(ipv4);
}

control egress {
    apply {
        
    }
}

control verify_checksum {
    apply {
        
    }
}

control compute_checksum {
    apply {
        
    }
}


pipeline {
    parser start;
    verify_checksum;
    ingress;
    egress;
    compute_checksum;
    deparser;
}

metadata standard_metadata {
    fields {
        ingress_port : 9;
        egress_spec : 9;
        egress_port : 9;
        packet_length : 32;
        enq_timestamp : 32;
        enq_qdepth : 19;
        deq_timedelta : 32;
        deq_qdepth : 19;
        egress_rid : 16;
        checksum_error : 1;
        priority : 3;
        resubmit_flag : 1;
        egress_mirror : 1;
        ingress_mirror : 1;
        drop_flag : 1;
        recirculate_flag : 1;
    }
}
