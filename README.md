The Main_Path_Priority.ipynb file can be run to recreate the slice as well as the experimental setup as mentioned in the project. After running the ipynb file, the slice would be recreated and would show an active slice status in WASH, TACC, USCD, MAX and DALL locations.

The Main_path_priority.ipynb file sets up the primary steps necessary to create a slice in the network using the FABRIC testbed. Executing this file would recreate the topology as mentioned in the project, with active slices.

Priority_path.p4 file that would run on the switch that would implement the routing logic based on the data priority,i.e, packets are routed based on their priority levels such as high, low and medium based on the values in their header fields (we are working on it)

Energy_Efficient_path.ipynb file would have monitered the traffic in the network as well as dynamically adjusted the nodes to conserve energy.

Nano_ipsec_setup.sh file in the server and client terminals will configure the IPsec tunnels for encryption between the server and client, to ensure security in high priority path.
