function set-talosconfig --description 'Sync your ~/.talos/config'
    set backup_dir ~/.talos.config.backup

    # Copy ~/.talos/config to ~/.talos.config.backup
    echo "copying ~/.talos/config to ~/.talos/config.backup"
    cp ~/.talos/config $backup_dir

    # Get the IP addresses of control plane nodes
    set control_plane_ips (kubectl get nodes -l node-role.kubernetes.io/control-plane="" -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}' | tr ' ' '\n')

    # Update talosctl config endpoints with control plane IPs
    echo "endpoints: $control_plane_ips"
    talosctl config endpoints $control_plane_ips

    # Get the IP addresses of worker nodes
    set worker_ips (kubectl get nodes -l node-role.kubernetes.io/worker="",node-role.kubernetes.io/worker="" -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}' | tr ' ' '\n')

    # Update talosctl config nodes with worker and control plane IPs
    echo "nodes: $control_plane_ips $worker_ips"
    talosctl config nodes $control_plane_ips $worker_ips
end
