# CREATE CONFIG CLUSTER

resource "null_resource" "talos_config" {
  provisioner "local-exec" {
    command = "talosctl gen config --output-dir ./talos_conf --with-docs=false --with-examples=false talos-k8s-gcp https://${local.load_balance_ip}:443"
  }
}

resource "null_resource" "apply_controlplane_conf" {
  provisioner "local-exec" {
    command = "talosctl apply-config --insecure --nodes ${local.control_plane_1_ip} --file talos_conf/controlplane.yaml"
  }

  depends_on = [null_resource.talos_config]
}

resource "null_resource" "apply_worker_conf" {
  provisioner "local-exec" {
    command = "talosctl apply-config --insecure --nodes ${local.worker_node_1_ip} --file talos_conf/worker.yaml"
  }
  depends_on = [null_resource.apply_controlplane_conf]
}

resource "null_resource" "set_endpoint_and_node" {
  provisioner "local-exec" {
    command = "talosctl --talosconfig ./talos_conf/talosconfig config endpoint ${local.control_plane_1_ip} && talosctl --talosconfig ./talos_conf/talosconfig config node ${local.control_plane_1_ip}"
  }
  depends_on = [null_resource.apply_worker_conf]
}

resource "null_resource" "bootstrap" {
  provisioner "local-exec" {
    command = "sleep 60 && talosctl --talosconfig ./talos_conf/talosconfig  bootstrap"
  }
  depends_on = [null_resource.set_endpoint_and_node]
}

resource "null_resource" "generate_kubeconfig" {

  provisioner "local-exec" {
    command = "sleep 60 && talosctl --talosconfig ./talos_conf/talosconfig kubeconfig ./talos_conf/"
  }
  depends_on = [null_resource.bootstrap]
}
