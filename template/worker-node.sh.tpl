      #!/bin/bash
      
      set -e 
      curl -sL https://talos.dev/install | sh
      talosctl gen config taloscluster https://$CONTROL_PLANE_IP:6443 --output-dir _out
      talosctl apply-config --insecure --nodes $WORKER_IP --file _out/worker.yaml
      talosctl config endpoint $CONTROL_PLANE_IP
      talosctl config node $CONTROL_PLANE_IP  
      talosctl --talosconfig $TALOSCONFIG config endpoint $CONTROL_PLANE_IP
      talosctl --talosconfig $TALOSCONFIG config node $CONTROL_PLANE_IP
      talosctl --talosconfig $TALOSCONFIG bootstrap
      talosctl --talosconfig $TALOSCONFIG kubeconfig .